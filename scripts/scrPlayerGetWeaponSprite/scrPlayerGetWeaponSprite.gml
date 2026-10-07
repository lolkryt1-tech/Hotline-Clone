/// @param {Real} _character Персонаж игрока (CHARACTER.COP и т.д.)
/// @param {Real} _weapon Текущее оружие (WEAPONS.UNARMED, WEAPONS.M16 и т.g.)
function scrPlayerGetWeaponSprite(_character, _weapon)
{
    // === 1. ХАРАКТЕРИСТИКИ ОРУЖИЯ ===
    var _cooldown    = 0;
    var _anim_speed  = 0;
    var _is_ranged   = false;
    var _frame_start = 0;
    
    var _melee_type  = HIT_TYPE.UNARMED; 
    
    var _shake       = 0; 
    var _sounds      = []; 
    
    // Параметры для вылета пули и гильз у игрока
    var _bullet_obj     = noone;
    var _bullet_speed   = 15;
    var _bullet_calibre = CALIBRE.PISTOL; 
    var _shell_obj      = noone;
    var _shell_img      = 0; 
    var _shell_x        = 0; 
    var _shell_y        = 0; 
    
    // Перебор параметров
    if (_weapon == WEAPONS.UNARMED) { _cooldown = 18; _anim_speed = 0.35; _is_ranged = false; _frame_start = 0; _melee_type = HIT_TYPE.UNARMED; _shake = 0.5; _sounds = [sndSwing1, sndSwing2]; }
	if (_weapon == WEAPONS.KNIFE)   { _cooldown = 0;  _anim_speed = 0.75; _is_ranged = false; _frame_start = 0; _melee_type = HIT_TYPE.CUT;		_shake = 0.2; _sounds = [sndSwing1, sndSwing2]; }
    if (_weapon == WEAPONS.BAT)     { _cooldown = 32; _anim_speed = 0.35; _is_ranged = false; _frame_start = 1; _melee_type = HIT_TYPE.BLUNT;   _shake = 0.5; _sounds = [sndSwing1, sndSwing2]; }
    if (_weapon == WEAPONS.PIPE)    { _cooldown = 18; _anim_speed = 0.35; _is_ranged = false; _frame_start = 1; _melee_type = HIT_TYPE.BLUNT;   _shake = 0.5; _sounds = [sndSwing1, sndSwing2]; }
    if (_weapon == WEAPONS.PISTOL)  { _cooldown = 14; _anim_speed = 1.0;  _is_ranged = true;  _frame_start = 0; _shake = 1;   _bullet_obj = objBullet; _bullet_calibre = CALIBRE.PISTOL;  _bullet_speed = 13; _shell_obj = objShell; _shell_img = 0; _sounds = [snd9mmShot]; _shell_x = 24; _shell_y = 4; }
    if (_weapon == WEAPONS.SHOTGUN) { _cooldown = 30; _anim_speed = 0.5;  _is_ranged = true;  _frame_start = 0; _shake = 2;   _bullet_obj = objBullet; _bullet_calibre = CALIBRE.SHOTGUN; _bullet_speed = 13; _shell_obj = objShell; _shell_img = 2; _sounds = [sndShotgunShot];  _shell_x = 8;  _shell_y = 8; }
    if (_weapon == WEAPONS.M16)     { _cooldown = 7;  _anim_speed = 1.0;  _is_ranged = true;  _frame_start = 0; _shake = 0.5; _bullet_obj = objBullet; _bullet_calibre = CALIBRE.PISTOL;  _bullet_speed = 13; _shell_obj = objShell; _shell_img = 1; _sounds = [sndM16Shot];  _shell_x = 12; _shell_y = 4; }

    // === 2. СТРУКТУРА СПРАЙТОВ ===
    var _sprites = { 
        walk:       noone, 
        attack:     noone,
		throw_prep: noone,
		throw_walk: noone
    };

    // === 3. ПЕРЕБОР ДЛЯ ПЕРСОНАЖЕЙ ===
    if (_character == CHARACTER.COP) 
    {
        if (_weapon == WEAPONS.UNARMED) { _sprites.walk = sprCopWalkUnarmed;	_sprites.attack = sprCopAttackPunch; }
		if (_weapon == WEAPONS.KNIFE)	{ _sprites.walk = sprCopWalkKnife;		_sprites.attack = sprCopAttackKnife; _sprites.throw_prep = sprCopKnifePrep; _sprites.throw_walk = sprCopWalkKnifePrep;}
        if (_weapon == WEAPONS.BAT)     { _sprites.walk = sprCopWalkBat;		_sprites.attack = sprCopAttackBat; }
        if (_weapon == WEAPONS.PIPE)    { _sprites.walk = sprCopWalkPipe;		_sprites.attack = sprCopAttackPipe; }
        if (_weapon == WEAPONS.PISTOL)  { _sprites.walk = sprCopWalk9mm;		_sprites.attack = sprCopAttack9mm; }
		if (_weapon == WEAPONS.SHOTGUN) { _sprites.walk = sprCopWalkShotgun;	_sprites.attack = sprCopAttackShotgun; }
        if (_weapon == WEAPONS.M16)     { _sprites.walk = sprCopWalkM16;		_sprites.attack = sprCopAttackM16; }
    }

    // === 4. ЗАЩИТА ОТ ПРОПУСКОВ ===
    if (_sprites.walk == noone)   _sprites.walk   = sprCopWalkUnarmed;
    if (_sprites.attack == noone) _sprites.attack = sprCopAttackPunch;

    // === 5. СИНХРОНИЗАЦИЯ С ИГРОКОМ ===
    current_weapon = _weapon;
    isRange_weapon = _is_ranged;
    
    // === 6. ВОЗВРАТ КОМПАКТНЫХ ДАННЫХ ===
    return {
        walk:           _sprites.walk, 
        attack:         _sprites.attack, 
		throw_prep:     _sprites.throw_prep, // ДОБАВЛЕНО В МАССИВ ВОЗВРАТА
		throw_walk:     _sprites.throw_walk, // ДОБАВЛЕНО В МАССИВ ВОЗВРАТА
        cooldown:       _cooldown,
        anim_speed:     _anim_speed, 
        is_ranged:      _is_ranged, 
        frame_start:    _frame_start, 
        melee_type:     _melee_type, 
        shake_amount:   _shake,
        bullet_obj:     _bullet_obj,
        bullet_speed:   _bullet_speed,
        bullet_calibre: _bullet_calibre, 
        shell_obj:      _shell_obj,
        shell_img:      _shell_img,
        shell_x:        _shell_x, 
        shell_y:        _shell_y, 
        sounds:         _sounds 
    };
}
