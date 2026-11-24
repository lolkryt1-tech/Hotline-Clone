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
	
	hit_count++;

	// === Если бьем ТРУБОЙ, то удар сразу засчитывается за три ===
	if (weapon == WEAPONS.PIPE)
	{
	    hit_count = 3;
	
		scrCameraShakePlay(SHAKE_EXECUTIONS, SHAKE_EXEC_BLUNT_PIPE);
	}
	else
	{
		scrCameraShakePlay(SHAKE_EXECUTIONS, SHAKE_EXEC_BLUNT);
	}



	var _dist = 20; 
	
	// Правильный расчет точки головы по направлению взгляда
	var _head_offset_x = x + lengthdir_x(_dist, my_angle);
	var _head_offset_y = y + lengthdir_y(_dist, my_angle); 

	// Спавним 3 сквирта
	repeat(3)
	{
	    var _random_direction = my_angle + irandom_range(-90, 90);
	    var _squirt = instance_create_layer(_head_offset_x, _head_offset_y, "Instances", objBloodSquirt);
	    _squirt.direction   = _random_direction;
	    _squirt.image_angle = _random_direction;
	}

	// Спавним 4 облака дыма крови
	repeat (4)
	{
	    my_id = instance_create_layer(_head_offset_x, _head_offset_y, "Instances", objBloodSmoke);
	    var _smoke_direction = my_angle + irandom_range(-90, 90);
	    my_id.direction = _smoke_direction;
	    my_id.image_angle = my_id.direction;
	    my_id.speed = random(2);
	}

}

// 2. Уменьшаем время жизни буфера каждого кадра
if (input_buffer_time > 0) {
    input_buffer_time--;
    if (input_buffer_time == 0) input_buffer = false; 
}

// 3. Ловим нажатие кнопки
if (scrBindCheckPressed("attack"))
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
	
	_body.blood_pool_forward_offset = 24; 
    
	
	scrEnemyUpdateTargetID(id, _player); 
    instance_destroy();
}
