// Безопасность: проверяем, что наш враг вообще существует
if (!instance_exists(owner)) exit;

// Переносим параметры летящего оружия в переменные хартбокса (чтобы враг мог их считать, если нужно)
weapon = other.weapon;
var _weapon_flight_dir = other.direction; 

// === СЮДА ДОБАВЛЯЮТСЯ КЛАССЫ ВРАГОВ ===
switch (owner.class)
{
    case CLASS.REGULAR: // === REGULAR / ОБЫЧНЫЙ ВРАГ (Твой рабочий код сверху) ===
        // 1. Эффект очков / осколков
        if (owner.can_hear == false) { instance_create_layer(owner.x, owner.y, "Instances", objHeadSet); }

        // 2. Создаем на полу упавшее оружие, которое бросил игрок
        var _dropped_weapon = instance_create_layer(owner.x, owner.y, "Instances", objWeapon);
        _dropped_weapon.weapon = other.weapon;

        // Уничтожаем объект летящего в воздухе оружия
        instance_destroy(other); 

        // 3. Спавним объект нокаута на координатах врага
        var _knocked = instance_create_layer(owner.x, owner.y, "Instances", objEnemyKnockedOut);
        _knocked.direction   = _weapon_flight_dir; 
        _knocked.speed       = 4;
        _knocked.my_angle    = _weapon_flight_dir - 180; 
        _knocked.image_index = 1;
        _knocked.faction     = owner.faction;
        _knocked.class       = owner.class;
                        
        // 4. Если у врага в руках было свое оружие, оно вылетает в случайную сторону
        if (owner.weapon != WEAPONS.UNARMED)
        {
            var _dropped = instance_create_layer(owner.x, owner.y, "Instances", objWeapon);
            _dropped.direction = irandom(360);
            _dropped.speed     = 5;
            _dropped.my_angle  = irandom(360);
            _dropped.weapon    = owner.weapon;
        }
                        
        // 5. Полностью удаляем живого врага и сам этот хартбокс из игры
        instance_destroy(owner); 
        instance_destroy();
        break;

    case CLASS.FAT:
        // === МЕСТО ДЛЯ ТОЛСТЯКА ===
        // Пример: audio_play_sound(sndKnock, 1, false); other.direction -= 180; exit;
        break;
        
    case CLASS.VEST:
        // === МЕСТО ДЛЯ БРОНИРОВАННОГО ===
        // Пример: owner.reload = 30; instance_destroy(other); exit;
        break;
        
    case CLASS.DODGER:
        // === МЕСТО ДЛЯ ЛОВКАЧА ===
        // Пример: exit; (оружие просто летит сквозь него)
        break;
        
    default:
        // Резервный выход на случай непредусмотренных классов
        break;
}
