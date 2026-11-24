if (!menu_active) exit;

// === ESCAPE ===
if (keyboard_check_pressed(vk_escape))
{
    if (is_paused && menu_page == MENU_PAGE.OPTIONS)
    {
        // Возврат из настроек
        menu_page = MENU_PAGE.MAIN;
        selected_index = 2;
        items_slide = 0;
    }
    else
    {
        is_paused = !is_paused;

        if (is_paused)
        {
            menu_page = MENU_PAGE.MAIN;
            selected_index = 0;

            objPauseManager.pause_tag("Pausable");
            audio_play_sound(sndPauseMenuAppear, 1, false);
        }
        else
        {
            objPauseManager.unpause_tag("Pausable");
        }
    }
}

// === АНИМАЦИИ ===
darken_alpha = lerp(
    darken_alpha,
    is_paused ? 1 : 0,
    0.15
);

items_slide = lerp(
    items_slide,
    is_paused ? 1 : 0,
    0.12
);

if (!is_paused) exit;

// === ТЕКУЩИЙ МАССИВ МЕНЮ ===
var _items = (menu_page == MENU_PAGE.MAIN)
    ? menu_items
    : options_items;

var _count = array_length(_items);

// === НАВИГАЦИЯ ===
var _up = keyboard_check_pressed(vk_up)
       || keyboard_check_pressed(ord("W"));

var _down = keyboard_check_pressed(vk_down)
         || keyboard_check_pressed(ord("S"));

if (_up || _down)
{
    selected_index += _down ? 1 : -1;

    if (selected_index < 0)
        selected_index = _count - 1;

    if (selected_index >= _count)
        selected_index = 0;

    var _snd = audio_play_sound(sndPauseMenuScroll, 0, false);

    if (_snd != -1) { audio_sound_pitch(_snd, random_range(0.9, 1.15)); }
}

// === НАСТРОЙКА ГРОМКОСТИ ===
if (menu_page == MENU_PAGE.OPTIONS)
{
    var _left = keyboard_check_pressed(vk_left)
             || keyboard_check_pressed(ord("A"));

    var _right = keyboard_check_pressed(vk_right)
              || keyboard_check_pressed(ord("D"));

    if (_left || _right)
    {
        var _change = _right ? 0.05 : -0.05;

        switch (selected_index)
        {
            case 0: // SOUND VOLUME
                global.settings.sound_volume = clamp(global.settings.sound_volume + _change, 0, 1);
                audio_play_sound(sndPauseMenuScroll, 0, false);
                break;

            case 1: // MUSIC VOLUME
                global.settings.music_volume = clamp(global.settings.music_volume + _change, 0, 1);
                break;
        }

        // Применяем и сохраняем
        scrSettingsApply();
        scrSettingsSave();
    }
}

// === ПОДТВЕРЖДЕНИЕ ===
var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left);

if (_confirm)
{
    if (menu_page == MENU_PAGE.MAIN)
    {
        switch (selected_index)
        {
            case 0: // RESUME
                is_paused = false;
                objPauseManager.unpause_tag("Pausable");
                break;

            case 1: // RESTART LEVEL
                objPauseManager.unpause_tag("Pausable");
                scrRestartLevel();
                break;

            case 2: // OPTIONS
                var _settings = instance_create_layer(0, 0, "Instances", objSettingsMenu);
                
                _settings.menu_context = SETTINGS_CONTEXT.PAUSE_MENU;
                _settings.return_instance = id; // Запоминаем, что вернуться нужно сюда
                
                menu_active = false; // Замораживаем паузу
                break;

            case 3: // EXIT
				scrMusicStop(0);
				scrDestroyManagers();
                room_goto(rmMainMenu);
                break;
        }
    }
	else
    {
        switch (selected_index)
        {
            case 2: // GAME SETTINGS
                var _settings = instance_create_layer(0, 0, "Instances", objSettingsMenu);
                
                _settings.menu_context = SETTINGS_CONTEXT.PAUSE_MENU;
                _settings.return_instance = id; // Запоминаем, что вернуться нужно в паузу
                
                menu_active = false;
                break;

            case 3: // BACK
                menu_page = MENU_PAGE.MAIN;
                selected_index = 2;
                items_slide = 0;
                break;
        }
    }
}