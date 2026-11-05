depth = 40;
anim_time = 0;

beams = [];
var _count = 25; // Количество лучей
var _gui_w = display_get_gui_width();

for (var i = 0; i < _count; i++) {
    array_push(beams, {
        // Позиция по X (стартуем по всей ширине, чтобы сразу было красиво)
        x: random_range(-_gui_w, _gui_w), 
        
        // Скорость движения вправо (от 1 до 4 пикселей за кадр)
        speed: random_range(1.0, 4.0), 
        
        // Ширина луча
        width: random_range(30, 200), 
        
        // Базовая прозрачность
        alpha: random_range(0.03, 0.1), 
        
        // Цвет (фиолетовый, как на референсе)
        color: make_color_rgb(80, 30, 120), 
        
        // Параметры для пульсации (чтобы лучи дышали)
        pulse_speed: random_range(0.02, 0.05),
        pulse_phase: random(360)
    });
}