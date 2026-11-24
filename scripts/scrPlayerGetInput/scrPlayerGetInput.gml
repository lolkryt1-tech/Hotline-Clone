function scrPlayerGetInput()
{
	var _axis_x = scrBindCheck("move_right") - scrBindCheck("move_left");
	var _axis_y = scrBindCheck("move_back") - scrBindCheck("move_forward");

    // Если включён хардмод, то камера перевёрнута, инвертируем обе оси,
    // чтобы управление оставалось "нормальным" на экране
    if (global.hard) {
        _axis_x *= -1;
        _axis_y *= -1;
    }

    return new Vector2(_axis_x, _axis_y);
}