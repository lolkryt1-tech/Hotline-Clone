/*
instance_create_layer(x, y, "Instances", objHeadSet);

// 1. Создаем упавшее оружие, которое бросил игрок
var _dropped_weapon = instance_create_layer(x, y, "Instances", objWeapon);
_dropped_weapon.weapon = other.weapon;

// Сохраняем направление полета летящего оружия в локальную переменную ДО его удаления
var _weapon_flight_dir = other.direction; 

// Уничтожаем летящее оружие
instance_destroy(other);

// 2. Создаем сбитого с ног врагаК
var _knocked = instance_create_layer(x, y, "Instances", objEnemyKnockedOut);

// ИСПРАВЛЕНО: Враг летит ТУДА ЖЕ, куда летело оружие
_knocked.direction = _weapon_flight_dir; 
_knocked.speed = 4;

// ИСПРАВЛЕНО: Угол спрайта врага разворачивается по направлению падения
_knocked.my_angle = _weapon_flight_dir - 180; 

_knocked.image_index = 1;
_knocked.faction = faction;
_knocked.class = class;
				
// 3. Если у врага в руках было свое оружие, оно вылетает в случайную сторону
if (weapon != WEAPONS.UNARMED)
{
	var _dropped = instance_create_layer(x, y, "Instances", objWeapon);
	_dropped.direction = irandom(360);
	_dropped.speed = 5;
	
	_dropped.my_angle = irandom(360);
	_dropped.weapon = weapon;
}
				
// Удаляем живого врага
instance_destroy(); 
