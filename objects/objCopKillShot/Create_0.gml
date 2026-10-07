image_speed = 0;
image_index = 0;
depth = -3000;

ammo = 0;
weapon = 0;

hurt_index = 11;     // Индекс удара копа
finish_index = 13;   // Финал взмаха копа
triggered_hurt = false;
hit_count = 0;


enemy_image_index = 0;				// Если зажата не зажата лкм, то последнее изображение 14, если нажата, то 18, если всё ещё зажата 21

enemy_faction	= 0;
enemy_class		= 0;
enemy_skin		= 0;
enemy_sprite	= 0;

is_execution = true;

if (enemy_skin == SKIN.COLOMBIANREGULAR)  { enemy_sprite = sprColombianDieShot; }

// === ПЕРЕМЕННЫЕ БУФЕРИЗАЦИИ ВВОДА ===
input_buffer = false;      
input_buffer_time = 0;     