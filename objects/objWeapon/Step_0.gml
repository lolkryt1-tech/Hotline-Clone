if (speed > 0) 
{

    // Вращение спрайта в полёте
    my_angle += speed * 0.25; 

    // Расчет шага полёта на текущем кадре
    var _hspd = lengthdir_x(speed, direction);
    var _vspd = lengthdir_y(speed, direction);

    // Массив объектов коллизии (стены и двери)
    var _blocks = [objSolidTall, objDoor];

    // Проверяем: если на этом шаге мы во что-то врежемся
    if (place_meeting(x + _hspd, y + _vspd, _blocks))
    {
		speed = 0;
        audio_play_sound(sndKnock, 1, false);
    }
}


hover_timer += 0.05; 
if (weapon == WEAPONS.KNIFE)	{ image_index = 0; weapon_type = TYPE.MELEE; }
if (weapon == WEAPONS.BAT)		{ image_index = 1; weapon_type = TYPE.MELEE; }
if (weapon == WEAPONS.PIPE)		{ image_index = 2; weapon_type = TYPE.MELEE; }
if (weapon == WEAPONS.PISTOL)	{ image_index = 3; weapon_type = TYPE.RANGE; }
if (weapon == WEAPONS.SHOTGUN)  { image_index = 4; weapon_type = TYPE.RANGE; }
if (weapon == WEAPONS.M16)		{ image_index = 5; weapon_type = TYPE.RANGE; }