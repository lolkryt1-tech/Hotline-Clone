var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _center_x = _gui_w * 0.5;
var _center_y = _gui_h * 0.5;


// ==================================================
// НАСТРОЙКИ ОТРИСОВКИ
// ==================================================

draw_set_font(fntMainMenu);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


// ==================================================
// ПРОГРЕСС ПЕРЕХОДА
// ==================================================

var _t = confirm_progress;

var _smooth_prog = _t * _t * (3.0 - 2.0 * _t);


// ==================================================
// НАЗВАНИЕ УРОВНЯ
// ==================================================

var _text_move_progress = clamp(_smooth_prog / 0.4, 0, 1);

var _text_y_start = _center_y + 50;
var _text_y_end = _center_y - 80;

var _text_y = lerp(
    _text_y_start,
    _text_y_end,
    _text_move_progress
);

var _center_idx_txt = round(scroll_value);

for (var i = _center_idx_txt - 1; i <= _center_idx_txt + 1; i++)
{
    if (i < 0 || i >= array_length(levels))
    {
        continue;
    }

    var _offset = (i - scroll_value) * 150;

    var _alpha = clamp(1.0 - abs(i - scroll_value), 0, 1);

    if (_alpha > 0.05)
    {
        draw_set_alpha(_alpha);
        draw_set_color(c_white);

        draw_text_transformed(
            _center_x + _offset,
            _text_y,
            levels[i],
            1.0,
            1.0,
            0
        );
    }
}


// ==================================================
// ЗАГОЛОВОК SELECT
// ==================================================

if (
    state == LEVEL_STATE.CHOOSING ||
    state == LEVEL_STATE.CONFIRMING ||
    (state == LEVEL_STATE.LEAVING && next_room == rmMainMenu)
)
{
    var _title_y_start = _center_y - 150;
    var _title_y_end = _title_y_start - 150;

    var _title_y = lerp(
        _title_y_start,
        _title_y_end,
        _smooth_prog
    );

    var _title_alpha = clamp(1.0 - (_smooth_prog * 1.5), 0, 1);

    if (state == LEVEL_STATE.LEAVING)
    {
        _title_y = _title_y_start;
        _title_alpha = 1.0;
    }

    if (_title_alpha > 0.01)
    {
        var _title_scale = 1.5 + (sin(title_pulse) * 0.05);

        draw_set_alpha(_title_alpha);
        draw_set_color(c_white);

        draw_text_transformed(
            _center_x,
            _title_y,
            "SELECT",
            _title_scale,
            _title_scale,
            0
        );
    }
}


// ==================================================
// РАСКРЫВАЮЩЕЕСЯ ПОЛОТНО
// ==================================================

if (state != LEVEL_STATE.CHOOSING)
{
    var _curtain_start = 0.4;

    var _curtain_progress = clamp(
        (_smooth_prog - _curtain_start) / (1.0 - _curtain_start),
        0,
        1
    );

    if (_curtain_progress > 0)
    {
        var _rect_w = 600;
        var _rect_h_max = 220;

        var _rect_x = _center_x - _rect_w * 0.5;

        var _y1 = _text_y + 40;

        var _eased_curtain = _curtain_progress * _curtain_progress *
                             (3.0 - 2.0 * _curtain_progress);

        var _current_h = _rect_h_max * _eased_curtain;

        var _y2 = _y1 + _current_h;


        // Подложка.

        draw_set_alpha(0.4);
        draw_set_color(c_black);

        draw_rectangle(
            _rect_x,
            _y1,
            _rect_x + _rect_w,
            _y2,
            false
        );


        // --------------------------------------------------
        // ПОЗИЦИЯ И ПРОЗРАЧНОСТЬ РАНГА
        // --------------------------------------------------

        // Координаты задаёт именно меню.
        // Объект ранга самостоятельно использует их в Draw GUI.

        var _rank_x = _rect_x + _rect_w - 80;
        var _rank_y = _y1 + 140;

        var _data_alpha = 0;

        if (_curtain_progress > 0.8)
        {
            _data_alpha = clamp(
                (_curtain_progress - 0.8) * 5,
                0,
                1
            );
        }

        if (grade_ui != noone && instance_exists(grade_ui))
        {
            grade_ui.target_x = _rank_x;
            grade_ui.target_y = _rank_y;
            grade_ui.target_alpha = _data_alpha;
        }


        // --------------------------------------------------
        // ДАННЫЕ УРОВНЯ
        // --------------------------------------------------

        if (_curtain_progress > 0.8)
        {
            draw_set_alpha(_data_alpha);

            var _cur_rec = level_records[target_scroll];

            var _best_time_str = formatTime(_cur_rec.best_time);

            draw_set_halign(fa_left);
            draw_set_color(c_white);

            draw_text_transformed(
                _rect_x + 30,
                _y1 + 50,
                "Best time: " + _best_time_str,
                0.8,
                0.8,
                0
            );

            var _difficulty_text = global.hard
                ? "Difficulty: Hard"
                : "Difficulty: Easy";

            draw_text_transformed(
                _rect_x + 30,
                _y1 + 150,
                _difficulty_text,
                0.8,
                0.8,
                0
            );


            // Заголовок Rank.

            draw_set_halign(fa_right);

            draw_text_transformed(
                _rect_x + _rect_w - 30,
                _y1 + 30,
                "Rank",
                0.8,
                0.8,
                0
            );


            // Если рекорда нет — белая палочка.

            if (_cur_rec.best_rank < 0)
            {
                var _line_w = 80;
                var _line_h = 6;

                var _line_x = _rect_x + _rect_w - 80;
                var _line_y = _y1 + 140;

                draw_set_alpha(_data_alpha);
                draw_set_color(c_white);

                draw_rectangle(
                    _line_x - _line_w * 0.5,
                    _line_y - _line_h * 0.5,
                    _line_x + _line_w * 0.5,
                    _line_y + _line_h * 0.5,
                    false
                );
            }
        }
    }
}


// ==================================================
// ПАЛОЧКИ ПО БОКАМ
// ==================================================

var _center_idx = round(scroll_value);

var _dist_to_center = abs(scroll_value - _center_idx);

var _stop_fade = 1.0 - clamp(
    (_dist_to_center - 0.05) / 0.2,
    0,
    1
);

if (_stop_fade > 0.01)
{
    var _idx = round(scroll_value);

    if (_idx >= 0 && _idx < array_length(levels))
    {
        var _text_width = string_width(levels[_idx]);

        var _pulse = (sin(current_time / 300) + 1) * 0.5;

        var _dash_offset = 30 + (8 * _pulse) + dash_spread;
        var _dash_len = 50;

        var _dash_x1_start = _center_x - (_text_width * 0.5) - _dash_offset;
        var _dash_x1_end = _dash_x1_start - _dash_len;

        var _dash_x2_start = _center_x + (_text_width * 0.5) + _dash_offset;
        var _dash_x2_end = _dash_x2_start + _dash_len;

        var _dash_alpha = (0.3 + (_pulse * 0.7)) * _stop_fade;

        var _dash_y = _text_y + 2;
        var _thick = 4;


        // Левая палочка.

        draw_primitive_begin(pr_trianglelist);

        draw_vertex_color(
            _dash_x1_start,
            _dash_y - _thick * 0.5,
            c_white,
            _dash_alpha
        );

        draw_vertex_color(
            _dash_x1_start,
            _dash_y + _thick * 0.5,
            c_white,
            _dash_alpha
        );

        draw_vertex_color(
            _dash_x1_end,
            _dash_y + _thick * 0.5,
            c_white,
            0.0
        );

        draw_vertex_color(
            _dash_x1_start,
            _dash_y - _thick * 0.5,
            c_white,
            _dash_alpha
        );

        draw_vertex_color(
            _dash_x1_end,
            _dash_y + _thick * 0.5,
            c_white,
            0.0
        );

        draw_vertex_color(
            _dash_x1_end,
            _dash_y - _thick * 0.5,
            c_white,
            0.0
        );

        draw_primitive_end();


        // Правая палочка.

        draw_primitive_begin(pr_trianglelist);

        draw_vertex_color(
            _dash_x2_start,
            _dash_y - _thick * 0.5,
            c_white,
            _dash_alpha
        );

        draw_vertex_color(
            _dash_x2_start,
            _dash_y + _thick * 0.5,
            c_white,
            _dash_alpha
        );

        draw_vertex_color(
            _dash_x2_end,
            _dash_y + _thick * 0.5,
            c_white,
            0.0
        );

        draw_vertex_color(
            _dash_x2_start,
            _dash_y - _thick * 0.5,
            c_white,
            _dash_alpha
        );

        draw_vertex_color(
            _dash_x2_end,
            _dash_y + _thick * 0.5,
            c_white,
            0.0
        );

        draw_vertex_color(
            _dash_x2_end,
            _dash_y - _thick * 0.5,
            c_white,
            0.0
        );

        draw_primitive_end();
    }
}


// ==================================================
// PLAY
// ==================================================

if (play_alpha > 0.01)
{
    var _play_y = _text_y_end + 40 + 150 + 60;

    var _play_pulse = (sin(current_time / 200) + 1) * 0.5;

    var _play_scale = 1.0 + (_play_pulse * 0.1) + (play_alpha * 0.4);

    draw_set_alpha(play_alpha);
    draw_set_halign(fa_center);

    draw_set_color(c_black);

    draw_text_transformed(
        _center_x + 2,
        _play_y + 2,
        "PLAY",
        _play_scale,
        _play_scale,
        0
    );

    draw_set_color(c_white);

    draw_text_transformed(
        _center_x,
        _play_y,
        "PLAY",
        _play_scale,
        _play_scale,
        0
    );
}


// ==================================================
// РЕЖИМ СЛОЖНОСТИ
// ==================================================

var _hard_text = "Disabled";
var _hard_color = c_gray;

if (global.hard == true)
{
    _hard_text = "Enabled";
    _hard_color = c_red;
}

draw_set_color(_hard_color);
draw_set_alpha(1.0);

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

draw_text_transformed(_center_x - 17, _gui_h - 20, "Press Space to change mode", 0.35, 0.35, 0);
draw_text_transformed(_center_x - 60, _gui_h - 40, "Hard mode: ", 0.5, 0.5, 0);

draw_text_transformed(_center_x + 40, _gui_h - 40, _hard_text, 0.5, 0.5, 0);


// ==================================================
// ЗАТЕМНЕНИЕ
// ==================================================

if (fade_alpha > 0)
{
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);

    draw_rectangle(
        0,
        0,
        _gui_w,
        _gui_h,
        false
    );
}


// ==================================================
// СБРОС СОСТОЯНИЯ ОТРИСОВКИ
// ==================================================

draw_set_alpha(1);
draw_set_color(c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);