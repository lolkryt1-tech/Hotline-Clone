global.camera_shake_menu_x = x;
global.camera_shake_menu_y = y;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _pressed = mouse_check_button_pressed(mb_left);

// === ПРИОРИТЕТ 1: ПЕРЕТАСКИВАНИЕ ОКНА ===

if (scrCameraShakeMenuHandleDragging(_mx, _my))
{
    scrCameraShakeMenuUpdateHover(_mx, _my);
    exit;
}

// === ПРИОРИТЕТ 2: АКТИВНОЕ РЕДАКТИРОВАНИЕ ===

if (editing_slider != -1)
{
    scrCameraShakeMenuHandleEditing();
}

// === ПРИОРИТЕТ 3: ПОЛЗУНКИ ===

if (scrCameraShakeMenuHandleSlider(_mx))
{
    scrCameraShakeMenuUpdateHover(_mx, _my);
    exit;
}

// === ПРИОРИТЕТ 4: ВЫПАДАЮЩИЙ СПИСОК ===

if (preset_dropdown_open)
{
    if (scrCameraShakeMenuHandleDropdown(_mx, _my, _pressed))
    {
        scrCameraShakeMenuUpdateHover(_mx, _my);
        exit;
    }
}

// === ПРИОРИТЕТ 5: НОВЫЕ НАЖАТИЯ ===

if (_pressed)
{
    scrCameraShakeMenuHandleButtons(_mx, _my);
}

if (instance_exists(id))
{
    scrCameraShakeMenuUpdateHover(_mx, _my);
}