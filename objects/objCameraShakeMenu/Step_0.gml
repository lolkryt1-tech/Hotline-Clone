global.camera_shake_menu_x = x;
global.camera_shake_menu_y = y;

// Получаем положение виртуального курсора в GUI.
var _mx = global.cursor_screen_x / max(window_get_width(), 1) * display_get_gui_width();
var _my = global.cursor_screen_y / max(window_get_height(), 1) * display_get_gui_height();

var _pressed = mouse_check_button_pressed(mb_left);

// === СИНХРОНИЗАЦИЯ ===
scrCameraShakeMenuSyncTextboxes();

// === ПЕРЕКЛЮЧЕНИЕ ПРЕСЕТА ПРИ СМЕНЕ ОРУЖИЯ ===
if (instance_exists(objPlayer))
{
    var _weapon = objPlayer.current_weapon;

    if (_weapon != last_weapon)
    {
        last_weapon = _weapon;
        
        // Сбрасываем ручной выбор ТОЛЬКО при смене оружия
        execution_manually_selected = false;

        // 1. Если открыта категория WEAPONS — обновляем оружие
        if (selected_category == "weapons")
        {
            var _new_preset = scrCameraShakeWeaponToString(_weapon);
            
            if (_new_preset != "" && _new_preset != selected_preset)
            {
                selected_preset = _new_preset;

                var _cat_presets = variable_struct_get(global.camera_shake.presets, selected_category);
                var _preset = variable_struct_get(_cat_presets, selected_preset);
                for (var j = 0; j < array_length(sliders); j++)
                {
                    var _data = scrCameraShakeMenuGetEffectData(_preset, sliders[j].effect);
                    var _v = variable_struct_get(_data, sliders[j].field);
                    sliders[j].max_current = max(sliders[j].max, _v);
                }
                
                scrCameraShakeMenuSyncTextboxes();
            }
        }
        
        // 2. Если открыта категория EXECUTIONS — обновляем казнь (если не выбирали вручную)
        if (selected_category == "executions" && !execution_manually_selected)
        {
            var _weapon_str = scrCameraShakeWeaponToString(_weapon);
            var _weapon_cat = variable_struct_get(global.camera_shake.presets, "weapons");
            var _weapon_preset = variable_struct_get(_weapon_cat, _weapon_str);
            
            if (_weapon_preset != undefined && variable_struct_exists(_weapon_preset, "exec"))
            {
                var _exec_id = _weapon_preset.exec;
                if (_exec_id != "" && _exec_id != selected_preset)
                {
                    selected_preset = _exec_id;
                    
                    var _preset = scrCameraShakeGetSelectedPreset();
                    for (var j = 0; j < array_length(sliders); j++)
                    {
                        var _data = scrCameraShakeMenuGetEffectData(_preset, sliders[j].effect);
                        var _v = variable_struct_get(_data, sliders[j].field);
                        sliders[j].max_current = max(sliders[j].max, _v);
                    }
                    scrCameraShakeMenuSyncTextboxes();
                }
            }
        }
    }
}

// === ПРИОРИТЕТ 1: ПЕРЕТАСКИВАНИЕ ОКНА ===
if (scrCameraShakeMenuHandleDragging(_mx, _my))
{
    scrCameraShakeMenuUpdateHover(_mx, _my);
    exit;
}

// === ПРИОРИТЕТ 2: ПОЛЗУНКИ ===
if (scrCameraShakeMenuHandleSlider(_mx))
{
    scrCameraShakeMenuUpdateHover(_mx, _my);
    exit;
}

// === ПРИОРИТЕТ 3: ВЫПАДАЮЩИЕ СПИСКИ ===

// Пресеты
if (preset_dropdown_open)
{	
    if (scrCameraShakeMenuHandleDropdown(_mx, _my, _pressed))
    {
        scrCameraShakeMenuUpdateHover(_mx, _my);
        exit;
    }
}

// Категории
if (category_dropdown_open)
{
    if (scrCameraShakeMenuHandleCategoryDropdown(_mx, _my, _pressed))
    {
        scrCameraShakeMenuUpdateHover(_mx, _my);
        exit;
    }
}

// === ПРИОРИТЕТ 4: НОВЫЕ НАЖАТИЯ ===
if (_pressed)
{
    scrCameraShakeMenuHandleButtons(_mx, _my);
}

if (instance_exists(id))
{
    scrCameraShakeMenuUpdateHover(_mx, _my);
}


if (keyboard_check_pressed(vk_escape)) { instance_destroy(); }