// === НАСТРОЙКА ОТРИСОВКИ ===

draw_set_alpha(1);
draw_set_font(gui_font);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// === ОКНО ===

draw_set_color(make_color_rgb(20, 20, 24));
draw_rectangle(x, y, x + window_w, y + window_h, false);

draw_set_color(make_color_rgb(75, 75, 85));
draw_rectangle(x, y, x + window_w, y + window_h, true);

// === ЗАГОЛОВОК ===

draw_set_color(make_color_rgb(45, 45, 55));
draw_rectangle(x, y, x + window_w, y + title_h, false);

draw_set_color(make_color_rgb(100, 100, 115));
draw_rectangle(x, y + title_h - 1, x + window_w, y + title_h, false);

draw_set_color(gui_text_color);
draw_text(x + 10, y + title_h * 0.5, "CAMERA SHAKE");


// === КНОПКА ЗАКРЫТИЯ ===

var _close_x = x + window_w - title_h;
var _close_y = y;

var _close_hover = point_in_rectangle(
    device_mouse_x_to_gui(0),
    device_mouse_y_to_gui(0),
    _close_x, _close_y,
    _close_x + title_h, _close_y + title_h
);

draw_set_color(_close_hover
    ? make_color_rgb(130, 55, 55)
    : make_color_rgb(45, 45, 55));

draw_rectangle(_close_x, _close_y, _close_x + title_h, _close_y + title_h, false);


// === КНОПКА ЗАКРЫТИЯ ===
var _close_x = x + window_w - title_h;
var _close_y = y;

var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

var _close_hover = point_in_rectangle(
    _mouse_x, _mouse_y,
    _close_x, _close_y,
    _close_x + title_h, _close_y + title_h
);

// Обводка кнопки
draw_set_color(_close_hover
    ? make_color_rgb(150, 90, 90)
    : make_color_rgb(100, 100, 115));

draw_rectangle(_close_x, _close_y, _close_x + title_h, _close_y + title_h, true);

// Крестик
draw_set_color(c_white);
draw_set_alpha(0.8);

var _cross_size = 5;
var _cross_cx = _close_x + title_h * 0.5;
var _cross_cy = _close_y + title_h * 0.5;

draw_line(_cross_cx - _cross_size, _cross_cy - _cross_size, _cross_cx + _cross_size, _cross_cy + _cross_size);
draw_line(_cross_cx + _cross_size, _cross_cy - _cross_size, _cross_cx - _cross_size, _cross_cy + _cross_size);

draw_set_alpha(1);


// === ЭЛЕМЕНТЫ ИНТЕРФЕЙСА ===

scrCameraShakeMenuDrawPreset();
scrCameraShakeMenuDrawEffects();
scrCameraShakeMenuDrawSections();
scrCameraShakeMenuDrawSliders();
scrCameraShakeMenuDrawActionButtons();

// === ВЫПАДАЮЩИЙ СПИСОК ===

if (preset_dropdown_open)
{
    scrCameraShakeMenuDrawDropdown();
}

// === ВОССТАНОВЛЕНИЕ НАСТРОЕК ОТРИСОВКИ ===

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);