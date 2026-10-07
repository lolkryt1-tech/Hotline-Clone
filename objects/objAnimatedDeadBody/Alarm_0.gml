var _offset_dist = 48;  // Смещение вперед вдоль тела врага

var _head_x = x + lengthdir_x(_offset_dist, my_angle);
var _head_y = y + lengthdir_y(_offset_dist, my_angle);

repeat(4) 
{
	var _direction = (my_angle) + random_range(-30, 30);
	
	// ИСПРАВЛЕНО: Добавлен знак равенства (=)
	var _squirt = instance_create_layer(_head_x, _head_y, "Instances", objBloodSquirt);
	_squirt.image_angle = _direction;
	_squirt.direction   = _direction;
}

// ИСПРАВЛЕНО: Добавлен знак равенства (=)
var _deadBody = instance_create_layer(x, y, "Instances", objDeadBody);
_deadBody.sprite_index = sprite_index;
_deadBody.image_index = image_index
_deadBody.my_angle = my_angle;
_deadBody.go_splat = false;

_deadBody.blood_pool_forward_offset = 46; 
_deadBody.blood_pool_scale_override = 0.5;

instance_destroy();
