/// @function scrEditorAssetBrowserDrawTabs(_active_tab, _mouse_x, _mouse_y)
/// @description Отрисовка вкладок Asset Browser.
function scrEditorAssetBrowserDrawTabs(_active_tab, _mouse_x, _mouse_y)
{
    var _tabs_y = window_y + header_height;
    var _tab_width = window_width / 5;

    var _tabs = ["BUILD", "FURNITURE", "ENEMY", "GAMEPLAY", "LEVEL"];

    var _color_tabs = make_color_rgb(43, 43, 49);
    var _color_active = make_color_rgb(75, 99, 137);
    var _color_hover = make_color_rgb(58, 58, 65);
    var _color_separator = make_color_rgb(78, 78, 86);
    var _color_text = make_color_rgb(230, 230, 235);
    var _color_inactive = make_color_rgb(165, 165, 175);

    // Основа панели вкладок
    draw_set_color(_color_tabs);
    draw_rectangle(window_x, _tabs_y, window_x + window_width, _tabs_y + tabs_height, false);

    for (var i = 0; i < array_length(_tabs); i++)
    {
        var _tab_x = window_x + i * _tab_width;
        var _tab_active = _tabs[i] == _active_tab;

        var _tab_hover = point_in_rectangle(
            _mouse_x, _mouse_y,
            _tab_x, _tabs_y,
            _tab_x + _tab_width, _tabs_y + tabs_height
        );

        if (_tab_active || _tab_hover)
        {
            draw_set_color(_tab_active ? _color_active : _color_hover);
            draw_rectangle(_tab_x, _tabs_y, _tab_x + _tab_width, _tabs_y + tabs_height, false);
        }

        draw_set_color(_tab_active ? _color_text : _color_inactive);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_tab_x + _tab_width * 0.5, _tabs_y + tabs_height * 0.5, _tabs[i]);

        // Разделители категорий
        if (i > 0)
        {
            draw_set_color(_color_separator);
            draw_line(_tab_x, _tabs_y + 6, _tab_x, _tabs_y + tabs_height - 6);
        }
    }
}