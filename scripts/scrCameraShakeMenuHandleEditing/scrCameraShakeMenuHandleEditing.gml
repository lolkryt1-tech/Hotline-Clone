/// @function scrCameraShakeMenuHandleEditing
/// @description Обрабатывает ввод символов, перемещение курсора и выделение текста.

function scrCameraShakeMenuHandleEditing()
{
    if (editing_slider == -1) return false;

    var _length = string_length(editing_value);
    var _shift = keyboard_check(vk_shift);
    var _control = keyboard_check(vk_control);

    // Ctrl + A — выделить всё.
    if (_control && keyboard_check_pressed(ord("A")))
    {
        editing_selection_start = 0;
        editing_selection_end = _length;
        editing_cursor = _length;
    }

    // Перемещение курсора.
    if (keyboard_check_pressed(vk_left))
    {
        if (!_shift && editing_selection_start != editing_selection_end)
        {
            editing_cursor = min(editing_selection_start, editing_selection_end);
        }
        else
        {
            editing_cursor = max(0, editing_cursor - 1);
        }

        editing_selection_start = _shift ? editing_selection_start : editing_cursor;
        editing_selection_end = editing_cursor;
    }

    if (keyboard_check_pressed(vk_right))
    {
        if (!_shift && editing_selection_start != editing_selection_end)
        {
            editing_cursor = max(editing_selection_start, editing_selection_end);
        }
        else
        {
            editing_cursor = min(_length, editing_cursor + 1);
        }

        editing_selection_start = _shift ? editing_selection_start : editing_cursor;
        editing_selection_end = editing_cursor;
    }

    // Home и End.
    if (keyboard_check_pressed(vk_home))
    {
        editing_cursor = 0;
        if (!_shift) editing_selection_start = editing_cursor;
        editing_selection_end = editing_cursor;
    }

    if (keyboard_check_pressed(vk_end))
    {
        editing_cursor = _length;
        if (!_shift) editing_selection_start = editing_cursor;
        editing_selection_end = editing_cursor;
    }

    // Удаление выделенного текста.
    var _sel_start = min(editing_selection_start, editing_selection_end);
    var _sel_end = max(editing_selection_start, editing_selection_end);
    var _has_selection = _sel_start != _sel_end;

    if (keyboard_check_pressed(vk_backspace) || keyboard_check_pressed(vk_delete))
    {
        if (_has_selection)
        {
            editing_value = string_delete(editing_value, _sel_start + 1, _sel_end - _sel_start);
            editing_cursor = _sel_start;
        }
        else if (keyboard_check_pressed(vk_backspace) && editing_cursor > 0)
        {
            editing_value = string_delete(editing_value, editing_cursor, 1);
            editing_cursor--;
        }
        else if (keyboard_check_pressed(vk_delete) && editing_cursor < _length)
        {
            editing_value = string_delete(editing_value, editing_cursor + 1, 1);
        }

        editing_selection_start = editing_cursor;
        editing_selection_end = editing_cursor;

        scrCameraShakeMenuApplyEditingValue();
    }

    // Ввод цифр и десятичной точки.
    var _input = keyboard_string;
    keyboard_string = "";

    for (var i = 1; i <= string_length(_input); i++)
    {
        var _char = string_char_at(_input, i);

        var _is_digit = string_digits(_char) == _char;
        var _is_dot = _char == "." || _char == ",";

        if (!_is_digit && !_is_dot) continue;

        _sel_start = min(editing_selection_start, editing_selection_end);
        _sel_end = max(editing_selection_start, editing_selection_end);
        _has_selection = _sel_start != _sel_end;

        // Разрешаем только одну десятичную точку.
        if (_is_dot)
        {
            var _before = string_copy(editing_value, 1, _sel_start);
            var _after = string_copy(editing_value, _sel_end + 1, string_length(editing_value));

            if (string_pos(".", _before + _after) > 0) continue;

            _char = ".";
        }

        if (_has_selection)
        {
            editing_value = string_delete(editing_value, _sel_start + 1, _sel_end - _sel_start);
            editing_cursor = _sel_start;
        }

        editing_value = string_insert(_char, editing_value, editing_cursor + 1);
        editing_cursor++;

        editing_selection_start = editing_cursor;
        editing_selection_end = editing_cursor;

        scrCameraShakeMenuApplyEditingValue();
    }

    // Esc — отменить редактирование.
    if (keyboard_check_pressed(vk_escape))
    {
        editing_value = editing_original_value;
        editing_slider = -1;
        editing_mouse_select = false;
        keyboard_string = "";
        return true;
    }

    return true;
}