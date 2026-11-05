if (startspeed == 0)
    startspeed = speed;

// Теперь это работает универсально для любого переданного цвета
image_blend = merge_color(blend_end, blend_start, speed * (1 / startspeed)); 

image_angle += rotspeed;

if (speed == 0)
{
	scrDrawBlood();
}
