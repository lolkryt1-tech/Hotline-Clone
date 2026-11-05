friction = 0.15;
rotspeed = (-1 + (round(random(1)) * 2)) * random(8);
startspeed = 0;
image_speed = 0;
image_angle = random(360);
image_index = floor(random(10000));
deadlined = 0;
mode = 0;

is_white_wall = true;

blend_start = c_white;  // Цвет, когда обломок только вылетел
blend_end = c_ltgray;   // Цвет, когда обломок остановился
