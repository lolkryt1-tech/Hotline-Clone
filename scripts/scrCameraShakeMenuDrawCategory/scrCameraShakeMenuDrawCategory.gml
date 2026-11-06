function scrCameraShakeMenuDrawCategory()
{
    var _list_x = x + category_dropdown_x;
    var _list_y = y + category_dropdown_y;

    // Название выбранной категории
    var _selected_name = selected_category;
    for (var i = 0; i < array_length(global.camera_shake.categories); i++)
    {
        if (global.camera_shake.categories[i].id == selected_category)
        {
            _selected_name = global.camera_shake.categories[i].name;
            break;
        }
    }

    draw_set_color(gui_secondary_color);
    draw_text(_list_x, _list_y - category_item_h * 0.5, "CATEGORY");

    draw_set_color(make_color_rgb(40, 40, 48));
    draw_rectangle(_list_x, _list_y, _list_x + category_dropdown_w, _list_y + category_item_h, false);

    draw_set_color(make_color_rgb(100, 100, 115));
    draw_rectangle(_list_x, _list_y, _list_x + category_dropdown_w, _list_y + category_item_h, true);

    draw_set_color(gui_text_color);
    draw_text(_list_x + 8, _list_y + category_item_h * 0.5, _selected_name);

    draw_set_halign(fa_right);
    draw_text(_list_x + category_dropdown_w - 8, _list_y + category_item_h * 0.5, category_dropdown_open ? "▲" : "▼");
    draw_set_halign(fa_left);
}