// 1. Плавное торможение (трение), если у вас его еще нет в коде
// speed = max(0, speed - 0.5); // Раскомментируйте, если нужно, чтобы кровь тормозила сама

// 2. Управление анимацией
if (image_index < image_number - 1) 
{
    // Пока анимация не дошла до конца, крутим кадры
    image_index += addspeed;
} 
else 
{
    // Замираем строго на самом последнем кадре
    image_index = image_number - 1; 
}

// 3. Логика спавна капель (кастомный триггер на определенном кадре)
if (image_index >= 2 && is_blood_spawned == 0)
{
    repeat (5 + random(4))
    {
        var _dir = (image_angle - 30) + random(60);
        var _length = 7 + random(10);
        var _my_id = instance_create_layer(x + lengthdir_x(_length, _dir), y + lengthdir_y(_length, _dir), "Instances", objBloodSpeck);
        _my_id.image_angle = _dir;
        _my_id.surface = surface;
    }
    is_blood_spawned = 1;
}

// 4. Остановка объекта при потере скорости (Вместо уничтожения)
if (speed <= 0.1) 
{
    speed = 0; // Полностью останавливаем движение физически
    
    // Эффект замер, теперь его можно "нарисовать" на сурфейсе пола
    // (Если вы используете систему сурфейсов для оптимизации пятен крови)
}