if (!place_free(x, y))
{
    my_id = instance_create_layer(x, y, "Instances", objBloodSplat);
	my_id.direction = (direction - 170) + random(10);
	my_id.speed = 1;
	my_id.image_angle = my_id.direction;
	my_id.image_xscale = 0.8 + random(0.2);
	my_id.image_yscale = my_id.image_xscale;
}