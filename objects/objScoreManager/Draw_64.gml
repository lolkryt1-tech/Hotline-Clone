var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// =========================================================================
// 1. ЧЕРНАЯ ЗАЛИВКА ЭКРАНА ПРИ СТАРТЕ
// =========================================================================
if (bg_overlay_alpha > 0) {
    draw_set_alpha(bg_overlay_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
}

// =========================================================================
// 2. ЧАСЫ (Правый верхний угол)
// =========================================================================
var _old_t_font   = draw_get_font();
var _old_t_color  = draw_get_color();
var _old_t_halign = draw_get_halign();

var _total_seconds = global.level_time / 60; 
var _minutes = floor(_total_seconds / 60);
var _seconds = floor(_total_seconds mod 60);
var _milliseconds = floor((_total_seconds mod 1) * 100); 

var _str_mins = (_minutes < 10) ? "0" + string(_minutes) : string(_minutes);
var _str_secs = (_seconds < 10) ? "0" + string(_seconds) : string(_seconds);
var _str_ms   = (_milliseconds < 10) ? "0" + string(_milliseconds) : string(_milliseconds);

draw_set_font(fntTimer); 
draw_set_halign(fa_left); 

var _timer_scale = 1; 
var _timer_y = 35;

var _char_w = string_width("0") * _timer_scale;
var _sep_w  = string_width(":") * _timer_scale;

var _total_width = (6 * _char_w) + (2 * _sep_w);
var _start_timer_x = _gui_w - _total_width - 40; 

var _draw_stable_text = function(_x, _y, _text, _scale) {
    draw_set_color(c_black);
    draw_text_transformed(_x - 1, _y,     _text, _scale, _scale, 0);
    draw_text_transformed(_x + 1, _y,     _text, _scale, _scale, 0);
    draw_text_transformed(_x,     _y - 1, _text, _scale, _scale, 0);
    draw_text_transformed(_x,     _y + 1, _text, _scale, _scale, 0);
    draw_set_color(c_white);
    draw_text_transformed(_x, _y, _text, _scale, _scale, 0);
};

var _cx = _start_timer_x;
_draw_stable_text(_cx, _timer_y, string_char_at(_str_mins, 1), _timer_scale); _cx += _char_w;
_draw_stable_text(_cx, _timer_y, string_char_at(_str_mins, 2), _timer_scale); _cx += _char_w;
_draw_stable_text(_cx, _timer_y, ":", _timer_scale); _cx += _sep_w;
_draw_stable_text(_cx, _timer_y, string_char_at(_str_secs, 1), _timer_scale); _cx += _char_w;
_draw_stable_text(_cx, _timer_y, string_char_at(_str_secs, 2), _timer_scale); _cx += _char_w;
_draw_stable_text(_cx, _timer_y, ".", _timer_scale); _cx += _sep_w;
_draw_stable_text(_cx, _timer_y, string_char_at(_str_ms, 1), _timer_scale); _cx += _char_w;
_draw_stable_text(_cx, _timer_y, string_char_at(_str_ms, 2), _timer_scale); _cx += _char_w;

draw_set_font(_old_t_font);
draw_set_color(_old_t_color);
draw_set_halign(_old_t_halign);

// =========================================================================
// 3. ТАБЛИЦА РЕЗУЛЬТАТОВ (Kills, Combo, Execution)
// =========================================================================
draw_set_alpha(1);
draw_set_font(fntScore);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

var _start_x = _gui_w * 0.1;
var _start_y = _gui_h * 0.15;
var _line_height = 80;

var _neon_magenta = make_color_rgb(255, 0, 128);
var _thick        = 2; 

var _wave_speed   = 0.003; 
var _wave_amount  = 12;    
var _wave_phase   = 0.6;   

for (var i = 0; i < array_length(stat_data); i++) {
    var _d = stat_data[i];
    if (_d.alpha_text <= 0) continue;

    var _y = _start_y + _line_height * i;
    var _offset = (1.0 - _d.slide) * -50;
    
    var _wave_x = sin((current_time * _wave_speed) + (i * _wave_phase)) * _wave_amount;
    var _current_x = _start_x + _offset + _wave_x;

    // --- НАЗВАНИЯ СТАТИСТИК ---
    draw_set_alpha(_d.alpha_text);
    draw_set_color(c_black);
    for (var dx = -_thick; dx <= _thick; dx += _thick) {
        for (var dy = -_thick; dy <= _thick; dy += _thick) {
            if (dx != 0 || dy != 0) draw_text(_current_x + dx, _y + dy, _d.label);
        }
    }
    
    draw_set_alpha(_d.alpha_text * 0.35);
    draw_set_color(_neon_magenta);
    draw_text(_current_x - 1, _y, _d.label);
    draw_text(_current_x + 1, _y, _d.label);
    draw_text(_current_x, _y - 1, _d.label);
    draw_text(_current_x, _y + 1, _d.label);

    draw_set_alpha(_d.alpha_text);
    draw_set_color(c_white);
    draw_text(_current_x, _y, _d.label);

    // --- ЦИФРЫ СТАТИСТИКИ ---
    if (_d.alpha_num > 0) {
        var _color_lame = make_color_rgb(100, 110, 140); 
        var _color_mid  = make_color_rgb(0, 243, 255);   
        var _color_max  = make_color_rgb(255, 215, 0);   

        var _base_color;
        if (_d.percent < 0.5) {
            _base_color = merge_color(_color_lame, _color_mid, _d.percent * 2);
        } else {
            var _gold_factor = power((_d.percent - 0.5) * 2, 2); 
            _base_color = merge_color(_color_mid, _color_max, _gold_factor);
        }

        var _final_color = (_d.flash > 0) ? merge_color(_base_color, c_white, _d.flash) : _base_color;
        var _num_scale   = 1.0 + (_d.flash * flash_scale_max);
        
        var _target_num_x = _current_x + text_num_offset;
        var _str = string(floor(_d.displayed)) + " / " + string(_d.max);

        draw_set_alpha(_d.alpha_num);
        draw_set_color(c_black);
        for (var dx = -_thick; dx <= _thick; dx += _thick) {
            for (var dy = -_thick; dy <= _thick; dy += _thick) {
                if (dx != 0 || dy != 0) {
                    draw_text_transformed(_target_num_x + dx, _y + dy, _str, _num_scale, _num_scale, 0);
                }
            }
        }

        draw_set_alpha(_d.alpha_num * 0.25);
        draw_set_color(_base_color);
        draw_text_transformed(_target_num_x - 3, _y, _str, _num_scale, _num_scale, 0);
        draw_text_transformed(_target_num_x + 3, _y, _str, _num_scale, _num_scale, 0);
        draw_text_transformed(_target_num_x, _y - 3, _str, _num_scale, _num_scale, 0);
        draw_text_transformed(_target_num_x, _y + 3, _str, _num_scale, _num_scale, 0);

        draw_set_alpha(_d.alpha_num);
        draw_set_color(_final_color);
        draw_text_transformed(_target_num_x, _y, _str, _num_scale, _num_scale, 0);
    }
}

// =========================================================================
// 4. БЛОК РАНГА (Слева внизу)
// =========================================================================
if (alpha_rank > 0) {
    var _offset = (1.0 - slide_rank) * -50;
    
    var _rank_wave_idx = 3; 
    var _rank_wave_x = sin((current_time * _wave_speed) + (_rank_wave_idx * _wave_phase)) * _wave_amount;
    
    var _grade_x = _start_x + _offset + _rank_wave_x;
    var _grade_y = _gui_h * 0.75; 

    draw_set_alpha(alpha_rank);
    draw_set_color(c_black);
    for (var dx = -_thick; dx <= _thick; dx += _thick) {
        for (var dy = -_thick; dy <= _thick; dy += _thick) {
            if (dx != 0 || dy != 0) draw_text(_grade_x + dx, _grade_y + dy, "GRADE");
        }
    }
    draw_set_color(c_white);
    draw_text(_grade_x, _grade_y, "GRADE");

    if (rank_revealed) {
        var _scale = 1.0 + (flash_rank * flash_scale_max); 
        var _sprite_x = _grade_x + 320; 
        var _sprite_y = _grade_y; 

        draw_set_alpha(alpha_rank);
        var _final_blend = (flash_rank > 0) ? merge_color(rank_color, c_white, flash_rank) : rank_color; 
        draw_sprite_ext(sprScoreGrade, rank_frame, _sprite_x, _sprite_y, _scale, _scale, 0, _final_blend, alpha_rank);
    }
}

// =========================================================================
// 4.8 LEVEL SCORE (Справа внизу)
// =========================================================================
if (level_score_alpha > 0) {
    var _score_fixed_x = _start_x + text_num_offset - 300; 
    var _score_text_y = _gui_h * 0.75; 

    draw_set_alpha(level_score_alpha);
    draw_set_color(c_black);
    for (var dx = -_thick; dx <= _thick; dx += _thick) {
        for (var dy = -_thick; dy <= _thick; dy += _thick) {
            if (dx != 0 || dy != 0) draw_text(_score_fixed_x + dx, _score_text_y + dy, "LEVEL SCORE");
        }
    }
    draw_set_color(c_white);
    draw_text(_score_fixed_x, _score_text_y, "LEVEL SCORE");

    var _score_pct = level_score_max > 0 ? clamp(level_score_displayed / level_score_max, 0, 1) : 0;
    var _score_lame = make_color_rgb(100, 110, 140);
    var _score_mid  = make_color_rgb(0, 243, 255);
    var _score_max_c = make_color_rgb(255, 215, 0);

    var _score_color;
    if (_score_pct < 0.5) {
        _score_color = merge_color(_score_lame, _score_mid, _score_pct * 2);
    } else {
        var _gold_f = power((_score_pct - 0.5) * 2, 2);
        _score_color = merge_color(_score_mid, _score_max_c, _gold_f);
    }

    var _final_score_color = (level_score_flash > 0) ? merge_color(_score_color, c_white, level_score_flash) : _score_color;
    var _score_scale       = 1.0 + (level_score_flash * flash_scale_max); 

    var _score_val_y = _score_text_y + 60; 
    var _score_str = string(floor(level_score_displayed)) + " / " + string(level_score_max);

    draw_set_color(c_black);
    for (var dx = -_thick; dx <= _thick; dx += _thick) {
        for (var dy = -_thick; dy <= _thick; dy += _thick) {
            if (dx != 0 || dy != 0) {
                draw_text_transformed(_score_fixed_x + dx, _score_val_y + dy, _score_str, _score_scale, _score_scale, 0);
            }
        }
    }

    draw_set_alpha(level_score_alpha * 0.25);
    draw_set_color(_score_color);
    draw_text_transformed(_score_fixed_x - 3, _score_val_y, _score_str, _score_scale, _score_scale, 0);
    draw_text_transformed(_score_fixed_x + 3, _score_val_y, _score_str, _score_scale, _score_scale, 0); 
    draw_text_transformed(_score_fixed_x, _score_val_y - 3, _score_str, _score_scale, _score_scale, 0);
    draw_text_transformed(_score_fixed_x, _score_val_y + 3, _score_str, _score_scale, _score_scale, 0);

    draw_set_alpha(level_score_alpha);
    draw_set_color(_final_score_color);
    draw_text_transformed(_score_fixed_x, _score_val_y, _score_str, _score_scale, _score_scale, 0);
}

// =========================================================================
// 4.9 СТАТИСТИКА TOTAL TIME И TOTAL RESTART (Правый нижний угол)
// =========================================================================
if (global_stats_alpha > 0) {
    draw_set_alpha(global_stats_alpha);
    draw_set_halign(fa_right);
    
    var _stat_fixed_x = _start_x + text_num_offset + 350;
    var _stat_y_time = _gui_h * 0.94;
    var _stat_y_rest = _gui_h * 0.97;
    var _time_str = "TOTAL TIME: " + total_time_string;
    var _rest_str = "TOTAL RESTART: " + string(total_restarts);
    var _stat_scale = 0.45;
    
    // TOTAL TIME
    draw_set_color(c_black);
    for (var dx = -_thick; dx <= _thick; dx += _thick) {
        for (var dy = -_thick; dy <= _thick; dy += _thick) {
            if (dx != 0 || dy != 0) draw_text_transformed(_stat_fixed_x + dx, _stat_y_time + dy, _time_str, _stat_scale, _stat_scale, 0);
        }
    }
    draw_set_color(c_white);
    draw_text_transformed(_stat_fixed_x, _stat_y_time, _time_str, _stat_scale, _stat_scale, 0);

    // TOTAL RESTART
    draw_set_color(c_black);
    for (var dx = -_thick; dx <= _thick; dx += _thick) {
        for (var dy = -_thick; dy <= _thick; dy += _thick) {
            if (dx != 0 || dy != 0) draw_text_transformed(_stat_fixed_x + dx, _stat_y_rest + dy, _rest_str, _stat_scale, _stat_scale, 0);
        }
    }
    draw_set_color(c_white);
    draw_text_transformed(_stat_fixed_x, _stat_y_rest, _rest_str, _stat_scale, _stat_scale, 0);
    
    draw_set_halign(fa_left);
}

// =========================================================================
// 4.95 ПОЛНОЭКРАННАЯ БЕЛАЯ ВСПЫШКА
// =========================================================================
if (screen_flash_alpha > 0) {
    draw_set_alpha(screen_flash_alpha);
    draw_set_color(c_white);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
}

// Сброс всех настроек контекста рисования
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);