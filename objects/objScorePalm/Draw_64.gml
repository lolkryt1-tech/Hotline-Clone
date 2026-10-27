var _gui_h = display_get_gui_height();
var _horizon_y = _gui_h * 0.5;

var _color_palm = make_color_rgb(0, 255, 200); 
var _color_glitch = make_color_rgb(255, 50, 150);

var _spr_w = sprite_get_width(sprScorePalmTree);
var _spr_h = sprite_get_height(sprScorePalmTree);

// Текущий масштаб из Step
var _scale = scale_var; 

// Позиция отрисовки
var _draw_y = y - (_spr_h * _scale); // Привязываем низ спрайта к координате y

// Отрезаем нижнюю часть (чтобы не вылезали за низ экрана, если нужно)
var _visible_h = _spr_h; 

// Рисуем розовую тень
// Рисуем розовую тень (последний аргумент теперь image_alpha)
draw_sprite_part_ext(sprScorePalmTree, image_index, 0, 0, _spr_w, _visible_h, x + 4, _draw_y, image_xscale * _scale, _scale, _color_glitch, image_alpha);

// Рисуем бирюзовую основу (последний аргумент теперь image_alpha)
draw_sprite_part_ext(sprScorePalmTree, image_index, 0, 0, _spr_w, _visible_h, x, _draw_y, image_xscale * _scale, _scale, _color_palm, image_alpha);
