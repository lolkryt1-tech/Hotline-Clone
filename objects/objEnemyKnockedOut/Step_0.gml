
// Если таймер закончился — крутим анимацию подъема врага
if (is_GettingUp) { image_index += 0.25; }

// Считаем шаг вперед на основе текущей скорости
var _hspd = lengthdir_x(speed, direction);
var _vspd = lengthdir_y(speed, direction);

// Дополнительная дистанция проверки перед маской
var _extra_x = lengthdir_x(8, direction);
var _extra_y = lengthdir_y(8, direction);

// === МЕТОД КРЕСТА ДЛЯ КАСАНИЯ СТЕН В ПОЛЕТЕ ===
if (place_meeting(x + _hspd + _extra_x, y + _vspd + _extra_y, objSolid))
{
    // Если маска уже пересекается со стеной — возвращаемся
    // в последнюю безопасную позицию и останавливаем движение
    if (!place_free(x, y))
    {
        x = last_safe_x;
        y = last_safe_y;
        speed = 0;
        exit;
    }
    else
    {
        // Маска ещё свободна — аккуратно доходим до стены
        move_contact_solid(direction, 8);
    }

    // Скан крестом на 3 пикселя во все стороны от текущей маски
    var _wall_right = place_meeting(x + 3, y, objSolid);
    var _wall_left  = place_meeting(x - 3, y, objSolid);
    var _wall_down  = place_meeting(x, y + 3, objSolid);
    var _wall_up    = place_meeting(x, y - 3, objSolid);

    var _final_angle = -1;

    if (_wall_right)      { _final_angle = 180; }
    else if (_wall_left)  { _final_angle = 0;   }
    else if (_wall_down)  { _final_angle = 90;  }
    else if (_wall_up)    { _final_angle = 270; }

    if (_final_angle == -1)
    {
        speed = 0;
        exit;
    }

    // Проверка удара спины
    var _angle_diff = abs(angle_difference(direction - 180, _final_angle));
    if (_angle_diff > 45)
    {
        speed = 0;
        exit;
    }

    // Проверка наличия стены за спиной
    var _back_wall_x = x + lengthdir_x(4, _final_angle - 180);
    var _back_wall_y = y + lengthdir_y(4, _final_angle - 180);

    if (!place_meeting(_back_wall_x, _back_wall_y, objSolid))
    {
        speed = 0;
        exit;
    }

    // Создаём настенную куклу
    var _lean = instance_create_layer(x, y, "Instances", objEnemyKnockedOutLean);
    _lean.skin                    = skin;
    _lean.class                   = class;
    _lean.faction                 = faction;
    _lean.sprDeadLeanMelee        = sprDeadLeanMelee;
    _lean.sprDeadLeanShotgun      = sprDeadLeanShotgun;
    _lean.sprDeadLeanMachinegun   = sprDeadLeanMachinegun;

    _lean.my_angle     = _final_angle;
    _lean.direction    = _final_angle;
    _lean.image_index  = 1;
    _lean.sprite_index = sprKnockedLean;

    instance_destroy();
    exit;
}

// Обычное движение по координатам
x += _hspd;
y += _vspd;

// Сохраняем позицию, только если маска не пересекается со стеной
if (place_free(x, y))
{
    last_safe_x = x;
    last_safe_y = y;
}
else
{
    x = last_safe_x;
    y = last_safe_y;
    speed = 0;
}
