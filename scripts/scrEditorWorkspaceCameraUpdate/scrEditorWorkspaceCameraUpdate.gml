
/// @function scrEditorWorkspaceCameraUpdate()
/// @description Обрабатывает перемещение и масштабирование камеры по командам objEditorInput.

function scrEditorWorkspaceCameraUpdate(_mouse_x, _mouse_y, _pan_pressed, _pan_down, _pan_released, _wheel)
{
    var _gui_w = max(display_get_gui_width(), 1);
    var _gui_h = max(display_get_gui_height(), 1);

    var _view_w = base_view_width / zoom;
    var _view_h = _view_w * _gui_h / _gui_w;


    // === ПЕРЕМЕЩЕНИЕ КАМЕРЫ ===

    if (_pan_pressed)
    {
        is_panning = true;
        pan_mouse_x = _mouse_x;
        pan_mouse_y = _mouse_y;
    }

    if (is_panning && _pan_down)
    {
        var _dx = _mouse_x - pan_mouse_x;
        var _dy = _mouse_y - pan_mouse_y;

        camera_target_x -= _dx * (_view_w / _gui_w);
        camera_target_y -= _dy * (_view_h / _gui_h);

        pan_mouse_x = _mouse_x;
        pan_mouse_y = _mouse_y;
    }

    if (_pan_released) is_panning = false;


    // === МАСШТАБИРОВАНИЕ ===

    if (_wheel != 0)
    {
        var _mouse_u = _mouse_x / _gui_w;
        var _mouse_v = _mouse_y / _gui_h;

        var _world_x = camera_x + _mouse_u * _view_w;
        var _world_y = camera_y + _mouse_v * _view_h;

        zoom *= (_wheel > 0) ? 1.1 : 1 / 1.1;
        zoom = clamp(zoom, zoom_min, zoom_max);

        _view_w = base_view_width / zoom;
        _view_h = _view_w * _gui_h / _gui_w;

        camera_target_x = _world_x - _mouse_u * _view_w;
        camera_target_y = _world_y - _mouse_v * _view_h;

        camera_x = camera_target_x;
        camera_y = camera_target_y;
    }


    // === ПЛАВНОСТЬ КАМЕРЫ ===

    var _smooth = 1 - exp(-camera_smooth * (delta_time / 1000000));

    camera_x = lerp(camera_x, camera_target_x, _smooth);
    camera_y = lerp(camera_y, camera_target_y, _smooth);

    if (abs(camera_x - camera_target_x) < 0.001) camera_x = camera_target_x;
    if (abs(camera_y - camera_target_y) < 0.001) camera_y = camera_target_y;
}
