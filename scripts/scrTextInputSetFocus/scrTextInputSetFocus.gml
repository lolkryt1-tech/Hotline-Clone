/// @function scrTextInputSetFocus
/// @description Переключает фокус на выбранное текстовое поле.
/// @param {array} _fields Массив текстовых полей.
/// @param {real} _index Индекс активируемого поля.

function scrTextInputSetFocus(_fields, _index)
{
    for (var i = 0; i < array_length(_fields); i++)
    {
        _fields[i].active = (i == _index);
    }

    if (_index >= 0 && _index < array_length(_fields))
    {
        _fields[_index].cursor = string_length(_fields[_index].text);
        _fields[_index].selection_start = _fields[_index].cursor;
        _fields[_index].selection_end = _fields[_index].cursor;
    }

    keyboard_string = "";
}