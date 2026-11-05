function LevelSelect_UpdateState()
{
    switch (state)
    {
        // ==============================================
        // CHOOSING — выбор уровня
        // ==============================================

        case LEVEL_STATE.CHOOSING:

            is_reversing = false;
            play_alpha = 0;

            // ESC — возвращение в главное меню.
            if (keyboard_check_pressed(vk_escape))
            {
                state = LEVEL_STATE.LEAVING;
                next_room = rmMainMenu;

                if (score_fader == noone || !instance_exists(score_fader))
                {
                    score_fader = instance_create_depth(0, 0, -1000, objScoreFader);

                    score_fader.is_fading = true;
                }
            }

            // Enter или ЛКМ — подтверждение выбора.
            if (keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left))
            {
                state = LEVEL_STATE.CONFIRMING;

                confirm_progress = 0;
                is_reversing = false;

                global.current_level_index = target_scroll;

                audio_play_sound(sndPauseMenuScroll, 0, false);
            }

        break;


        // ==============================================
        // CONFIRMING — открытие или закрытие полотна
        // ==============================================

        case LEVEL_STATE.CONFIRMING:

            if (!is_reversing)
            {
                confirm_progress = min(1.0, confirm_progress + 0.04);

                if (confirm_progress >= 1.0)
                {
                    state = LEVEL_STATE.WAITING;
                }
            }
            else
            {
                LevelSelect_DestroyGrade();

                confirm_progress = max(0.0, confirm_progress - 0.04);

                play_alpha = max(0.0, play_alpha - 0.04);

                if (confirm_progress <= 0.0)
                {
                    state = LEVEL_STATE.CHOOSING;
                    is_reversing = false;

                    // Обновляем рекорды после возвращения.
                    for (var i = 0; i < array_length(level_records); i++)
                    {
                        var _rec = loadLevelRecord(level_records[i].name);

                        level_records[i].best_time = _rec.best_time;
                        level_records[i].best_rank = _rec.best_rank;
                        level_records[i].best_score = _rec.best_score;
                    }
                }
            }

        break;


        // ==============================================
        // WAITING — полотно открыто, можно начать игру
        // ==============================================

        case LEVEL_STATE.WAITING:

            if (!is_reversing)
            {
                play_alpha = min(1.0, play_alpha + 0.02);

                // Создаём ранг, если его ещё нет.
                LevelSelect_CreateGrade();
            }

            // Enter или ЛКМ — запуск игры.
            if (keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left))
            {
                state = LEVEL_STATE.LEAVING;
                next_room = rmLevelTitle;

                if (score_fader == noone || !instance_exists(score_fader))
                {
                    score_fader = instance_create_depth(0, 0, -1000, objScoreFader);

                    score_fader.is_fading = true;
                }
            }

            // ESC — начать закрытие полотна.
            if (keyboard_check_pressed(vk_escape) && !is_reversing)
            {
                is_reversing = true;
                state = LEVEL_STATE.CONFIRMING;
            }

        break;


        // ==============================================
        // LEAVING — ожидание завершения затемнения
        // ==============================================

        case LEVEL_STATE.LEAVING:

            if (score_fader != noone && instance_exists(score_fader))
            {
                if (score_fader.fade_alpha >= 1.0)
                {
                    room_goto(next_room);
                }
            }

        break;
    }
}