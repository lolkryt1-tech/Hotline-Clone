draw_text(10, 10, "FPS: " + string(fps));

// Отрисовка реального FPS (показывает чистую производительность ПК)
draw_text(10, 30, "FPS Real: " + string(floor(fps_real)));

// 1. СОХРАНЯЕМ ТЕКУЩИЕ НАСТРОЙКИ (чтобы не сломать дебаг)
var _old_font   = draw_get_font();
var _old_color  = draw_get_color();
var _old_alpha  = draw_get_alpha();
var _old_halign = draw_get_halign();
var _old_valign = draw_get_valign();

// 2. ВКЛЮЧАЕМ НАСТРОЙКИ ДЛЯ ИНТЕРФЕЙСА
draw_set_font(fntAmmo);
draw_set_halign(fa_left);
draw_set_valign(fa_middle); // Текст центрируется по оси вертикали

// === БАЗОВЫЕ КООРДИНАТЫ (ЛЕВЫЙ НИЖНИЙ УГОЛ) ===
var _x = 40; 
var _y = display_get_gui_height() - 60; // Единая горизонтальная ось для всего HUD

// 3. ОТРЕСОВКА ИНТЕРФЕЙСА ДЛЯ ОГНЕСТРЕЛЬНОГО ОРУЖИЯ
// Проверяем текущее оружие игрока из энума WEAPONS
if (current_weapon == WEAPONS.PISTOL || current_weapon == WEAPONS.SHOTGUN || current_weapon == WEAPONS.M16) 
{  
    // === ОПРЕДЕЛЯЕМ КАДР ИКОНКИ ПАТРОНА (sprAmmo) ===
    var _ammo_frame = 0; // Дефолтный кадр
    
    if (current_weapon == WEAPONS.PISTOL)  _ammo_frame = 0;
    if (current_weapon == WEAPONS.M16)     _ammo_frame = 1;
	if (current_weapon == WEAPONS.SHOTGUN) _ammo_frame = 2;
    
    var _text = string(ammo); // Текст патронов
    
    // === НАСТРОЙКИ МАСШТАБА И ГЕОМЕТРИИ ===
    var _icon_scale = 3.5;              // Масштаб иконки патрона
    var _icon_w     = 12 * _icon_scale; // Расчетная ширина иконки
    var _gap        = 15;               // Отступ между иконкой и текстом
    
    // Линии начинаются от САМОГО левого края экрана (X = 0)
    var _bg_x1 = 0; 
    
    // Финальная ширина полос (самой верхней)
    var _base_w  = _x + _icon_w + _gap + string_width(_text) + 260;

    // === 3А. РИСУЕМ ЗАТУХАЮЩИЕ ЧЕРНЫЕ ПОЛОСЫ ВРУЧНУЮ ===
    var _bg_y = _y; 
    
    var _draw_fade_line = function(_x1, _y1, _x2, _y2) {
        draw_primitive_begin(pr_trianglestrip);
        draw_vertex_color(_x1, _y1, c_black, 0.45); 
        draw_vertex_color(_x1, _y2, c_black, 0.45);
        draw_vertex_color(_x2, _y1, c_black, 0.0);
        draw_vertex_color(_x2, _y2, c_black, 0.0);
        draw_primitive_end();
    };

    var _step = 30;
    var _shake = 8; 

    _draw_fade_line(_bg_x1, _bg_y - 35, _base_w - (_step * 5) + random_range(-_shake, _shake), _bg_y - 30);
    _draw_fade_line(_bg_x1, _bg_y - 24, _base_w - (_step * 4) + random_range(-_shake, _shake), _bg_y - 19);
    _draw_fade_line(_bg_x1, _bg_y - 13, _base_w - (_step * 3) + random_range(-_shake, _shake), _bg_y - 8);
    _draw_fade_line(_bg_x1, _bg_y - 2,  _base_w - (_step * 2) + random_range(-_shake, _shake), _bg_y + 3);
    _draw_fade_line(_bg_x1, _bg_y + 9,  _base_w - (_step * 1) + random_range(-_shake, _shake), _bg_y + 14);
    _draw_fade_line(_bg_x1, _bg_y + 20, _base_w - (_step * 0) + random_range(-_shake, _shake), _bg_y + 25);

    draw_set_alpha(1.0);
    draw_set_color(c_white);

    // === 3Б. РИСУЕМ ИКОНКУ ПАТРОНА С МЕДЛЕННЫМ КРУГОВЫМ ПОКАЧИВАНИЕМ ===
    var _icon_speed = current_time * 0.002; 
    var _icon_amp   = 3.0;                  
    
    var _icon_circle_angle = cos(_icon_speed) * _icon_amp;
    var _final_icon_angle = icon_shake_angle + _icon_circle_angle;
    
    var _icon_x = _x + cos(_icon_speed) * 1.2;
    var _icon_y = (_y - 6) + sin(_icon_speed) * 1.2;

    // ИСПРАВЛЕНО: Вместо кадра 0 передаем рассчитанный _ammo_frame
    draw_sprite_ext(sprAmmo, _ammo_frame, _icon_x, _icon_y, _icon_scale, _icon_scale, _final_icon_angle, c_white, 1.0); 

    // === 3В. РИСУЕМ ШРИФТ ПАТРОНОВ С ТЯЖЕЛОЙ ОБВОДКОЙ, ДВИЖЕНИЕМ И ПУЛЬСОМ МАСШТАБА ===
    var _text_wave = sin(current_time * 0.003) * 2.0; 
    
    var _text_x = _x + _icon_w + _gap; 
    var _text_y = (_y - 5) + _text_wave; 
    
    // Итоговый масштаб текста: базовый (1.0) + импульс отдачи
    var _current_scale = 1.0 + ammo_scale_pulse;
    
    var _rotate_speed = current_time * 0.003; 
    var _amplitude    = 0.6; 
    
    var _shadow_x = _text_x + (3.0 * _current_scale) + (cos(_rotate_speed) * _amplitude);
    var _shadow_y = _text_y + (3.0 * _current_scale) + (sin(_rotate_speed) * _amplitude);
    
    // === ТЯЖЁЛАЯ ЧЁРНАЯ ОБВОДКА ===
    draw_set_color(c_black);
    var _b_dist = 2 * _current_scale; 
    for (var _ox = -_b_dist; _ox <= _b_dist; _ox += _current_scale) {
        for (var _oy = -_b_dist; _oy <= _b_dist; _oy += _current_scale) {
            draw_text_transformed(_shadow_x + _ox, _shadow_y + _oy, _text, _current_scale, _current_scale, 0);
        }
    }
    for (var _ox = -_b_dist; _ox <= _b_dist; _ox += _current_scale) {
        for (var _oy = -_b_dist; _oy <= _b_dist; _oy += _current_scale) {
            draw_text_transformed(_text_x + _ox, _text_y + _oy, _text, _current_scale, _current_scale, 0);
        }
    }

    // === КРАСНАЯ ТЕНЬ ===
    var _crimson_color = make_color_rgb(180, 0, 50); 
    draw_set_color(_crimson_color); 
    draw_text_transformed(_shadow_x,     _shadow_y,     _text, _current_scale, _current_scale, 0);
    draw_text_transformed(_shadow_x - 1, _shadow_y - 1, _text, _current_scale, _current_scale, 0); 
    draw_text_transformed(_shadow_x - 2, _shadow_y - 2, _text, _current_scale, _current_scale, 0);

    // === БИРЮЗОВЫЙ ТЕКСТ С ЭФФЕКТНЫМ ПОБЕЛЕНИЕМ ПО LERP ===
    var _base_cyan = make_color_rgb(140, 255, 255); 
    var _final_text_color = merge_color(_base_cyan, c_white, ammo_color_factor * 0.85);
    
    draw_set_color(_final_text_color); 
    draw_text_transformed(_text_x, _text_y, _text, _current_scale, _current_scale, 0);
}

// 4. ВОЗВРАЩАЕМ ВСЕ СТАРЫЕ НАСТРОЙКИ НАЗАД
draw_set_font(_old_font);
draw_set_color(_old_color);
draw_set_alpha(_old_alpha);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);
