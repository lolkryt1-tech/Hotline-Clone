depth = 100;
anim_time = 0;

// Цвета для градиента
color_base = make_color_rgb(30, 80, 130);   // Темно-синий
color_high = make_color_rgb(60, 120, 180);  // Светло-синий
color_pulse = 0; // 0..1 (будет меняться)

blobs = [];
var _count = 15; 

for (var i = 0; i < _count; i++) {
    array_push(blobs, {
        base_x: random_range(-150, 150),
        base_y: random_range(-150, 150),
        radius: random_range(100, 400),
        alpha: random_range(0.15, 0.5),
        phase_x: random(360),
        phase_y: random(360),
        speed_x: random_range(0.005, 0.02),
        speed_y: random_range(0.005, 0.02),
        amplitude: random_range(40, 120),
        
        // Пульсация радиуса
        radius_pulse_phase: random(360),
        radius_pulse_speed: random_range(0.01, 0.03),
        radius_pulse_amount: random_range(10, 30) // Насколько радиус меняется
    });
}