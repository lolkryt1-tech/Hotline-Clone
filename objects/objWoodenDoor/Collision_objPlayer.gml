// Если дверь заперта — игрок её не открывает
if (closed) 
{
    // Переключаемся на игрока
    with (objPlayer)
    {
        // 1. Вместо отката координат, используем встроенный в move_and_collide фикс.
        // Передаем функции массив из ТЕКУЩЕЙ двери и ВСЕХ твердых стен.
        // Благодаря этому игрок будет скользить по двери и НЕ сможет влететь в стену рядом.
        
        var _targets = [other.id, objSolid]; // Укажите здесь ваш объект стен, если он называется иначе
        
        // 2. Двигаем игрока с учетом обеих коллизий. 
        // Добавляем 4-й и 5-й параметры (max_iterations) для более точного выталкивания при застревании.
        move_and_collide(hor_velocity, ver_velocity, _targets, 4);
    }
    return;
}



swinger = 1;

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

// Толкаем дверь ОТ игрока
if (_angle_diff > 0) 
{
    swingspeed = -8;
} 
else 
{
    swingspeed = 8;
}