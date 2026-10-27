var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _moon_x = _gui_w * 0.5;
var _moon_y = _gui_h * 0.5;

// Используем anim_time для пульсации (значение от 0 до 1)
var _pulse = (sin(anim_time) + 1) * 0.5; 

var _color_top = make_color_rgb(255, 200 + (55 * _pulse), 50);
var _color_bot = make_color_rgb(255, 50, 150);

// 1. ПУЛЬСИРУЮЩЕЕ СВЕЧЕНИЕ
var _glow_steps = 10;        
// Радиус свечения пульсирует от 40 до 80 пикселей
var _glow_max_radius = 40 + (40 * _pulse);   

for (var i = 0; i < _glow_steps; i++) {
    var _step_progress = (i + 1) / _glow_steps; 
    var _glow_radius = moon_radius + (_glow_max_radius * _step_progress);
    
    // Яркость свечения тоже пульсирует (от 0.05 до 0.15)
    var _base_alpha = 0.05 + (0.1 * _pulse);
    var _glow_alpha = _base_alpha * (1 - _step_progress); 
    
    draw_set_alpha(_glow_alpha);
    draw_set_color(_color_bot);
    
    // Рисуем верхнюю половину свечения
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(_moon_x, _moon_y, _color_bot, _glow_alpha); 
    
    var _segments = 32;
    for (var j = 0; j <= _segments; j++) {
        var _angle = pi + (j / _segments) * pi; 
        var _px = _moon_x + cos(_angle) * _glow_radius;
        var _py = _moon_y + sin(_angle) * _glow_radius;
        
        draw_vertex_color(_px, _py, _color_bot, _glow_alpha);
    }
    draw_primitive_end();
}

// 2. САМА ЛУНА (ВЕРХНЯЯ ПОЛОВИНА)
draw_set_alpha(1); 
draw_primitive_begin(pr_trianglefan);
draw_vertex_color(_moon_x, _moon_y, _color_bot, 1);

var _segments = 64;
for (var i = 0; i <= _segments; i++) {
    var _angle = pi + (i / _segments) * pi; 
    
    var _px = _moon_x + cos(_angle) * moon_radius;
    var _py = _moon_y + sin(_angle) * moon_radius;
    
    var _t = (sin(_angle) + 1) * 0.5; 
    var _c = merge_color(_color_top, _color_bot, _t);
    draw_vertex_color(_px, _py, _c, 1);
}
draw_primitive_end();

// 3. ОТРАЖЕНИЕ (тоже пульсирует)
for (var i = 0; i < 15; i++) {
    var _ref_y = _moon_y + (i * 12); 
    // Прозрачность отражения зависит от пульсации
    var _alpha = (0.2 + (0.1 * _pulse)) * (1 - (i / 15)); 
    var _wobble = sin(current_time / 300 + i) * 4; 
    
    var _ref_width = (moon_radius * 1.0) * (1 - (i / 18));
    
    draw_set_alpha(_alpha);
    draw_set_color(merge_color(_color_top, _color_bot, 0.8));
    draw_rectangle(_moon_x - _ref_width + _wobble, _ref_y, _moon_x + _ref_width + _wobble, _ref_y + 8, false);
}
draw_set_alpha(1);