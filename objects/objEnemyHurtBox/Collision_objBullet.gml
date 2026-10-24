// =========================================================================
// 1. БАЗОВЫЕ ПРОВЕРКИ И ИСКЛЮЧЕНИЯ (Пуля гарантированно летит МИМО)
// =========================================================================
if (!instance_exists(owner)) 
{ 
    instance_destroy(); 
    exit; 
}

if (other.faction == owner.faction) exit;
if (collision_line(other.x, other.y, owner.x, owner.y, objSolidTall, false, true)) exit; 

// А) Обычный враг сидит на корточках в укрытии — пуля летит дальше насквозь
if (owner.class == CLASS.REGULAR && owner.state == STATES.HIDERDUCK)
{
    exit; 
}

// Б) Ловкач уклоняется от атаки — пуля честно летит дальше насквозь
if (owner.class == CLASS.DODGER)
{
    owner.reload       = max(owner.reload, 20);
    owner.state        = STATES.DODGE;
    owner.sprite_index = sprColombianDDodge;
    owner.image_index  = 4;
    exit; 
}

// =========================================================================
// 2. ФАЗА ТОЧНОГО ПОПАДАНИЯ (Сбор параметров и поглощение пачки дроби)
// =========================================================================
var _bullet_dir     = other.direction;
var _bullet_calibre = other.calibre; 
var _bullet_faction = other.faction; 

owner.last_hit_dir = _bullet_dir;
owner.pellets_hit += 1; // Засчитываем текущую пулю

if (_bullet_calibre == CALIBRE.SHOTGUN)
{
    instance_destroy(other); // Удаляем первую пойманную дробинку
    
    // Собираем остальные дробинки в радиусе хитбокса за этот же кадр
    var _bullet_list = ds_list_create();
    var _num_bullets = collision_circle_list(x, y, 24, objBullet, false, true, _bullet_list, false);
    
    for (var i = 0; i < _num_bullets; i++)
    {
        var _found_bullet = _bullet_list[| i];
        if (_found_bullet.faction != owner.faction && _found_bullet.faction == _bullet_faction && _found_bullet.calibre == CALIBRE.SHOTGUN)
        {
            owner.pellets_hit += 1; 
            instance_destroy(_found_bullet); 
        }
    }
    ds_list_destroy(_bullet_list);
    
    if (owner.pellets_hit < 3) owner.pellets_hit = 3; 
}
else 
{
    // Обычная пуля уничтожается. Если калибр КРУПНЫЙ — ставим флаг ваншота
    if (_bullet_calibre == CALIBRE.BIG) owner.kill_instantly = true; 
    instance_destroy(other); 
}

// =========================================================================
// 3. РАСПРЕДЕЛЕНИЯ УРОНА И ЭФФЕКТОВ ПО КЛАССАМ (SWITCH)
// =========================================================================
switch (owner.class)
{
    // -----------------------------------------------------------------
    // ТОЛСТЯК (CLASS.FAT) — Впитывает урон по массе и балансу
    // -----------------------------------------------------------------
    case CLASS.FAT:
        owner.fat_is_bleeding = true;
        
        var _hit_sound = choose(sndBulletHit1, sndBulletHit2, sndBulletHit3);
        var _played_sound = audio_play_sound(_hit_sound, 1, false);
        audio_sound_pitch(_played_sound, random_range(0.8, 0.95)); 

        var _smoke_count = irandom_range(1, 4);
        repeat(_smoke_count)
        {
            var _blood_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
            _blood_smoke.speed = random_range(1.0, 2.2);
            var _random_dir = (_bullet_dir - 180) + random_range(-35, 35);
            _blood_smoke.direction = _random_dir;
            _blood_smoke.my_angle  = _random_dir; 
        }

        if (owner.state == STATES.FATDIE)
        {
            if (_bullet_calibre == CALIBRE.SNIPER) {
                owner.fat_balance -= 100;
            } else {
                owner.fat_balance -= (_bullet_calibre == CALIBRE.SHOTGUN) ? (33 * owner.pellets_hit) : ((_bullet_calibre == CALIBRE.BIG) ? 50 : 33);
            }
            owner.knocked_by_bullet = true;
        }
        else
        {
            if (_bullet_calibre == CALIBRE.SNIPER) {
                owner.fat_blood_current -= 150;
            } else {
                owner.fat_blood_current -= (_bullet_calibre == CALIBRE.SHOTGUN) ? (33 * owner.pellets_hit) : ((_bullet_calibre == CALIBRE.BIG) ? 50 : 25);
            }
            owner.knocked_by_bullet = false;
        }

        owner.pellets_hit = 0;
        owner.kill_instantly = false;
        exit; 

    // -----------------------------------------------------------------
    // БРОНЕЖИЛЕТ (CLASS.VEST) — Получает искры и уходит в стан
    // -----------------------------------------------------------------
	case CLASS.VEST:
	var _played_sound = audio_play_sound(choose(sndBulletHitVest, sndBulletHitVest2), 1, false);
	audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
	
	scrFxSparksHit(x, y, _bullet_dir);
	owner.spark_flash = 3;
	
	owner.state = STATES.STUN;
	owner.sprite_index = sprColombianVestStun;
	owner.image_index  = 0;
    
	if (_bullet_calibre == CALIBRE.SNIPER) {
		owner.stun_current += 100;
	} else {
		owner.stun_current += (25 * owner.pellets_hit);
	}
	break;

    // -----------------------------------------------------------------
    // ТОЛСТЯК В БРОНЕЖИЛЕТЕ (CLASS.FATVEST) — Только эффекты попадания
    // в броник (звук + искры), пуля уничтожается. Урона/стана/смены
    // состояния нет.
    // -----------------------------------------------------------------
    case CLASS.FATVEST:
        var _played_sound = audio_play_sound(choose(sndBulletHitVest, sndBulletHitVest2), 1, false);
        audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
		scrFxSparksHit(x, y, _bullet_dir, owner.current_speed + 2);
		
		part_particles_create(global.sys_sparks, x, y, global.type_sparks, 10);
		
		owner.should_spark = true;
        break;

    // -----------------------------------------------------------------
    // ОБЫЧНЫЙ (CLASS.REGULAR) — Мгновенная смерть, дроп оружия и спавн трупа
    // -----------------------------------------------------------------
    case CLASS.REGULAR:
		scrAddKillStats(250, false);
		
        var _hit_sound = choose(sndBulletHit1, sndBulletHit2, sndBulletHit3);
        var _played_sound = audio_play_sound(_hit_sound, 1, false);
        audio_sound_pitch(_played_sound, random_range(0.9, 1.1));

        if (owner.can_hear == 0) { instance_create_layer(owner.x, owner.y, "Instances", objHeadSet); }

        var _dead_body = instance_create_layer(owner.x, owner.y, "Instances", objDeadBody);
        _dead_body.sprite_index = (!owner.kill_instantly && owner.pellets_hit >= 3) ? owner.sprDeadShotgun : owner.sprDeadMachineGun;
        _dead_body.speed        = (!owner.kill_instantly && owner.pellets_hit >= 3) ? 4.0 : 0.5; 
        
        _dead_body.direction    = _bullet_dir;
        _dead_body.my_angle     = _bullet_dir; 
        _dead_body.hit_type     = HIT_TYPE.BULLET;
        _dead_body.go_splat     = 1;
        _dead_body.skin         = owner.skin;

        if (owner.weapon != WEAPONS.UNARMED) 
        {
            var _dropped = instance_create_layer(owner.x, owner.y, "Instances", objWeapon);
            _dropped.direction = irandom(360); 
			_dropped.speed     = 5; 
			_dropped.my_angle  = irandom(360); 
			_dropped.weapon    = owner.weapon;
            _dropped.ammo      = owner.ammo;
        }

        instance_destroy(owner);
        instance_destroy(); 
        exit;
}

// Сброс накопленных временных параметров для выживших инстансов (например, VEST)
owner.pellets_hit = 0;
owner.kill_instantly = false;