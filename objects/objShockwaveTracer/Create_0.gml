alpha = 1.0;              // стартовая прозрачность (влияет на силу искажения)
wave_width = 2;           // половина толщины полосы искажения
expand_speed = 3.5;       // как быстро полоса РАСШИРЯЕТСЯ (толстеет со временем)
fade_speed = 0.08;        // как быстро волна ЗАТУХАЕТ (время жизни)
distortion_force = 0.04;  // сила сдвига пикселей

start_x = 0;
start_y = 0;
target_x = 0;
target_y = 0;
is_ready = false;

u_scene_tex   = shader_get_sampler_index(shd_explosion_ripple, "u_scene_tex");
u_distort_tex = shader_get_sampler_index(shd_explosion_ripple, "u_distort_tex");
u_force       = shader_get_uniform(shd_explosion_ripple, "u_force");
distortion_force = 0.04;

mask_surf  = -1;
scene_surf = -1;