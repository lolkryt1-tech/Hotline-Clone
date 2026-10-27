depth = -7000;
image_speed = 0;
car_zone_width = 40;
car_zone_height = 40;
car_zone_active = false;      // Флаг, что игрок в зоне

push_timer = 0;
car_start_timer = 0;
has_been_pushed = false;

// 1. Смещение ВВЕРХ (к верхнему пассажирскому окну)
var _dist_side = 23;                   
var _angle_side = image_angle + 90;    

var _spawn_x = x + lengthdir_x(_dist_side, _angle_side);
var _spawn_y = y + lengthdir_y(_dist_side, _angle_side);

// 2. Смещение ВПЕРЕД (ближе к капоту, в зеленый круг)
var _dist_forward = 20;                
_spawn_x += lengthdir_x(_dist_forward, image_angle);
_spawn_y += lengthdir_y(_dist_forward, image_angle);

// Создаем дверь
var _door = instance_create_layer(_spawn_x, _spawn_y, "Instances", objCopCarDoor);
_door.base_angle = image_angle; 
_door.open_direction = -1; 

// Салон
var _floor = instance_create_layer(x, y, "Instances", objCopCarFloor);
_floor.image_angle = image_angle; 

// Багажник
var _trunk = instance_create_layer(x, y, "Instances", objCopCarTrunk);
_trunk.image_angle = image_angle; 
