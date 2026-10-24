renderer.Update();

var _w = window_get_width();
var _h = window_get_height();

// ЗАЩИТА ОТ ALT+TAB
if (_w <= 0 || _h <= 0) exit;

// Получаем освещённую поверхность из официального API Bulb
var _bulb_out = renderer.GetOutputSurface(application_surface);

if (surface_exists(_bulb_out)) {
    // Создаём/пересоздаём lit_surf под размер окна
    if (!surface_exists(lit_surf) || surface_get_width(lit_surf) != _w) {
        if (surface_exists(lit_surf)) surface_free(lit_surf);
        lit_surf = surface_create(_w, _h);
    }
    
    // Копируем освещённую картинку в lit_surf (для шоквейва)
    surface_set_target(lit_surf);
    draw_clear_alpha(c_black, 1);
    draw_surface_stretched(_bulb_out, 0, 0, _w, _h);
    surface_reset_target();
    
    // Выводим освещённую сцену на экран
    draw_surface(lit_surf, 0, 0);
}