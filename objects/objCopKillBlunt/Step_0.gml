if (weapon == WEAPONS.BAT) { sprite_index = sprCopKillBat }

if (enemy_skin == SKIN.COLOMBIANREGULAR) 
{ 
	if (weapon == WEAPONS.PIPE) enemy_sprite = sprColombianDieStomp;
}

if (enemy_skin == SKIN.COLOMBIANVEST) 
{ 
	if (weapon == WEAPONS.PIPE) enemy_sprite = sprColombianVestDieStomp;
}



// 1. Воспроизводим звук просто при совпадении кадра
if (image_index == 6)
{
	triggered_hurt = true;
	
    var _played_sound = audio_play_sound(sndHit3, 1, false);
    if (_played_sound != -1)
    {
        audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
    }
}

// 2. Уменьшаем время жизни буфера каждого кадра
if (input_buffer_time > 0) {
    input_buffer_time--;
    if (input_buffer_time == 0) input_buffer = false; 
}

// 3. Ловим нажатие мыши
if (mouse_check_button_pressed(mb_left))
{
    if (isSwinging == false) {
        isSwinging = true;
        image_index = 3;
    } else {
        // ИСПРАВЛЕНО: Архивируем нажатие ТОЛЬКО если это НЕ труба (WEAPONS.PIPE)
        if (weapon != WEAPONS.PIPE) {
            input_buffer = true;
            input_buffer_time = 5; 
        }
    }
}

// 4. Логика удара
if (isSwinging == true)
{
	image_index += 0.5;
	enemy_image_index += 0.25;
    
	if (image_index == 3) 
    { 
        if (input_buffer == true) {
            image_index = 3;       
            input_buffer = false;  
            input_buffer_time = 0;
        } else {
            isSwinging = false;    
        }
    }
}

if (hit_count == 3 && image_index == 3)
{
    var _player = instance_create_layer(x, y, "Instances", objPlayer);
    _player.character      = CHARACTER.COP; 
    _player.current_weapon = weapon;
	
    _player.my_sprites     = scrPlayerGetWeaponSprite(_player.character, _player.current_weapon);
	
    _player.sprite_index   = _player.my_sprites.walk; 
    _player.image_index    = 0;
    
    var _body = instance_create_layer(x, y, "Instances", objDeadBody);
    _body.sprite_index = enemy_sprite;
    _body.image_index = _body.image_number - 1;
    _body.my_angle = my_angle;
    _body.isExecuted = true;
    
	
	scrEnemyUpdateTargetID(id, _player); 
    instance_destroy();
}
