function scrPlayerStartExecution()
{
    if !(keyboard_check_pressed(vk_space)) return;
    
    // Получаем массив всех типов объектов в игре, у которых есть тег "Executable"
    var _executable_objects = tag_get_asset_ids("Executable", asset_object);
    
    // === ОБНОВЛЕНО: Расширяем зону охвата с помощью круга коллизии ===
    var _grab_radius = 24;
    var _victim = collision_circle(x, y, _grab_radius, _executable_objects, false, true);
    
    // Если никто с тегом "Executable" в радиусе не лежит — выходим
    if (_victim == noone) return;
    
    // === ЗАЩИТА: Проверяем, нет ли стены между игроком и жертвой ===
    var _wall = collision_line(x, y, _victim.x, _victim.y, objSolidTall, false, true);
    if (_wall != noone) return; // Нельзя казнить сквозь стены и закрытые двери!
    
    // Проверяем, является ли тегированная жертва именно настенной куклой
    var _is_lean_execution = (_victim.object_index == objEnemyKnockedOutLean);
	
	// Заводим локальную переменную для сохранения ID созданного объекта казни
	var _excutand = noone;

    // =========================================================================
    // === ВАРИАНТ А: КАЗНЬ У СТЕНЫ (ПРИСЛОНЕННЫЙ ВРАГ С ТЕГОМ) ===
    // =========================================================================
    if (_is_lean_execution)
    {
        // Сохраняем ТЕКУЩИЕ БЕЗОПАСНЫЕ координаты игрока перед его удалением
        var _player_saved_x = x;
        var _player_saved_y = y;

        // 1. Если у игрока в руках было оружие — выбрасываем его на пол
        if (current_weapon != WEAPONS.UNARMED)
        {
            audio_play_sound(sndThrow, 1, false);
            
            var _throw_dir = _victim.my_angle; 
            
            var _check_x = x + lengthdir_x(16, _throw_dir);
            var _check_y = y + lengthdir_y(16, _throw_dir);
            var _wall_in_front = collision_line(x, y, _check_x, _check_y, objSolidTall, false, true);
            
            var _thrown = instance_create_layer(x, y, "Instances", objWeaponThrow);
            _thrown.weapon = current_weapon;
            _thrown.my_angle = irandom(360);
			_thrown.image_index = scrWeaponGetImage(current_weapon);
            
            if (_wall_in_front != noone)
            {
                _thrown.direction = _throw_dir;
                _thrown.speed = 0; 
            }
            else
            {
                _thrown.direction = _throw_dir;
                _thrown.speed = 4; 
            }
            
            current_weapon = WEAPONS.UNARMED;
        }
        
        // 2. Спавним объект казни у стены
        if (character == CHARACTER.COP)
        {
            _excutand = instance_create_layer(_victim.x, _victim.y, "Instances", objCopKillLean);
            
            _excutand.my_angle = _victim.my_angle - 180;
            _excutand.image_index = 0;
            
			_excutand.enemy_skin	= _victim.skin;
			_excutand.enemy_class	= _victim.class;
            _excutand.enemy_faction	= _victim.faction;
            _excutand.weapon		= WEAPONS.UNARMED; 
            
            // ПЕРЕДАЕМ СОХРАНЕННЫЕ КООРДИНАТЫ ВНУТРЬ ОБЪЕКТА КАЗНИ
            _excutand.return_x = _player_saved_x;
            _excutand.return_y = _player_saved_y;
        }
    }
    // =========================================================================
    // === ВАРИАНТ Б: ОБЫЧНАЯ КАЗНЬ НА ПОЛУ ===
    // =========================================================================
    else
    {
        if (character == CHARACTER.COP)
        {
            if (current_weapon == WEAPONS.UNARMED) 
            { 
                _excutand = instance_create_layer(_victim.x, _victim.y, "Instances", objCopKillUnarmed);
        
                _excutand.my_angle = _victim.my_angle - 180;
                _excutand.image_index = 0;
				
				_excutand.enemy_skin	= _victim.skin;
				_excutand.enemy_class	= _victim.class;
                _excutand.enemy_faction = _victim.faction;
				_excutand.enemy_sprite  = scrGetExecutionSprite(_victim.skin);
            }
			
			if (current_weapon == WEAPONS.KNIFE)
            { 
                _excutand = instance_create_layer(_victim.x, _victim.y, "Instances", objCopKillKnife);
        
                _excutand.my_angle = _victim.my_angle - 180;
				_excutand.weapon		= current_weapon;
                _excutand.image_index = 0;
				
				_excutand.enemy_skin	= _victim.skin;
                _excutand.enemy_class	= _victim.class;
				_excutand.enemy_faction	= _victim.faction;
				_excutand.enemy_sprite  = scrGetExecutionSprite(_victim.skin);
            }
            
            if (current_weapon == WEAPONS.BAT || current_weapon == WEAPONS.PIPE)
            { 
                _excutand = instance_create_layer(_victim.x, _victim.y, "Instances", objCopKillBlunt);
				
                _excutand.my_angle = _victim.my_angle - 180;
				_excutand.weapon		= current_weapon;
                _excutand.image_index = 3;
				
				_excutand.enemy_skin	= _victim.skin;
                _excutand.enemy_class	= _victim.class;
				_excutand.enemy_faction	= _victim.faction;
				_excutand.enemy_sprite  = scrGetExecutionSprite(_victim.skin);
            }
			
			if (current_weapon == WEAPONS.PISTOL && ammo != 0)
			{
				_excutand = instance_create_layer(_victim.x, _victim.y, "Instances", objCopKillShot); 
				_excutand.my_angle = _victim.my_angle - 180;
				_excutand.weapon = current_weapon;
                _excutand.ammo = ammo;
                _excutand.image_index = 0;
				
				_excutand.enemy_skin	= _victim.skin;
				_excutand.enemy_class	= _victim.class;
                _excutand.enemy_faction = _victim.faction;
				_excutand.enemy_sprite  = scrGetExecutionSprite(_victim.skin);
			}
            
            if (current_weapon == WEAPONS.M16 || current_weapon == WEAPONS.SHOTGUN)
            { 
                _excutand = instance_create_layer(_victim.x, _victim.y, "Instances", objCopKillWeaponBlunt);
        
                _excutand.my_angle = _victim.my_angle - 180;
			    _excutand.weapon = current_weapon;
                _excutand.ammo = ammo;
				_excutand.image_index = 0;
				
				_excutand.enemy_skin	= _victim.skin;
				_excutand.enemy_class	= _victim.class;
                _excutand.enemy_faction = _victim.faction;
				_excutand.enemy_sprite  = scrGetExecutionSprite(_victim.skin);
            }
			
			
			if (_excutand == noone)
			{
				if (current_weapon != WEAPONS.UNARMED)
		        {
		            audio_play_sound(sndThrow, 1, false);
            
		            var _throw_dir = _victim.my_angle; 
					var _thrown = instance_create_layer(x, y, "Instances", objWeaponThrow);
		            _thrown.weapon = current_weapon;
		            _thrown.my_angle = irandom(360);
					_thrown.speed = 2;
					_thrown.image_index = scrWeaponGetImage(current_weapon);
					current_weapon = WEAPONS.UNARMED;
				}
				
				_excutand = instance_create_layer(_victim.x, _victim.y, "Instances", objCopKillUnarmed);
        
				_excutand.my_angle = _victim.my_angle - 180;
				_excutand.image_index = 0;
				
				_excutand.enemy_skin	= _victim.skin;
				_excutand.enemy_class	= _victim.class;
				_excutand.enemy_faction = _victim.faction;
				_excutand.enemy_sprite  = scrGetExecutionSprite(_victim.skin);
			}
        }
    }
    
	// === МГНОВЕННЫЙ БЕСШОВНЫЙ ПЕРЕВОД МИШЕНИ ДЛЯ ВСЕХ ВРАГОВ ===
	scrEnemyUpdateTargetID(id, _excutand); 

    // Уничтожаем жертву и сам объект живого игрока
    instance_destroy(_victim);
    instance_destroy();
}
