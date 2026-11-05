var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _center_x = _gui_w * 0.5;
var _center_y = _gui_h * 0.5;

// 1. Базовый черный фон
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// 2. Вычисляем текущий цвет на основе пульсации
// Плавно переходим от базового к светлому и обратно
var _current_color = merge_color(color_base, color_high, color_pulse);

var _segments = 32;

for (var i = 0; i < array_length(blobs); i++) {
    var _b = blobs[i];
    
    var _bx = _center_x + _b.base_x + _b.offset_x;
    var _by = _center_y + _b.base_y + _b.offset_y;
    
    // Используем радиус с учетом пульсации
    var _r = _b.radius_current; 
    
    draw_primitive_begin(pr_trianglefan);
    // В центре цвет с текущим градиентом и альфой капли
    draw_vertex_color(_bx, _by, _current_color, _b.alpha);
    
    for (var j = 0; j <= _segments; j++) {
        var _angle = (j / _segments) * pi * 2;
        var _px = _bx + cos(_angle) * _r;
        var _py = _by + sin(_angle) * _r;
        
        // Края прозрачные
        draw_vertex_color(_px, _py, _current_color, 0.0);
    }
    draw_primitive_end();
}