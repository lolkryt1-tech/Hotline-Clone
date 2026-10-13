if (startspeed == 0)
    startspeed = speed;

if (is_white_wall == true) { image_blend = merge_color(c_ltgray, c_white, speed * (1 / startspeed)); }
image_angle += rotspeed;

if (speed == 0)
{
	scrDrawBlood();
}
