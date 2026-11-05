
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _center_x = _gui_w * 0.5;
var _center_y = _gui_h * 0.5;

// --- 1. ТЕКСТ С 3D ОБЪЁМОМ И ECHO ---
if (text_started) {

    draw_set_font(fntLevelSelect);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    var _len = string_length(level_name);
    var _total_width = string_width(level_name);
    var _start_x = _center_x - (_total_width * 0.5);

    var _current_x = _start_x;
    var _limit = min(text_visible_chars + 1, _len);

    for (var i = 1; i <= _limit; i++) {

        var _char = string_char_at(level_name, i);
        var _char_w = string_width(_char) + 5;

        // --- АНИМАЦИЯ ПОЯВЛЕНИЯ ---
        var _p = 1.0;

        if (i == text_visible_chars + 1) {
            _p = clamp(
                text_char_timer / text_char_delay,
                0.0, 1.0
            );
        }

        var _slide_y = (1.0 - _p) * 30;
        var _wiggle_y = sin(anim_time * 2 + i) * 12;
        var _alpha = _p;

        if (_alpha > 0) {

            var _final_y = _center_y + _slide_y + _wiggle_y;
            var _char_center_x = _current_x + (_char_w * 0.5);

            // =====================================
            // 2. ГРАДИЕНТ ОСНОВНОЙ БУКВЫ
            // =====================================

            // Разница фаз между верхом и низом
            var _phase = gradient_offset + i * 0.18;

            var _wave_top = sin(_phase);
            var _wave_bottom = sin(_phase - 1.5);

            var _t_top = (_wave_top + 1.0) * 0.5;
            var _t_bottom = (_wave_bottom + 1.0) * 0.5;

            // Розовый -> бирюзовый
            var _color_top = merge_color(
                gradient_pink,
                gradient_cyan,
                _t_top
            );

            var _color_bottom = merge_color(
                gradient_pink,
                gradient_cyan,
                _t_bottom
            );

            // Белые переливы
            var _white_top = power(_t_top, 5) * 0.3;
            var _white_bottom = power(_t_bottom, 5) * 0.3;

            _color_top = merge_color(
                _color_top,
                gradient_white,
                _white_top
            );

            _color_bottom = merge_color(
                _color_bottom,
                gradient_white,
                _white_bottom
            );

            // =====================================
            // 3. СОХРАНЕНИЕ ИСТОРИИ ECHO
            // =====================================

            if (array_length(echo_history) < i) {
                echo_history[i - 1] = [];
            }

            var _history = echo_history[i - 1];

            // Сохраняем положение буквы
            array_insert(
                _history,
                0,
                [_current_x, _final_y]
            );

            // Ограничиваем историю
            if (array_length(_history) > echo_max_history) {
                array_resize(_history, echo_max_history);
            }

            echo_history[i - 1] = _history;

            // =====================================
            // 4. ОТРИСОВКА ECHO
            // =====================================

            for (var e = echo_count; e >= 1; e--) {

                var _index = e * echo_interval;

                if (_index < array_length(_history)) {

                    var _old_pos = _history[_index];

                    var _echo_x = _old_pos[0];
                    var _echo_y = _old_pos[1];

                    // Затухание старых копий
                    var _fade = power(echo_decay, e);
                    var _echo_alpha = _alpha * _fade;

                    // Псевдослучайный сдвиг оттенка
                    // Стабилен для каждой буквы и слоя
                    var _seed = sin(
                        e * 12.9898 + i * 78.233
                    ) * 43758.5453;

                    var _random_factor = _seed - floor(_seed);

                    // Плавные волны цвета
                    var _echo_phase =
                        gradient_offset * 0.8
                        - e * 0.45
                        + i * 0.2
                        + _random_factor * 2.0;

                    // Разные фазы сверху и снизу
                    var _echo_wave_top = sin(_echo_phase);
                    var _echo_wave_bottom = sin(
                        _echo_phase - 1.5
                    );

                    var _echo_mix_top = clamp(
                        0.3
                        + _echo_wave_top * 0.3
                        + _random_factor * echo_color_variation,
                        0, 1
                    );

                    var _echo_mix_bottom = clamp(
                        0.3
                        + _echo_wave_bottom * 0.3
                        + _random_factor * echo_color_variation,
                        0, 1
                    );

                    // Цвет верхней части Echo
                    var _echo_top = merge_color(
                        gradient_pink,
                        gradient_cyan,
                        _echo_mix_top
                    );

                    // Цвет нижней части Echo
                    var _echo_bottom = merge_color(
                        gradient_pink,
                        gradient_cyan,
                        _echo_mix_bottom
                    );

                    // Белые блики
                    var _echo_white_top = power(
                        max(0, _echo_wave_top), 6
                    ) * 0.7;

                    var _echo_white_bottom = power(
                        max(0, _echo_wave_bottom), 6
                    ) * 0.7;

                    _echo_top = merge_color(
                        _echo_top,
                        gradient_white,
                        _echo_white_top
                    );

                    _echo_bottom = merge_color(
                        _echo_bottom,
                        gradient_white,
                        _echo_white_bottom
                    );

                    // Рисуем копию с вертикальным градиентом
                    draw_text_transformed_color(
                        _echo_x,
                        _echo_y,
                        _char,
                        1, 1, 0,
                        _echo_top,
                        _echo_top,
                        _echo_bottom,
                        _echo_bottom,
                        _echo_alpha
                    );
                }
            }

            // =====================================
            // 5. 3D ОБЪЁМ БУКВ
            // =====================================

            var _vol_color_start = make_color_rgb(
                105, 60, 112
            );

            var _vol_color_end = make_color_rgb(
                35, 13, 49
            );

            var _dist_x =
                (_char_center_x - _center_x)
                / (_gui_w * 0.5);

            var _dist_y =
                (_final_y - _center_y)
                / (_gui_h * 0.5);

            var _shadow_dir_x = _dist_x * 12;
            var _shadow_dir_y = _dist_y * 12;

            var _layers = 8;

            for (var v = _layers; v > 0; v--) {

                var _factor = v / _layers;

                var _vx = _current_x
                    + (_shadow_dir_x * _factor);

                var _vy = _final_y
                    + (_shadow_dir_y * _factor);

                var _current_vol_color = merge_color(
                    _vol_color_start,
                    _vol_color_end,
                    _factor
                );

                draw_text_transformed_color(
                    _vx,
                    _vy,
                    _char,
                    1, 1, 0,
                    _current_vol_color,
                    _current_vol_color,
                    _current_vol_color,
                    _current_vol_color,
                    _alpha
                );

                draw_text_transformed_color(
                    _vx + 1,
                    _vy + 1,
                    _char,
                    1, 1, 0,
                    c_black,
                    c_black,
                    c_black,
                    c_black,
                    _alpha * 0.3
                );
            }

            // =====================================
            // 6. ЧЁРНАЯ ОБВОДКА
            // =====================================

            for (var dx = -2; dx <= 2; dx += 2) {
                for (var dy = -2; dy <= 2; dy += 2) {

                    if (dx != 0 || dy != 0) {

                        draw_text_transformed_color(
                            _current_x + dx,
                            _final_y + dy,
                            _char,
                            1, 1, 0,
                            c_black,
                            c_black,
                            c_black,
                            c_black,
                            _alpha
                        );
                    }
                }
            }

            // =====================================
            // 7. ПЕРЕДНЯЯ ЧАСТЬ БУКВЫ
            // =====================================

            draw_text_transformed_color(
                _current_x,
                _final_y,
                _char,
                1, 1, 0,
                _color_top,
                _color_top,
                _color_bottom,
                _color_bottom,
                _alpha
            );
        }

        _current_x += _char_w;
    }
}

// =====================================
// 8. ВОССТАНОВЛЕНИЕ НАСТРОЕК DRAW
// =====================================

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
