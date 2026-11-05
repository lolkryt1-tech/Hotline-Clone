/// @desc Пропуск текущего этапа анимации
function scrScoreMenu_Skip() {
    switch (state) {
        case SCORE_STATE.WAIT:
            state = SCORE_STATE.ANIM_STAT;
            stat_index = 0;
            state_timer = 0;
            break;

        case SCORE_STATE.ANIM_STAT:
        {
            var _s = stat_data[stat_index];

            _s.displayed = _s.target;
            _s.percent = _s.max > 0
                ? clamp(_s.target / _s.max, 0, 1) : 0;

            _s.alpha_text = 1;
            _s.alpha_num = 1;
            _s.slide = 1;
            _s.flash = 1.0;
            _s.last_int = floor(_s.target);

            if (_s.sound_handle != -1 && audio_is_playing(_s.sound_handle)) {
                audio_stop_sound(_s.sound_handle);
            }

            if (!_s.splash_played) {
                audio_play_sound(sndScoreNumberSplash, 5, false);
                _s.splash_played = true;
            }

            stat_index++;
            state_timer = 0;

            if (stat_index >= array_length(stat_data)) {
                state = SCORE_STATE.SHOW_RANK;
                rank_phase = 0;
            }

            break;
        }

        case SCORE_STATE.SHOW_RANK:

            
			if (rank_phase == 0) {
			    level_score_displayed = level_score_target;
			    level_score_alpha = 1.0;
			    global_stats_alpha = 1.0;
			    level_score_flash = 1.0;
			    level_score_last_int = floor(level_score_target);

			    if (!score_splash_played) {
			        audio_play_sound(sndScoreNumberSplash, 5, false);
			        score_splash_played = true;
			    }

			    rank_phase = 1;
			}

            else if (rank_phase == 1) {
                // Завершаем появление GRADE.
                slide_rank = 1;
                alpha_rank = 1;
                rank_phase = 2;
                rank_rise_timer = 0;
            }
            else if (rank_phase == 2 && !rank_revealed) {
                // Пропускаем ожидание раскрытия оценки.
                rank_rise_timer = rank_rise_duration;
            }
            else if (rank_revealed) {
                state = SCORE_STATE.DONE;
                state_timer = 0;
            }

            break;
    }
}
