//if (is_unlocked && !is_on_screen) { return; }
// Вычисляем плавное смещение (амплитуда 6 пикселей)
var _wave = sin(hover_timer) * 4;

// ВАРИАНТ А: Покачивание ВПЕРЕД-НАЗАД (по направлению стрелки)
var _draw_x = x + lengthdir_x(_wave, image_angle);
var _draw_y = y + lengthdir_y(_wave, image_angle);

/* 
// ВАРИАНТ Б: Покачивание ВЛЕВО-ВПРАВО (перпендикулярно направлению стрелки)
var _draw_x = x + lengthdir_x(_wave, image_angle + 90);
var _draw_y = y + lengthdir_y(_wave, image_angle + 90);
*/

// Отрисовка со смещенными координатами
draw_sprite_ext(sprite_index, image_index, _draw_x, _draw_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
