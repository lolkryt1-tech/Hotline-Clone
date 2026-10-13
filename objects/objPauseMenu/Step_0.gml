// === ESCAPE — открыть/закрыть паузу ===
if (keyboard_check_pressed(vk_escape)) 
{
    is_paused = !is_paused;
    
    if (is_paused)
    {
        selected_index = 0;
        objPauseManager.pause_tag("Pausable");
        audio_play_sound(sndPauseMenuAppear, 1, false);
    }
    else
    {
        objPauseManager.unpause_tag("Pausable");
    }
}

// === ЛЕРП ЗАТЕМНЕНИЯ ===
var _target_alpha = is_paused ? 1 : 0;
darken_alpha = lerp(darken_alpha, _target_alpha, 0.15);

// === АНИМАЦИЯ ВЪЕЗДА ПУНКТОВ ===
var _target_slide = is_paused ? 1 : 0;
items_slide = lerp(items_slide, _target_slide, 0.12);

// === ОБРАБОТКА МЕНЮ ===
if (is_paused)
{
    // === НАВИГАЦИЯ (W/S и ↑/↓) ===
    var _nav_up   = keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"));
    var _nav_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
    
    if (_nav_up)
    {
        selected_index--;
        if (selected_index < 0) selected_index = array_length(menu_items) - 1;
        
        var _snd = audio_play_sound(sndPauseMenuScroll, 0, false);
        if (_snd != -1) audio_sound_pitch(_snd, random_range(0.9, 1.15));
    }
    if (_nav_down)
    {
        selected_index++;
        if (selected_index >= array_length(menu_items)) selected_index = 0;
        
        var _snd = audio_play_sound(sndPauseMenuScroll, 0, false);
        if (_snd != -1) audio_sound_pitch(_snd, random_range(0.9, 1.15));
    }
    
    // === ВЫБОР ===
    var _confirm = false;
    
    // Enter или ЛКМ
    if (keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left))
    {
        _confirm = true;
    }
    
    // Выполнение выбора
    if (_confirm)
    {
        switch (selected_index)
        {
            case 0: // RESUME
                is_paused = false;
                objPauseManager.unpause_tag("Pausable");
                break;
            case 1: // RESTART
                scrRestartLevel();
                break;
        }
    }
}