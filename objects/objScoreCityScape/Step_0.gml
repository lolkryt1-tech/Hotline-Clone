// Обновляем фазу покачивания и перелива цвета для каждого здания индивидуально
var _len = array_length(buildings_array);
for (var i = 0; i < _len; i++) {
    // Скорость wave_speed (0.01 - 0.025) отлично подходит для плавного изменения цвета
    buildings_array[i].wave_time += buildings_array[i].wave_speed;
}
