/// @function scrDrawTextEllipsis
/// @description Рисует текст, обрезая его и добавляя "..." если не влезает в ширину.
function scrDrawTextEllipsis(_x, _y, _text, _max_width)
{
    var _full_width = string_width(_text);
    if (_full_width <= _max_width) {
        draw_text(_x, _y, _text);
        return;
    }
    
    var _ellipsis_width = string_width("...");
    var _current_text = "";
    
    for (var i = 1; i <= string_length(_text); i++) {
        var _char = string_char_at(_text, i);
        if (string_width(_current_text + _char) + _ellipsis_width > _max_width) {
            break;
        }
        _current_text += _char;
    }
    
    draw_text(_x, _y, _current_text + "...");
}