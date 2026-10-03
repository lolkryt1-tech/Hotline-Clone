if (keyboard_check_pressed(vk_f1)) { global.debug = !global.debug; }

scrCopFlipShotgun(); 

scrPlayerAttack();
scrPlayerInteractWeapon();
scrPlayerStartExecution();


scrProcessShellSpawn();	// СПАВНИМ ГИЛЬЗУ ЗДЕСЬ ПОТОМУ ЧТО У ДРОБОВИКА ЗАДЕРЖКА ПЕРЕД СПАВНОМ ГИЛЬЗЫ

// 1. Получаем ввод (Вектор)
get_input = scrPlayerGetInput();

// 2. Считаем физику и двигаем тело по этому вектору
scrPlayerMovementPhysics(get_input);

// 3. Анимируем ног и ТОРСА, надо будет поменять название
scrPlayerAnimatedLegs(get_input);

// Follow Crosshair
my_angle = point_direction(x, y, objEffector.x, objEffector.y);



// GUI Физика пружины и затухания
icon_shake_angle = lerp(icon_shake_angle, 0, 0.25);

// Сделали остывание цвета НАМНОГО резче (с 0.08 подняли до 0.25 в такт остальному)
ammo_color_factor = lerp(ammo_color_factor, 0, 0.25);

// Оставляем твой резкий пульс масштаба
ammo_scale_pulse = lerp(ammo_scale_pulse, 0, 0.25);