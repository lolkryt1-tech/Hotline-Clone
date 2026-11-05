/// @desc Появление надписи GRADE и раскрытие рейтинга
function scrScoreMenu_UpdateRank() {
    if (rank_phase == 1) {
        slide_rank = min(slide_rank + slide_speed, 1.0);
        alpha_rank = min(alpha_rank + text_fade_speed, 1.0);

        if (alpha_rank < 1.0 && !sound_text_played_rank) {
            audio_play_sound(sndScoreGradeRise, 6, false);
            sound_text_played_rank = true;
        }

        if (alpha_rank >= 1.0) {
            rank_phase = 2;
            rank_rise_timer = 0;
        }
    }

    rank_frame = final_rank_num;

    if (rank_phase == 2 && !rank_revealed) {
        rank_rise_timer++;

        if (rank_rise_timer >= rank_rise_duration) {
            rank_revealed = true;
            screen_flash_alpha = 1.0;
            flash_rank = 1.0;

            audio_play_sound(sndScoreGrade, 8, false);
            audio_play_sound(sndScoreNumberSplash, 5, false);

            state_timer = 0;

            scrScoreMenu_GradeUI();
        }
    }

    if (rank_revealed && state_timer > 90) {
        state = SCORE_STATE.DONE;
        state_timer = 0;
    }
}
