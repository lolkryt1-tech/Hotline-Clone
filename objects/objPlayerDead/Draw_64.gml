// 1. СОХРАНЯЕМ ТЕКУЩИЕ НАСТРОЙКИ ГРАФИКИ
var _old_font   = draw_get_font();
var _old_color  = draw_get_color();
var _old_alpha  = draw_get_alpha();
var _old_halign = draw_get_halign();
var _old_valign = draw_get_valign();

// 2. ВКЛЮЧАЕМ НАСТРОЙКИ ДЛЯ ИНТЕРФЕЙСА
draw_set_font(fntAmmo);
draw_set_halign(fa_center); 
draw_set_valign(fa_middle); // Текст центрируется по оси вертикали
draw_set_alpha(1.0);

// === НАСТРОЙКИ МАСШТАБА И УВЕЛИЧЕННОЙ ГЕОМЕТРИИ ПЛАШКИ ===
var _text_scale = 0.62; // Размер текста (золотая середина)

// Текст "PRESS R TO RESTART"
var _full_text = "PRESS R TO RESTART";
var _real_text_w = string_width(_full_text) * _text_scale;

// СДЕЛАЛИ КОРОБКУ ЕЩЕ ЧУТЬ БОЛЬШЕ (Ширина +65, Высота 30 для свободного "воздуха" внутри)
var _panel_w = _real_text_w + 65; 
var _panel_h = 30;  

// Позиция плашки: X = 30 пикселей от левого края
var _x1 = 30; 
var _y1 = restart_panel_y - _panel_h;
var _x2 = _x1 + _panel_w;
var _y2 = restart_panel_y + _panel_h;

// === 3А. РИСУЕМ УВЕЛИЧЕННЫЙ СТАТИЧНЫЙ ПОЛНОСТЬЮ ЧЕРНЫЙ ПРЯМОУГОЛЬНИК ===
draw_set_color(c_black);
draw_rectangle(_x1, _y1, _x2, _y2, false);


// === 3Б. РИСУЕМ РАЗНОЦВЕТНЫЙ ТЕКСТ С МЕДЛЕННО КРУЖАЩЕЙСЯ ПО ЧАСОВОЙ ФИОЛЕТОВОЙ ТЕНЬЮ ===

// ПЛАВНЫЙ КРЕН ТЕКСТА: покачивается влево-вправо на максимум 3.5 градуса
var _text_angle = sin(current_time * 0.003) * 3.5;

// Вычисляем НАСТОЯЩИЙ ЦЕНТР плашки (ось вращения строго посередине строки)
var _center_x = _x1 + (_panel_w / 2);
var _center_y = restart_panel_y;

var _part1 = "PRESS ";
var _part2 = "R";
var _part3 = " TO RESTART";

// Вычисляем ширину кусков текста
var _w1 = string_width(_part1) * _text_scale;
var _w2 = string_width(_part2) * _text_scale;
var _w3 = string_width(_part3) * _text_scale;
var _total_w = _w1 + _w2 + _w3;

// Находим смещение от центра до левого старта строки с учётом текущего наклона текста!
var _start_dist = -(_total_w / 2);

// Функция: рисует куски текста с фиолетовой тенью, крутящейся по часовой стрелке МЕДЛЕННЕЕ
var _draw_text_with_orbit_shadow = function(_tx, _ty, _string, _main_color, _scale, _angle) {
    // МЕДЛЕННОЕ КРУЖЕНИЕ: уменьшили коэффициент скорости с 0.006 до 0.003 для ленивого хода
    var _rotate_speed = current_time * 0.003; 
    var _amplitude    = 0.7; // Микро-амплитуда дрожания
    
    // Постоянный базовый сдвиг (+2 справа, +2 снизу) + круговая орбита по cos/sin
    var _sh_x = _tx + 2.0 + (cos(_rotate_speed) * _amplitude);
    var _sh_y = _ty + 2.0 + (sin(_rotate_speed) * _amplitude);

    // Фирменный сочный фиолетовый цвет для 3D-тени
    var _purple_shadow = make_color_rgb(150, 0, 200); 
    draw_set_color(_purple_shadow);
    
    // Рисуем плотную фиолетовую подложку с круговым смещением и наклоном строки
    draw_text_transformed(_sh_x,     _sh_y,     _string, _scale, _scale, _angle);
    draw_text_transformed(_sh_x - 1, _sh_y - 1, _string, _scale, _scale, _angle);
    
    // Рисуем основной цвет поверх тени
    draw_set_color(_main_color);
    draw_text_transformed(_tx, _ty, _string, _scale, _scale, _angle);
};

// Переключаем на fa_left, математика позиций считается от центра вращения
draw_set_halign(fa_left);

// 1. Рисуем "PRESS " (чистый белый)
var _p1_x = _center_x + lengthdir_x(_start_dist, _text_angle);
var _p1_y = _center_y + lengthdir_y(_start_dist, _text_angle);
_draw_text_with_orbit_shadow(_p1_x, _p1_y, _part1, c_white, _text_scale, _text_angle);

// 2. Рисуем "R" (ядовито-желтый)
var _p2_x = _center_x + lengthdir_x(_start_dist + _w1, _text_angle);
var _p2_y = _center_y + lengthdir_y(_start_dist + _w1, _text_angle);
var _r_color = make_color_rgb(255, 240, 0); 
_draw_text_with_orbit_shadow(_p2_x, _p2_y, _part2, _r_color, _text_scale, _text_angle);

// 3. Рисуем " TO RESTART" (белый)
var _p3_x = _center_x + lengthdir_x(_start_dist + _w1 + _w2, _text_angle);
var _p3_y = _center_y + lengthdir_y(_start_dist + _w1 + _w2, _text_angle);
_draw_text_with_orbit_shadow(_p3_x, _p3_y, _part3, c_white, _text_scale, _text_angle);


// 4. ВОЗВРАЩАЕМ ВСЕ СТАРЫЕ НАСТРОЙКИ НАЗАД
draw_set_font(_old_font);
draw_set_color(_old_color);
draw_set_alpha(_old_alpha);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);
