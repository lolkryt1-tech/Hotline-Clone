function scrEnemyGetSprite(_class, _weapon)
{
    // === 1. ХАРАКТЕРИСТИКИ И ТАЙМИНГИ ОРУЖИЯ ДЛЯ ИИ ===
    var _attack_range        = 0;
    var _is_range_weapon     = false;
    var _cooldown            = 20;
    var _anim_speed          = 0.5;
    var _sounds              = []; 
    
    // Параметры снарядов и гильз
    var _bullet_obj          = noone;
    var _bullet_speed        = 15;
    var _bullet_calibre      = CALIBRE.PISTOL; // НОВОЕ: Калибр пули врага по умолчанию
    var _shell_obj           = noone;
    var _shell_img           = 0; 
    var _shell_x             = 0; 
    var _shell_y             = 0; 
    
    // Перебор параметров строго в одну строчку (добавлены калибры, скорости пули и оффсеты)
    if (_weapon == WEAPONS.UNARMED) { _attack_range = 10;  _is_range_weapon = false; _cooldown = 18; _anim_speed = 0.35; _sounds = [sndSwing1, sndSwing2]; }
    if (_weapon == WEAPONS.BAT)     { _attack_range = 16;  _is_range_weapon = false; _cooldown = 24; _anim_speed = 0.35; _sounds = [sndSwing1, sndSwing2]; }
    if (_weapon == WEAPONS.PIPE)    { _attack_range = 16;  _is_range_weapon = false; _cooldown = 18; _anim_speed = 0.35; _sounds = [sndSwing1, sndSwing2]; }
    if (_weapon == WEAPONS.PISTOL)  { _attack_range = 128; _is_range_weapon = true;  _cooldown = 14; _anim_speed = 1;  _bullet_obj = objBullet; _bullet_calibre = CALIBRE.PISTOL;  _bullet_speed = 13; _shell_obj = objShell; _shell_img = 0; _sounds = [snd9mmShot]; _shell_x = 24; _shell_y = 4; }
    if (_weapon == WEAPONS.M16)     { _attack_range = 256; _is_range_weapon = true;  _cooldown = 7;  _anim_speed = 1;  _bullet_obj = objBullet; _bullet_calibre = CALIBRE.PISTOL;  _bullet_speed = 13; _shell_obj = objShell; _shell_img = 1; _sounds = [sndM16Shot]; _shell_x = 12; _shell_y = 4; }
    if (_weapon == WEAPONS.SHOTGUN) { _attack_range = 160; _is_range_weapon = true;  _cooldown = 75; _anim_speed = 0.5; _bullet_obj = objBullet; _bullet_calibre = CALIBRE.SHOTGUN; _bullet_speed = 13; _shell_obj = objShell; _shell_img = 2; _sounds = [sndShotgunShot]; _shell_x = 8;  _shell_y = 8; }

    // === 2. ДЕФОЛТНАЯ ЗАГОТОВКА ПОД СТРУКТУРУ СПРАЙТОВ ===
    var _sprites = {
        idle: noone, walk: noone, search: noone, attack: noone, knocked: noone, knockedLean: noone,
        deadBlunt: noone, deadCut: noone, deadSlash: noone, deadMachineGun: noone, deadShotgun: noone,
        deadLeanShotgun: noone, deadLeanMachinegun: noone, deadLeanMelee: noone
    };

    // === 3. ЖЕСТКИЙ ПЕРЕБОР СПРАЙТОВ ДЛЯ КАЖДОГО КЛАССА ===
    if (_class == CLASS.REGULAR) 
    {
        _sprites.deadBlunt = sprColombianDeadBlunt; _sprites.deadCut = sprColombianDieBlunt; _sprites.deadSlash = sprColombianDieBlunt; _sprites.deadMachineGun = sprColombianDeadMachinegun; _sprites.deadShotgun = sprColombianDeadShotgun;
        
        _sprites.knocked             = sprColombianGetUp; 
        _sprites.knockedLean         = sprColombianGetUpLean;
        _sprites.deadLeanShotgun     = sprColombianDeadLeanShotgun;
        _sprites.deadLeanMachinegun  = sprColombianDeadLeanMachinegun;
        _sprites.deadLeanMelee       = sprColombianDeadLeanMelee;

        if (_weapon == WEAPONS.UNARMED) { _sprites.idle = sprColombianWalkUnarmed; _sprites.walk = sprColombianWalkUnarmed; _sprites.search = sprColombianWalkUnarmed; _sprites.attack = sprColombianWalkUnarmed; }
        if (_weapon == WEAPONS.BAT)     { _sprites.idle = noone;                   _sprites.walk = sprColombianWalkBat;     _sprites.search = sprColombianSearchBat;     _sprites.attack = sprColombianAttackBat; }
        if (_weapon == WEAPONS.PIPE)    { _sprites.idle = sprColombianIdlePipe;    _sprites.walk = sprColombianWalkPipe;    _sprites.search = sprColombianSearchPipe;    _sprites.attack = sprColombianAttackPipe; }
        if (_weapon == WEAPONS.PISTOL)  { _sprites.idle = sprColombianWalk9mm;     _sprites.walk = sprColombianWalk9mm;     _sprites.search = sprColombianSearch9mm;     _sprites.attack = sprColombianAttack9mm; }
        if (_weapon == WEAPONS.M16)     { _sprites.idle = sprColombianWalkM16;     _sprites.walk = sprColombianWalkM16;     _sprites.search = sprColombianSearchM16;     _sprites.attack = sprColombianAttackM16; }
        if (_weapon == WEAPONS.SHOTGUN) { _sprites.idle = sprColombianWalkShotgun; _sprites.walk = sprColombianWalkShotgun; _sprites.search = sprColombianSearchShotgun; _sprites.attack = sprColombianAttackShotgun; }
    }

    // === 4. АВТО-ПОДСТАНОВКА ОТСУТСТВУЮЩИХ АНИМАЦИЙ ===
    if (_sprites.walk == noone)   _sprites.walk = sprColombianWalkUnarmed;
    if (_sprites.idle == noone)   _sprites.idle = _sprites.walk;
    if (_sprites.search == noone) _sprites.search = _sprites.walk;
    if (_sprites.attack == noone) _sprites.attack = _sprites.walk;
    
    if (_sprites.knocked == noone)     _sprites.knocked = _sprites.deadBlunt;
    if (_sprites.knockedLean == noone) _sprites.knockedLean = _sprites.knocked;
    if (_sprites.deadLeanMelee == noone)      _sprites.deadLeanMelee = _sprites.deadBlunt;
    if (_sprites.deadLeanMachinegun == noone) _sprites.deadLeanMachinegun = _sprites.deadLeanMelee;
    if (_sprites.deadLeanShotgun == noone)    _sprites.deadLeanShotgun = _sprites.deadLeanMelee;

    // Синхронизируем переменные с объектом врага
    weapon = _weapon;
    isRange_weapon = _is_range_weapon;
    
    // === 5. ВОЗВРАТ КОМПАКТНОЙ СТРУКТУРЫ ===
    return {
        sprites:            _sprites, 
        attack_range:       _attack_range,
        cooldown:           _cooldown,
        anim_speed:         _anim_speed,
        bullet_obj:         _bullet_obj,
        bullet_speed:       _bullet_speed,
        bullet_calibre:     _bullet_calibre, // НОВОЕ: Передаем калибр в структуру ИИ
        shell_obj:          _shell_obj,
        shell_img:          _shell_img,
        shell_x:            _shell_x, 
        shell_y:            _shell_y, 
        sounds:             _sounds
    };
}
