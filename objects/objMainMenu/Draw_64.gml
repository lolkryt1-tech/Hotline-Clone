// Если открыты настройки, то блокируем
if (!menu_active) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_font(fntMainMenu);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _start_y = _gui_h * 0.55; 
var _line_height = 60;        

for (var i = 0; i < array_length(menu_items); i++) {
    var _y = _start_y + (_line_height * i);
    var _is_selected = (i == selected_index);
    
    // --- ПУЛЬСАЦИЯ ---
    var _scale = 1.0;
    if (_is_selected) {
        // Синус выдает от -1 до 1. 
        // Превращаем это в пульсацию от 1.0 до 1.15.
        var _pulse = (sin(pulse_time) + 1) * 0.5; // от 0 до 1
        _scale = 1.0 + (_pulse * 0.15); // от 1.0 до 1.15
    }
    
    var _color = _is_selected ? make_color_rgb(255, 50, 150) : c_white; 
    
    // Черная обводка (тень)
    draw_set_color(c_black);
    // Умножаем масштаб для обводки тоже, чтобы она не отставала
    draw_text_transformed(_gui_w * 0.5 + 2, _y + 2, menu_items[i], _scale, _scale, 0);
    
    // Сама кнопка
    draw_set_color(_color);
    draw_text_transformed(_gui_w * 0.5, _y, menu_items[i], _scale, _scale, 0);
}

// Сброс
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// --- ЗАТЕМНЕНИЕ (ПОВЕРХ ВСЕГО) ---
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}