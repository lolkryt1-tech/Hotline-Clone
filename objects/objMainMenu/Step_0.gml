// Если открыты настройки, то блокируем управление
if (!menu_active) exit;

// --- ЛОГИКА ЗАТЕМНЕНИЯ ---
if (fade_state == 1) {
    fade_alpha = max(0, fade_alpha - fade_speed); 
} else if (fade_state == -1) {
    fade_alpha = min(1, fade_alpha + fade_speed); 
}

// --- ВЫПОЛНЕНИЕ ДЕЙСТВИЯ ПОСЛЕ ЗАТУХАНИЯ ---
if (fade_state == -1 && fade_alpha >= 1.0) {
    switch (next_action) {
        case "START":
            room_goto(rmLevelTitle); 
            break;
        case "CONTINUE":
            room_goto(rmLevelSelect);
            break;
        case "EXIT":
            game_end();
            break;
    }
}

pulse_time += 0.1;

// === НАВИГАЦИЯ (W/S и ↑/↓) ===
var _nav_up   = keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"));
var _nav_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));

if (_nav_up)
{
    selected_index--;
    if (selected_index < 0) selected_index = array_length(menu_items) - 1;
    pulse_time = 0;
    
    var _snd = audio_play_sound(sndPauseMenuScroll, 0, false);
    if (_snd != -1) audio_sound_pitch(_snd, random_range(0.9, 1.15));
}
if (_nav_down)
{
    selected_index++;
    if (selected_index >= array_length(menu_items)) selected_index = 0;
    pulse_time = 0;
    
    var _snd = audio_play_sound(sndPauseMenuScroll, 0, false);
    if (_snd != -1) audio_sound_pitch(_snd, random_range(0.9, 1.15));
}

// === ВЫБОР ===
// Блокируем выбор, если мы уже в процессе затухания, чтобы не нажать дважды
if (fade_state != -1 && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left)))
{
    audio_play_sound(sndPauseMenuScroll, 0, false);
    
    switch (selected_index)
    {
        case 0: // START
            fade_state = -1;
			fade_speed = 0.05;
            next_action = "START";
            break;
            
        case 1: // CONTINUE
            fade_state = -1;
			fade_speed = 0.05;
            next_action = "CONTINUE";
            break;
            
        case 2: // SETTINGS

		    var _settings = instance_create_layer(0, 0, "Instances", objSettingsMenu);

		    _settings.menu_context = SETTINGS_CONTEXT.MAIN_MENU;
		    _settings.return_instance = id;

		    menu_active = false;

		    break;
            
        case 3: // EXIT
            fade_state = -1;
            next_action = "EXIT";
            break;
    }
}