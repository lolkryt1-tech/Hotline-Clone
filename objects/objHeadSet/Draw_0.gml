// Рассчитываем размер
var _current_scale = base_scale + (z * 0.04); 

// Тень под очками на земле
draw_sprite_ext(sprite_index, image_index, x, y, _current_scale * 0.8, _current_scale * 0.8, image_angle, c_black, 0.3);

// Рисуем очки со смещением по оси Y
draw_sprite_ext(sprite_index, image_index, x, y - z, _current_scale, _current_scale, image_angle, image_blend, image_alpha);
