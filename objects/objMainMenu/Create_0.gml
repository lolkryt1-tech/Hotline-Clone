depth = 10;
window_set_cursor(cr_none);

menu_items = ["START", "CONTINUE", "SETTINGS", "EXIT"];
selected_index = 0;

pulse_time = 0;

// --- ПЕРЕМЕННЫЕ ДЛЯ ЗАТЕМНЕНИЯ ---
fade_alpha = 1.0;   // Начинаем с черного экрана
fade_state = 1;     // 1 = расцветаем, -1 = затухаем
fade_speed = 0.02;  // Скорость

next_action = "";   // Что делать после затухания

// Управление меню
menu_active = true;