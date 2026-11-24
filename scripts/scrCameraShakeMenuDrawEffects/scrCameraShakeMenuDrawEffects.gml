function scrCameraShakeMenuDrawEffects(_mx, _my)
{
    draw_set_color(gui_secondary_color);
    draw_text(x + effect_button_x, y + effect_button_y - 14, "EFFECTS");

    var _preset = scrCameraShakeGetSelectedPreset();

    var _effects = ["kick", "bounce", "perlin"];
    var _effect_names = ["KICK", "BOUNCE", "PERLIN"];

    for (var i = 0; i < array_length(_effects); i++)
    {
        var _effect = _effects[i];
        var _enabled = variable_struct_get(_preset, _effect + "_enabled");

        var _button_x = x + effect_button_x + i * (effect_button_w + effect_button_gap);
        var _button_y = y + effect_button_y;

        var _hover = !(preset_dropdown_open || category_dropdown_open) && point_in_rectangle(
            _mx, _my,
            _button_x, _button_y,
            _button_x + effect_button_w, _button_y + effect_button_h
        );

        var _button_color = _enabled
            ? (_hover ? make_color_rgb(70, 125, 105) : make_color_rgb(55, 105, 90))
            : (_hover ? make_color_rgb(75, 75, 90) : make_color_rgb(55, 55, 65));

        draw_set_color(_button_color);
        draw_rectangle(_button_x, _button_y, _button_x + effect_button_w, _button_y + effect_button_h, false);

        draw_set_color(make_color_rgb(100, 100, 115));
        draw_rectangle(_button_x, _button_y, _button_x + effect_button_w, _button_y + effect_button_h, true);

        draw_set_color(_enabled ? gui_text_color : make_color_rgb(145, 145, 155));
        draw_set_halign(fa_center);
        draw_text(_button_x + effect_button_w * 0.5, _button_y + effect_button_h * 0.5, _effect_names[i] + (_enabled ? "  ON" : "  OFF"));

        draw_set_halign(fa_left);
    }
}