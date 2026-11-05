state_timer++;

if (instance_exists(objScoreFader))
{
	objScoreFader.is_fading = true;
	if (objScoreFader.fade_alpha = 1) { room_goto(rmLevelSelect); }
}

var _skip_pressed = mouse_check_button_pressed(mb_left);
var _full_skip_pressed = mouse_check_button_pressed(mb_right);

// Полный пропуск
if (_full_skip_pressed) && (!instance_exists(objScoreFader)) 
{ 
	scrMusicStop(60);
	instance_create_layer(0, 0, "Instances", objScoreFader); 
}

// Сначала обрабатываем пропуск.
if (_skip_pressed && state != SCORE_STATE.DONE) {
	if (audio_is_playing(sndScoreGradeRise)) { audio_stop_sound(sndScoreGradeRise); }
    scrScoreMenu_Skip();
}
else {
    if (state >= SCORE_STATE.ANIM_STAT) {
        bg_overlay_alpha = max(0, bg_overlay_alpha - 0.015);
    }

    if (screen_flash_alpha > 0) {
        screen_flash_alpha = max(0, screen_flash_alpha - 0.04);
    }

    switch (state) {
        case SCORE_STATE.WAIT:

            if (state_timer > 30) {
                state = SCORE_STATE.ANIM_STAT;
                stat_index = 0;
                state_timer = 0;
            }

            break;

        case SCORE_STATE.ANIM_STAT:

            scrScoreMenu_UpdateStats();

            break;

		case SCORE_STATE.SHOW_RANK:

		    if (rank_phase == 0) { scrScoreMenu_UpdateScore(); }
		    else { scrScoreMenu_UpdateRank(); }

		    break;

        case SCORE_STATE.DONE:

            if (_skip_pressed) && (!instance_exists(objScoreFader)) 
			{ 
				scrMusicStop(60);
				instance_create_layer(0, 0, "Instances", objScoreFader); 
			}

            break;
    }
}

// Затухание вспышек.
for (var i = 0; i < array_length(stat_data); i++) {
    stat_data[i].flash = max(0, stat_data[i].flash - flash_speed);
}

flash_rank = max(0, flash_rank - flash_speed);
level_score_flash = max(0, level_score_flash - flash_speed);
