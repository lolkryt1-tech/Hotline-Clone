/// @function scrTextInputUpdate
/// @description Обрабатывает ввод текста, удаление и замену выделенного фрагмента.
/// @param {array} _fields Массив текстовых полей.
/// @param {real} _index Индекс активного поля.
/// @returns {bool} True, если поле активно.

function scrTextInputUpdate(_fields, _index)
{
    if (_index < 0 || _index >= array_length(_fields)) return false;

    var _field = _fields[_index];
    if (!_field.active) return false;

    var _old_text = _field.text;
    var _old_cursor = _field.cursor;

    var _text = _field.text;
    var _cursor = _field.cursor;

    var _selection_min = min(_field.selection_start, _field.selection_end);
    var _selection_max = max(_field.selection_start, _field.selection_end);
    var _has_selection = (_selection_min != _selection_max);
	
	
	
	// === ВЫДЕЛЕНИЕ ВСЕГО ТЕКСТА ===

	if (keyboard_check(vk_control) && keyboard_check_pressed(ord("A")))
	{
	    _field.selection_start = 0;
	    _field.selection_end = string_length(_text);
	    _field.selection_anchor = 0;

	    _cursor = string_length(_text);
	    _field.cursor = _cursor;
	    _field.cursor_blink_time = current_time;

	    keyboard_string = "";
	    return true;
	}

    // === ОБРАБОТКА УДАЛЕНИЯ ===

    var _backspace = scrTextInputKeyRepeat(
        keyboard_check_pressed(vk_backspace),
        keyboard_check(vk_backspace),
        key_repeat_timers,
        "backspace",
        key_repeat_delay,
        key_repeat_interval
    );

    var _delete = scrTextInputKeyRepeat(
        keyboard_check_pressed(vk_delete),
        keyboard_check(vk_delete),
        key_repeat_timers,
        "delete",
        key_repeat_delay,
        key_repeat_interval
    );

    // Удаляем выделенный фрагмент.
    if (_has_selection && (_backspace || _delete))
    {
        _text = string_delete(_text, _selection_min + 1, _selection_max - _selection_min);
        _cursor = _selection_min;
        _has_selection = false;
    }
    else
    {
        // Удаление символа слева от курсора.
        if (_backspace && _cursor > 0)
        {
            _text = string_delete(_text, _cursor, 1);
            _cursor--;
        }

        // Удаление символа справа от курсора.
        if (_delete && _cursor < string_length(_text))
        {
            _text = string_delete(_text, _cursor + 1, 1);
        }
    }
	
	
	// === БУФЕР ОБМЕНА: КОПИРОВАНИЕ И ВЫРЕЗАНИЕ ===

	var _ctrl = keyboard_check(vk_control);

	if (_ctrl && keyboard_check_pressed(ord("C")) && _has_selection)
	{
	    var _copy_text = string_copy(
	        _text,
	        _selection_min + 1,
	        _selection_max - _selection_min
	    );

	    clipboard_set_text(_copy_text);
	    keyboard_string = "";
	    return true;
	}

	if (_ctrl && keyboard_check_pressed(ord("X")) && _has_selection)
	{
	    var _cut_text = string_copy(
	        _text,
	        _selection_min + 1,
	        _selection_max - _selection_min
	    );

	    clipboard_set_text(_cut_text);

	    _text = string_delete(
	        _text,
	        _selection_min + 1,
	        _selection_max - _selection_min
	    );

	    _cursor = _selection_min;
	    _field.text = _text;
	    _field.cursor = _cursor;
	    _field.selection_start = _cursor;
	    _field.selection_end = _cursor;
	    _field.cursor_blink_time = current_time;

	    keyboard_string = "";
	    return true;
	}
	

   // === ПЕРЕМЕЩЕНИЕ КУРСОРА ===

	var _left = scrTextInputKeyRepeat(
	    keyboard_check_pressed(vk_left),
	    keyboard_check(vk_left),
	    key_repeat_timers,
	    "left",
	    key_repeat_delay,
	    key_repeat_interval
	);

	var _right = scrTextInputKeyRepeat(
	    keyboard_check_pressed(vk_right),
	    keyboard_check(vk_right),
	    key_repeat_timers,
	    "right",
	    key_repeat_delay,
	    key_repeat_interval
	);

	var _shift = keyboard_check(vk_shift);

	if (_left || _right)
	{
	    if (_shift)
	    {
	        // Запоминаем начальную точку выделения.
	        if (!_has_selection)
	        {
	            _field.selection_anchor = _cursor;
	        }

	        if (_left) _cursor = max(0, _cursor - 1);
	        if (_right) _cursor = min(string_length(_text), _cursor + 1);

	        _field.selection_start = _field.selection_anchor;
	        _field.selection_end = _cursor;
	        _has_selection = (_field.selection_start != _field.selection_end);
	    }
	    else
	    {
	        // Без Shift перемещаемся к краю выделения.
	        if (_has_selection)
	        {
	            _cursor = _left ? _selection_min : _selection_max;
	        }
	        else
	        {
	            if (_left) _cursor = max(0, _cursor - 1);
	            if (_right) _cursor = min(string_length(_text), _cursor + 1);
	        }

	        _field.selection_start = _cursor;
	        _field.selection_end = _cursor;
	        _has_selection = false;
	    }
	}

    // === ВВОД НОВЫХ СИМВОЛОВ ===

    // === ВСТАВКА ИЗ БУФЕРА ОБМЕНА ===
	var _input = keyboard_string;

	if (_ctrl && keyboard_check_pressed(ord("V")))
	{
	    _input = clipboard_get_text();

	    _input = string_replace_all(_input, "\r", " ");
	    _input = string_replace_all(_input, "\n", " ");
	    _input = string_replace_all(_input, "\t", " ");

	    // Убираем повторяющиеся пробелы.
	    while (string_pos("  ", _input) > 0)
	    {
	        _input = string_replace_all(_input, "  ", " ");
	    }
	}

	keyboard_string = "";

    if (string_length(_input) > 0 && _has_selection)
    {
        _text = string_delete(_text, _selection_min + 1, _selection_max - _selection_min);
        _cursor = _selection_min;
        _has_selection = false;
    }

    for (var i = 1; i <= string_length(_input); i++)
    {
        var _char = string_char_at(_input, i);
        var _valid = true;

        switch (_field.input_type)
        {
            case "number":
                _valid = (ord(_char) >= 48 && ord(_char) <= 57);
                break;

            case "decimal":
                _valid = (ord(_char) >= 48 && ord(_char) <= 57);

                if (_char == "." || _char == ",")
                {
                    _valid = string_pos(".", _text) == 0 && string_pos(",", _text) == 0;
                    _char = ".";
                }
                break;
        }

        if (!_valid) continue;
        if (string_length(_text) >= _field.max_length) continue;

        _text = string_insert(_char, _text, _cursor + 1);
        _cursor++;
    }

	// === СОХРАНЕНИЕ СОСТОЯНИЯ ===

	_field.text = _text;
	_field.cursor = _cursor;

	// Сохраняем выделение, пока оно не было обработано клавиатурой.
	if (_has_selection && !_field.dragging_selection)
	{
	   var _selection_consumed = _backspace || _delete || ((_left || _right) && !keyboard_check(vk_shift)) || string_length(_input) > 0;

	    if (_selection_consumed)
	    {
	        _field.selection_start = _cursor;
	        _field.selection_end = _cursor;
	    }
	}
	else if (!_field.dragging_selection)
	{
	    _field.selection_start = _cursor;
	    _field.selection_end = _cursor;
	}

	// Сбрасываем мигание при изменении текста или позиции курсора.
	if (_field.text != _old_text || _field.cursor != _old_cursor)
	{
	    _field.cursor_blink_time = current_time;
	}
	
	// Обновляем прокрутку после перемещения курсора.
	scrTextInputUpdateScroll(_field, field_w - 20);

    return true;
}