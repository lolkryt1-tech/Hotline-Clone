// Безопасность: проверяем, что наш враг вообще существует
if (!instance_exists(owner)) exit;

// Переносим параметры летящего оружия в переменные хартбокса
weapon = other.weapon;
var _weapon_flight_dir = other.direction; 

// === СЮДА ДОБАВЛЯЮТСЯ КЛАССЫ ВРАГОВ ===
switch (owner.class)
{
    case CLASS.REGULAR:
        var _dropped_player_weapon = instance_create_layer(owner.x, owner.y, "Instances", objWeapon);
        _dropped_player_weapon.weapon = other.weapon;
		_dropped_player_weapon.ammo   = other.ammo;
        instance_destroy(other); 
		
        scrEnemyGetHitMelee(owner, WEAPONS.UNARMED, _weapon_flight_dir, id);
		
        instance_destroy();
        break;

    case CLASS.FAT:
        // === МЕСТО ДЛЯ ТОЛСТЯКА ===
        break;
        
    case CLASS.VEST:
        _dropped_player_weapon = instance_create_layer(owner.x, owner.y, "Instances", objWeapon);
        _dropped_player_weapon.weapon = other.weapon;
		_dropped_player_weapon.ammo   = other.ammo;
        instance_destroy(other); 
		
        scrEnemyGetHitMelee(owner, WEAPONS.UNARMED, _weapon_flight_dir, id);
		
        instance_destroy();
        break;
        
    case CLASS.DODGER:
		owner.reload = max(owner.reload, 20);
	    owner.state = STATES.DODGE;
	
		owner.sprite_index = sprColombianDDodge;
		owner.image_index = 4;
		break; 
        
    default:
        break;
}
