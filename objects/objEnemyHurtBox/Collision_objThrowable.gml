// Безопасность: проверяем, что наш враг вообще существует
if (!instance_exists(owner)) exit;

// Переносим параметры летящего оружия в переменные хартбокса
weapon = other.weapon;
var _weapon_flight_dir = other.direction; 

if (owner.class == CLASS.REGULAR && owner.state == STATES.HIDERDUCK)
{
    exit; // Пуля НЕ уничтожается, урон НЕ наносится, она летит дальше!
}

// === СЮДА ДОБАВЛЯЮТСЯ КЛАССЫ ВРАГОВ ===
switch (owner.class)
{
    case CLASS.REGULAR:
		scrAddKillStats(500, false);
		audio_play_sound(sndCut1, 1, false);
		
		if (owner.can_hear == 0) { instance_create_layer(owner.x, owner.y, "Instances", objHeadSet); }
	
        // 1. Выбрасываем оружие, которое было у врага
        var _dropped_weapon = instance_create_layer(owner.x, owner.y, "Instances", objWeapon);
        _dropped_weapon.weapon = owner.weapon;
        _dropped_weapon.ammo   = owner.ammo;
		
        // 3. Спавним анимированный труп вместо стандартного knockeddown
        var _dead_body = instance_create_layer(owner.x, owner.y, "Instances", objAnimatedDeadBody);
        _dead_body.my_angle = _weapon_flight_dir - 180;
        
        // 4. Уничтожаем самого врага, так как он мгновенно погиб
		instance_destroy(other);
        instance_destroy(owner);
		
        // 5. Уничтожаем текущий хартбокс
        instance_destroy();
		
		objEffector.shake = 0.25;
        break;

    case CLASS.FAT:
        // === МЕСТО ДЛЯ ТОЛСТЯКА ===
        break;
        
    case CLASS.VEST:
        // === МЕСТО ДЛЯ БРОНИРОВАННОГО ===
        break;
        
    case CLASS.DODGER:
        // Доджер полностью игнорирует урон от метательного оружия и просто уворачивается
        owner.reload = max(owner.reload, 20);
        owner.state = STATES.DODGE;
	
        owner.sprite_index = sprColombianDDodge;
        owner.image_index = 4;
        break; 
        
    default:
        break;
}
