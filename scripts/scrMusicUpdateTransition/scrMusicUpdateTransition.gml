/// @function scrMusicUpdateTransition()
/// @description Обновляет состояние музыкального перехода.

function scrMusicUpdateTransition()
{
	
    // === ОЖИДАНИЕ ЗАГРУЗКИ МУЗЫКИ ===

    // === СОЗДАНИЕ СТРИМА ===
	
	// Сртока с путем
    if (music_pending_asset != -1)
    {
        var _filepath = music_pending_asset;
        var _loop = music_pending_loop;

        music_pending_asset = -1; // Сбрасываем, чтобы не создать дважды

        // Создаём стрим из файла
        var _stream_sound = audio_create_stream(_filepath);
        
        if (_stream_sound != -1)
        {
            if (music_next != -1)
            {
                audio_stop_sound(music_next);
                audio_destroy_stream(music_next_asset); // Уничтожаем старый стрим
                music_next = -1;
                music_next_asset = -1;
            }

            // Запускаем на эмиттере (как у тебя было)
            music_next = audio_play_sound_on(music_emitter, _stream_sound, _loop, 100);
            
            if (music_next != -1)
            {
                music_next_asset = _stream_sound; // Запоминаем ID стрима
                audio_sound_gain(music_next, 0, 0);
                music_fade_timer = 0;
                music_fade_state = 1;
            }
            else
            {
                // Если не удалось запустить, сразу уничтожаем стрим
                audio_destroy_stream(_stream_sound);
            }
        }
        else
        {
            show_debug_message("Ошибка: Не удалось создать стрим для файла: " + string(_filepath));
        }
    }

    // === ПЕРЕХОД ===

    if (music_fade_state != 0)
    {
        music_fade_timer++;

        var _progress = clamp(music_fade_timer / music_fade_duration, 0, 1);

        switch (music_fade_state)
        {
            // === ПЕРЕКЛЮЧЕНИЕ МУЗЫКИ ===
            case 1:

                if (music_current != -1) {
                    audio_sound_gain(music_current, 1 - _progress, 0);
                }

                if (music_next != -1) {
                    audio_sound_gain(music_next, _progress, 0);
                }

                if (_progress >= 1) {
                    if (music_current != -1) {
                        audio_stop_sound(music_current);
                        audio_destroy_stream(music_current_asset); // <--- ОЧИСТКА ПАМЯТИ
                    }

                    music_current = music_next;
                    music_current_asset = music_next_asset;

                    music_next = -1;
                    music_next_asset = -1;

                    music_fade_state = 0;
                }

                break;


            // === ОСТАНОВКА МУЗЫКИ ===
            case 2:

                if (music_current != -1) {
                    audio_sound_gain(music_current, 1 - _progress, 0);
                }

                if (music_next != -1) {
                    audio_sound_gain(music_next, 1 - _progress, 0);
                }

               if (_progress >= 1) {

                    if (music_current != -1) {
                        audio_stop_sound(music_current);
                        audio_destroy_stream(music_current_asset); // <--- ОЧИСТКА ПАМЯТИ
                    }

                    if (music_next != -1) {
                        audio_stop_sound(music_next);
                        audio_destroy_stream(music_next_asset); // <--- ОЧИСТКА ПАМЯТИ
                    }

                    music_current = -1;
                    music_current_asset = -1;

                    music_next = -1;
                    music_next_asset = -1;

                    music_fade_state = 0;
                }

                break;
        }
    }
}