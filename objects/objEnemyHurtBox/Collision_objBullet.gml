// 1. АБСОЛЮТНАЯ ЗАЩИТА: Если пуля или САМ ВРАГ уже уничтожены в этом кадре — моментально выходим!
if (other == noone || !instance_exists(other)) exit;

if (!variable_instance_exists(id, "owner") || owner == noone || !instance_exists(owner)) 
{
    instance_destroy(); // Если хозяин мертв, хартбокс удаляется и не виснет в памяти
    exit;
}

// 2. БЕЗОПАСНОЕ ИЗВЛЕЧЕНИЕ ID ПУЛИ
var _bullet_id = other.id;
if (!instance_exists(_bullet_id)) exit;

// 3. ПРОВЕРКА ФРАКЦИИ: Свои пули (пистолетные тоже) не наносят урон союзникам
if (_bullet_id.faction == owner.faction) exit;

// ЗАЩИТА ОТ ПРОСТРЕЛОВ СКВОЗЬ СТЕНЫ
if (collision_line(_bullet_id.x, _bullet_id.y, owner.x, owner.y, objSolidTall, false, true)) exit; 

var _bullet_dir = _bullet_id.direction;

// ЗАГОТОВКА ПОД ЛОВКАЧА
if (owner.class == CLASS.DODGER)
{
    exit; 
}

// Проверяем переменную ваншота
if (!variable_instance_exists(owner, "kill_instantly")) {
    owner.kill_instantly = false;
}

// === ФАЗА 1: ОБРАБОТКА ПОПАДАНИЯ ПО КАЛИБРАМ ===
if (_bullet_id.calibre == CALIBRE.SHOTGUN)
{
    owner.pellets_hit += 1;
    owner.last_hit_dir = _bullet_dir;
    
    var _bullet_faction = _bullet_id.faction; 
    instance_destroy(_bullet_id); 
    
    // Воронка для дробовика (засасывает только вражеские пеллеты)
    var _bullet_list = ds_list_create();
    var _num_bullets = collision_circle_list(x, y, 24, objBullet, false, true, _bullet_list, false);
    
    for (var i = 0; i < _num_bullets; i++)
    {
        var _found_bullet = _bullet_list[| i];
        if (instance_exists(_found_bullet) && _found_bullet.faction != owner.faction && _found_bullet.faction == _bullet_faction && _found_bullet.calibre == CALIBRE.SHOTGUN)
        {
            owner.pellets_hit += 1; 
            instance_destroy(_found_bullet); 
        }
    }
    ds_list_destroy(_bullet_list);
    
    if (owner.pellets_hit < 3) owner.pellets_hit = 3; 
}
else if (_bullet_id.calibre == CALIBRE.MAGNUM)
{
    owner.pellets_hit += 1;
    owner.kill_instantly = true; 
    owner.last_hit_dir = _bullet_dir;
}
else 
{
    // Обычная пуля (PISTOL / M16)
    owner.pellets_hit += 1; 
    owner.kill_instantly = true; 
    owner.last_hit_dir = _bullet_dir;
    instance_destroy(_bullet_id); // Уничтожаем пистолетную пулю игроков
}


// === ФАЗА 2: МГНОВЕННАЯ РЕГИСТРАЦИЯ СМЕРТИ ===
// Дополнительная проверка: если в процессе обработки фазы 1 хозяин ВДРУГ исчез — выходим
if (owner == noone || !instance_exists(owner)) {
    instance_destroy();
    exit;
}

if (owner.pellets_hit > 0)
{
    if (owner.class == CLASS.REGULAR)
    {
        var _hit_sound = choose(sndBulletHit1, sndBulletHit2, sndBulletHit3);
        var _played_sound = audio_play_sound(_hit_sound, 1, false);

        if (owner.can_hear == 0) { instance_create_layer(owner.x, owner.y, "Instances", objHeadSet); }
        if (_played_sound != -1) { audio_sound_pitch(_played_sound, random_range(0.9, 1.1)); }

        var _dead_body = instance_create_layer(owner.x, owner.y, "Instances", objDeadBody);
        
        if (!owner.kill_instantly && owner.pellets_hit >= 3) 
        {
            _dead_body.sprite_index = owner.my_sprites.sprites.deadShotgun;
            _dead_body.speed = 4.0; 
        } 
        else 
        {
            _dead_body.sprite_index = owner.my_sprites.sprites.deadMachineGun;
            _dead_body.speed = 0.5; 
        }
        
        _dead_body.direction    = _bullet_dir;
        _dead_body.my_angle     = _bullet_dir; 
        _dead_body.hit_type     = HIT_TYPE.BULLET;
        _dead_body.go_splat     = 1;
        _dead_body.class        = owner.class; 

        if (owner.weapon != WEAPONS.UNARMED) {
            var _dropped = instance_create_layer(owner.x, owner.y, "Instances", objWeapon);
            _dropped.direction = irandom(360); _dropped.speed = 5; _dropped.my_angle = irandom(360); _dropped.weapon = owner.weapon;
        }

        instance_destroy(owner);
        instance_destroy(); 
        exit;
    }
    
    owner.pellets_hit = 0;
    owner.kill_instantly = false;
}
