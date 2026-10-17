uid = 0;
is_unlocked = false;
trigger_unlock = true;

image_speed = 0;
image_index = 0;
depth = - 8000;

target_room = noone;
target_floor_index = 0;

target_Px = 0;
target_Py = 0;
target_Ex = 0;
target_Ey = 0;

image_alpha = 0;

// Техническая задержка в 1 кадр для правильной инициализации objFloorClear
trigger_delay = 1;
wait_timer = 1;
clear_delay_timer = 1; 


// Переменные для отслеживания положения на экране
is_on_screen   = true;  
gui_icon_x     = 0;     
gui_icon_y     = 0;     
gui_icon_angle = 0;     

has_spawned_clear_text = false; // Флаг: была ли уже показана надпись о зачистке
first_frame_check      = true;  // Технический флаг для проверки комнаты в самый первый кадр на наличие врагов
