// =========================================================================
// 1. БЛОК ОТРИСОВКИ КОМБО С ЕСТЕСТВЕННЫМ РАЗМЕРОМ (Слева сверху)
// =========================================================================
if (global.combo_current > 1)
{
    var _old_font  = draw_get_font();
    var _old_color = draw_get_color();
    
    draw_set_font(fntCombo);
    var _text = string(global.combo_current) + "X";
    
    // Координаты отрисовки текста
    var _tx = 60;
    var _ty = 40;
    
    // --- НАСТРОЙКА ЦВЕТА С МЯГКИМ ОСВЕТЛЕНИЕМ ---
    var _base_purple = make_color_rgb(180, 50, 250); 
    var _current_color = merge_color(_base_purple, c_white, combo_flash * 0.4);
    
    // 🔥 ИСПРАВЛЕНО: Убран коэффициент 1.3, берем чистый combo_scale (в покое равен 1.0)
    var _final_scale = combo_scale;
    
    // --- ПЛОТНАЯ ОБВОДКА В 2 ПИКСЕЛЯ ДЛЯ ТВОЕГО ШРИФТА ---
    var _text_border_color = make_color_rgb(40, 40, 40); 
    
    // Плотное смещение по осям (2 пикселя)
    draw_text_transformed_color(_tx - 2, _ty,     _text, _final_scale, _final_scale, 0, _text_border_color, _text_border_color, _text_border_color, _text_border_color, 1);
    draw_text_transformed_color(_tx + 2, _ty,     _text, _final_scale, _final_scale, 0, _text_border_color, _text_border_color, _text_border_color, _text_border_color, 1);
    draw_text_transformed_color(_tx,     _ty - 2, _text, _final_scale, _final_scale, 0, _text_border_color, _text_border_color, _text_border_color, _text_border_color, 1);
    draw_text_transformed_color(_tx,     _ty + 2, _text, _final_scale, _final_scale, 0, _text_border_color, _text_border_color, _text_border_color, _text_border_color, 1);
    
    // Закрываем дыры по диагоналям (1-2 пикселя)
    draw_text_transformed_color(_tx - 1, _ty - 1, _text, _final_scale, _final_scale, 0, _text_border_color, _text_border_color, _text_border_color, _text_border_color, 1);
    draw_text_transformed_color(_tx + 1, _ty - 1, _text, _final_scale, _final_scale, 0, _text_border_color, _text_border_color, _text_border_color, _text_border_color, 1);
    draw_text_transformed_color(_tx - 1, _ty + 1, _text, _final_scale, _final_scale, 0, _text_border_color, _text_border_color, _text_border_color, _text_border_color, 1);
    draw_text_transformed_color(_tx + 1, _ty + 1, _text, _final_scale, _final_scale, 0, _text_border_color, _text_border_color, _text_border_color, _text_border_color, 1);
    
    // Рисуем основной фиолетовый текст поверх обводки
    draw_text_transformed_color(_tx, _ty, _text, _final_scale, _final_scale, 0, _current_color, _current_color, _current_color, _current_color, 1);
    
    // --- УВЕЛИЧЕННАЯ ПОЛОСКА С ТЁМНОЙ ОБВОДКОЙ ---
    var _bar_x = 35;
    var _bar_y = 140;        
    var _bar_width = 140;   
    var _bar_height = 12;   
    
    var _fill = (global.combo_timer / global.combo_time_max) * _bar_width;
    var _border = 2; 
    var _border_color = make_color_rgb(40, 40, 40); 
    
    draw_rectangle_color(_bar_x - _border, _bar_y - _border, _bar_x + _bar_width + _border, _bar_y + _bar_height + _border, _border_color, _border_color, _border_color, _border_color, false);
    draw_rectangle_color(_bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_height, c_black, c_black, c_black, c_black, false);
    
    var _c1 = merge_color(c_orange, c_white, combo_flash * 0.2);
    var _c2 = merge_color(c_red, c_white, combo_flash * 0.2);
    draw_rectangle_color(_bar_x, _bar_y, _bar_x + _fill, _bar_y + _bar_height, _c1, _c2, _c2, _c1, false);

    draw_set_font(_old_font);
    draw_set_color(_old_color);
}


// =========================================================================
// 2. БЛОК ОТРИСОВКИ СТАБИЛЬНОГО ТАЙМЕРА (Посимвольный вывод без шатания)
// =========================================================================
var _old_t_font   = draw_get_font();
var _old_t_color  = draw_get_color();
var _old_t_halign = draw_get_halign();

// Рассчитываем время
var _total_seconds = global.level_time / 60; 
var _minutes = floor(_total_seconds / 60);
var _seconds = floor(_total_seconds mod 60);
var _milliseconds = floor((_total_seconds mod 1) * 100); 

var _str_mins = (_minutes < 10) ? "0" + string(_minutes) : string(_minutes);
var _str_secs = (_seconds < 10) ? "0" + string(_seconds) : string(_seconds);
var _str_ms   = (_milliseconds < 10) ? "0" + string(_milliseconds) : string(_milliseconds);

var _timer_text = _str_mins + ":" + _str_secs + "." + _str_ms;

// Включаем нужный шрифт
draw_set_font(fntTimer); 
draw_set_halign(fa_left); 

var _timer_scale = 1; 
var _timer_y = 35;

var _char_w = string_width("0") * _timer_scale;
var _sep_w  = string_width(":") * _timer_scale;

// Начальная координата X для таймера (считаем обратно от правого края)
var _total_width = (6 * _char_w) + (2 * _sep_w);
var _start_x = display_get_gui_width() - _total_width - 40; 

// Функция-помощник для рисования символов с обводкой в конкретном X
var _draw_stable_text = function(_x, _y, _text, _scale) {
    draw_set_color(c_black);
    // Обводка 1 пиксель по кругу
    draw_text_transformed(_x - 1, _y,     _text, _scale, _scale, 0);
    draw_text_transformed(_x + 1, _y,     _text, _scale, _scale, 0);
    draw_text_transformed(_x,     _y - 1, _text, _scale, _scale, 0);
    draw_text_transformed(_x,     _y + 1, _text, _scale, _scale, 0);
    
    // Основной белый text
    draw_set_color(c_white);
    draw_text_transformed(_x, _y, _text, _scale, _scale, 0);
};

// --- ПОШАГОВАЯ ОТРИСОВКА СЕТКИ ТАЙМЕРА ---
var _cx = _start_x;

// 1. Рисуем Минуты (2 цифры посимвольно)
_draw_stable_text(_cx, _timer_y, string_char_at(_str_mins, 1), _timer_scale); _cx += _char_w;
_draw_stable_text(_cx, _timer_y, string_char_at(_str_mins, 2), _timer_scale); _cx += _char_w;

// 2. Рисуем Двоеточие
_draw_stable_text(_cx, _timer_y, ":", _timer_scale); _cx += _sep_w;

// 3. Рисуем Секунды (2 цифры посимвольно)
_draw_stable_text(_cx, _timer_y, string_char_at(_str_secs, 1), _timer_scale); _cx += _char_w;
_draw_stable_text(_cx, _timer_y, string_char_at(_str_secs, 2), _timer_scale); _cx += _char_w;

// 4. Рисуем Точку
_draw_stable_text(_cx, _timer_y, ".", _timer_scale); _cx += _sep_w;

// 5. Рисуем Миллисекунды (2 цифры посимвольно)
_draw_stable_text(_cx, _timer_y, string_char_at(_str_ms, 1), _timer_scale); _cx += _char_w;
_draw_stable_text(_cx, _timer_y, string_char_at(_str_ms, 2), _timer_scale); _cx += _char_w;

// Восстанавливаем состояние холста
draw_set_font(_old_t_font);
draw_set_color(_old_t_color);
draw_set_halign(_old_t_halign);
