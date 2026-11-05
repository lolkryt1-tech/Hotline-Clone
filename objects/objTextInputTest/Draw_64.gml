draw_set_font(gui_font);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

if (active_field >= 0)
{
    scrTextInputUpdateScroll(text_fields[active_field], field_w - 20);
}

draw_set_color(c_white);
draw_text(field_x, field_y - 35, "TEXT INPUT TEST");

for (var i = 0; i < array_length(text_fields); i++)
{
    var _field = text_fields[i];

    var _field_y = field_y + i * (field_h + field_gap);

    var _color = _field.active ? make_color_rgb(65, 85, 105) : make_color_rgb(40, 40, 48);

    // Фон поля.
    draw_set_color(_color);
    draw_rectangle(field_x, _field_y, field_x + field_w, _field_y + field_h, false);

    // Рамка.
    draw_set_color(_field.active ? c_white : make_color_rgb(100, 100, 110));
    draw_rectangle(field_x, _field_y, field_x + field_w, _field_y + field_h, true);

    // === ОБЛАСТЬ ОТОБРАЖЕНИЯ ТЕКСТА ===

    var _text_x = field_x + 10;
    var _text_y = _field_y + 5;
    var _text_width = field_w - 20;
    var _text_height = field_h - 10;

    gpu_set_scissor(_text_x, _text_y, _text_width, _text_height);

    // === ВИДИМАЯ ЧАСТЬ ТЕКСТА ===

    var _visible_count = 0;
    var _available_width = _text_width;

    for (var j = _field.scroll_start; j < string_length(_field.text); j++)
    {
        var _candidate = string_copy(_field.text, _field.scroll_start + 1, _visible_count + 1);

        if (string_width(_candidate) > _available_width) break;

        _visible_count++;
    }

    var _visible_text = string_copy(_field.text, _field.scroll_start + 1, _visible_count);

    // === ВЫДЕЛЕНИЕ ТЕКСТА ===

    var _selection_min = min(_field.selection_start, _field.selection_end);
    var _selection_max = max(_field.selection_start, _field.selection_end);

    if (_selection_min != _selection_max)
    {
        var _start_text = string_copy(
            _field.text,
            _field.scroll_start + 1,
            max(0, _selection_min - _field.scroll_start)
        );

        var _selected_text = string_copy(
            _field.text,
            _selection_min + 1,
            _selection_max - _selection_min
        );

        var _selection_x1 = _text_x + string_width(_start_text);
        var _selection_x2 = _selection_x1 + string_width(_selected_text);

        draw_set_color(make_color_rgb(70, 120, 180));
        draw_rectangle(
            _selection_x1,
            _field_y + 5,
            _selection_x2,
            _field_y + field_h - 5,
            false
        );
    }

    // === ТЕКСТ ===

    var _scroll_x = _field.scroll_x;
    var _text_draw_x = _text_x - _scroll_x;

    // === ВЫДЕЛЕНИЕ ТЕКСТА ===

    var _selection_min = min(_field.selection_start, _field.selection_end);
    var _selection_max = max(_field.selection_start, _field.selection_end);

    if (_selection_min != _selection_max)
    {
        var _start_text = string_copy(_field.text, 1, _selection_min);
        var _selected_text = string_copy(_field.text, _selection_min + 1, _selection_max - _selection_min);

        var _selection_x1 = _text_draw_x + string_width(_start_text);
        var _selection_x2 = _selection_x1 + string_width(_selected_text);

        draw_set_color(make_color_rgb(70, 120, 180));
        draw_rectangle(
            _selection_x1,
            _field_y + 5,
            _selection_x2,
            _field_y + field_h - 5,
            false
        );
    }

    // === ОТРИСОВКА ТЕКСТА ===

    draw_set_color(c_white);
    draw_text(_text_draw_x, _field_y + field_h * 0.5, _field.text);

    // === КУРСОР ===

    if (_field.active && ((current_time - _field.cursor_blink_time) mod 1000) < 500)
    {
        var _cursor_text = string_copy(_field.text, 1, _field.cursor);
        var _cursor_x = _text_draw_x + string_width(_cursor_text) + 1;

        draw_set_color(c_white);
        draw_line(_cursor_x, _field_y + 8, _cursor_x, _field_y + field_h - 8);

        // === ДИАГНОСТИКА ПРОКРУТКИ ===

        gpu_set_scissor(0, 0, display_get_width(), display_get_height());

        draw_set_color(c_yellow);
        draw_text(_text_x, _field_y + field_h + 5,
            "Cursor: " + string(_field.cursor)
            + " | Scroll X: " + string(_field.scroll_x)
        );

        draw_text(_text_x, _field_y + field_h + 20,
            "Beam: " + string(_cursor_x - _text_x)
            + " / " + string(_text_width)
        );

        gpu_set_scissor(_text_x, _text_y, _text_width, _text_height);
    }
	
	// восстанавливаем область отрисовки.
	gpu_set_scissor(0, 0, display_get_width(), display_get_height());
}