
/// @function scrEditorAssetBrowserDrawTileLayers(_layers_x, _layers_w, _bottom_y, _color_text, _color_inactive, _color_panel, _color_border, _color_active, _color_scroll)
/// @description Отрисовка списка TILE LAYERS.

function scrEditorAssetBrowserDrawTileLayers(
    _layers_x,
    _layers_w,
    _bottom_y,
    _color_text,
    _color_inactive,
    _color_panel,
    _color_border,
    _color_active,
    _color_scroll
)
{
    // === TILE LAYERS ===
    draw_set_color(_color_text);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(_layers_x, _bottom_y, "TILE LAYERS");

    // === УДАЛЕНИЕ СЛОЯ ===
    draw_set_color(array_length(tile_layers) > 0
        ? make_color_rgb(75, 43, 43)
        : make_color_rgb(35, 35, 39));

    draw_rectangle(
        _layers_x + _layers_w - 78,
        _bottom_y - 2,
        _layers_x + _layers_w - 62,
        _bottom_y + 15,
        false
    );

    draw_set_color(array_length(tile_layers) > 0 ? _color_text : _color_inactive);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_layers_x + _layers_w - 70, _bottom_y + 6, "-");

    // === КНОПКИ ПЕРЕМЕЩЕНИЯ ===
    var _up_x = _layers_x + _layers_w - 58;
    var _down_x = _layers_x + _layers_w - 38;
    var _button_y1 = _bottom_y - 2;
    var _button_y2 = _bottom_y + 15;

    // UP
    draw_set_color(active_layer > 0
        ? make_color_rgb(58, 58, 65)
        : make_color_rgb(35, 35, 39));

    draw_rectangle(_up_x, _button_y1, _up_x + 16, _button_y2, false);

    draw_set_color(active_layer > 0 ? _color_text : _color_inactive);

    // Графическая стрелка вверх
    draw_line(_up_x + 8, _bottom_y + 10, _up_x + 8, _bottom_y + 3);
    draw_line(_up_x + 4, _bottom_y + 7, _up_x + 8, _bottom_y + 3);
    draw_line(_up_x + 12, _bottom_y + 7, _up_x + 8, _bottom_y + 3);

    // DOWN
    draw_set_color(active_layer >= 0 && active_layer < array_length(tile_layers) - 1
        ? make_color_rgb(58, 58, 65)
        : make_color_rgb(35, 35, 39));

    draw_rectangle(_down_x, _button_y1, _down_x + 16, _button_y2, false);

    draw_set_color(active_layer >= 0 && active_layer < array_length(tile_layers) - 1
        ? _color_text
        : _color_inactive);

    // Графическая стрелка вниз
    draw_line(_down_x + 8, _bottom_y + 3, _down_x + 8, _bottom_y + 10);
    draw_line(_down_x + 4, _bottom_y + 6, _down_x + 8, _bottom_y + 10);
    draw_line(_down_x + 12, _bottom_y + 6, _down_x + 8, _bottom_y + 10);

    // === ДОБАВЛЕНИЕ СЛОЯ ===
    draw_set_color(make_color_rgb(58, 58, 65));
    draw_rectangle(
        _layers_x + _layers_w - 18,
        _bottom_y - 2,
        _layers_x + _layers_w,
        _bottom_y + 15,
        false
    );

    draw_set_color(_color_text);
    draw_text(_layers_x + _layers_w - 9, _bottom_y + 6, "+");

    // === ОБЛАСТЬ СПИСКА ===
    var _list_y = _bottom_y + 18;
    var _list_h = 78;
    var _scrollbar_w = 8;
    var _row_h = layers_row_height;
    var _list_w = _layers_w - _scrollbar_w - 3;

    draw_set_color(_color_panel);
    draw_rectangle(_layers_x, _list_y, _layers_x + _layers_w, _list_y + _list_h, false);

    draw_set_color(_color_border);
    draw_rectangle(_layers_x, _list_y, _layers_x + _layers_w, _list_y + _list_h, true);

    // === СЛОИ ===
    for (var i = 0; i < array_length(tile_layers); i++)
    {
        var _visible_index = i - layers_scroll;
        if (_visible_index < 0 || _visible_index >= layers_visible_count) continue;

        var _row_y = _list_y + _visible_index * _row_h;
        var _icon_y = _row_y + _row_h * 0.5;

        // Исходная строка становится полупрозрачной
        if (layer_dragging && i == layer_drag_candidate)
        {
            draw_set_alpha(0.25);
        }
        else
        {
            draw_set_alpha(1);
        }

        if (i == active_layer)
        {
            draw_set_color(_color_active);
            draw_rectangle(_layers_x + 2, _row_y + 1, _layers_x + _list_w, _row_y + _row_h, false);
        }

        // === НАЗВАНИЕ / ПОЛЕ ПЕРЕИМЕНОВАНИЯ ===
        if (rename_active && rename_layer_index == i)
        {
            draw_set_color(make_color_rgb(25, 25, 29));
            draw_rectangle(
                _layers_x + 5,
                _row_y + 3,
                _layers_x + _list_w - 96,
                _row_y + _row_h - 2,
                false
            );

            draw_set_color(make_color_rgb(255, 190, 65));
            draw_rectangle(
                _layers_x + 5,
                _row_y + 3,
                _layers_x + _list_w - 96,
                _row_y + _row_h - 2,
                true
            );

            draw_set_color(_color_text);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_text(_layers_x + 9, _icon_y, keyboard_string);
        }
        else
        {
            draw_set_color(tile_layers[i].visible ? _color_text : _color_inactive);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_text(_layers_x + 7, _icon_y, tile_layers[i].name);
        }

        // ACTIVE
        if (i == active_layer)
        {
            draw_set_color(make_color_rgb(45, 105, 70));
            draw_roundrect(_layers_x + _list_w - 91, _row_y + 5, _layers_x + _list_w - 43, _row_y + 21, false);

            draw_set_color(_color_text);
            draw_set_halign(fa_center);
            draw_text(_layers_x + _list_w - 67, _icon_y, "ACTIVE");
        }

        // Глазик
        var _eye_x = _layers_x + _list_w - 30;

        draw_set_color(tile_layers[i].visible ? _color_text : _color_inactive);
        draw_ellipse(_eye_x - 6, _icon_y - 4, _eye_x + 6, _icon_y + 4, true);
        draw_circle(_eye_x, _icon_y, 2, false);

        // Замок
        var _lock_x = _layers_x + _list_w - 10;
        draw_set_color(tile_layers[i].locked ? _color_text : _color_inactive);

        // Дужка замка
        draw_line(_lock_x - 3, _icon_y - 2, _lock_x - 3, _icon_y - 6);
        draw_line(_lock_x - 3, _icon_y - 6, _lock_x, _icon_y - 9);
        draw_line(_lock_x, _icon_y - 9, _lock_x + 3, _icon_y - 6);
        draw_line(_lock_x + 3, _icon_y - 6, _lock_x + 3, _icon_y - 2);

        // Корпус замка
        draw_rectangle(_lock_x - 5, _icon_y - 2, _lock_x + 5, _icon_y + 6, false);

        draw_set_alpha(1);
    }

    // === ВИЗУАЛИЗАЦИЯ ПЕРЕТАСКИВАНИЯ ===
    if (layer_dragging
    && layer_drag_candidate >= 0
    && layer_drag_candidate < array_length(tile_layers))
    {
        // === ЛИНИЯ ВСТАВКИ ===
        if (layer_drag_target >= 0
        && layer_drag_target != layer_drag_candidate)
        {
            var _line_index = layer_drag_target;

            if (layer_drag_target > layer_drag_candidate)
            {
                _line_index += 1;
            }

            var _line_y = _list_y + (_line_index - layers_scroll) * _row_h;

            if (_line_y >= _list_y && _line_y <= _list_y + _list_h)
            {
                draw_set_alpha(1);
                draw_set_color(make_color_rgb(255, 190, 65));

                draw_rectangle(
                    _layers_x + 3,
                    _line_y - 1,
                    _layers_x + _list_w - 2,
                    _line_y + 1,
                    false
                );
            }
        }

        // === ПЕРЕТАСКИВАЕМАЯ СТРОКА ===
        var _drag_y = clamp(
            layer_drag_mouse_y - _row_h * 0.5,
            _list_y,
            _list_y + _list_h - _row_h
        );

        var _drag_center_y = _drag_y + _row_h * 0.5;

        draw_set_alpha(0.9);

        // Фон строки
        draw_set_color(make_color_rgb(48, 48, 55));
        draw_rectangle(
            _layers_x + 2,
            _drag_y + 1,
            _layers_x + _list_w,
            _drag_y + _row_h,
            false
        );

        // Рамка
        draw_set_color(make_color_rgb(255, 190, 65));
        draw_rectangle(
            _layers_x + 2,
            _drag_y + 1,
            _layers_x + _list_w,
            _drag_y + _row_h,
            true
        );

        // Название
        draw_set_color(tile_layers[layer_drag_candidate].visible
            ? _color_text
            : _color_inactive);

        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text(
            _layers_x + 7,
            _drag_center_y,
            tile_layers[layer_drag_candidate].name
        );

        // ACTIVE
        if (layer_drag_candidate == active_layer)
        {
            draw_set_color(make_color_rgb(45, 105, 70));
            draw_roundrect(
                _layers_x + _list_w - 91,
                _drag_y + 5,
                _layers_x + _list_w - 43,
                _drag_y + 21,
                false
            );

            draw_set_color(_color_text);
            draw_set_halign(fa_center);
            draw_text(_layers_x + _list_w - 67, _drag_center_y, "ACTIVE");
        }

        // Глазик
        var _drag_eye_x = _layers_x + _list_w - 30;

        draw_set_color(tile_layers[layer_drag_candidate].visible
            ? _color_text
            : _color_inactive);

        draw_ellipse(
            _drag_eye_x - 6,
            _drag_center_y - 4,
            _drag_eye_x + 6,
            _drag_center_y + 4,
            true
        );

        draw_circle(_drag_eye_x, _drag_center_y, 2, false);

        // Замок
        var _drag_lock_x = _layers_x + _list_w - 10;

        draw_set_color(tile_layers[layer_drag_candidate].locked
            ? _color_text
            : _color_inactive);

        draw_line(_drag_lock_x - 3, _drag_center_y - 2, _drag_lock_x - 3, _drag_center_y - 6);
        draw_line(_drag_lock_x - 3, _drag_center_y - 6, _drag_lock_x, _drag_center_y - 9);
        draw_line(_drag_lock_x, _drag_center_y - 9, _drag_lock_x + 3, _drag_center_y - 6);
        draw_line(_drag_lock_x + 3, _drag_center_y - 6, _drag_lock_x + 3, _drag_center_y - 2);

        draw_rectangle(
            _drag_lock_x - 5,
            _drag_center_y - 2,
            _drag_lock_x + 5,
            _drag_center_y + 6,
            false
        );

        draw_set_alpha(1);
    }

    // === ПУСТОЙ СПИСОК ===
    if (array_length(tile_layers) == 0)
    {
        draw_set_color(_color_inactive);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_layers_x + _list_w * 0.5, _list_y + _list_h * 0.5, "NO LAYERS");
    }

    // === ВЕРТИКАЛЬНЫЙ СКРОЛЛБАР ===
    var _max_scroll = max(array_length(tile_layers) - layers_visible_count, 0);
    var _scroll_x = _layers_x + _layers_w - _scrollbar_w;
    var _scroll_y = _list_y;

    if (_max_scroll > 0)
    {
        var _thumb_h = max(16, _list_h * layers_visible_count / array_length(tile_layers));
        var _thumb_y = _scroll_y + (_list_h - _thumb_h) * layers_scroll / _max_scroll;

        draw_set_color(make_color_rgb(25, 25, 29));
        draw_rectangle(_scroll_x, _scroll_y, _scroll_x + _scrollbar_w, _scroll_y + _list_h, false);

        draw_set_color(_color_scroll);
        draw_roundrect(_scroll_x + 1, _thumb_y, _scroll_x + _scrollbar_w - 1, _thumb_y + _thumb_h, false);
    }

    // === ПОДТВЕРЖДЕНИЕ УДАЛЕНИЯ ===
    if (delete_confirm_active)
    {
        var _dialog_w = 220;
        var _dialog_h = 64;
        var _dialog_x = _layers_x + (_layers_w - _dialog_w) * 0.5;
        var _dialog_y = _list_y + (_list_h - _dialog_h) * 0.5;

        draw_set_color(make_color_rgb(25, 25, 29));
        draw_rectangle(
            _dialog_x,
            _dialog_y,
            _dialog_x + _dialog_w,
            _dialog_y + _dialog_h,
            false
        );

        draw_set_color(make_color_rgb(180, 65, 65));
        draw_rectangle(
            _dialog_x,
            _dialog_y,
            _dialog_x + _dialog_w,
            _dialog_y + _dialog_h,
            true
        );

        draw_set_color(_color_text);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        if (delete_confirm_index >= 0
        && delete_confirm_index < array_length(tile_layers))
        {
            draw_text(
                _dialog_x + _dialog_w * 0.5,
                _dialog_y + 15,
                "DELETE " + tile_layers[delete_confirm_index].name + "?"
            );
        }

        // DELETE
        draw_set_color(make_color_rgb(115, 45, 45));
        draw_rectangle(_dialog_x + 24, _dialog_y + 34, _dialog_x + 104, _dialog_y + 56, false);

        draw_set_color(_color_text);
        draw_text(_dialog_x + 64, _dialog_y + 45, "DELETE");

        // CANCEL
        draw_set_color(make_color_rgb(58, 58, 65));
        draw_rectangle(_dialog_x + 116, _dialog_y + 34, _dialog_x + 196, _dialog_y + 56, false);

        draw_set_color(_color_text);
        draw_text(_dialog_x + 156, _dialog_y + 45, "CANCEL");
    }

    draw_set_alpha(1);
}
