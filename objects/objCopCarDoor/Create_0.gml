depth = -5000;

// === КОНСТАНТЫ ===
max_open_angle = 85;      
detection_radius = 64;    
zone_width = 64;          
zone_height = 48;         
zone_offset_forward = -16; 

rotation_speed = 6; // Скорость поворота (градусов за кадр)

// === ПЕРЕМЕННЫЕ СОСТОЯНИЯ ===
base_angle = 0;          
open_direction = 1;      
is_open = false;         
target_angle = 0;        

// === ФЛАГИ ДЛЯ ЗВУКОВ ===
sound_opened_played = false; 
sound_closed_played = false; 