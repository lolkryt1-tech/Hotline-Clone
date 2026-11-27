
if (!instance_exists(objLevelEditor)) exit;

var _open = false;
var _active_tab = "BUILD";

with (objLevelEditor)
{
    _open = editor_ui.asset_browser.is_open;
    _active_tab = editor_ui.asset_browser.active_tab;
}

if (!_open) exit;

// === ЦВЕТА ===
var _color_border = make_color_rgb(75, 75, 82);
var _color_header = make_color_rgb(66, 66, 73);
var _color_close = make_color_rgb(58, 58, 64);
var _color_text = make_color_rgb(230, 230, 235);

// === ВНЕШНЯЯ РАМКА ===
draw_set_alpha(1);
draw_set_color(_color_border);
draw_rectangle(window_x - 1, window_y - 1, window_x + window_width + 1, window_y + window_height + 1, false);

// === ОСНОВА ОКНА ===
draw_set_color(make_color_rgb(30, 30, 34));
draw_rectangle(window_x, window_y, window_x + window_width, window_y + window_height, false);

// === ВЕРХНЯЯ ПОЛОСА ===
draw_set_color(_color_header);
draw_rectangle(window_x, window_y, window_x + window_width, window_y + header_height, false);

// === КНОПКА ЗАКРЫТИЯ ===
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

var _close_x = window_x + window_width - close_size;
var _close_hover = point_in_rectangle(
    _mouse_x, _mouse_y,
    _close_x, window_y,
    window_x + window_width, window_y + header_height
);

draw_set_color(_close_hover ? make_color_rgb(130, 65, 65) : _color_close);
draw_rectangle(_close_x, window_y, window_x + window_width, window_y + header_height, false);

draw_set_color(_color_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_close_x + close_size * 0.5, window_y + header_height * 0.5, "X");

// === ВКЛАДКИ ===
scrEditorAssetBrowserDrawTabs(_active_tab, _mouse_x, _mouse_y);

// === ГРАНИЦА ПОД ВКЛАДКАМИ ===
var _content_top = window_y + header_height + tabs_height;

draw_set_color(_color_border);
draw_line(window_x, _content_top, window_x + window_width, _content_top);

// === СОДЕРЖИМОЕ ВКЛАДОК ===
if (_active_tab == "BUILD")
{
    scrEditorAssetBrowserDrawBuild();
}
// === ПОДСКАЗКИ ПОВЕРХ ИНТЕРФЕЙСА ===
if (_active_tab == "BUILD" && build_type == "TILES")
{
    scrEditorAssetBrowserDrawToolTooltip();
}


// === ВОССТАНОВЛЕНИЕ НАСТРОЕК ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
