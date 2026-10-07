repeat (2 + random(2))
{
    my_id = instance_create_layer(objEffector.x, objEffector.y, "Instances", objEnemyColombian);
    my_id.image_angle = (my_angle - 180) + random(20);
	my_id.direction = my_angle;
}