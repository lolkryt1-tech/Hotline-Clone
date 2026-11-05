
#region СБРАСЫВАЕМ ЭКРАН В ПЕРВОМ КАДРЕ

var _win_w = window_get_width();
var _win_h = window_get_height();

if (window_get_fullscreen()) {
    _win_w = display_get_width();
    _win_h = display_get_height();
}

surface_resize(application_surface, _win_w, _win_h);
display_set_gui_size(_win_w, _win_h);

#endregion


enum SCORE_STATE { WAIT, ANIM_STAT, SHOW_RANK, DONE, EXIT }

scrScoreMenu_Init();

scrClearFloorData();
