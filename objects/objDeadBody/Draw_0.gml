/*
// 1. Строим мировую матрицу, смещая объект по оси Z
var matrix = matrix_build(0, 0, my_z_index, 0, 0, 0, 1, 1, 1);
matrix_set(matrix_world, matrix);

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, my_angle, image_blend, image_alpha);
draw_text(x, y + 30, depth);

// Сбрасываем матрицу в исходное состояние
matrix_set(matrix_world, matrix_build_identity());
*/

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, my_angle, image_blend, image_alpha);