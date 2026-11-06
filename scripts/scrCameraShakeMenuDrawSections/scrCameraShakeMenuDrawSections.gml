function scrCameraShakeMenuDrawSections()
{
    var _preset = scrCameraShakeGetSelectedPreset();

    for (var i = 0; i < array_length(slider_sections); i++)
    {
        var _section = slider_sections[i];
        var _section_y = y + _section.y;

        var _enabled = variable_struct_get(_preset, string_lower(_section.name) + "_enabled");

        draw_set_color(_enabled ? gui_secondary_color : make_color_rgb(75, 75, 80));
        draw_text(x + slider_x, _section_y, _section.name);

        draw_set_color(_enabled ? make_color_rgb(65, 65, 75) : make_color_rgb(40, 40, 45));
        draw_line(x + slider_x + 85, _section_y, x + slider_x + slider_w, _section_y);
    }
}