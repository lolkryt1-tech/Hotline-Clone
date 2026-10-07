if (abs(swingspeed) > 0) 
{
    // Запоминаем угол перед движением
    var _prev_angle = image_angle;
    image_angle += swingspeed;
    
    // ПРОГРЕССИВНОЕ ИСПРАВЛЕНИЕ: Проверяем коллизию со стеной
    if (place_meeting(x, y, objSolid)) 
    {
        var _door_length = sprite_width; 
        var _tip_x = x + lengthdir_x(_door_length, image_angle);
        var _tip_y = y + lengthdir_y(_door_length, image_angle);
        
        if (position_meeting(_tip_x, _tip_y, objSolid)) 
        {
            image_angle = _prev_angle; 
            swingspeed *= -0.5;        
        }
        else 
        {
            swingspeed *= 0.9; 
        }
    }
    
    // Ограничение углов поворота относительно начального положения (max_angle = 135)
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
    
    // === 1. ПЛАВНОЕ ЭКСПАНЕНЦИАЛЬНОЕ ЗАТУХАНИЕ ===
    // Трение гасит скорость плавно в каждый момент времени
    swingspeed *= 0.94; 
    
    // === 2. АВТО-ЗАХЛОПЫВАНИЕ В СТАРТОВОМ ПРОЁМЕ ===
    // Если дверь близко к закрытию, доводчик возвращает её на место
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
    
    // === 3. БЕЗОПАСНЫЙ СТОП ДЛЯ МИКРО-СКОРОСТЕЙ ===
    // Старое линейное торможение (вычитание по 0.25) ОТСЮДА ПОЛНОСТЬЮ УБРАНО.
    // Как только трение опустило скорость почти до нуля, мы просто зануляем её,
    // чтобы дверь уснула в открытом состоянии и не спамила звуки.
    if (abs(swingspeed) < 0.05) 
    {
        swinger = 0;
        swingspeed = 0;
    }
}
