
/// @function scrEditorWorkspaceCameraApply()
/// @description Устанавливает размер и положение камеры рабочей области.

function scrEditorWorkspaceCameraApply()
{
    var _gui_w = max(display_get_gui_width(), 1);
    var _gui_h = max(display_get_gui_height(), 1);

    var _view_w = base_view_width / zoom;
    var _view_h = _view_w * _gui_h / _gui_w;

    camera_set_view_size(camera_id, _view_w, _view_h);
    camera_set_view_pos(camera_id, camera_x, camera_y);
}
