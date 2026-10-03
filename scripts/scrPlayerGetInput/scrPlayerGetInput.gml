function scrPlayerGetInput()
{
	var _axis_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var _axis_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    return new Vector2(_axis_x, _axis_y);
}