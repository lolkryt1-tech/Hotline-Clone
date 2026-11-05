var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

shader_set(shdPlasma);

shader_set_uniform_f(u_time, anim_time);
// Передаем реальный размер экрана, чтобы соотношение сторон было верным
shader_set_uniform_f(u_resolution, _gui_w, _gui_h);

draw_set_color(c_white);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

shader_reset();