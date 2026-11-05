function scrCameraShakeMenuClose()
{
    global.camera_shake_menu_open = false;
    global.camera_shake_menu_hover = false;
    global.camera_shake_menu_dragging = false;

    window_set_cursor(cr_none);
	
	instance_destroy(objCameraShakeMenu);
}