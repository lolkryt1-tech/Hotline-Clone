image_speed = 0.5;
energie = 3;
life = 30;
depth = -1;

// Инициализируем переменную, чтобы игра не вылетала.
// Реальное значение прилетит либо из Creation Code комнаты, либо из буфера загрузки!
my_light = noone;


// Создаём свет
if (instance_exists(objLightController))
{
	// Передаем только чистый отступ (12), а x и y прибавляем снаружи
	var _front_x = x + lengthdir_x(32, image_angle);
	var _front_y = y + lengthdir_y(32, image_angle); 
	
	my_light = instance_create_layer(_front_x, _front_y, "Light", objLightSource);
	my_light.light_intensity = 1;
	my_light.light_scale = 1;
}
