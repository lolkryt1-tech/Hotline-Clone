if (speed == 0) { scrDrawBlood(); instance_destroy(); }

// 1. Логика высоты (Z-ось)
if (z > 0 || z_speed != 0) 
{
    z += z_speed;
    z_speed -= gravity_z;

    // Приземление на землю
    if (z <= 0) 
    {
        z = 0;
        z_speed = 0;
    }
}

// 2. Медленное вращение спрайта во время движения
if (speed > 0) 
{
    image_angle += rot_speed;
}

// 3. Столкновение с высокой стеной objSolidTall
var _next_x = x + lengthdir_x(speed, direction);
var _next_y = y + lengthdir_y(speed, direction);

if (place_meeting(_next_x, _next_y, objSolidTall))
{
    speed = 0;
}
