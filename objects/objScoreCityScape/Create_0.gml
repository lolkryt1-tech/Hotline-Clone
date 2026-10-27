depth = 94;

// Базовые настройки покачивания горизонта
_wave_amplitude = 6;  // Максимальный ход вверх-вниз в пикселях

// Ширина одного здания для размножения по горизонту
city_width = sprite_get_width(scrScoreSkyScape);
var _gui_w = display_get_gui_width();

// Вычисляем, сколько зданий поместится на экране с запасом
var _scale_x = 0.55;
var _scaled_width = city_width * _scale_x;
var _needed_buildings = ceil(_gui_w / _scaled_width) + 2; 

// Генерируем массив зданий (Сюда записываются индивидуальные настройки для каждого дома)
buildings_array = array_create(_needed_buildings);

// Находим общее количество кадров в спрайте зданий для рандомизации
var _subimages_count = sprite_get_number(scrScoreSkyScape);

for (var i = 0; i < _needed_buildings; i++) {
    buildings_array[i] = {
        // Базовая X позиция по цепочке на горизонте
        base_x: i * _scaled_width,
        
        // Рандомный разворот здания: 1 (нормально) или -1 (отзеркалено)
        x_scale_sign: choose(1, -1),
        
        // Уникальное начальное смещение по времени, чтобы здания качались вразнобой
        wave_time: random(100),
        
        // Уникальная скорость покачивания для конкретно этого здания
        wave_speed: random_range(0.01, 0.025),
        
        // РАНДОМИЗАЦИЯ КАДРА: выбираем случайный индекс от 0 до максимума
        img_index: irandom(_subimages_count - 1)
    };
}
