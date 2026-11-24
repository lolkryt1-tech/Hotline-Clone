if (!menu_active) exit;

if (darken_alpha <= 0.001) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _cx = _gui_w * 0.5;
var _cy = _gui_h * 0.5;

// === ЗАТЕМНЕНИЕ ===
draw_set_color(c_black);
draw_set_alpha(darken_alpha * 0.7);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// === НАСТРОЙКИ ТЕКСТА ===
draw_set_font(fntDebug);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _slide_offset = (1 - items_slide) * 60;

var _title = (menu_page == MENU_PAGE.MAIN)
    ? "PAUSE"
    : "OPTIONS";

var _items = (menu_page == MENU_PAGE.MAIN)
    ? menu_items
    : options_items;

// === ЗАГОЛОВОК ===
var _title_y = _cy - 120 + _slide_offset;

draw_set_color(c_black);
draw_set_alpha(darken_alpha);
draw_text(_cx + 2, _title_y + 2, _title);

draw_set_color(c_white);
draw_text(_cx, _title_y, _title);

// === ПУНКТЫ МЕНЮ ===
for (var i = 0; i < array_length(_items); i++)
{
    var _y = _cy - 20 + (i * 45) + _slide_offset;
    var _text = _items[i];

    // Проценты громкости
    if (menu_page == MENU_PAGE.OPTIONS)
    {
       switch (i)
        {
            case 0: // SOUND VOLUME
                _text += "  < "
                    + string(round(global.settings.sound_volume * 100))
                    + "% >";
                break;

            case 1: // MUSIC VOLUME
                _text += "  < "
                    + string(round(global.settings.music_volume * 100))
                    + "% >";
                break;
        }
    }

    var _selected = (i == selected_index);

    if (_selected)
        _text = "> " + _text + " <";

    // Тень
    draw_set_color(c_black);
    draw_set_alpha(darken_alpha);
    draw_text(_cx + 2, _y + 2, _text);

    // Основной текст
    if (_selected)
    {
        var _pulse = 0.7 + 0.3
            * sin(current_time * 0.005);

        draw_set_color(make_color_rgb(255, 210, 60));
        draw_set_alpha(darken_alpha * _pulse);
    }
    else
    {
        draw_set_color(c_gray);
        draw_set_alpha(darken_alpha);
    }

    draw_text(_cx, _y, _text);
}

// === СБРОС ===
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);