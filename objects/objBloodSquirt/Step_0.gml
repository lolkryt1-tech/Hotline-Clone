if (sprite_index == sprBloodSquirt1)
{
    if (round(random(12)) == 2)
    {
        my_id = instance_create_layer(x + lengthdir_x(6 + abs(lengthdir_y(24 * image_xscale, dir)), image_angle), y + lengthdir_y(6 + abs(lengthdir_y(24 * image_xscale, dir)), image_angle), "Instances", objBloodSmudge);
        my_id.speed = random(1);
		my_id.direction = direction;
        my_id.image_angle = (image_angle - 5) + random(10);
    }
	
    repeat (random(2))
    {
        my_id = instance_create_layer(((x + lengthdir_x(3 + abs(lengthdir_y(12 * image_xscale, dir)), image_angle)) - 7) + random(14), ((y + lengthdir_y(3 + abs(lengthdir_y(12 * image_xscale, dir)), image_angle)) - 7) + random(14), "Instances", objBloodSpeck);
        my_id.image_angle = (image_angle - 5) + random(10);
        my_id.image_index = random(3);
		my_id.direction = direction;
    }
	
}

if (sprite_index == sprBloodSquirt2)
{
    if (round(random(20)) == 2 && dir < 150)
    {
        my_id = instance_create_layer(x + lengthdir_x(3 + abs(lengthdir_y(12 * image_xscale, dir)), image_angle), y + lengthdir_y(3 + abs(lengthdir_y(12 * image_xscale, dir)), image_angle), "Instances", objBloodSmudge);
        my_id.speed = random(1);
		my_id.direction = direction;
        my_id.image_angle = (image_angle - 5) + random(10);
    }
    
    repeat (random(2))
    {
        my_id = instance_create_layer(((x + lengthdir_x(3 + abs(lengthdir_y(12 * image_xscale, dir)), image_angle)) - 7) + random(14), ((y + lengthdir_y(3 + abs(lengthdir_y(12 * image_xscale, dir)), image_angle)) - 7) + random(14), "Instances", objBloodSpeck);
        my_id.image_angle = (image_angle - 7) + random(14);
        my_id.image_index = random(3);
		my_id.direction = direction;
    }
}

dir += (image_speed * 16);
image_blend = merge_color(c_red, c_maroon, 0.8);