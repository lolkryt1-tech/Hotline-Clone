var _screen_cx = display_get_gui_width() / 2;
var _screen_cy = display_get_gui_height() / 2;

// Масштаб надписи
var _sc = 2.5; 

// Фирменные цвета
var _c_cyan  = make_color_rgb(0, 240, 210);  
var _c_black = c_black;

var _spr_w = 222;
var _spr_h = 11;
var _start_x = _screen_cx - ((_spr_w * _sc) / 2);
var _start_y = _screen_cy - ((_spr_h * _sc) / 2) - 100;
var _slice_h = 1; 

// =========================================================================
// СЛОЙ 1: ЧЁРНАЯ ОБВОДКА ПО ПЕРИМЕТРУ (Слегка прозрачная подложка)
// =========================================================================
random_set_seed(timer); 
for (var _yy = 0; _yy < _spr_h; _yy += _slice_h)
{
    var _current_slice_h = min(_slice_h, _spr_h - _yy);
    var _vhs_line_shift = 0;
    if (random(100) < 8) _vhs_line_shift = choose(-1.5, -1, 1, 1.5);
    
    var _draw_x = _start_x + (_vhs_line_shift * _sc);
    var _draw_y = _start_y + (_yy * _sc);

    for (var _ox = -2; _ox <= 2; _ox += 2) {
        for (var _oy = -2; _oy <= 2; _oy += 2) {
            // Умножаем на 0.85, чтобы чёрный контур мягко просвечивал
            draw_sprite_part_ext(sprite_index, image_index, 0, _yy, _spr_w, _current_slice_h, _draw_x + _ox - (split_offset * _sc), _draw_y + _oy, _sc, _sc, _c_black, gui_alpha * 0.85);
            draw_sprite_part_ext(sprite_index, image_index, 0, _yy, _spr_w, _current_slice_h, _draw_x + _ox + (split_offset * _sc), _draw_y + _oy, _sc, _sc, _c_black, gui_alpha * 0.85);
        }
    }
}

// =========================================================================
// СЛОЙ 2: БИРЮЗОВЫЙ НЕОНОВЫЙ ОРЕОЛ (Приглушённый неон)
// =========================================================================
random_set_seed(timer); 
for (var _yy = 0; _yy < _spr_h; _yy += _slice_h)
{
    var _current_slice_h = min(_slice_h, _spr_h - _yy);
    var _vhs_line_shift = 0;
    if (random(100) < 8) _vhs_line_shift = choose(-1.5, -1, 1, 1.5);
    
    var _draw_x = _start_x + (_vhs_line_shift * _sc);
    var _draw_y = _start_y + (_yy * _sc);

    // Умножаем на 0.8, чтобы бирюзовое свечение выглядело более стеклянным
    draw_sprite_part_ext(sprite_index, image_index, 0, _yy, _spr_w, _current_slice_h, _draw_x - 1 - (split_offset * _sc), _draw_y, _sc, _sc, _c_cyan, gui_alpha * 0.8);
    draw_sprite_part_ext(sprite_index, image_index, 0, _yy, _spr_w, _current_slice_h, _draw_x + 1 + (split_offset * _sc), _draw_y, _sc, _sc, _c_cyan, gui_alpha * 0.8);
}

// =========================================================================
// СЛОЙ 3: ЦЕНТРАЛЬНАЯ БЕЛАЯ СЕРДЦЕВИНА (Ещё более полупрозрачная)
// =========================================================================
random_set_seed(timer); 
for (var _yy = 0; _yy < _spr_h; _yy += _slice_h)
{
    var _current_slice_h = min(_slice_h, _spr_h - _yy);
    var _vhs_line_shift = 0;
    if (random(100) < 8) _vhs_line_shift = choose(-1.5, -1, 1, 1.5);
    
    var _draw_x = _start_x + (_vhs_line_shift * _sc);
    var _draw_y = _start_y + (_yy * _sc);

    // Снизили с 0.7 до 0.55 для красивого эффекта прозрачности букв изнутри
    draw_sprite_part_ext(sprite_index, image_index, 0, _yy, _spr_w, _current_slice_h, _draw_x, _draw_y, _sc, _sc, c_white, gui_alpha * 0.55);
}

randomise();
