// =========================================================================
// 1. БАЗОВЫЕ ПРОВЕРКИ И ИНИЦИАЛИЗАЦИЯ
// =========================================================================
if (!instance_exists(owner)) 
{ 
    instance_destroy(); 
    exit; 
}

if (other.faction == owner.faction) exit;
if (collision_line(other.x, other.y, owner.x, owner.y, objSolidTall, false, true)) exit; 

var _bullet_dir = other.direction;
var _bullet_calibre = other.calibre; 
var _bullet_faction = other.faction; 

owner.last_hit_dir = _bullet_dir;

// =========================================================================
// 2. ГЛАВНОЕ РАСПРЕДЕЛЕНИЕ ЛОГИКИ ПО КЛАССАМ (SWITCH)
// =========================================================================
switch (owner.class)
{
    // -----------------------------------------------------------------
    // ЛОВКАЧ (DODGER) — Пули честно летят дальше насквозь
    // -----------------------------------------------------------------
    case CLASS.DODGER:
        owner.reload = max(owner.reload, 20);
        owner.state = STATES.DODGE;
        owner.sprite_index = sprColombianDDodge;
        owner.image_index = 4;
        
        exit; // Пуля НЕ уничтожается, урон НЕ наносится, она летит дальше!

    // -----------------------------------------------------------------
    // ТОЛСТЯК (CLASS.FAT) — Впитывает урон, спавнит сочную кровь
    // -----------------------------------------------------------------
    case CLASS.FAT:
        // Сначала обрабатываем калибры и уничтожаем пулю
        if (_bullet_calibre == CALIBRE.SHOTGUN)
        {
            owner.pellets_hit += 1;
            owner.last_hit_dir = _bullet_dir;
            instance_destroy(other); 
            
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
            owner.pellets_hit += 1; 
            owner.last_hit_dir = _bullet_dir;
            if (_bullet_calibre == CALIBRE.MAGNUM) owner.kill_instantly = true; 
            instance_destroy(other); 
        }

        // Спавн звуков и крови
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

        // Просчёт урона/равновесия
        if (owner.state == STATES.FATDIE)
        {
            owner.fat_balance -= (_bullet_calibre == CALIBRE.SHOTGUN) ? (33 * owner.pellets_hit) : ((_bullet_calibre == CALIBRE.MAGNUM) ? 50 : 33);
            owner.knocked_by_bullet = true;
            owner.last_hit_dir = _bullet_dir;
        }
        else
        {
            owner.fat_blood_current -= (_bullet_calibre == CALIBRE.SHOTGUN) ? (33 * owner.pellets_hit) : ((_bullet_calibre == CALIBRE.MAGNUM) ? 50 : 25);
            owner.knocked_by_bullet = false;
        }

        owner.pellets_hit = 0;
        owner.kill_instantly = false;
        
        exit; // Выходим из события для толстяка

    // -----------------------------------------------------------------
    // ОСТАЛЬНЫЕ КЛАССЫ (VEST, REGULAR) — Сбор калибров пули перед Фазой 2
    // -----------------------------------------------------------------
    default:
        if (_bullet_calibre == CALIBRE.SHOTGUN)
        {
            owner.pellets_hit += 1;
            owner.last_hit_dir = _bullet_dir;
            instance_destroy(other); 
            
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
            owner.pellets_hit += 1; 
            owner.last_hit_dir = _bullet_dir;
            if (_bullet_calibre == CALIBRE.MAGNUM) owner.kill_instantly = true; 
            instance_destroy(other); 
        }
        break;
}

// =========================================================================
// 3. ФАЗА СМЕРТИ ИЛИ ОГЛУШЕНИЯ (Для VEST и REGULAR)
// =========================================================================
if (owner.pellets_hit > 0)
{
    // БРОНЕЖИЛЕТОНОСЕЦ (CLASS.VEST)
    if (owner.class == CLASS.VEST)
    {
        var _played_sound = audio_play_sound(choose(sndBulletHitVest, sndBulletHitVest2), 1, false);
        audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
		
        var _sys = part_system_create(psSparks);
        part_system_position(_sys, x, y);
		
        owner.state = STATES.STUN;
        owner.sprite_index = sprColombianVestStun;
        owner.image_index  = 0;
        owner.stun_current += (25 * owner.pellets_hit);
    }

    // ОБЫЧНЫЙ ВРАГ (CLASS.REGULAR)
    else if (owner.class == CLASS.REGULAR)
    {
		scrAddKillStats(250, false);
		
        var _hit_sound = choose(sndBulletHit1, sndBulletHit2, sndBulletHit3);
        var _played_sound = audio_play_sound(_hit_sound, 1, false);

        if (owner.can_hear == 0) { instance_create_layer(owner.x, owner.y, "Instances", objHeadSet); }
        audio_sound_pitch(_played_sound, random_range(0.9, 1.1));

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
			_dropped.speed = 5; 
			_dropped.my_angle = irandom(360); 
			_dropped.weapon = owner.weapon;
            _dropped.ammo = owner.ammo;
        }

        instance_destroy(owner);
        instance_destroy(); 
        exit;
    }
    
    // Сброс триггеров кадра для выжившего Жилета
    owner.pellets_hit = 0;
    owner.kill_instantly = false;
}
