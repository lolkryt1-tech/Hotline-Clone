hit_count++;

// === ИСПРАВЛЕНО: Если бьем ТРУБОЙ, то удар сразу засчитывается за три ===
if (weapon == WEAPONS.PIPE)
{
    hit_count = 3;
}

objEffector.shake = 1.5;

var _dist = 20; 
	
// Правильный расчет точки головы по направлению взгляда
var _head_offset_x = x + lengthdir_x(_dist, my_angle);
var _head_offset_y = y + lengthdir_y(_dist, my_angle); 

// Спавним 3 сквирта
repeat(3)
{
    var _random_direction = my_angle + irandom_range(-90, 90);
    var _squirt = instance_create_layer(_head_offset_x, _head_offset_y, "Instances", objBloodSquirt);
    _squirt.direction   = _random_direction;
    _squirt.image_angle = _random_direction;
}

// Спавним 4 облака дыма крови
repeat (4)
{
    my_id = instance_create_layer(_head_offset_x, _head_offset_y, "Instances", objBloodSmoke);
    var _smoke_direction = my_angle + irandom_range(-90, 90);
    my_id.direction = _smoke_direction;
    my_id.image_angle = my_id.direction;
    my_id.speed = random(2);
}
