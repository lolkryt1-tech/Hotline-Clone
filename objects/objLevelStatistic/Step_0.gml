// 1. Считаем общее время уровня
global.level_time++;

// 2. Логика угасания комбо
if (global.combo_current > 0)
{
    global.combo_timer--;
    
    if (global.combo_timer <= 0)
    {
        global.combo_current = 0;
        global.combo_timer = 0;
    }
}

// 3. ПЛАВНОЕ ЗАТУХАНИЕ ЭФФЕКТОВ (возвращаем к исходному фиолетовому и размеру 1.0)
combo_scale = lerp(combo_scale, 1.0, 0.1);
combo_flash = lerp(combo_flash, 0.0, 0.15);
