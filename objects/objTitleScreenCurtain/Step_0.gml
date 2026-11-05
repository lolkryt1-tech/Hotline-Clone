var _gui_w = display_get_gui_width();

// 1. ЛОГИКА ОЖИДАНИЯ (Первые 6 секунд или до нажатия ПКМ)
if (!curtain_active && !curtain_finished) {
    
    // Уменьшаем таймер с учетом дельта-тайм
    curtain_timer -= (delta_time / 1000000);
    
    // Пропуск на ПКМ (mb_right) — сбрасываем таймер в ноль
    if (mouse_check_button_pressed(mb_left)) || (mouse_check_button_pressed(mb_right)) {
        curtain_timer = 0;
		curtain_speed = 2000;
    }
    
    // Когда время вышло, активируем движение шторки
    if (curtain_timer <= 0) {
        curtain_active = true;
    }
}

// 2. ЛОГИКА ДВИЖЕНИЯ И СМЕНЫ КОМНАТЫ
if (curtain_active && !curtain_finished) {

    // Движение с дельта-тайм
    curtain_x += curtain_speed * (delta_time / 1000000);

    // Как только сплошная черная плита полностью закрыла правый край экрана
    if (curtain_x >= _gui_w) {
        curtain_x = _gui_w;
        curtain_finished = true;
        
        // Переключаем комнату
        room_goto(Start); 
    }
}
