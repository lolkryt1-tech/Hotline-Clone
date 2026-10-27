#region СБРАСЫВАЕМ ЭКРАН В ПЕРВОМ КАДРЕ
var _win_w = window_get_width();
var _win_h = window_get_height();
if (window_get_fullscreen()) {
    _win_w = display_get_width();
    _win_h = display_get_height();
}
surface_resize(application_surface, _win_w, _win_h);
display_set_gui_size(_win_w, _win_h);
#endregion

enum SCORE_STATE { WAIT, ANIM_STAT, SHOW_RANK, DONE }
state = SCORE_STATE.WAIT;
state_timer = 0;
stat_index = 0;

// === ЗАТЕМНЕНИЕ ФОНА ===
bg_overlay_alpha = 1.0;

// === ДАННЫЕ СТАТ (ВОЗВРАЩАЕМ 3 СТРОКИ НАВЕРХ) ===
stat_data = array_create(0);

var _labels = array_create(3);
_labels[0] = "Kills";
_labels[1] = "Max Combo";
_labels[2] = "Execution";

var _targets = array_create(3);
_targets[0] = global.enemies_killed;
_targets[1] = global.combo_max_level;
_targets[2] = global.executions_count;

var _maxes = array_create(3, 0);
_maxes[0] = 30;
_maxes[1] = 25;
_maxes[2] = 6;
_maxes[3] = 42000;

if (variable_global_exists("current_level") && variable_struct_exists(global.current_level, "max_stats")) {
    _maxes[0] = global.current_level.max_stats.kills;
    _maxes[1] = global.current_level.max_stats.combo;
    _maxes[2] = global.current_level.max_stats.execs;
	_maxes[3] = global.current_level.max_stats.score;
	
} 

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

// === РАНГ ===
alpha_rank = 0; 
slide_rank = 0; 
flash_rank = 0;
rank_frame = 0; 
rank_color = c_gray; 
percent_total = 0;

sound_text_played_rank  = false;
sound_splash_played_rank = false;
sound_grade_played = false;

// === ИТОГОВЫЙ СЧЕТ УРОВНЯ (ВОЗВРАЩАЕМ ДАННЫЕ ДЛЯ ПРАВОГО БЛОКА) ===
level_score_target = global.total_score; 
level_score_max = _maxes[3];
level_score_displayed = 0;   
level_score_last_int  = -1;  
level_score_flash = 0;
level_score_alpha = 0;

// === ПЛАШКИ: TOTAL TIME & TOTAL RESTART ===
global_stats_alpha = 0; 
total_restarts = global.total_restarts;

var _total_seconds = global.level_time / 60; 

var _hours   = floor(_total_seconds / 3600);          
var _minutes = floor((_total_seconds mod 3600) / 60); 
var _seconds = floor(_total_seconds mod 60);          

var _str_hours = (_hours < 10) ? "0" + string(_hours) : string(_hours);
var _str_mins  = (_minutes < 10) ? "0" + string(_minutes) : string(_minutes);
var _str_secs  = (_seconds < 10) ? "0" + string(_seconds) : string(_seconds);

total_time_string = _str_hours + ":" + _str_mins + ":" + _str_secs;

// === ЛОГИКА НАРАСТАНИЯ И ОЖИДАНИЯ ВСПЫШКИ ===
rank_rise_timer = 0;        
rank_rise_duration = 70;    
rank_revealed = false;      
screen_flash_alpha = 0;     

// === СКОРОСТИ АНИМАЦИЙ ===
slide_speed     = 0.05;
text_fade_speed = 0.05;
num_fade_speed  = 0.05;
count_speed     = 0.05;
flash_speed     = 0.01;
flash_scale_max = 0.4;

text_num_offset = 1000; 
