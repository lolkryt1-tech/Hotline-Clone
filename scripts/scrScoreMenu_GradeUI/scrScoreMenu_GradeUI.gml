/// @desc Создание objScoreGradeUI
function scrScoreMenu_GradeUI() {
    if (grade_ui != noone && instance_exists(grade_ui)) {
        return;
    }

    grade_ui = instance_create_depth(0, 0, 4, objScoreGradeUI);
    grade_ui.setRank(final_rank_num);

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    grade_ui.target_x = _gui_w * 0.1 + 320;
    grade_ui.target_y = _gui_h * 0.75;
    grade_ui.target_alpha = 1.0;

    grade_ui.grow_progress = 1.0;
    grade_ui.rank_scale = grade_ui.rank_scale_base;

    grade_ui.white_flash = 0.0;
    grade_ui.black_flash = 0.0;
}
