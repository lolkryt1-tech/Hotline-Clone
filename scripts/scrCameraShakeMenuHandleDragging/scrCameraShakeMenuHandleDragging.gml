function scrCameraShakeMenuHandleDragging(_mx, _my)
{
    if (!dragging) return false;

    if (mouse_check_button(mb_left))
    {
        var _gui_w = display_get_gui_width();
        var _gui_h = display_get_gui_height();

        x = clamp(_mx - drag_offset_x, 0, max(0, _gui_w - window_w));
        y = clamp(_my - drag_offset_y, 0, max(0, _gui_h - window_h));
    }
    else
    {
        dragging = false;
    }

    return true;
}