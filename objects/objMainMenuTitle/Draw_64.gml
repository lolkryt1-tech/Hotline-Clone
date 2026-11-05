draw_set_font(fntMainMenu); 
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _str = "ГОРЯЧАЯ ЛИНИЯ МАЙАМИ";
var _head = trail[0];

// Масштаб текста
var _title_scale = 2.0; 

// --- ВЫЧИСЛЯЕМ НАКЛОН ---
// Вычисляем, насколько текст сдвинулся по X с прошлого кадра
var _velocity_x = 0;
if (array_length(trail) > 1) {
    _velocity_x = trail[0].x - trail[1].x;
}

// Превращаем скорость в угол наклона (в градусах)
// Коэффициент 1.5 подобран на глаз, чтобы наклон был заметным, но не ломал текст
var _tilt_angle = _velocity_x * 1.5; 
_tilt_angle = clamp(_tilt_angle, -15, 15); // Ограничиваем наклон 15 градусами

// --- ОТРИСОВКА ---

// 1. ШЛЕЙФ (Тоже наклоняем, чтобы он совпадал с текстом)
for (var i = array_length(trail) - 1; i >= 1; i--) {
    var _t = trail[i];
    var _trail_alpha = (1.0 - (i / array_length(trail))) * 0.15;
    
    if (_trail_alpha > 0) {
        draw_set_alpha(_trail_alpha);
        draw_set_color(make_color_rgb(100, 0, 50)); 
        var _t_scale = _title_scale * (1.0 - (i * 0.02));
        
        // Наклоняем каждую часть шлейфа (можно чуть уменьшить наклон для старых частей)
        draw_text_transformed(_t.x, _t.y, _str, _t_scale, _t_scale, _tilt_angle * 0.5);
    }
}

// 2. ТЕНЬ
draw_set_alpha(1);
draw_set_color(c_black);
draw_text_transformed(_head.x + 4, _head.y + 4, _str, _title_scale, _title_scale, _tilt_angle);

// 3. РОЗОВЫЙ СДВИГ
draw_set_alpha(1);
draw_set_color(make_color_rgb(255, 50, 150)); 
draw_text_transformed(_head.x + 2, _head.y, _str, _title_scale, _title_scale, _tilt_angle);

// 4. БИРЮЗОВЫЙ СДВИГ
draw_set_color(make_color_rgb(0, 255, 255)); 
draw_text_transformed(_head.x - 2, _head.y, _str, _title_scale, _title_scale, _tilt_angle);

// 5. БЕЛЫЕ БЛИКИ
draw_set_alpha(1);
draw_set_color(c_white);
// Здесь используем микро-сдвиг, чтобы перекрыть цветные края
for (var _dx = -1; _dx <= 1; _dx++) {
    for (var _dy = -1; _dy <= 1; _dy++) {
        draw_text_transformed(_head.x + _dx, _head.y + _dy, _str, _title_scale, _title_scale, _tilt_angle);
    }
}

// Сброс
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);