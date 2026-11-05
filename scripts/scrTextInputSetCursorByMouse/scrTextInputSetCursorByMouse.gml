/// @function scrTextInputSetCursorByMouse
/// @description Определяет позицию текстового курсора по координате мыши.
/// @param {struct} _field Текстовое поле.
/// @param {real} _mx Координата мыши по горизонтали.
/// @param {real} _text_x Начало отображения текста.
/// @returns {real} Индекс позиции курсора.

function scrTextInputSetCursorByMouse(_field, _mx, _text_x)
{
    var _text = _field.text;
    var _local_x = max(0, _mx - _text_x);
    var _visible_text = string_copy(_text, _field.scroll_start + 1, string_length(_text));

    var _cursor = _field.scroll_start;
    var _width = 0;

    for (var i = 1; i <= string_length(_visible_text); i++)
    {
        var _char_width = string_width(string_copy(_visible_text, 1, i)) - _width;

        if (_local_x < _width + _char_width * 0.5) break;

        _width += _char_width;
        _cursor++;
    }

    _field.cursor_blink_time = current_time;

    return _cursor;
}