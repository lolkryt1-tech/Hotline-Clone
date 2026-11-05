function scrScoreMenu_Init() {
    get_percent_color = function(_percent) {
        var _lame = make_color_rgb(100, 110, 140);
        var _mid = make_color_rgb(0, 243, 255);
        var _max = make_color_rgb(255, 215, 0);

        if (_percent < 0.5) return merge_color(_lame, _mid, _percent * 2);
        return merge_color(_mid, _max, power((_percent - 0.5) * 2, 2));
    };

    draw_text_outline = function(_x, _y, _str, _scale, _thick) {
        draw_set_color(c_black);

        for (var dx = -_thick; dx <= _thick; dx += _thick) {
            for (var dy = -_thick; dy <= _thick; dy += _thick) {
                if (dx != 0 || dy != 0) {
                    draw_text_transformed(_x + dx, _y + dy, _str, _scale, _scale, 0);
                }
            }
        }
    };

    draw_text_glow = function(_x, _y, _str, _scale, _color, _alpha) {
        draw_set_alpha(_alpha);
        draw_set_color(_color);
        draw_text_transformed(_x - 3, _y, _str, _scale, _scale, 0);
        draw_text_transformed(_x + 3, _y, _str, _scale, _scale, 0);
        draw_text_transformed(_x, _y - 3, _str, _scale, _scale, 0);
        draw_text_transformed(_x, _y + 3, _str, _scale, _scale, 0);
    };

    state = SCORE_STATE.WAIT;
    state_timer = 0;
    stat_index = 0;

    bg_overlay_alpha = 1.0;

    var _labels = ["Kills", "Max Combo", "Execution"];
    var _targets = [
        global.enemies_killed,
        global.combo_max_level,
        global.executions_count
    ];

    var _maxes = [30, 25, 6, 42000];

    if (variable_global_exists("current_level")
    && variable_struct_exists(global.current_level, "max_stats")) {
        _maxes[0] = global.current_level.max_stats.kills;
        _maxes[1] = global.current_level.max_stats.combo;
        _maxes[2] = global.current_level.max_stats.execs;
        _maxes[3] = global.current_level.max_stats.score;
    }

    stat_data = array_create(3);

    for (var i = 0; i < 3; i++) {
        stat_data[i] = {
            label: _labels[i],
            target: _targets[i],
            max: _maxes[i],
            displayed: 0,
            percent: 0,
            alpha_text: 0,
            alpha_num: 0,
            slide: 0,
            flash: 0,
            last_int: -1,
            sound_handle: -1,
            text_played: false,
            splash_played: false
        };
    }

    alpha_rank = 0;
    slide_rank = 0;
    flash_rank = 0;
    rank_frame = 0;
    sound_text_played_rank = false;

    level_score_target = global.total_score;
    level_score_max = _maxes[3];
    level_score_displayed = 0;
    level_score_last_int = -1;
    level_score_flash = 0;
    level_score_alpha = 0;
    score_splash_played = false;

    global_stats_alpha = 0;
    total_restarts = global.total_restarts;

	var _total_seconds = global.level_time / 60;

	var _hours = floor(_total_seconds / 3600);
	var _minutes = floor((_total_seconds mod 3600) / 60);
	var _seconds = floor(_total_seconds mod 60);

	var _str_hours = (_hours < 10) ? "0" + string(_hours) : string(_hours);
	var _str_mins = (_minutes < 10) ? "0" + string(_minutes) : string(_minutes);
	var _str_secs = (_seconds < 10) ? "0" + string(_seconds) : string(_seconds);

	total_time_string = _str_hours + ":" + _str_mins + ":" + _str_secs;

    rank_rise_timer = 0;
    rank_rise_duration = 70;
    rank_revealed = false;
    screen_flash_alpha = 0;

    // Подэтапы раскрытия оценки:
    // 0 — подсчёт очков
    // 1 — появление GRADE
    // 2 — раскрытие оценки
    rank_phase = 0;

    slide_speed = 0.05;
    text_fade_speed = 0.05;
    num_fade_speed = 0.05;
    count_speed = 0.05;
    flash_speed = 0.01;
    flash_scale_max = 0.4;

    text_num_offset = 1000;

    scrScoreMenu_Rank();

    grade_ui = noone;
}
