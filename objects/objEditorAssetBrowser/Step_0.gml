if (!instance_exists(objLevelEditor)) exit;

var _browser = objLevelEditor.editor_ui.asset_browser;

if (!_browser.is_open)
{
    is_dragging = false;
    layers_scroll_dragging = false;
    tileset_pan_dragging = false;

    hover_tile_x = -1;
    hover_tile_y = -1;
	
	tooltip_target = "";
	tooltip_timer = 0;
	tooltip_alpha = 0;
	
    exit;
}

// === ПОЛУЧЕНИЕ ВВОДА ===
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

var _left_pressed = mouse_check_button_pressed(mb_left);
var _left_down = mouse_check_button(mb_left);
var _left_released = mouse_check_button_released(mb_left);

var _middle_pressed = mouse_check_button_pressed(mb_middle);
var _middle_down = mouse_check_button(mb_middle);
var _middle_released = mouse_check_button_released(mb_middle);

var _wheel = mouse_wheel_up() - mouse_wheel_down();

// === ОКНО ===
if (scrEditorAssetBrowserHandleWindow(
    _browser,
    _mouse_x,
    _mouse_y,
    _left_pressed,
    _left_down,
    _left_released
))
{
    exit;
}

// === ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК ===
var _tabs_y = window_y + header_height;
var _tab_width = window_width / 5;

if (_left_pressed
&& _mouse_x >= window_x && _mouse_x <= window_x + window_width
&& _mouse_y >= _tabs_y && _mouse_y <= _tabs_y + tabs_height)
{
    var _tab_index = clamp(
        floor((_mouse_x - window_x) / _tab_width),
        0,
        4
    );

    var _tabs = ["BUILD", "FURNITURE", "ENEMY", "GAMEPLAY", "LEVEL"];

    _browser.active_tab = _tabs[_tab_index];

    tileset_dropdown_open = false;
    layers_scroll_dragging = false;
    tileset_pan_dragging = false;
}

// === BUILD ===
if (_browser.active_tab == "BUILD")
{
	// === ВЫБОР ИНСТРУМЕНТА ===
    if (build_type == "TILES")
    {
        var _workspace = instance_find(objEditorWorkspace, 0);

        if (_workspace != noone)
        {
            var _tool_size = 22;
            var _tool_gap = 5;
            var _tool_x = window_x + 12;
            var _tool_y = window_y + header_height + tabs_height + 8;

            var _pencil_x = _tool_x;
            var _rectangle_x = _pencil_x + _tool_size + _tool_gap;
			
			// === НАВЕДЕНИЕ ДЛЯ ПОДСКАЗОК ===
			var _new_tooltip_target = "";

			if (point_in_rectangle(
			    _mouse_x, _mouse_y,
			    _pencil_x, _tool_y,
			    _pencil_x + _tool_size, _tool_y + _tool_size
			))
			{
			    _new_tooltip_target = "PENCIL";
			}
			else if (point_in_rectangle(
			    _mouse_x, _mouse_y,
			    _rectangle_x, _tool_y,
			    _rectangle_x + _tool_size, _tool_y + _tool_size
			))
			{
			    _new_tooltip_target = "RECTANGLE";
			}

			if (_new_tooltip_target != tooltip_target)
			{
			    tooltip_target = _new_tooltip_target;
			    tooltip_timer = 0;
			    tooltip_alpha = 0;
			}
			else if (tooltip_target != "")
			{
			    tooltip_timer = min(tooltip_timer + 1, tooltip_delay);

			    if (tooltip_timer >= tooltip_delay)
			        tooltip_alpha = min(tooltip_alpha + 0.09, 1);
			}
			else
			{
			    tooltip_alpha = max(tooltip_alpha - 0.09, 0);
			}
			

            // Выбор мышью
            if (_left_pressed)
            {
                if (point_in_rectangle(
                    _mouse_x, _mouse_y,
                    _pencil_x, _tool_y,
                    _pencil_x + _tool_size, _tool_y + _tool_size
                ))
                {
                    _workspace.active_tool = "PENCIL";
                }
                else if (point_in_rectangle(
                    _mouse_x, _mouse_y,
                    _rectangle_x, _tool_y,
                    _rectangle_x + _tool_size, _tool_y + _tool_size
                ))
                {
                    _workspace.active_tool = "RECTANGLE";
                }
            }

            // Выбор клавишами
			if (keyboard_check_pressed(ord("D")))
			    _workspace.active_tool = "PENCIL";

			if (keyboard_check_pressed(ord("R")))
			    _workspace.active_tool = "RECTANGLE";
        }
    }
	
	
    var _margin = 12;
    var _content_top = window_y + header_height + tabs_height;

    // === TYPE (TILES / WALLS) ===
    var _type_y = _content_top + 8;
    var _button_w = 58;
    var _button_h = 22;

    var _tiles_x = window_x + window_width - _button_w * 2 - 20;
    var _walls_x = window_x + window_width - _button_w - _margin;

    if (_left_pressed
    && _mouse_y >= _type_y && _mouse_y <= _type_y + _button_h)
    {
        if (_mouse_x >= _tiles_x && _mouse_x <= _tiles_x + _button_w)
        {
            build_type = "TILES";
            tileset_dropdown_open = false;
        }
        else if (_mouse_x >= _walls_x && _mouse_x <= _walls_x + _button_w)
        {
            build_type = "WALLS";
            tileset_dropdown_open = false;
            tileset_pan_dragging = false;
        }
    }

    // === TILESET ===
    scrEditorAssetBrowserHandleTileset(
        _browser,
        _mouse_x,
        _mouse_y,
        _left_pressed,
        _middle_pressed,
        _middle_down,
        _middle_released,
        _wheel
    );

    // === TILE LAYERS ===
    scrEditorAssetBrowserHandleLayers(
        _browser,
        _mouse_x,
        _mouse_y,
        _left_pressed,
        _left_down,
        _left_released,
        _wheel
    );
}

// === ГРАНИЦЫ ОКНА ===
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

window_x = clamp(window_x, 0, max(_gui_w - window_width, 0));
window_y = clamp(window_y, 0, max(_gui_h - window_height, 0));