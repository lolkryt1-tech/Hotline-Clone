function scrProcessShellSpawn()
{
    // ОПТИМИЗАЦИЯ: Если таймер равен -1 (выстрела не было) — выходим
    if (shell_ready_to_spawn == -1) exit; 

    // Если таймер ещё тикает, уменьшаем его и ждем следующего кадра
    if (shell_ready_to_spawn > 0)
    {
        shell_ready_to_spawn--;
        exit; 
    }

    // === ФАЗА СПАВНА ===
    if (my_sprites.shell_obj != noone)
    {
        // Математика один в один как в scrEnemyAttackRange:
		// Вместо 12 и 0 подставляем shell_x и shell_y из структуры my_sprites
		var _shell_x = x + lengthdir_x(my_sprites.shell_x, my_angle) + lengthdir_x(my_sprites.shell_y, my_angle - 90);
		var _shell_y = y + lengthdir_y(my_sprites.shell_x, my_angle) + lengthdir_y(my_sprites.shell_y, my_angle - 90);

		var _shell = instance_create_layer(_shell_x, _shell_y, "Instances", my_sprites.shell_obj);
		_shell.direction   = (my_angle - 110) + random_range(-15, 15);
		_shell.my_angle    = my_angle; 
		_shell.image_index = my_sprites.shell_img; 
		_shell.image_speed = 0;                    
	}
    
    // Выключаем таймер до следующего выстрела
    shell_ready_to_spawn = -1; 
}
