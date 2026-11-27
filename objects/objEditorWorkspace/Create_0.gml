depth = -100;

/// === РАБОЧАЯ ОБЛАСТЬ ===

// Размеры этажа
floor_width  = 2400;
floor_height = 1600;

// Положение рабочей области
floor_x = 0;
floor_y = 0;


// === КАМЕРА ===

// Базовая ширина области обзора
base_view_width = 960;

// Создаём отдельную камеру
var _gui_w = max(display_get_gui_width(), 1);
var _gui_h = max(display_get_gui_height(), 1);

var _view_h = base_view_width * _gui_h / _gui_w;

camera_id = camera_create_view(0, 0, base_view_width, _view_h, 0, noone, -1, -1, -1, -1);

// Назначаем камеру окну
view_enabled = true;
view_visible[0] = true;
view_camera[0] = camera_id;


// === ПОЛОЖЕНИЕ КАМЕРЫ ===

// Текущая позиция
camera_x = 0;
camera_y = 0;

// Целевая позиция
camera_target_x = 0;
camera_target_y = 0;


// === МАСШТАБ ===

zoom = 1.0;
zoom_min = 0.25;
zoom_max = 2.0;


// === ПЕРЕМЕЩЕНИЕ ===

is_panning = false;

pan_mouse_x = 0;
pan_mouse_y = 0;


// === ПЛАВНОСТЬ ===

// Скорость приближения к целевой позиции
camera_smooth = 48;


// === СЕТКА ===

grid_enabled = true;
grid_cell_size = 16;
grid_major_size = 128;
grid_min_spacing = 8;

// === ПРИВЯЗКА К СЕТКЕ ===

snap_enabled = true;
snap_cell_size = 16;



// === ИНСТРУМЕНТЫ ===

active_tool = "PENCIL"; // PENCIL / RECTANGLE

// Последняя обработанная клетка карандаша
pencil_last_x = -1;
pencil_last_y = -1;

// Состояние прямоугольного выделения
rectangle_active = false;
rectangle_action = ""; // DRAW / ERASE

rectangle_start_x = -1;
rectangle_start_y = -1;
rectangle_end_x = -1;
rectangle_end_y = -1;

// Временное сохранение тайлов при предпросмотре стирания
rectangle_preview_layer = -1;
rectangle_preview_cells = [];


// === ИСТОРИЯ ИЗМЕНЕНИЙ TILEMAP ===
tile_history_active = false;
tile_history_layer = -1;
tile_history_cells = [];