if (instance_exists(objPauseMenu) && objPauseMenu.is_paused == true || state = CAMSTATES.LEVEL_END) return;

// ==========================================
// === ОТРИСОВКА ИГРОВОГО КУРСОРА ===
// ==========================================

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _win_w = max(window_get_width(), 1);
var _win_h = max(window_get_height(), 1);

// Преобразуем экранные координаты в GUI.
var _cursor_x = global.cursor_screen_x * (_gui_w / _win_w);
var _cursor_y = global.cursor_screen_y * (_gui_h / _win_h);

// Получаем текущий спрайт курсора.
var _cursor_sprite = global.cursor_sprite;

// Отрисовываем курсор.
var _cursor_size = global.settings.crosshair_size * 2;

if (global.camera_shake_menu_hover)
{
    _cursor_size = 1;
}

draw_sprite_ext(_cursor_sprite, 0, _cursor_x, _cursor_y, _cursor_size, _cursor_size, 0, image_blend, image_alpha);