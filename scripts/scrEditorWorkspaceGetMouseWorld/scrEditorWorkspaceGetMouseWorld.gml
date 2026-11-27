/// @function scrEditorWorkspaceGetMouseWorld()
/// @description Возвращает мировые координаты курсора мыши.

function scrEditorWorkspaceGetMouseWorld()
{
    var _gui_w = max(display_get_gui_width(), 1);
    var _gui_h = max(display_get_gui_height(), 1);

    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);

    var _view_w = camera_get_view_width(camera_id);
    var _view_h = camera_get_view_height(camera_id);

    return {
        x: camera_x + _mouse_x * (_view_w / _gui_w),
        y: camera_y + _mouse_y * (_view_h / _gui_h)
    };
}