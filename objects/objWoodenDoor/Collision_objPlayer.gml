swinger = 1; // ИСПРАВЛЕНО: теперь swinger задается правильно

// Если дверь уже летит с бешеной скоростью, не пересчитываем силу толчка
if (abs(swingspeed) > 3.5) exit;

// Звук открытия при слабом толчке
if (abs(swingspeed) < 2) 
{
    audio_play_sound(sndDoorOpen, 0, false);
}

// Вычисляем вектор от петли двери до игрока
var _to_player_x = objPlayer.x - x;
var _to_player_y = objPlayer.y - y;

// Находим угол между вектором на игрока и текущим углом двери
var _player_dir = point_direction(0, 0, _to_player_x, _to_player_y);
var _angle_diff = angle_difference(_player_dir, image_angle);

// ИСПРАВЛЕНО: Если игрок находится "слева" от линии двери, толкаем в одну сторону, если "справа" — в противоположную
if (_angle_diff > 0) 
{
    swingspeed = -8; // Дверь летит ОТ игрока
} 
else 
{
    swingspeed = 8;  // Дверь летит ОТ игрока
}
