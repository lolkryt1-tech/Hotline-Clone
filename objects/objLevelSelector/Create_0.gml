depth = 5;

enum LEVEL_STATE
{
    CHOOSING,
    CONFIRMING,
    WAITING,
    LEAVING
}

state = LEVEL_STATE.CHOOSING;

levels = [
    "New Case",
    "Level 2",
    "Level 3",
    "Level 4",
    "Level 5",
    "Level 6"
];

scroll_value = 0;
target_scroll = 0;

base_scroll_speed = 0.05;
fast_scroll_speed = 0.25;
current_scroll_speed = 0.05;

confirm_progress = 0;
title_pulse = 0;
dash_spread = 0;

is_reversing = false;
play_alpha = 0;

fade_alpha = 1.0;
fade_state = 1;
fade_speed = 0.02;


// ==================================================
// ССЫЛКИ
// ==================================================

grade_ui = noone;
score_fader = noone;

next_room = rmLevelTitle;


// ==================================================
// ЗАГРУЗКА РЕКОРДОВ
// ==================================================

normal_records = [];
hard_records = [];

var _saved_hard = global.hard;

for (var i = 0; i < array_length(levels); i++)
{
    var _name = levels[i];

    // NORMAL
    global.hard = false;

    var _normal = loadLevelRecord(_name);

    array_push(normal_records,
    {
        name: _name,
        best_time: _normal.best_time,
        best_rank: _normal.best_rank,
        best_score: _normal.best_score
    });


    // HARD
    global.hard = true;

    var _hard = loadLevelRecord(_name);

    array_push(hard_records,
    {
        name: _name,
        best_time: _hard.best_time,
        best_rank: _hard.best_rank,
        best_score: _hard.best_score
    });
}


// Возвращаем исходную сложность.
global.hard = _saved_hard;


// Активный массив рекордов.
level_records = global.hard ? hard_records : normal_records;