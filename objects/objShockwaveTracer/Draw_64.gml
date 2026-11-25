if (!is_ready || alpha <= 0) exit;
if (!surface_exists(application_surface)) exit;

// Используем размеры чистого игрового кадра (рабочего холста)
var _w = surface_get_width(application_surface);
var _h = surface_get_height(application_surface);
if (_w <= 0 || _h <= 0) exit;

// Пересоздаем поверхности, если они отсутствуют или изменился размер холста
if (!surface_exists(mask_surf)
|| surface_get_width(mask_surf) != _w
|| surface_get_height(mask_surf) != _h) {
    if (surface_exists(mask_surf)) surface_free(mask_surf);
    mask_surf = surface_create(_w, _h);
}

if (!surface_exists(scene_surf)
|| surface_get_width(scene_surf) != _w
|| surface_get_height(scene_surf) != _h) {
    if (surface_exists(scene_surf)) surface_free(scene_surf);
    scene_surf = surface_create(_w, _h);
}

// ==========================================
// --- ШАГ 1: МАСКА ИСКАЖЕНИЯ ---
// ==========================================
surface_set_target(mask_surf);
draw_clear_alpha(c_black, 0.0);

var _cam_x = global.cam_x;
var _cam_y = global.cam_y;

// Расчет масштаба относительно игрового холста
var _scale_x = _w / global.cam_w;
var _scale_y = _h / global.cam_h;

var _sx = (start_x - _cam_x) * _scale_x;
var _sy = (start_y - _cam_y) * _scale_y;
var _tx = (target_x - _cam_x) * _scale_x;
var _ty = (target_y - _cam_y) * _scale_y;

// Режим хардмода: зеркальное отражение координат внутри маски
if (global.hard) {
    _sx = _w - _sx;
    _sy = _h - _sy;
    _tx = _w - _tx;
    _ty = _h - _ty;
}

// ==========================================
// === КОМПЕНСАЦИЯ ТОЛЩИНЫ ОТ ЗУМА ===
// ==========================================
var _zoom = max(objEffector.zoom_level, 0.001);
var _adjusted_width = wave_width / _zoom;

// ==========================================
// === ГЕОМЕТРИЯ ВОЛНЫ ===
// ==========================================

var _true_dir = point_direction(_sx, _sy, _tx, _ty);
var _nx = lengthdir_x(_adjusted_width, _true_dir + 90);
var _ny = lengthdir_y(_adjusted_width, _true_dir + 90);

var _x1 = _sx + _nx;
var _y1 = _sy + _ny;
var _x2 = _sx - _nx;
var _y2 = _sy - _ny;
var _x3 = _tx + _nx;
var _y3 = _ty + _ny;
var _x4 = _tx - _nx;
var _y4 = _ty - _ny;

var _color_left  = make_color_rgb(64, 128, 0);
var _color_right = make_color_rgb(192, 128, 0);

draw_primitive_begin(pr_trianglestrip);
draw_vertex_color(_x1, _y1, _color_left, alpha);
draw_vertex_color(_x2, _y2, _color_right, alpha);
draw_vertex_color(_x3, _y3, _color_left, alpha);
draw_vertex_color(_x4, _y4, _color_right, alpha);
draw_primitive_end();

surface_reset_target();

// ==========================================
// --- ШАГ 2: СЦЕНА С ШЕЙДЕРОМ ---
// ==========================================
surface_set_target(scene_surf);
draw_clear_alpha(c_black, 0);

shader_set(shd_explosion_ripple);

var _light_ctrl = instance_find(objLightController, 0);
var _src_surf = application_surface;

// Проверяем наличие контроллера света и его поверхности
if (_light_ctrl != noone && surface_exists(_light_ctrl.lit_surf)) {
    _src_surf = _light_ctrl.lit_surf;
}

texture_set_stage(u_scene_tex, surface_get_texture(_src_surf));
texture_set_stage(u_distort_tex, surface_get_texture(mask_surf));
shader_set_uniform_f(u_force, distortion_force);

// Растягиваем источник под размеры игрового холста
draw_surface_stretched(_src_surf, 0, 0, _w, _h);

shader_reset();
surface_reset_target();

// ==========================================
// --- ШАГ 3: ВЫВОД НА ЭКРАН ---
// ==========================================
gpu_set_blendenable(false);

draw_surface_stretched(
    scene_surf,
    0,
    0,
    display_get_gui_width(),
    display_get_gui_height()
);

gpu_set_blendenable(true);