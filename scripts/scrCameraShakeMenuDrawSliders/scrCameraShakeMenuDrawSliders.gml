function scrCameraShakeMenuDrawSliders(_mx, _my)
{
    var _preset = scrCameraShakeGetSelectedPreset();

    for (var i = 0; i < array_length(sliders); i++)
    {
        var _slider = sliders[i];
        var _data = scrCameraShakeMenuGetEffectData(_preset, _slider.effect);
        var _value = variable_struct_get(_data, _slider.field);

        var _enabled = variable_struct_get(_preset, _slider.effect + "_enabled");

        var _row_y = y + _slider.y;
        var _track_x = x + slider_x;
        var _track_y = _row_y + 20;

        // Цвета элементов.
        // Проверяем наведение мыши на ползунок.

        var _hover = !(preset_dropdown_open || category_dropdown_open) && point_in_rectangle(
            _mx, _my, _track_x, _track_y - slider_handle_size,
            _track_x + slider_w, _track_y + slider_handle_size
        );

        var _text_color = _enabled ? gui_secondary_color : make_color_rgb(75, 75, 80);
        var _value_color = _enabled ? gui_text_color : make_color_rgb(75, 75, 80);

        var _track_color = _enabled
            ? (_hover ? make_color_rgb(75, 85, 95) : make_color_rgb(55, 55, 65))
            : make_color_rgb(35, 35, 40);

        var _fill_color = _enabled
            ? (_hover ? make_color_rgb(95, 175, 145) : make_color_rgb(75, 145, 125))
            : make_color_rgb(55, 65, 60);

        var _handle_color = _enabled
            ? (_hover ? make_color_rgb(255, 255, 255) : gui_text_color)
            : make_color_rgb(65, 65, 70);

        // Название параметра.

        draw_set_color(_text_color);
        draw_set_halign(fa_left);
        draw_text(_track_x, _row_y, _slider.name);

        // Числовое значение
        var _tb_w = 70;
        var _tb_x = _track_x + slider_w - _tb_w;
        var _tb_y = _row_y - 20;

        // Запоминаем позицию — понадобится в Step и HandleButtons
        _slider.draw_x = _tb_x;
        _slider.draw_y = _tb_y;

        _slider.textbox.Draw(_tb_x, _tb_y, _tb_w);

        // Фоновая дорожка.

        draw_set_color(_track_color);
        draw_rectangle(_track_x, _track_y - slider_h * 0.5, _track_x + slider_w, _track_y + slider_h * 0.5, false);

        // Положение маркера.

        var _progress = clamp((_value - _slider.min) / (_slider.max_current - _slider.min), 0, 1);
        var _handle_x = _track_x + _progress * slider_w;

        // Заполненная часть.

        draw_set_color(_fill_color);
        draw_rectangle(_track_x, _track_y - slider_h * 0.5, _handle_x, _track_y + slider_h * 0.5, false);

        // Маркер.

        draw_set_color(_handle_color);
        draw_rectangle(_handle_x - slider_handle_size * 0.5, _track_y - slider_handle_size, _handle_x + slider_handle_size * 0.5, _track_y + slider_handle_size, false);
    }
}