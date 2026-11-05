/// @function scrMusicUpdateTransition()
/// @description Обновляет состояние музыкального перехода.

function scrMusicUpdateTransition()
{
    // === ОЖИДАНИЕ ЗАГРУЗКИ МУЗЫКИ ===

    if (music_pending_asset != -1 && audio_group_is_loaded(audiogroup_music))
    {
        var _sound = music_pending_asset;
        var _loop = music_pending_loop;

        music_pending_asset = -1;

        if (_sound != music_current_asset)
        {
            if (music_next != -1)
            {
                audio_stop_sound(music_next);
                music_next = -1;
            }

            music_next = audio_play_sound_on(music_emitter, _sound,  _loop, 100);

            if (music_next != -1)
            {
                music_next_asset = _sound;

                audio_sound_gain(music_next, 0, 0);

                music_fade_timer = 0;
                music_fade_state = 1;
            }
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
                    }

                    if (music_next != -1) {
                        audio_stop_sound(music_next);
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