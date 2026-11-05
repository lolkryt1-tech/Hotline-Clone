function scrPlayerGetInput()
{
    var _axis_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var _axis_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    // Если камера перевёрнута (180°), инвертируем обе оси,
    // чтобы управление оставалось "нормальным" на экране
    if (global.hard) {
        _axis_x *= -1;
        _axis_y *= -1;
    }

    return new Vector2(_axis_x, _axis_y);
}