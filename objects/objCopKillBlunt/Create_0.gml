image_speed = 0;
image_index = 4;
depth = -3000;

weapon = 0;
enemy_start_bleeding = false;

hurt_index = 9;
finish_index = 11;

enemy_image_index = 0;

enemy_faction = 0;
enemy_class = 0;

enemy_sprite = sprEffector;

isSwinging = false;
hit_count = 0;

is_execution = true;

if (enemy_class == CLASS.REGULAR) 
{ 
	if (weapon == WEAPONS.PIPE) enemy_sprite = sprColombianDieStomp; else enemy_sprite = sprColombianDieBlunt; 
}

// === ПЕРЕМЕННЫЕ БУФЕРИЗАЦИИ ВВОДА ===
input_buffer = false;      
input_buffer_time = 0;     