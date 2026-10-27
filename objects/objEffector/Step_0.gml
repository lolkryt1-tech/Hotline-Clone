global.cam_x = camera_get_view_x(global.cam);
global.cam_y = camera_get_view_y(global.cam);
global.cam_w = camera_get_view_width(global.cam);
global.cam_h = camera_get_view_height(global.cam);

global.cam_scale_x = window_get_width() / global.cam_w;
global.cam_scale_y = window_get_height() / global.cam_h;

// === ТАБЛИЦА СОСТОЯНИЙ ЭФФЕКТОРА ===
switch (state)
{
    case CAMSTATES.GAME:       scrCameraGame();     break;
    case CAMSTATES.LEVEL_END:  scrCameraLevelEnd(); break;
}
