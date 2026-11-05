var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

shader_set(shdLevelTitleSmoke);
shader_set_uniform_f(u_time, anim_time);
shader_set_uniform_f(u_resolution, _gui_w, _gui_h);
shader_set_uniform_f(u_color_base, 0.4, 0.4, 0.45);
shader_set_uniform_f(u_color_glow, 0.3, 0.1, 0.4);
shader_set_uniform_f(u_progress, smoke_progress);
shader_set_uniform_f(u_smoke_seed, smoke_seed_x, smoke_seed_y);

draw_set_color(c_white);
draw_rectangle(0, 0, _gui_w, _gui_h, false);
shader_reset();
