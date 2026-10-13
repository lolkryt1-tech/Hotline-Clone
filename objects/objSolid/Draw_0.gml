// 1. Рисуем собственную тень объекта со смещением вправо
draw_sprite_ext(sprite_index, image_index, x + 2, y, image_xscale, image_yscale, image_angle, c_black, 0.5);

// 2. Рисуем сам объект поверх тени
draw_self();