
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _center_x = _gui_w * 0.5;
var _center_y = _gui_h * 0.5;


// ========================================
// 1. РАЗДЕЛИТЕЛЬНАЯ ЛИНИЯ
// ========================================

if (line_progress > 0)
{
    var _current_line_width = line_width * line_progress;

    draw_set_color(line_color);
    draw_set_alpha(line_progress);

    draw_line_width(
        _center_x - _current_line_width * 0.5,
        _center_y + line_offset_y,
        _center_x + _current_line_width * 0.5,
        _center_y + line_offset_y,
        1
    );
}


// ========================================
// 2. PRESS SPACE TO CHANGE TIP
// ========================================

if (hint_alpha > 0)
{
    draw_set_font(fntTitleTipsHelper);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(hint_color);
    draw_set_alpha(hint_alpha);

    var _hint_y = _center_y + hint_offset_y + (1 - hint_progress) * 12;

    draw_text_transformed(_center_x, _hint_y, "PRESS [SPACE] TO CHANGE TIP", 1, 1, 0);
}


// ========================================
// 3. ОСНОВНАЯ ПОДСКАЗКА
// ========================================

if (tip_reveal > 0)
{
    draw_set_font(tip_font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Размер поверхности под текст
    var _surface_w = max(1, ceil(string_width(current_tip)) + 8);
    var _surface_h = max(1, ceil(string_height(current_tip)) + 8);

    // Создаём или обновляем поверхность
    if (!surface_exists(tip_surface) || tip_surface_w != _surface_w || tip_surface_h != _surface_h)
    {
        if (surface_exists(tip_surface)) surface_free(tip_surface);

        tip_surface = surface_create(_surface_w, _surface_h);
        tip_surface_w = _surface_w;
        tip_surface_h = _surface_h;
    }

    if (surface_exists(tip_surface))
    {
        // Рисуем полный текст на прозрачной поверхности
        surface_set_target(tip_surface);
        draw_clear_alpha(c_black, 0);

        draw_set_font(tip_font);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(tip_color);
        draw_set_alpha(1);

        draw_text(_surface_w * 0.5, _surface_h * 0.5, current_tip);
        surface_reset_target();

        // ------------------------------------
        // МАСКА: ОТ ЦЕНТРА К КРАЯМ
        // ------------------------------------

        var _text_scale = 1;
		var _half_w = _surface_w * 0.5;
		var _reveal_w = _half_w * tip_reveal;
		var _draw_y = _center_y + tip_offset_y - _surface_h * _text_scale * 0.5;

        draw_set_color(c_white);
        draw_set_alpha(tip_reveal);

        // Левая половина
		draw_surface_part_ext(
		    tip_surface,
		    _half_w - _reveal_w, 0,
		    _reveal_w, _surface_h,
		    _center_x - _reveal_w * _text_scale, _draw_y,
		    _text_scale, _text_scale,
		    c_white, tip_reveal
		);

		// Правая половина
		draw_surface_part_ext(
		    tip_surface,
		    _half_w, 0,
		    _reveal_w, _surface_h,
		    _center_x, _draw_y,
		    _text_scale, _text_scale,
		    c_white, tip_reveal
		);
    }
}


// ========================================
// 4. ВОССТАНОВЛЕНИЕ НАСТРОЕК DRAW
// ========================================

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
