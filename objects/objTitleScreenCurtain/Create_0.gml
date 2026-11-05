// Скорость движения шторки, пикселей в секунду
curtain_speed = 1400;

// Текущее положение переднего края
curtain_x = -200;

// Таймер ожидания (в секундах)
curtain_timer = 6.0;

// Состояние шторки
curtain_active = false;
curtain_finished = false;
sprite_prefetch(sprScreenCurtain);
