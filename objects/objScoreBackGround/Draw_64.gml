var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _center_x = _gui_w * 0.5;
var _horizon_y = _gui_h * 0.5;

var _neon_pink   = make_color_rgb(255, 0, 128);    
var _space_blue  = make_color_rgb(10, 24, 45);     

// ==========================================
// СЛОЙ 1. НЕБО С РАДИАЛЬНЫМ ЭФФЕКТОМ ЗАКАТА
// ==========================================
draw_set_color(_space_blue);
draw_rectangle(0, 0, _gui_w, _horizon_y, false);

draw_set_alpha(1);
draw_primitive_begin(pr_trianglefan);
draw_vertex_color(_center_x, _horizon_y, _neon_pink, 1); 

var _sky_segments = 32;
var _glow_radius = _gui_w * 0.6; 

for (var i = 0; i <= _sky_segments; i++) {
    var _angle = pi + (i / _sky_segments) * pi; 
    var _px = _center_x + cos(_angle) * _glow_radius;
    var _py = _horizon_y + sin(_angle) * _glow_radius * 0.7; 
    draw_vertex_color(_px, _py, _space_blue, 0); 
}
draw_primitive_end();
draw_set_alpha(1);

// ==========================================
// СЛОЙ 2. ЛУНА И ЕЁ СОБСТВЕННОЕ СВЕЧЕНИЕ
// ==========================================
if (instance_exists(objScoreMoon)) {
    with (objScoreMoon) {
        var _moon_x = _gui_w * 0.5;
        var _moon_y = _gui_h * 0.5;
        var _pulse = (sin(anim_time) + 1) * 0.5; 
        var _color_top = make_color_rgb(255, 200 + (55 * _pulse), 50);
        var _color_bot = make_color_rgb(255, 50, 150);

        var _glow_steps = 10;        
        var _glow_max_radius = 40 + (40 * _pulse);   

        for (var i = 0; i < _glow_steps; i++) {
            var _step_progress = (i + 1) / _glow_steps; 
            var _glow_radius = moon_radius + (_glow_max_radius * _step_progress);
            var _base_alpha = 0.05 + (0.1 * _pulse);
            var _glow_alpha = _base_alpha * (1 - _step_progress); 
            
            draw_set_alpha(_glow_alpha);
            draw_set_color(_color_bot);
            
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
    }
}
draw_set_alpha(1);
