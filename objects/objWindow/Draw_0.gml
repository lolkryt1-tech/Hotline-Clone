// 1. Отрисовка тени и базовой рамы окна (рисуется ВСЕГДА, даже если окно разбито)
draw_sprite_ext(sprite_index, image_index, x + 2, y, image_xscale, image_yscale, image_angle, c_black, 0.5);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);



// ЕСЛИ ОКНО РАЗБИТО — ВЫХОДИМ, НЕ РИСУЯ БЛИКИ И БИРЮЗОВОЕ СТЕКЛО
if (image_index == 3) exit;

// ========================================================
// 2. НАСТРОЙКИ ПОДГОНКИ И ВЕЛИЧИНА БЛИКА
// ========================================================
var c_hotline_cyan = make_color_rgb(0, 240, 235); 
var is_horizontal  = (sprite_width >= sprite_height);
var glare_width    = 48; // Полная ширина мягкого блика
var slant          = 8;  // Наклон полосы

// Твои проверенные пиксельные корректировки прямоугольника (+2 влево, +1 вправо, +1 вверх, +1 вниз)
var b_left   = -sprite_xoffset + 4 - 2;      var b_right  = -sprite_xoffset + sprite_width - 4 + 1;   
var b_top    = -sprite_yoffset + 3 - 1;      var b_bottom = -sprite_yoffset + sprite_height - 3 + 1;   
var loop_range = (is_horizontal ? sprite_width : sprite_height) + glare_width;

// ========================================================
// 3. РАНДОМИЗИРОВАННЫЙ ПАРАЛЛАКС КАМЕРЫ И ПЕТЛЯ
// ========================================================
var calculated_pos = real(id) * 17.53; 

var cam = view_get_camera(0);
if (cam != -1) { 
    var angle_rad = degtorad(image_angle);
    calculated_pos += (camera_get_view_x(cam) * sin(angle_rad)) + (camera_get_view_y(cam) * cos(angle_rad));
}
var shift = ((calculated_pos * 0.15) mod loop_range);
if (shift < 0) shift += loop_range;

// ========================================================
// 4. МАТРИЦА И ОТРИСОВКА СТЕКЛА
// ========================================================
var matrix_old = matrix_get(matrix_world);
matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, image_angle, 1, 1, 1));

gpu_set_blendmode(bm_normal); draw_set_alpha(1.0); 
draw_rectangle_color(b_left, b_top, b_right, b_bottom, c_hotline_cyan, c_hotline_cyan, c_hotline_cyan, c_hotline_cyan, false);

// ========================================================
// 5. ОТРИСОВКА КОМПАКТНОГО МЕГА-БЛИКА ЧЕРЕЗ ЦВЕТНОЙ ПРИМИТИВ
// ========================================================
gpu_set_blendmode(bm_add);
var pos_var = (is_horizontal ? b_left : b_top) - (glare_width / 2) + shift;
if (pos_var > (is_horizontal ? b_left : b_top) + (is_horizontal ? sprite_width : sprite_height)) pos_var -= loop_range;

draw_primitive_begin(pr_trianglestrip);
if (is_horizontal) {
    // Горизонтальное окно: Градиент слева направо (Прозрачный бирюзовый -> Белый -> Прозрачный бирюзовый)
    draw_vertex_color(clamp(pos_var, b_left, b_right), b_top, c_hotline_cyan, 0);
    draw_vertex_color(clamp(pos_var - slant, b_left, b_right), b_bottom, c_hotline_cyan, 0);
    draw_vertex_color(clamp(pos_var + glare_width/2, b_left, b_right), b_top, c_white, 1);
    draw_vertex_color(clamp(pos_var + glare_width/2 - slant, b_left, b_right), b_bottom, c_white, 1);
    draw_vertex_color(clamp(pos_var + glare_width, b_left, b_right), b_top, c_hotline_cyan, 0);
    draw_vertex_color(clamp(pos_var + glare_width - slant, b_left, b_right), b_bottom, c_hotline_cyan, 0);
} else {
    // Вертикальное окно: Градиент сверху вниз (Прозрачный бирюзовый -> Белый -> Прозрачный бирюзовый)
    draw_vertex_color(b_left, clamp(pos_var, b_top, b_bottom), c_hotline_cyan, 0);
    draw_vertex_color(b_right, clamp(pos_var - slant, b_top, b_bottom), c_hotline_cyan, 0);
    draw_vertex_color(b_left, clamp(pos_var + glare_width/2, b_top, b_bottom), c_white, 1);
    draw_vertex_color(b_right, clamp(pos_var + glare_width/2 - slant, b_top, b_bottom), c_white, 1);
    draw_vertex_color(b_left, clamp(pos_var + glare_width, b_top, b_bottom), c_hotline_cyan, 0);
    draw_vertex_color(b_right, clamp(pos_var + glare_width - slant, b_top, b_bottom), c_hotline_cyan, 0);
}
draw_primitive_end();

// Сброс графики
draw_set_alpha(1.0); gpu_set_blendmode(bm_normal); matrix_set(matrix_world, matrix_old);
