if (keyboard_check_pressed(vk_f1)) { global.debug = !global.debug; energy += 1000; }

if (active == false) return;


// УНИКАЛЬНОЕ ДЛЯ КОПА
scrCopFlipShotgun(); 
scrPlayerThrowableHandler();

// УНИВЕРСАЛЬНОЕ
scrPlayerAttack();
scrPlayerInteractWeapon();
scrPlayerStartExecution();

scrProcessShellSpawn();	// СПАВНИМ ГИЛЬЗУ ЗДЕСЬ ПОТОМУ ЧТО У ДРОБОВИКА ЗАДЕРЖКА ПЕРЕД СПАВНОМ ГИЛЬЗЫ

// 1. Получаем ввод (Вектор)
get_input = scrPlayerGetInput();

// 2. Считаем физику и двигаем тело по этому вектору
scrPlayerMovementPhysics(get_input);

// 3. Анимируем ног и ТОРСА, надо будет поменять название, пока что впадлу
scrPlayerAnimatedLegs(get_input);

// Follow Crosshair
my_angle = point_direction(x, y, objEffector.x, objEffector.y);



// АНИМАЦИЯ ДЛЯ ХУДА ПАТРОНОВ
icon_shake_angle = lerp(icon_shake_angle, 0, 0.25);
ammo_color_factor = lerp(ammo_color_factor, 0, 0.25);
ammo_scale_pulse = lerp(ammo_scale_pulse, 0, 0.25);