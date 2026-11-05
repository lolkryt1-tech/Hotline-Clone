
/// @function scrTextInputUpdateScroll
/// @description Поддерживает видимость текстового курсора при горизонтальной прокрутке.
/// @param {struct} _field Текстовое поле.
/// @param {real} _width Доступная ширина текста.

function scrTextInputUpdateScroll(_field, _width)
{
    var _text = _field.text;
    var _cursor = clamp(_field.cursor, 0, string_length(_text));

    var _text_width = string_width(_text);
    var _caret_width = 1;
    var _padding = 2;

    // Если строка помещается целиком, прокрутка не нужна.
    if (_text_width + _caret_width + _padding <= _width)
    {
        _field.scroll_x = 0;
        return;
    }

    // Максимальное допустимое смещение.
    var _max_scroll = max(0, _text_width + _caret_width + _padding - _width);
    _field.scroll_x = clamp(_field.scroll_x, 0, _max_scroll);

    // Измеряем положение курсора в пикселях.
    var _cursor_text = string_copy(_text, 1, _cursor);
    var _cursor_x = string_width(_cursor_text);
    var _cursor_right = _cursor_x + _caret_width;

    // Курсор вышел за левую границу.
    if (_cursor_x - _field.scroll_x < _padding)
    {
        _field.scroll_x = max(0, _cursor_x - _padding);
    }
    // Курсор вышел за правую границу.
    else if (_cursor_right - _field.scroll_x > _width - _padding)
    {
        _field.scroll_x = min(_max_scroll, _cursor_right - (_width - _padding));
    }
}
