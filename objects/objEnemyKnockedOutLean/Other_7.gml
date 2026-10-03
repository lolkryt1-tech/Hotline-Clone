// 1. Определяем нужный базовый объект на основе класса поведения
var _object_to_spawn = objEnemyColombian; // По умолчанию колумбиец

switch (class)
{
    case CLASS.REGULAR:
        _object_to_spawn = objEnemyColombian;
        break;
        
    // Сюда пишем другие логические классы (например, CLASS.FAT, CLASS.DOG)
}

// === ВЫДВИЖЕНИЕ ВРАГА ВПЕРЕД ОТ СТЕНЫ ===
// Считаем направление взгляда встающего врага
var _look_dir = direction - 180;

// Смещение в пикселях (выдвигаем врага на 8 пикселей вперед от стены, чтобы маска вышла из коллизии)
var _offset_dist = 0; 
var _spawn_x = x + lengthdir_x(_offset_dist, _look_dir);
var _spawn_y = y + lengthdir_y(_offset_dist, _look_dir);

// ИСПРАВЛЕНО: Если в точке смещения бот умудрился коснуться другой стены, 
// move_and_collide на следующем кадре плавно его скорректирует.

// 2. Спавним живого врага БЕЗОПАСНО, чуть дальше от стены
var _revived = instance_create_layer(_spawn_x, _spawn_y, "Instances", _object_to_spawn);

// 3. Передаем ему ВСЕ параметры обратно (Класс + Фракция спасены!)
_revived.class          = class;
_revived.faction        = faction; // Враг встает и помнит свою фракцию!
_revived.weapon         = WEAPONS.UNARMED; // Встает без оружия
_revived.reaction_time  = 0;
_revived.my_angle       = _look_dir;
_revived.direction      = _look_dir;
_revived.state          = STATES.UNARMEDSEARCH;

// 4. НАСТРОЙКА СПРАЙТОВ:
// Функция сама выберет правильные спрайты на основе переданного класса
_revived.my_sprites     = scrEnemyGetSprite(_revived.class, _revived.weapon);
_revived.sprite_index   = _revived.my_sprites.sprites.walk; 

// 5. Уничтожаем прислонившуюся куклу
instance_destroy();
