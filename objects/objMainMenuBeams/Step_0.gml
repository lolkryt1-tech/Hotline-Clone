anim_time += 1;
var _gui_w = display_get_gui_width();

for (var i = 0; i < array_length(beams); i++) {
    var _b = beams[i];
    
    // Двигаем вправо
    _b.x += _b.speed;
    
    // Если луч ушел за правый край (с учетом его ширины) — телепортируем влево
    if (_b.x - _b.width > _gui_w) {
        _b.x = -_b.width - random_range(50, 500); // Появляется далеко слева
        _b.speed = random_range(1.0, 4.0);       // Меняем скорость для разнообразия
        _b.width = random_range(30, 200);
        _b.alpha = random_range(0.03, 0.1);
    }
}