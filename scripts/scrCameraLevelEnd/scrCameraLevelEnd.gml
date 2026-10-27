function scrCameraLevelEnd()
{
	image_alpha -= 0.25;
	
    // 1. Считаем целевую позицию X для левого верхнего угла камеры, чтобы центрироваться по машине
    var _cam_w = camera_get_view_width(_cam);
    var _target_cam_x = target_car_x - (_cam_w / 2);
    
    // Плавное выравнивание по горизонтали к машине (начинается от точки, где камера застыла)
    cutscene_cam_x = lerp(cutscene_cam_x, _target_cam_x, 0.05);
    
    // 2. Линейный и абсолютно константный полет вверх по вертикали (Y)
    cutscene_cam_y -= 2.0; // Твоя скорость взлета
    
    // 3. Жестко выставляем позицию вьюпорта камеры в мире без посредников
    camera_set_view_pos(_cam, cutscene_cam_x, cutscene_cam_y);
    
    // 4. Занавеска падает сверху вниз на GUI
    var _gui_h = display_get_gui_height();
    curtain_y = min(curtain_y + curtain_speed, _gui_h);
    
    // 5. Таймер до перехода в комнату очков
    cutscene_timer--;
    if (cutscene_timer <= 0) 
    {
         room_goto(rmScore);
		 
		 instance_destroy(objSaveManager);
		 instance_destroy(objBloodSurfaceManager);
		 instance_destroy(objDepthManager);
		 instance_destroy(objParticleManager);
		 instance_destroy(objPathManager);
		 instance_destroy(objPauseManager);
		 instance_destroy(objPauseMenu);
		 instance_destroy(objGameManager);
		 instance_destroy(objEffector);
		 instance_destroy(objLevelStatistic);
    }
	
	if (fade_darkness > 0) 
    {
        fade_darkness = max(fade_darkness - fade_speed, 0.0);
    }
}
