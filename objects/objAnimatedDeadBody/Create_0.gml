image_speed = 0.35;
my_angle = 0;

alarm[0] = 95;

repeat(4)
{
	var _rand_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
	var _rand_dir = random(360);
	_rand_smoke.direction   = _rand_dir;
	_rand_smoke.image_angle = _rand_dir;
	_rand_smoke.speed       = random_range(0.5, 2);
}