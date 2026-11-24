
function scrInitialization()
{
    // ========================================
    // ОСНОВНЫЕ ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
    // ========================================

    if (!variable_global_exists("hard"))
    {
        global.hard = false;
    }
	
	// Настройки лук фурзер
	if (!variable_global_exists("look_further_toggle"))
	{
	    global.look_further_toggle = false;
	}

    // Настройки меню тряски экрана.

    if (!variable_global_exists("camera_shake_menu_x"))
    {
        global.camera_shake_menu_x = 12;
    }

    if (!variable_global_exists("camera_shake_menu_y"))
    {
        global.camera_shake_menu_y = 12;
    }


    // ========================================
    // ОПРЕДЕЛЕНИЯ БИНДОВ
    // ========================================

    if (!variable_global_exists("bind_definitions"))
    {
        global.bind_definitions = [
            // MOVEMENT
            { id: "move_forward",       label: "MOVE FORWARD",       default_key: ord("W") },
            { id: "move_left",          label: "MOVE LEFT",          default_key: ord("A") },
            { id: "move_back",           label: "MOVE BACK",          default_key: ord("S") },
            { id: "move_right",          label: "MOVE RIGHT",         default_key: ord("D") },
            { id: "look_further",        label: "LOOK FURTHER",       default_key: vk_shift },
            { id: "toggle_look_further", label: "TOGGLE LOOK FURTHER", default_key: 20 },

            // COMBAT
            { id: "attack",              label: "ATTACK",              default_key: mb_left },
            { id: "execution",           label: "EXECUTION",           default_key: vk_space },
            { id: "pickup_weapon",       label: "PICK UP WEAPON",      default_key: mb_right },
            { id: "prefer_firearm",      label: "PREFER FIREARM",      default_key: mb_side2 },
            { id: "prefer_melee",        label: "PREFER MELEE",        default_key: mb_side1 },
            { id: "weapon_ability",      label: "WEAPON ABILITY",      default_key: ord("F") },

            // SYSTEM
            { id: "quick_load",          label: "QUICK LOAD",           default_key: vk_f9 },
            { id: "quick_save",          label: "QUICK SAVE",           default_key: vk_f5 },
            { id: "restart",             label: "RESTART",              default_key: ord("R") },
            { id: "screen_shake",        label: "SCREEN SHAKE MENU",    default_key: vk_f7 }
        ];
    }
}
