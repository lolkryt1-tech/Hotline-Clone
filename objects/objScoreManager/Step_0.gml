state_timer++;

if (state >= SCORE_STATE.ANIM_STAT) {
    bg_overlay_alpha = max(0, bg_overlay_alpha - 0.015); 
}

if (screen_flash_alpha > 0) {
    screen_flash_alpha = max(0, screen_flash_alpha - 0.04); 
}

switch (state)
{
    case SCORE_STATE.WAIT:
        if (state_timer > 30) {
            state = SCORE_STATE.ANIM_STAT;
            stat_index = 0;
            state_timer = 0;
        }
        break;

    case SCORE_STATE.ANIM_STAT:
    {
        var _s = stat_data[stat_index];

        if (_s.alpha_text < 1.0) {
            if (!_s.text_played) {
                audio_play_sound(sndScoreTextAppear, 5, false);
                _s.text_played = true;
            }
            _s.slide      = min(_s.slide + slide_speed, 1.0);
            _s.alpha_text = min(_s.alpha_text + text_fade_speed, 1.0);
        }
        else {
            _s.alpha_num = min(_s.alpha_num + num_fade_speed, 1.0);

            if (_s.alpha_num >= 1.0) {
                _s.displayed = lerp(_s.displayed, _s.target, count_speed);
                _s.percent   = _s.max > 0 ? clamp(_s.displayed / _s.max, 0, 1) : 0;

                var _int = floor(_s.displayed);
                if (_int > _s.last_int) {
                    if (audio_is_playing(_s.sound_handle)) {
                        audio_stop_sound(_s.sound_handle);
                    }
                    _s.sound_handle = audio_play_sound(sndScoringShort, 3, false);
                    if (_s.sound_handle != -1) audio_sound_pitch(_s.sound_handle, random_range(0.95, 1.05));
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
                    }
                }
            }
        }
        break;
    }

    case SCORE_STATE.SHOW_RANK:
        // Правый нижний блок очков и нижняя стата плавно зажигаются по альфе БЕЗ СДВИГА
        level_score_alpha = min(level_score_alpha + num_fade_speed, 1.0);
        
        if (level_score_alpha > 0) {
            global_stats_alpha = min(global_stats_alpha + num_fade_speed, 1.0);
        }

        // Логика нарастания цифр правого блока на месте
        if (level_score_alpha >= 1.0 && level_score_displayed < level_score_target) {
            level_score_displayed = lerp(level_score_displayed, level_score_target, count_speed);
            
            var _score_int = floor(level_score_displayed);
            if (_score_int > level_score_last_int) {
                var _snd = audio_play_sound(sndScoringShort, 2, false);
                if (_snd != -1) audio_sound_pitch(_snd, random_range(1.1, 1.2)); 
                level_score_last_int = _score_int;
            }
        }
        
        if (level_score_displayed != level_score_target && abs(level_score_displayed - level_score_target) < 0.5) {
            level_score_displayed = level_score_target;
            level_score_flash = 1.0; 
            audio_play_sound(sndScoreNumberSplash, 5, false); 
        }

        // Как только правый нижний блок досчитался — выезжает надпись GRADE
        if (level_score_displayed == level_score_target) {
            slide_rank = min(slide_rank + slide_speed, 1.0);
            alpha_rank = min(alpha_rank + text_fade_speed, 1.0);
            
            if (alpha_rank < 1.0 && !sound_text_played_rank) {
                audio_play_sound(sndScoreGradeRise, 6, false); 
                sound_text_played_rank = true;
            }
        }

        // Возвращаем расчет среднего процента обратно на 3 строки
        percent_total = (stat_data[0].percent + stat_data[1].percent + stat_data[2].percent) / 3;

        if (percent_total >= 0.9)       { rank_frame = 4; rank_color = make_color_rgb(255, 215, 0); }   
        else if (percent_total >= 0.75) { rank_frame = 3; rank_color = make_color_rgb(255, 0, 128); }   
        else if (percent_total >= 0.5)  { rank_frame = 2; rank_color = make_color_rgb(0, 243, 255); }   
        else if (percent_total >= 0.25) { rank_frame = 1; rank_color = make_color_rgb(140, 150, 180); } 
        else                            { rank_frame = 0; rank_color = make_color_rgb(90, 95, 115); }   

        if (alpha_rank >= 1.0 && !rank_revealed) {
            rank_rise_timer++;
            
            if (rank_rise_timer >= rank_rise_duration) {
                rank_revealed = true;
                screen_flash_alpha = 1.0; 
                flash_rank = 1.0;         

                audio_play_sound(sndScoreGrade, 8, false); 
                audio_play_sound(sndScoreNumberSplash, 5, false);
                state_timer = 0;
            }
        }

        if (rank_revealed && state_timer > 90) {
            state = SCORE_STATE.DONE;
            state_timer = 0;
        }
        break;

    case SCORE_STATE.DONE:
        if (keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left)) {
            // room_goto(rmMenu);
        }
        break;
}

for (var i = 0; i < array_length(stat_data); i++) {
    stat_data[i].flash = max(0, stat_data[i].flash - flash_speed);
}
flash_rank        = max(0, flash_rank - flash_speed);
level_score_flash = max(0, level_score_flash - flash_speed);
