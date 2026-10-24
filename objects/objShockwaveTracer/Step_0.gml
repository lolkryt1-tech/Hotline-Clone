if (!is_ready) exit;

alpha -= fade_speed;
wave_width = min(wave_width + expand_speed, 200);

// --- НОВАЯ ПРОВЕРКА ---
// Если разрешение экрана изменилось (например, нажали Alt+Enter),
// старые поверхности нужно удалить, чтобы они создались заново.
var _real_w = display_get_width();
var _real_h = display_get_height();

if (surface_exists(mask_surf) && surface_get_width(mask_surf) != _real_w) {
    surface_free(mask_surf);
    mask_surf = -1;
}
if (surface_exists(scene_surf) && surface_get_width(scene_surf) != _real_w) {
    surface_free(scene_surf);
    scene_surf = -1;
}
// ----------------------

if (alpha <= 0) {
    if (surface_exists(mask_surf))  { surface_free(mask_surf);  mask_surf  = -1; }
    if (surface_exists(scene_surf)) { surface_free(scene_surf); scene_surf = -1; }
    instance_destroy();
}