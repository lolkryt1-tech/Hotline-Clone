shake = 0;
shake_timer = 0;

_cam = view_camera[0];


my_target = 0;

// Ваша точная база из редактора комнат
base_width = 480; 
base_height = 270;

// Текущий зум, рамки приближения/отдаления
zoom_level = 1.0; 
zoom_min = 0.5;   // Приближение (покажет область 240x135)
zoom_max = 2.5;   // Отдаление (покажет область 1200x675)

camera_set_view_pos(_cam, objPlayer.x, objPlayer.y);

window_set_cursor(cr_none);

// Прогреваем игру и загружаем в кэш шрифт
draw_set_font(fntAmmo);
var _dump1 = string_width("PRESS R TO RESTART0123456789");

/*
if (!instance_exists(objPlayer)) { instance_create_layer(x, y, "Instances", objPlayer); }
if (!instance_exists(objDepthManager)) { instance_create_layer(0, 0, "Instances", objDepthManager); }
if (!instance_exists(objPathManager)) { instance_create_layer(0, 0, "Instances", objPathManager); }
if (!instance_exists(objBloodSurfaceManager)) { instance_create_layer(0, 0, "Blood_layer", objBloodSurfaceManager); }
if (!instance_exists(objSaveManager)) { instance_create_layer(0, 0, "Instances", objSaveManager); }
