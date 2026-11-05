anim_time += 1;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _center_x = _gui_w * 0.5;
var _center_y = _gui_h * 0.15;

// Вычисляем текущий угол (против часовой стрелки — минус в синусе)
// Мы используем две разные частоты для X и Y, чтобы траектория была эллиптической (более живой)
var _angle_x = -anim_time * swing_speed;
var _angle_y = -anim_time * swing_speed * 0.7; 

// Текущие координаты
var _current_x = _center_x + sin(_angle_x) * swing_radius_x;
var _current_y = _center_y + cos(_angle_y) * swing_radius_y;

// Добавляем текущую позицию в начало массива шлейфа
array_insert(trail, 0, { x: _current_x, y: _current_y, alpha: 1.0 });

// Ограничиваем длину шлейфа
while (array_length(trail) > 15) {
    array_delete(trail, array_length(trail) - 1, 1);
}

// Обновляем альфу для шлейфа (чтобы он плавно исчезал)
for (var i = 1; i < array_length(trail); i++) {
    trail[i].alpha = max(0, 1.0 - (i / array_length(trail)));
}