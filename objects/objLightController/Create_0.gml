depth = 15000;

// === НАСТРОЙКИ AMBIENT LIGHT ===
ambient_color = make_color_rgb(15, 15, 20);

// === НАСТРОЙКИ РЕНДЕРЕРА ===
use_soft_shadows = false;
use_smooth_lighting = false;

// === СОЗДАНИЕ РЕНДЕРЕРА ===
renderer = new BulbRenderer(view_camera[0]);
renderer.ambientColor = ambient_color;
renderer.soft = use_soft_shadows;
renderer.smooth = use_smooth_lighting;

application_surface_draw_enable(false);

lit_surf = -1;