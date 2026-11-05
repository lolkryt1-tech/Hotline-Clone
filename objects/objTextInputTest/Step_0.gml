var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _pressed = mouse_check_button_pressed(mb_left);
var _held = mouse_check_button(mb_left);

// === НАЧАЛО ВЫДЕЛЕНИЯ ===

if (_pressed)
{
    var _found = -1;

    for (var i = 0; i < array_length(text_fields); i++)
    {
        var _field_y = field_y + i * (field_h + field_gap);

        if (point_in_rectangle(
            _mx, _my,
            field_x, _field_y,
            field_x + field_w, _field_y + field_h
        ))
        {
            _found = i;
            break;
        }
    }

    active_field = _found;
    scrTextInputSetFocus(text_fields, active_field);

    if (active_field >= 0)
    {
        var _field = text_fields[active_field];

        var _cursor = scrTextInputSetCursorByMouse(
            _field,
            _mx,
            field_x + 10
        );

        _field.cursor = _cursor;
        _field.selection_start = _cursor;
        _field.selection_end = _cursor;
        _field.dragging_selection = true;
    }
}


// === ПРОДОЛЖЕНИЕ ВЫДЕЛЕНИЯ ===

if (active_field >= 0)
{
    var _field = text_fields[active_field];

    if (_field.dragging_selection && _held)
    {
        var _text_x = field_x + 10;
        var _text_width = field_w - 20;

        // Автоматическая прокрутка за границами поля.
        scrTextInputUpdateDragScroll(_field, _mx, _text_x, _text_width);

        // Пересчитываем позицию курсора.
        _field.cursor = scrTextInputSetCursorByMouse(_field, _mx, _text_x);

        // Ограничиваем позицию курсора длиной текста.
        _field.cursor = clamp(_field.cursor, 0, string_length(_field.text));

        _field.selection_end = _field.cursor;
    }

    if (_field.dragging_selection && !_held)
    {
        _field.dragging_selection = false;
    }
}

// === ОБРАБОТКА ВВОДА ===

scrTextInputUpdate(text_fields, active_field);