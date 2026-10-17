if (image_index == 1) return;		// Кальян уже упал


if (other.hor_velocity != 0 || other.ver_velocity != 0)
{
    // Получаем точный угол движения игрока (0 - вправо, 90 - вверх, 180 - влево, 270 - вниз)
    var _move_dir = point_direction(0, 0, other.hor_velocity, other.ver_velocity);
	speed = 2;
    
    // Наклоняем кальян строго по вектору толчка
	direction = _move_dir;
    image_angle = direction; 
	image_index = 1;
	audio_play_sound(sndGlass1, 1, false);
}