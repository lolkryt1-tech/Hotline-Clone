if (abs(swingspeed) > 0) 
{
    // Запоминаем угол перед движением
    var _prev_angle = image_angle;
    image_angle += swingspeed;
    
    // ПРОГРЕССИВНОЕ ИСПРАВЛЕНИЕ: Проверяем коллизию со стеной
    if (place_meeting(x, y, objSolid)) 
    {
        // Небольшой трюк: проверяем, застревает ли дальний конец двери.
        // Если застревает именно край, а не петля — значит, мы врезались в препятствие.
        var _door_length = sprite_width; // Длина вашей двери
        var _tip_x = x + lengthdir_x(_door_length, image_angle);
        var _tip_y = y + lengthdir_y(_door_length, image_angle);
        
        // Если дальний конец двери пересекает стену, то это настоящий удар об стену
        if (position_meeting(_tip_x, _tip_y, objSolid)) 
        {
            image_angle = _prev_angle; // Возвращаем назад
            swingspeed *= -0.5;        // Отскок
        }
        else 
        {
            // Если дальний конец свободен, но место контакта выдает коллизию — 
            // это микро-задевание стены у основания петли из-за вращения сетки.
            // Позволяем двери двигаться, но чуть-чуть гасим скорость, чтобы не провалиться глубоко.
            swingspeed *= 0.9; 
        }
    }
    
    // Ограничение углов поворота относительно начального положения
    var _angle_diff = angle_difference(image_angle, start_angle);
    if (_angle_diff < -max_angle) 
    {
        image_angle = start_angle - max_angle;
        swingspeed = abs(swingspeed);
    }
    if (_angle_diff > max_angle) 
    {
        image_angle = start_angle + max_angle;
        swingspeed = -abs(swingspeed);
    }
    
    // Плавное затухание скорости (трение)
    if (abs(swingspeed) < 3.5) 
    {
        if (abs(angle_difference(image_angle, start_angle)) < 6) 
        {
            swingspeed = 0;
            image_angle = start_angle;
            swinger = 0;
            exit;
        }
    }
    
    // Линейное торможение
    if (swingspeed > 0.25) swingspeed -= 0.25;
    else if (swingspeed < -0.25) swingspeed += 0.25;
    else 
    {
        swinger = 0;
        swingspeed = 0;
    }
}
