global.decals_render_counter--;
depth = global.decals_render_counter;

alarm[0] = 60;

// Базовые настройки движения по полу
direction = 0;              // Зададим при спавне (вылет вбок из пушки)
speed = random_range(1.5, 3); // Скорость ленивого полета вбок
image_speed = 0;            
image_angle = random(360);     // Собственный угол вращения
rot_speed = random_range(10, 25) * choose(-1, 1); // Скорость вращения в полете

// ФИЗИКА ВЫСОТЫ (Имитация 3D вылета)
z = 0;                      // Высота над полом (0 - лежит на полу)
z_speed = random_range(2, 3); // Стартовая скорость взлета ВВЕРХ
gravity_z = 0.35;            // Сила гравитации, тянущая гильзу вниз
bounce_count = 0;           // Счетчик отскоков от пола
max_bounces = random_range(2, 3);            // Сколько раз гильза отскочит, прежде чем успокоиться