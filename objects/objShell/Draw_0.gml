// Сделали увеличение едва заметным: делим z на 40 вместо 15
var _scale_pulse = 1.0 + (z * 0.02); // УМЕНЬШИЛИ коэффициент (было 0.05)

// Точка отрисовки (высота вычитается из Y)
var _draw_y = y - z;

// Рисуем
draw_sprite_ext(sprite_index, image_index, x, _draw_y, _scale_pulse, _scale_pulse, image_angle, c_white, 1.0);