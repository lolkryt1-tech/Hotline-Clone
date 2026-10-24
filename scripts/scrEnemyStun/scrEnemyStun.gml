function scrEnemyStun()
{
    // Отключаем ИИ и движение по путям
    speed = 0; 
    path_end();
    current_speed = 0;
    image_index += 0.25;
	
	if (my_target == noone) { scrEnemyTryGetTarget(); }
    
    if (sprite_index != sprColombianVestStun)
    {
        if (weapon != WEAPONS.UNARMED && instance_exists(my_target) && !scrHasClearView(x, y, my_target.x, my_target.y)) { state = STATES.SEARCH; exit; }
		if (weapon == WEAPONS.SNIPER) && instance_exists(my_target) { state = STATES.ATTACKHITSCAN; exit; }
        if (weapon != WEAPONS.UNARMED && instance_exists(my_target) && isRange_weapon == true) { state = STATES.ATTACKRANGE; exit; }
        if (weapon != WEAPONS.UNARMED && instance_exists(my_target) && isRange_weapon == false) { state = STATES.CHASE; exit; }
        if (weapon != WEAPONS.UNARMED) { state = STATES.STEP; exit; }
        
        state = STATES.UNARMEDSEARCH; exit; 
    }
    
    if (stun_current >= 100)
    {
        // Создаем объект оглушенного/лежачего врага
        var ko = instance_create_layer(x, y, "Instances", objEnemyKnockedOut);
        
        if (can_hear == 0) { instance_create_layer(x, y, "Instances", objHeadSet); }
		
		if (weapon != WEAPONS.UNARMED)
        {
            var _dropped = instance_create_layer(x, y, "Instances", objWeapon);
            _dropped.direction = irandom(360); 
            _dropped.speed = 8; 
            _dropped.my_angle = irandom(360); 
            _dropped.weapon = weapon;
            _dropped.ammo = ammo;
			
            weapon = WEAPONS.UNARMED; // Защита от спавна оружия каждый подкадр
        }
    
        // Передаем ему параметры для правильного отображения трупа/спрайта
        ko.sprite_index = sprColombianVestGetUp;
        ko.direction = last_hit_dir;
        ko.image_index = 1;
        ko.speed = 2;
        
        ko.my_angle = last_hit_dir - 180;
        ko.skin = skin;
        ko.class = class;
        ko.faction = faction;
        ko.sprite_index   = sprKnocked;
        ko.sprKnockedLean = sprKnockedLean;
        ko.sprDeadLeanMelee = sprDeadLeanMelee;
        ko.sprDeadLeanShotgun = sprDeadLeanShotgun;
        ko.sprDeadLeanMachinegun = sprDeadLeanMachinegun;
    
        // Уничтожаем самого активного врага
        instance_destroy();
    }
}