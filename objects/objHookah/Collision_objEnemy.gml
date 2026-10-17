if (image_index == 1) return; // Кальян уже упал

// Проверяем, что у врага есть скорость (он движется)
if (other.current_speed > 0.1)
{
    // Так как у врагов нет hor_velocity/ver_velocity, определяем направление по их встроенной переменной direction или image_angle
    var _move_dir = other.direction; 

    speed = 2; // Кальян отлетает
    
    direction = _move_dir;
    image_angle = direction; 
    image_index = 1; // Переключаем спрайт на упавший
    audio_play_sound(sndGlass1, 1, false); // Звук разбитого стекла
}
