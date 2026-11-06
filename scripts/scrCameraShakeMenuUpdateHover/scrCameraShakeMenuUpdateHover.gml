/// @description Обновляет состояние наведения курсора на меню и его элементы.
/// Учитывает выпадающий список, перетаскивание окна и ползунков.
/// Также управляет отображением системного курсора.

function scrCameraShakeMenuUpdateHover(_mx, _my)
{
    var _hover = point_in_rectangle(
        _mx, _my,
        x, y,
        x + window_w, y + window_h
    );

    if (preset_dropdown_open)
    {
        var _presets = scrCameraShakeGetCategoryPresets(selected_category);
        var _list_count = array_length(_presets);
        var _list_visible = min(preset_visible_count, _list_count);

        var _list_x = x + preset_dropdown_x;
        var _list_y = y + preset_dropdown_y;

        var _button_hover = point_in_rectangle(
            _mx, _my,
            _list_x, _list_y,
            _list_x + preset_dropdown_w,
            _list_y + preset_item_h
        );

        var _list_hover = point_in_rectangle(
            _mx, _my,
            _list_x, _list_y + preset_item_h,
            _list_x + preset_dropdown_w,
            _list_y + preset_item_h + _list_visible * preset_item_h
        );

        _hover = _hover || _button_hover || _list_hover;
    }

    global.camera_shake_menu_hover = _hover || dragging || slider_dragging != -1;
    global.camera_shake_menu_dragging = dragging;

    window_set_cursor(global.camera_shake_menu_hover ? cr_default : cr_none);
}