image_angle += (diradd * speed * 6);

if (place_meeting(x, y, objSolidTall))
    speed = 0;

if (speed == 0)
{
	scrDrawBlood();
}
