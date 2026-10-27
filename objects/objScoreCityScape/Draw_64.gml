var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _horizon_y = _gui_h * 0.5;

// --- НАСТРОЙКИ МАСШТАБА И ПОЗИЦИИ ---
var _scale_x = 0.55;       // Базовый масштаб по ширине
var _scale_y = 0.65;       // Базовый масштаб по высоте
var _push_down = 35;       

var _len = array_length(buildings_array);

// Вычисление позиции Y (с учетом Middle Centre)
var _sprite_half_h = (sprite_get_height(scrScoreSkyScape) * _scale_y) * 0.5;
var _city_y = _horizon_y + _push_down - _sprite_half_h; 

var _scaled_width = sprite_get_width(scrScoreSkyScape) * _scale_x;
var _half_w = _scaled_width * 0.5;

// --- БАЗОВАЯ ПАЛИТРА ДЛЯ ГРАДИЕНТА ПО X ---
var _neon_cyan   = make_color_rgb(0, 240, 200);   // Левая сторона экрана (Мята / Бирюза)
var _neon_blue   = make_color_rgb(0, 100, 255);   // Центр экрана (Глубокий синий неон)
var _neon_pink   = make_color_rgb(255, 0, 160);   // Правая сторона экрана (Маджента / Розовый)
var _glow_white  = make_color_rgb(245, 250, 255); // Белое светящееся ядро (для низа по Y)

// ==========================================
// 1. СЛОЙ ОБВОДКИ: ГОРИЗОНТАЛЬНЫЙ НЕОНОВЫЙ КОНТУР ЧЕРЕЗ GPU ТУМАН
// ==========================================
var _glow_passes = 4; // Количество слоев размытия контура

for (var g = _glow_passes; g >= 1; g--) {
    // ЖИРНОСТЬ ОБВОДКИ: Коэффициент 4.5 делает неон плотным
    var _add = g * 4.5; 
    var _sa_x = _scale_x + (_add / sprite_get_width(scrScoreSkyScape));
    var _sa_y = _scale_y + (_add / sprite_get_height(scrScoreSkyScape));
    
    for (var i = 0; i < _len; i++) {
        var _b = buildings_array[i];
        var _current_offset_y = sin(_b.wave_time) * _wave_amplitude;
        var _draw_x = _b.base_x + _half_w;
        
        // --------------------------------------------------
        // ШАГ А: РАСЧЕТ ГОРИЗОНТАЛЬНОГО ГРАДИЕНТА (ОСЬ X)
        // --------------------------------------------------
        var _x_ratio = clamp(_draw_x / _gui_w, 0.0, 1.0);
        var _base_x_color = c_white;
        
        if (_x_ratio < 0.5) {
            _base_x_color = merge_color(_neon_cyan, _neon_blue, _x_ratio * 2.0);
        } else {
            _base_x_color = merge_color(_neon_blue, _neon_pink, (_x_ratio - 0.5) * 2.0);
        }
        
        // --------------------------------------------------
        // ШАГ Б: РАСЧЕТ ВЕРТИКАЛЬНОГО ГРАДИЕНТА (ОСЬ Y)
        // --------------------------------------------------
        var _y_factor = (1 - (g / _glow_passes)); 
        var _final_pixel_color = merge_color(_base_x_color, _glow_white, _y_factor * 0.6);
        
        // Устанавливаем получившийся цвет в видеокарту
        gpu_set_fog(true, _final_pixel_color, 0, 0);
        
        // Прозрачность слоя
        var _layer_alpha = (0.25 / g) * 1.5;
        
        // Рисуем контур с учетом индивидуального кадра здания (_b.img_index)
        draw_sprite_ext(
            scrScoreSkyScape, _b.img_index, 
            _draw_x, _city_y + _current_offset_y, 
            _sa_x * _b.x_scale_sign, _sa_y, 
            0, _final_pixel_color, _layer_alpha
        );
    }
}

// ВЫКЛЮЧАЕМ РЕЖИМ ТУМАНА GPU
gpu_set_fog(false, c_white, 0, 0);

// ==========================================
// 2. МЯГКОЕ НЕОНОВОЕ МАРЕВО КВЕРХУ (ОБЪЁМНЫЙ ВЕРТИКАЛЬНЫЙ БЛУМ)
// ==========================================
gpu_set_blendmode(bm_add); // Включаем аддитивное смешивание для эффекта "свечения"

var _bloom_passes = 14; // Количество шагов для идеальной плавности блума

for (var bp = 1; bp <= _bloom_passes; bp++) {
    var _bloom_ratio = bp / _bloom_passes;
    var _bloom_alpha = lerp(0.04, 0.001, _bloom_ratio); // Плавное падение прозрачности кверху
    
    var _blur_x = _scale_x + (bp * 0.02);   // Слегка размываем по X, чтобы окна сливались
    var _stretch_y = _scale_y + (bp * 0.04); // Мягко вытягиваем по Y к небу

    for (var i = 0; i < _len; i++) {
        var _b = buildings_array[i];
        var _current_offset_y = sin(_b.wave_time) * _wave_amplitude;
        var _draw_x = _b.base_x + _half_w;
        
        var _x_ratio = clamp(_draw_x / _gui_w, 0.0, 1.0);
        var _bloom_color = (_x_ratio < 0.5) ? merge_color(_neon_cyan, _neon_blue, _x_ratio * 2.0) : merge_color(_neon_blue, _neon_pink, (_x_ratio - 0.5) * 2.0);
        
        gpu_set_fog(true, _bloom_color, 0, 0);
        
        // Смещение каждого следующего слоя чуть выше предыдущего (шаг в 2.5 пикселя)
        var _bloom_y = _city_y + _current_offset_y - (bp * 2.5);
        
        draw_sprite_ext(
            scrScoreSkyScape, _b.img_index, 
            _draw_x, _bloom_y, 
            _blur_x * _b.x_scale_sign, _stretch_y, 
            0, _bloom_color, _bloom_alpha
        );
    }
}

// СБРОС СОСТОЯНИЙ ВИДЕОКАРТЫ В ДЕФОЛТ
gpu_set_blendmode(bm_normal);
gpu_set_fog(false, c_white, 0, 0);

// ==========================================
// 3. ОТРИСОВКА ОРИГИНАЛЬНОГО ЧЕРНО-БЕЛОГО ЗДАННЯ ПОВЕРХ ВСЕГО
// ==========================================
draw_set_alpha(1);
for (var i = 0; i < _len; i++) {
    var _b = buildings_array[i];
    var _current_offset_y = sin(_b.wave_time) * _wave_amplitude;
    var _draw_x = _b.base_x + _half_w;
    
    draw_sprite_ext(
        scrScoreSkyScape, _b.img_index, // Отрисовка чистого здания со своим кадром
        _draw_x, _city_y + _current_offset_y, 
        _scale_x * _b.x_scale_sign, _scale_y, 
        0, c_white, 1
    );
}

draw_set_alpha(1);
