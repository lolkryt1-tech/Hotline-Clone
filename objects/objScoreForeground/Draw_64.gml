var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _center_x = _gui_w * 0.5;
var _horizon_y = _gui_h * 0.5;

var _neon_pink   = make_color_rgb(255, 0, 128);    // Розовый неон для сетки
var _road_dark   = make_color_rgb(15, 5, 25);      // Темный асфальт трассы
var _void_black  = make_color_rgb(5, 2, 10);       // Черная основа обочин
var _neon_cyan   = make_color_rgb(0, 255, 255);    // Бирюзовые борта

// Прокрутку сетки берем из бэкграунда
var _scroll = 0;
if (instance_exists(objScoreBackGround)) {
    _scroll = objScoreBackGround.grid_scroll;
}

// ==========================================
// ГЕОМЕТРИЯ ДОРОГИ С СУЖЕНИЕМ К ЦЕНТРУ
// ==========================================
// ИЗМЕНЕНИЕ: Вместо полного радиуса луны делаем верхушку узкой (45 пикселей от центра),
// чтобы трасса элегантно сходилась к солнцу
var _road_w_top = 45; 
var _road_w_bot = _center_x; 

var _rx1 = _center_x - _road_w_top; // Верхний левый (у солнца)
var _rx2 = _center_x + _road_w_top; // Верхний правый (у солнца)
var _rx3 = _gui_w;                  // Нижний правый (точно в угол)
var _rx4 = 0;                       // Нижний левый (точно в угол)

// ==========================================
// СЛОЙ 1. ЧЕРНЫЕ ОБОЧИНЫ (ЗА ДОРОГОЙ)
// ==========================================
draw_set_alpha(1);
draw_set_color(_void_black);
draw_rectangle(0, _horizon_y, _gui_w, _gui_h, false);

// ==========================================
// СЛОЙ 2. ПОЛОТНО ДОРОГИ
// ==========================================
draw_set_color(_road_dark);
draw_primitive_begin(pr_trianglefan);
draw_vertex(_rx1, _horizon_y);
draw_vertex(_rx2, _horizon_y);
draw_vertex(_rx3, _gui_h);
draw_vertex(_rx4, _gui_h);
draw_primitive_end();

// ==========================================
// СЛОЙ 3. ДВИЖУЩАЯСЯ НЕОНОВАЯ СЕТКА (СТРОГО ВНУТРИ ДОРОГИ)
// ==========================================
var _lines = 16;

// 3.1. Горизонтальные линии (динамически обрезаются по краям сужающейся дороги)
for (var i = 1; i <= _lines; i++) {
    var _t = (i / _lines) + _scroll;
    if (_t > 1.0) _t -= 1.0;
    
    var _line_y = _horizon_y + (_gui_h - _horizon_y) * power(_t, 2.5);
    
    if (_line_y >= _horizon_y) {
        // Вычисляем ширину дороги именно на этой высоте _line_y
        var _current_w = lerp(_road_w_top, _road_w_bot, power(_t, 2.5));
        
        var _lx1 = _center_x - _current_w;
        var _lx2 = _center_x + _current_w;
        
        draw_set_alpha(lerp(0.0, 0.6, _t));
        draw_set_color(_neon_pink);
        draw_line_width(_lx1, _line_y, _lx2, _line_y, 1.5);
    }
}

// 3.2. Вертикальные продольные линии дороги (схождение веером к центру солнца)
draw_set_alpha(0.25);
draw_set_color(_neon_pink);
var _lanes = 8; 
for (var i = 1; i < _lanes; i++) {
    var _road_t = i / _lanes;
    
    var _x_top = lerp(_rx1, _rx2, _road_t);
    var _x_bot = lerp(_rx4, _rx3, _road_t);
    
    draw_line_width(_x_top, _horizon_y, _x_bot, _gui_h, 1);
}

// ==========================================
// СЛОЙ 4. СВЕТЯЩИЕСЯ БОРТИКИ ДОРОГИ (CYAN НЕОН В УГЛЫ)
// ==========================================
draw_set_color(_neon_cyan);

// Мягкий Bloom-эффект размытия бортов
for(var i = 1; i <= 5; i++) {
    draw_set_alpha(0.25 / i);
    var _glow_thickness = i * 6;
    draw_line_width(_rx1, _horizon_y, _rx4, _gui_h, _glow_thickness); 
    draw_line_width(_rx2, _horizon_y, _rx3, _gui_h, _glow_thickness); 
}

// Плотная неоновая основа бортов
draw_set_alpha(0.8);
draw_line_width(_rx1, _horizon_y, _rx4, _gui_h, 8); 
draw_line_width(_rx2, _horizon_y, _rx3, _gui_h, 8);

// Белое ослепительное ядро
draw_set_alpha(1);
draw_line_width_color(_rx1, _horizon_y, _rx4, _gui_h, 3, c_white, c_white);
draw_line_width_color(_rx2, _horizon_y, _rx3, _gui_h, 3, c_white, c_white);

// Полный сброс альфы
draw_set_alpha(1);
