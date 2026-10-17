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
         // Спавн звуков и крови
        owner.fat_is_bleeding = true;
		owner.fat_blood_current -= 50;
        var _hit_sound = choose(sndBulletHit1, sndBulletHit2, sndBulletHit3);
        var _played_sound = audio_play_sound(_hit_sound, 1, false);
        audio_sound_pitch(_played_sound, random_range(0.8, 0.95)); 

        // ИСПРАВЛЕННЫЙ БЛОК: Теперь скорость применяется к созданному объекту крови!
        var _smoke_count = irandom_range(1, 4);
        repeat(_smoke_count)
        {
            var _blood_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
            _blood_smoke.speed = random_range(1.0, 2.2);
            var _random_dir = (owner.direction - 180) + random_range(-35, 35);
            _blood_smoke.direction = _random_dir;
            _blood_smoke.my_angle  = _random_dir; 
        }
		
		instance_destroy(other); 
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
