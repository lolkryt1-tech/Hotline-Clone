var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

if (bg_overlay_alpha > 0) {
    draw_set_alpha(bg_overlay_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
}

draw_set_font(fntScore);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

var _start_x = _gui_w * 0.1;
var _start_y = _gui_h * 0.15;
var _line_height = 80;
var _thick = 2;

for (var i = 0; i < array_length(stat_data); i++) {
    var _d = stat_data[i];
    if (_d.alpha_text <= 0) continue;

    var _y = _start_y + _line_height * i;
    var _offset = (1.0 - _d.slide) * -50;
    var _wave_x = sin((current_time * 0.003) + (i * 0.6)) * 12;
    var _current_x = _start_x + _offset + _wave_x;

    draw_set_alpha(_d.alpha_text);
    draw_text_outline(_current_x, _y, _d.label, 1.0, _thick);
    draw_text_glow(_current_x, _y, _d.label, 1.0, make_color_rgb(255, 0, 128), _d.alpha_text * 0.35);
    draw_set_alpha(_d.alpha_text);
    draw_set_color(c_white);
    draw_text(_current_x, _y, _d.label);

    if (_d.alpha_num > 0) {
        var _base_color = get_percent_color(_d.percent);
        var _final_color = (_d.flash > 0) ? merge_color(_base_color, c_white, _d.flash) : _base_color;
        var _num_scale = 1.0 + (_d.flash * flash_scale_max);
        var _target_num_x = _current_x + text_num_offset;
        var _str = string(floor(_d.displayed)) + " / " + string(_d.max);

        draw_set_alpha(_d.alpha_num);
        draw_text_outline(_target_num_x, _y, _str, _num_scale, _thick);
        draw_text_glow(_target_num_x, _y, _str, _num_scale, _base_color, _d.alpha_num * 0.25);
        draw_set_alpha(_d.alpha_num);
        draw_set_color(_final_color);
        draw_text_transformed(_target_num_x, _y, _str, _num_scale, _num_scale, 0);
    }
}

if (alpha_rank > 0) {
    var _offset = (1.0 - slide_rank) * -50;
    var _wave_x = sin((current_time * 0.003) + (3 * 0.6)) * 12;
    var _grade_x = _start_x + _offset + _wave_x;
    var _grade_y = _gui_h * 0.75;

    draw_set_alpha(alpha_rank);
    draw_text_outline(_grade_x, _grade_y, "GRADE", 1.0, _thick);
    draw_set_color(c_white);
    draw_text(_grade_x, _grade_y, "GRADE");

    if (grade_ui != noone && instance_exists(grade_ui)) {
        grade_ui.target_alpha = 1.0;
        grade_ui.target_x = _grade_x + 320;
        grade_ui.target_y = _grade_y;
    }
}

if (level_score_alpha > 0) {
    var _wave_speed  = 0.003;
    var _wave_amount = 12;
    var _wave_phase  = 0.6;
    
    var _score_wave_x = sin((current_time * _wave_speed) + (4 * _wave_phase)) * _wave_amount;
    
    var _score_fixed_x = _start_x + text_num_offset - 300 + _score_wave_x;
    var _score_text_y = _gui_h * 0.75;

    draw_set_alpha(level_score_alpha);
    draw_text_outline(_score_fixed_x, _score_text_y, "LEVEL SCORE", 1.0, _thick);
    draw_set_color(c_white);
    draw_text(_score_fixed_x, _score_text_y, "LEVEL SCORE");

    var _score_pct = level_score_max > 0 ? clamp(level_score_displayed / level_score_max, 0, 1) : 0;
    var _score_color = get_percent_color(_score_pct);
    var _final_score_color = (level_score_flash > 0) ? merge_color(_score_color, c_white, level_score_flash) : _score_color;
    var _score_scale = 1.0 + (level_score_flash * flash_scale_max);

    var _score_val_y = _score_text_y + 60;
    var _score_str = string(floor(level_score_displayed)) + " / " + string(level_score_max);

    draw_set_alpha(level_score_alpha);
    draw_text_outline(_score_fixed_x, _score_val_y, _score_str, _score_scale, _thick);
    draw_text_glow(_score_fixed_x, _score_val_y, _score_str, _score_scale, _score_color, level_score_alpha * 0.25);
    draw_set_alpha(level_score_alpha);
    draw_set_color(_final_score_color);
    draw_text_transformed(_score_fixed_x, _score_val_y, _score_str, _score_scale, _score_scale, 0);
}

if (global_stats_alpha > 0) {
    draw_set_alpha(global_stats_alpha);
    draw_set_halign(fa_right);
    
    var _stat_fixed_x = _start_x + text_num_offset + 400;
    var _stat_y_time = _gui_h * 0.94;
    var _stat_y_rest = _gui_h * 0.97;
    var _time_str = "TOTAL TIME: " + total_time_string;
    var _rest_str = "TOTAL RESTARTS: " + string(total_restarts);
    var _stat_scale = 0.45;

    draw_text_outline(_stat_fixed_x, _stat_y_time, _time_str, _stat_scale, _thick);
    draw_set_color(c_white);
    draw_text_transformed(_stat_fixed_x, _stat_y_time, _time_str, _stat_scale, _stat_scale, 0);

    draw_text_outline(_stat_fixed_x, _stat_y_rest, _rest_str, _stat_scale, _thick);
    draw_set_color(c_white);
    draw_text_transformed(_stat_fixed_x, _stat_y_rest, _rest_str, _stat_scale, _stat_scale, 0);
    
    draw_set_halign(fa_left);
}

if (screen_flash_alpha > 0) {
    draw_set_alpha(screen_flash_alpha);
    draw_set_color(c_white);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);