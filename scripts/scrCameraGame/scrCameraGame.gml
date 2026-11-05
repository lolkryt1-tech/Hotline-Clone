function scrCameraGame()
{
    // Обычный геймплей: объект эффектора сидит строго на мышке
    x = mouse_x;
    y = mouse_y;

    // Автоматический рассвет
    if (fade_darkness > 0)
    {
        fade_darkness = max(fade_darkness - fade_speed, 0.0);
    }

	// МЕНЮ НАСТРОЙКИ ТРЯСКИ ПРИ СТРЕЛЬБЕ
	if (keyboard_check_pressed(vk_f7))
	{
	    if (instance_exists(objCameraShakeMenu))
	    {
	        scrCameraShakeMenuClose();
	    }
	    else
	    {
	        // Создаём резервную копию, если её ещё нет
	        if (global.camera_shake.backup == undefined)
	        {
	            global.camera_shake.backup = scrCameraShakeCreatePresets();

	            scrCameraShakeCopyPresets(
	                global.camera_shake.presets,
	                global.camera_shake.backup
	            );

	            global.camera_shake.backup_enabled = global.camera_shake.enabled;
	        }

	        instance_create_depth(0, 0, -15000, objCameraShakeMenu);
	        global.camera_shake_menu_open = true;
	    }
	}
}