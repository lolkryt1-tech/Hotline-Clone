if (!instance_exists(objLevelEditor)) exit;

// === ПОЛУЧЕНИЕ ВВОДА ===

var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

var _left_pressed = mouse_check_button_pressed(mb_left);

var _pan_pressed = mouse_check_button_pressed(mb_middle);
var _pan_down = mouse_check_button(mb_middle);
var _pan_released = mouse_check_button_released(mb_middle);

var _wheel = mouse_wheel_up() - mouse_wheel_down();


// === ПРОВЕРКА ASSET BROWSER ===

var _over_browser = false;

if (instance_exists(objEditorAssetBrowser))
{
    var _browser_open = false;
    with (objLevelEditor) _browser_open = editor_ui.asset_browser.is_open;

    if (_browser_open)
    {
        with (objEditorAssetBrowser)
        {
            _over_browser = point_in_rectangle(
                _mouse_x, _mouse_y,
                window_x, window_y,
                window_x + window_width, window_y + window_height
            );
        }
    }
}

// Не приближаем камеру над окном браузера
var _camera_wheel = _over_browser ? 0 : _wheel;


// === ОБНОВЛЕНИЕ КАМЕРЫ ===

scrEditorWorkspaceCameraUpdate(
    _mouse_x,
    _mouse_y,
    _pan_pressed,
    _pan_down,
    _pan_released,
    _camera_wheel
);

scrEditorWorkspaceCameraApply();


// === РАЗМЕЩЕНИЕ ТАЙЛА ===

scrEditorWorkspaceHandleTools(_over_browser);