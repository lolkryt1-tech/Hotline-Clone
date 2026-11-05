// 1. СОХРАНЯЕМ ПРЕДЫДУЩИЕ НАСТРОЙКИ ТЕКСТА
var _old_font  = draw_get_font();
var _old_halign = draw_get_halign();
var _old_valign = draw_get_valign();

// 2. ЗАДАЕМ НАШИ НАСТРОЙКИ
draw_set_font(font_to_use);
draw_set_halign(fa_left); 
draw_set_valign(fa_middle);

var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();
var _total_width = string_width(text_string);

var _start_x = (_gui_width / 2) - (_total_width / 2); 
var _draw_y = _gui_height / 2; 

var _current_offset_x = -60;

for (var i = 1; i <= text_length; i++)
{
    var _char = string_char_at(text_string, i);
    var _char_width = string_width(_char) + 5;
    var _arr_idx = i - 1;
    
    if (letter_alpha[_arr_idx] > 0)
    {
        var _letter_x = _start_x + _current_offset_x + (_char_width / 2);
        
        // Перемножаем локальную альфу буквы на глобальную альфу затухания
        var _final_alpha = letter_alpha[_arr_idx] * global_alpha;
        
        draw_text_transformed_color(
            _letter_x, 
            _draw_y, 
            _char, 
            letter_scale[_arr_idx], 
            letter_scale[_arr_idx], 
            0, 
            c_white, c_white, c_white, c_white, 
            _final_alpha
        );
    }
    
    _current_offset_x += _char_width;
}

// 3. ВОССТАНАВЛИВАЕМ ПРЕДЫДУЩИЕ НАСТРОЙКИ ТЕКСТА
draw_set_font(_old_font);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);
