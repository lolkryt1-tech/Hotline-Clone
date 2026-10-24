function scrPlayerStartExecution()
{
    if !(keyboard_check_pressed(vk_space)) return;
    
    // 1. ПОИСК И ПРОВЕРКА ЖЕРТВЫ
    var _executable_objects = tag_get_asset_ids("Executable", asset_object);
    var _grab_radius = 24;
    var _victim = collision_circle(x, y, _grab_radius, _executable_objects, false, true);
    
    if (_victim == noone) return;
    
    // Защита: проверка стен
    var _wall = collision_line(x, y, _victim.x, _victim.y, objSolidTall, false, true);
    if (_wall != noone) return; 

    var _is_lean_execution = (_victim.object_index == objEnemyKnockedOutLean);
    var _excutand = noone;

    // =========================================================================
    // === ВАРИАНТ А: КАЗНЬ У СТЕНЫ ===
    // =========================================================================
    if (_is_lean_execution)
    {
        var _player_saved_x = x;
        var _player_saved_y = y;

        // Выбрасываем оружие перед казнью у стены
        if (current_weapon != WEAPONS.UNARMED)
        {
            audio_play_sound(sndThrow, 1, false);
            var _throw_dir = _victim.my_angle; 
            var _check_x = x + lengthdir_x(16, _throw_dir);
            var _check_y = y + lengthdir_y(16, _throw_dir);
            var _wall_in_front = collision_line(x, y, _check_x, _check_y, objSolidTall, false, true);
            
            var _thrown = instance_create_layer(x, y, "Instances", objWeaponThrow);
            _thrown.weapon = current_weapon;
            _thrown.ammo   = ammo;
            _thrown.my_angle = irandom(360);
            _thrown.image_index = scrWeaponGetImage(current_weapon);
            
            if (_wall_in_front != noone) { _thrown.direction = _throw_dir; _thrown.speed = 0; }
            else                         { _thrown.direction = _throw_dir; _thrown.speed = 4; }
            
            current_weapon = WEAPONS.UNARMED;
        }
        
        if (character == CHARACTER.COP)
        {
            _excutand = instance_create_layer(_victim.x, _victim.y, "Instances", objCopKillLean);
            _excutand.my_angle = _victim.my_angle - 180;
            _excutand.image_index = 0;
            _excutand.enemy_skin    = _victim.skin;
            _excutand.enemy_class   = _victim.class;
            _excutand.enemy_faction = _victim.faction;
            _excutand.weapon        = WEAPONS.UNARMED; 
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
            var _target_object = noone;
            var _start_frame = 0;
            
            // --- ⚠️ ПРОВЕРКА НА ТОЛСТЯКА ---
            if ( _victim.class == CLASS.FAT || _victim.class == CLASS.FATVEST)
            {
                // Если оружие не тяжелое — прерываем казнь, толстяка нельзя забить руками/ножом
                if (!scrWeaponIsHeavy(current_weapon)) return;
                
                // Если оружие тяжелое — назначаем объект казни толстяка
                _target_object = objCopKillFatSledgeHammerFat;
                _start_frame = 0;
            }
            // --- ОПРЕДЕЛЕНИЕ ОБЪЕКТА ДЛЯ ОБЫЧНЫХ ВРАГОВ ---
            else
            {
                switch (current_weapon)
                {
                    case WEAPONS.UNARMED:
                        _target_object = objCopKillUnarmed;
                        break;
                        
                    case WEAPONS.KNIFE:
                        _target_object = objCopKillKnife;
                        break;
                        
                    case WEAPONS.BAT:
                    case WEAPONS.PIPE:
                        _target_object = objCopKillBlunt;
                        _start_frame = 3; // Специфический стартовый кадр для биты/трубы
                        break;
                        
                    case WEAPONS.SLEDGEHAMMER:
                        _target_object = objCopKillSledgeHammer;
                        break;
                        
                    case WEAPONS.PISTOL:
                        if (ammo != 0) _target_object = objCopKillShot;
                        break;
                        
                    case WEAPONS.M16:
                    case WEAPONS.SHOTGUN:
                        _target_object = objCopKillWeaponBlunt;
                        break;
                }
            }

            // Если оружие было огнестрельным без патронов или не подошло ни под один кейс:
            if (_target_object == noone)
            {
                // Выбрасываем текущее бесполезное оружие
                if (current_weapon != WEAPONS.UNARMED)
                {
                    audio_play_sound(sndThrow, 1, false);
                    var _thrown = instance_create_layer(x, y, "Instances", objWeaponThrow);
                    _thrown.weapon = current_weapon;
                    _thrown.ammo   = ammo;
                    _thrown.my_angle = irandom(360);
                    _thrown.speed = 2;
                    _thrown.image_index = scrWeaponGetImage(current_weapon);
                    current_weapon = WEAPONS.UNARMED;
                }
                // Переключаем на казнь кулаками
                _target_object = objCopKillUnarmed;
                _start_frame = 0;
            }

            // --- СПАВН ВЫБРАННОГО ОБЪЕКТА КАЗНИ ---
            _excutand = instance_create_layer(_victim.x, _victim.y, "Instances", _target_object);
            _excutand.my_angle      = _victim.my_angle - 180;
            _excutand.image_index   = _start_frame;
            _excutand.weapon        = current_weapon;
            
            // Если в объекте есть переменная ammo (для огнестрела), безопасно передаем её
            if (variable_instance_exists(_excutand, "ammo")) { _excutand.ammo = ammo; }

            // Передача параметров жертвы в объект казни
            _excutand.enemy_skin    = _victim.skin;
            _excutand.enemy_class   = _victim.class;
            _excutand.enemy_faction = _victim.faction;
            _excutand.enemy_sprite  = scrGetExecutionSprite(_victim.skin, current_weapon);
        }
    }
    
    // 3. ЗАВЕРШЕНИЕ И ПЕРЕДАЧА УПРАВЛЕНИЯ
    if (_excutand != noone)
    {
        scrEnemyUpdateTargetID(id, _excutand); 
        instance_destroy(_victim);
        instance_destroy();
    }
}
