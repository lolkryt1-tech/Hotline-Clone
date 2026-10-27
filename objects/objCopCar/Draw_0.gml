// 1. Рисуем собственную тень объекта со смещением вправо
draw_sprite_ext(sprite_index, image_index, x + 2, y, image_xscale, image_yscale, image_angle, c_black, 0.5);

// 2. Рисуем сам объект поверх тени
draw_self();

// === ВИЗУАЛИЗАЦИЯ И ДЕБАГ ЗОНЫ ВХОДА ===
var _w2 = car_zone_width / 2;
var _h2 = car_zone_height / 2;

// Вычисляем смещения по осям машины с помощью lengthdir.
// lengthdir_x/y(длина, угол) считает смещение ВДОЛЬ машины (по X)
// lengthdir_x/y(длина, угол + 90) считает смещение ПОПЕРЕК машины (по Y)

// Точка 1: задний левый угол зоны (-_w2, -_h2)
var _x1 = x + lengthdir_x(-_w2, image_angle) + lengthdir_x(-_h2, image_angle + 90);
var _y1 = y + lengthdir_y(-_w2, image_angle) + lengthdir_y(-_h2, image_angle + 90);

// Точка 2: передний левый угол зоны (_w2, -_h2)
var _x2 = x + lengthdir_x(_w2, image_angle) + lengthdir_x(-_h2, image_angle + 90);
var _y2 = y + lengthdir_y(_w2, image_angle) + lengthdir_y(-_h2, image_angle + 90);

// Точка 3: передний правый угол зоны (_w2, _h2)
var _x3 = x + lengthdir_x(_w2, image_angle) + lengthdir_x(_h2, image_angle + 90);
var _y3 = y + lengthdir_y(_w2, image_angle) + lengthdir_y(_h2, image_angle + 90);

// Точка 4: задний правый угол зоны (-_w2, _h2)
var _x4 = x + lengthdir_x(-_w2, image_angle) + lengthdir_x(_h2, image_angle + 90);
var _y4 = y + lengthdir_y(-_w2, image_angle) + lengthdir_y(_h2, image_angle + 90);

// Зеленый цвет, если игрок внутри, красный — если снаружи
var _color = car_zone_active ? c_lime : c_red;

// Отрисовка рамки зоны
draw_line_color(_x1, _y1, _x2, _y2, _color, _color);
draw_line_color(_x2, _y2, _x3, _y3, _color, _color);
draw_line_color(_x3, _y3, _x4, _y4, _color, _color);
draw_line_color(_x4, _y4, _x1, _y1, _color, _color);

// Текст "IN CAR" при активации зоны
if (car_zone_active) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    
    // Тень текста
    draw_text_color(x, y - 40 + 1, "IN CAR", c_black, c_black, c_black, c_black, 1);
    // Основной текст
    draw_text_color(x, y - 40, "IN CAR", c_lime, c_lime, c_lime, c_lime, 1);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
