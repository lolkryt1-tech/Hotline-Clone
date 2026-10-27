// Ставим глубину: чуть-чуть впереди неба (100), но позади луны (90)
depth = 96;

// Запрещаем автоматическую смену кадров, мы будем управлять этим сами
image_speed = 0; 
// Выбираем случайный кадр из спрайта (если там несколько видов звезд)
image_index = irandom(sprite_get_number(sprite_index) - 1);

// Настройки плавности и времени
anim_time = 0;
twinkle_speed = random_range(0.01, 0.03); // Скорость жизни звезды

// Рандомизируем размеры
base_scale = random_range(0.4, 1.2);
max_scale  = base_scale * random_range(1.5, 2.2);

image_xscale = base_scale;
image_yscale = base_scale;
image_alpha = 0;
