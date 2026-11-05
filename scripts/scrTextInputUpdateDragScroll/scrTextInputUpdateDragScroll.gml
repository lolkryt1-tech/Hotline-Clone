/// @function scrTextInputUpdateDragScroll
/// @description Прокручивает текстовое поле при выделении за его границами.
/// @param {struct} _field Текстовое поле.
/// @param {real} _mx Координата мыши.
/// @param {real} _text_x Начало отображения текста.
/// @param {real} _width Доступная ширина текста.

function scrTextInputUpdateDragScroll(_field, _mx, _text_x, _width)
{
    var _text = _field.text;
    var _text_length = string_length(_text);

    if (_mx < _text_x)
    {
        var _distance = _text_x - _mx;
        var _speed = max(1, ceil(_distance / 8));

        _field.scroll_start = max(0, _field.scroll_start - _speed);
    }

    if (_mx > _text_x + _width)
    {
        var _distance = _mx - (_text_x + _width);
        var _speed = max(1, ceil(_distance / 8));

        _field.scroll_start = min(_text_length - 1, _field.scroll_start + _speed);
    }

    // Не позволяем прокрутить текст дальше его последнего символа.
    while (_field.scroll_start > 0)
    {
        var _visible_text = string_copy(
            _text,
            _field.scroll_start + 1,
            _text_length
        );

        if (string_width(_visible_text) > _width) break;

        _field.scroll_start--;
    }
}