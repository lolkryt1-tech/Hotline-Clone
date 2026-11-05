/// @desc Обновление анимации отдельных показателей
function scrScoreMenu_UpdateStats() {
    var _s = stat_data[stat_index];

    if (_s.alpha_text < 1.0) {
        if (!_s.text_played) {
            audio_play_sound(sndScoreTextAppear, 5, false);
            _s.text_played = true;
        }

        _s.slide = min(_s.slide + slide_speed, 1.0);
        _s.alpha_text = min(_s.alpha_text + text_fade_speed, 1.0);
    }
    else {
        _s.alpha_num = min(_s.alpha_num + num_fade_speed, 1.0);

        if (_s.alpha_num >= 1.0) {
            _s.displayed = lerp(_s.displayed, _s.target, count_speed);

            if (abs(_s.displayed - _s.target) < 0.1) {
                _s.displayed = _s.target;
            }

            _s.percent = _s.max > 0
                ? clamp(_s.displayed / _s.max, 0, 1) : 0;

            var _int = floor(_s.displayed);

            if (_int > _s.last_int) {
                if (audio_is_playing(_s.sound_handle)) {
                    audio_stop_sound(_s.sound_handle);
                }

                _s.sound_handle = audio_play_sound(sndScoringShort, 3, false);

                if (_s.sound_handle != -1) {
                    audio_sound_pitch(_s.sound_handle, random_range(0.95, 1.05));
                }

                _s.last_int = _int;
            }
        }

        if (_s.alpha_num >= 1.0 && abs(_s.displayed - _s.target) < 0.5) {
            _s.displayed = _s.target;
            _s.flash = 1.0;

            if (!_s.splash_played) {
                audio_play_sound(sndScoreNumberSplash, 5, false);
                _s.splash_played = true;
            }

            if (state_timer > 60) {
                stat_index++;
                state_timer = 0;

                if (stat_index >= array_length(stat_data)) {
                    state = SCORE_STATE.SHOW_RANK;
                    rank_phase = 0;
                }
            }
        }
    }
}
