// Если таймер закончился — крутим анимацию подъема врага
if (is_GettingUp) { image_index += 0.25; }

// Считаем шаг вперед на основе текущей скорости
var _hspd = lengthdir_x(speed, direction);
var _vspd = lengthdir_y(speed, direction);

// === МЕТОД КРЕСТА ДЛЯ КАСАНИЯ СТЕН В ПОЛЕТЕ ===
// Проверяем: если на следующем шаге мы врежемся в стену
if (place_meeting(x + _hspd, y + _vspd, objSolid))
{
    // 1. Скан крестом на 3 пикселя во все стороны от текущей маски
    var _wall_right = place_meeting(x + 3, y, objSolid); // Стена справа
    var _wall_left  = place_meeting(x - 3, y, objSolid); // Стена слева
    var _wall_down  = place_meeting(x, y + 3, objSolid); // Стена снизу
    var _wall_up    = place_meeting(x, y - 3, objSolid); // Стена сверху
    
    // Изначально ставим флаг, что угол не определен
    var _final_angle = -1; 
    
    // Выбор угла строго по осям плитки
    if (_wall_right)      { _final_angle = 180; } // Стена справа -> лицом влево
    else if (_wall_left)  { _final_angle = 0;   } // Стена слева  -> лицом вправо
    else if (_wall_down)  { _final_angle = 90;  } // Стена снизу  -> лицом вверх
    else if (_wall_up)    { _final_angle = 270; } // Стена сверху  -> лицом вниз
    
    // Если влетел ровно в стык по диагонали и крест не нащупал одну доминирующую стену:
    if (_final_angle == -1)
    {
        speed = 0;
        exit; 
    }

    // === СТРОГАЯ ПРОВЕРКА НА УДАР СПИНЫ ===
    var _angle_diff = abs(angle_difference(direction - 180, _final_angle));
    if (_angle_diff > 45) 
    {
        speed = 0;
        exit; 
    }

    // === НАОБОРОТ: ПРОВЕРКА НАЛИЧИЯ СТЕНЫ ЗА СПИНОЙ ===
    // Ищем стену в 4 пикселях позади будущего направления взгляда
    var _back_wall_x = x + lengthdir_x(4, _final_angle - 180);
    var _back_wall_y = y + lengthdir_y(4, _final_angle - 180);
    
    // Если за спиной ВДРУГ оказалась пустота (нет стены) — отменяем посадку
    if (!place_meeting(_back_wall_x, _back_wall_y, objSolid))
    {
        speed = 0;
        exit; // Не спавним objLean, враг падает на пол, чтобы не висеть спиной в воздухе
    }

    // 2. Спавним настенную куклу (если все проверки пройдены)
    var _lean = instance_create_layer(x, y, "Instances", objEnemyKnockedOutLean);
    _lean.class       = class;
    _lean.faction     = faction; 
    
    // Передаем строго ровные углы: 0, 90, 180 или 270
    _lean.my_angle    = _final_angle;
    _lean.direction   = _final_angle;
    _lean.image_index = 1;
    
    var _temp_data = scrEnemyGetSprite(class, WEAPONS.UNARMED);
    _lean.sprite_index = _temp_data.sprites.knockedLean;
    
    // 3. Мгновенно уничтожаем себя в полете, уступая место настенной позе
    instance_destroy();
}
