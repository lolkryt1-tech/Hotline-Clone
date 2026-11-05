/// @desc Подсчёт и отображение итоговых очков
function scrScoreMenu_UpdateScore() {
    level_score_alpha = min(level_score_alpha + num_fade_speed, 1.0);

    if (level_score_alpha > 0) {
        global_stats_alpha = min(global_stats_alpha + num_fade_speed, 1.0);
    }

    if (level_score_alpha >= 1.0 && level_score_displayed < level_score_target) {
        level_score_displayed = lerp(
            level_score_displayed,
            level_score_target,
            count_speed
        );

        var _score_int = floor(level_score_displayed);

        if (_score_int > level_score_last_int) {
            var _snd = audio_play_sound(sndScoringShort, 2, false);

            if (_snd != -1) {
                audio_sound_pitch(_snd, random_range(1.1, 1.2));
            }

            level_score_last_int = _score_int;
        }

        if (abs(level_score_displayed - level_score_target) < 0.5) {
            level_score_displayed = level_score_target;
            level_score_flash = 1.0;

            if (!score_splash_played) {
                audio_play_sound(sndScoreNumberSplash, 5, false);
                score_splash_played = true;
            }
        }
    }

    // Переходим к GRADE только после полного подсчёта
    // и завершения появления общего счёта.
    if (level_score_displayed >= level_score_target
    && level_score_alpha >= 1.0
    && global_stats_alpha >= 1.0) {
        rank_phase = 1;
    }
}
