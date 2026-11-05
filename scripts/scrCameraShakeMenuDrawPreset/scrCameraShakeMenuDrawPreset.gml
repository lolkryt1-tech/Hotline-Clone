function scrCameraShakeMenuDrawPreset()
{
    var _selected_name = selected_preset;

    for (var i = 0; i < array_length(weapon_presets); i++)
    {
        if (weapon_presets[i].id == selected_preset)
        {
            _selected_name = weapon_presets[i].name;
            break;
        }
    }

    var _list_x = x + preset_dropdown_x;
    var _list_y = y + preset_dropdown_y;

    draw_set_color(gui_secondary_color);
    draw_text(_list_x, _list_y - preset_item_h * 0.5, "WEAPON PRESET");

    draw_set_color(make_color_rgb(40, 40, 48));
    draw_rectangle(_list_x, _list_y, _list_x + preset_dropdown_w, _list_y + preset_item_h, false);

    draw_set_color(make_color_rgb(100, 100, 115));
    draw_rectangle(_list_x, _list_y, _list_x + preset_dropdown_w, _list_y + preset_item_h, true);

    draw_set_color(gui_text_color);
    draw_text(_list_x + 8, _list_y + preset_item_h * 0.5, _selected_name);

    draw_set_halign(fa_right);
    draw_text(_list_x + preset_dropdown_w - 8, _list_y + preset_item_h * 0.5, preset_dropdown_open ? "▲" : "▼");

    draw_set_halign(fa_left);
}