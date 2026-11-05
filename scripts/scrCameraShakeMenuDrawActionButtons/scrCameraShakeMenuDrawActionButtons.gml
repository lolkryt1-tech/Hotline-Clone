function scrCameraShakeMenuDrawActionButtons()
{
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    var _button_y = y + action_button_y;

    // SAVE и CANCEL

    if (scrCameraShakeHasChanges())
    {
        // SAVE

        var _button_x = x + save_button_x;
        var _hover = point_in_rectangle(_mx, _my, _button_x, _button_y, _button_x + action_button_w, _button_y + action_button_h);

        draw_set_color(_hover ? make_color_rgb(75, 135, 110) : make_color_rgb(55, 105, 90));
        draw_rectangle(_button_x, _button_y, _button_x + action_button_w, _button_y + action_button_h, false);

        draw_set_color(_hover ? make_color_rgb(130, 175, 150) : make_color_rgb(100, 145, 125));
        draw_rectangle(_button_x, _button_y, _button_x + action_button_w, _button_y + action_button_h, true);

        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(_button_x + action_button_w * 0.5, _button_y + action_button_h * 0.5, "SAVE");

        // CANCEL

        _button_x = x + cancel_button_x;
        _hover = point_in_rectangle(_mx, _my, _button_x, _button_y, _button_x + action_button_w, _button_y + action_button_h);

        draw_set_color(_hover ? make_color_rgb(85, 75, 85) : make_color_rgb(65, 65, 75));
        draw_rectangle(_button_x, _button_y, _button_x + action_button_w, _button_y + action_button_h, false);

        draw_set_color(_hover ? make_color_rgb(135, 120, 140) : make_color_rgb(100, 100, 115));
        draw_rectangle(_button_x, _button_y, _button_x + action_button_w, _button_y + action_button_h, true);

        draw_set_color(c_white);
        draw_text(_button_x + action_button_w * 0.5, _button_y + action_button_h * 0.5, "CANCEL");
    }

    // DEFAULT

    var _button_x = x + default_button_x;
    var _hover = point_in_rectangle(_mx, _my, _button_x, _button_y, _button_x + action_button_w, _button_y + action_button_h);

    draw_set_color(_hover ? make_color_rgb(85, 100, 120) : make_color_rgb(65, 75, 90));
    draw_rectangle(_button_x, _button_y, _button_x + action_button_w, _button_y + action_button_h, false);

    draw_set_color(_hover ? make_color_rgb(145, 160, 180) : make_color_rgb(110, 125, 145));
    draw_rectangle(_button_x, _button_y, _button_x + action_button_w, _button_y + action_button_h, true);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_button_x + action_button_w * 0.5, _button_y + action_button_h * 0.5, "DEFAULT");

    draw_set_halign(fa_left);
}