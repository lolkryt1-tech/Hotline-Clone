/// @function scrEditorAssetBrowserHandleWindow()
/// @description Обрабатывает закрытие и перемещение окна Asset Browser.

function scrEditorAssetBrowserHandleWindow(
    _browser,
    _mouse_x,
    _mouse_y,
    _left_pressed,
    _left_down,
    _left_released
)
{
    // === ЗАКРЫТИЕ ОКНА ===
    var _close_x = window_x + window_width - close_size;

    if (_left_pressed
    && _mouse_x >= _close_x && _mouse_x <= window_x + window_width
    && _mouse_y >= window_y && _mouse_y <= window_y + header_height)
    {
        _browser.is_open = false;

        is_dragging = false;
        tileset_pan_dragging = false;
        layers_scroll_dragging = false;

        return true;
    }

    // === НАЧАЛО ПЕРЕТАСКИВАНИЯ ОКНА ===
    if (_left_pressed
    && _mouse_x >= window_x && _mouse_x <= _close_x
    && _mouse_y >= window_y && _mouse_y <= window_y + header_height)
    {
        is_dragging = true;

        drag_offset_x = _mouse_x - window_x;
        drag_offset_y = _mouse_y - window_y;
    }

    // === ПЕРЕТАСКИВАНИЕ ОКНА ===
    if (is_dragging)
    {
        if (_left_down)
        {
            var _gui_w = display_get_gui_width();
            var _gui_h = display_get_gui_height();

            window_x = clamp(
                _mouse_x - drag_offset_x,
                0,
                max(_gui_w - window_width, 0)
            );

            window_y = clamp(
                _mouse_y - drag_offset_y,
                0,
                max(_gui_h - window_height, 0)
            );
        }

        if (_left_released)
            is_dragging = false;

        return true;
    }

    return false;
}