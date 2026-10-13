function scrEnemyStun()
{
    // Отключаем ИИ и движение по путям
    speed = 0; 
    path_end();
    current_speed = 0;
    image_index += 0.25;
    
 // --- СПАВН ИСКР ОТ ЖИЛЕТА (РАЗОК ПРИ ПОПАДАНИИ) ---
    if (should_spark == true)
    {
        var _spark_count = 4 + irandom(3); // От 4 до 7 штук
        
        repeat (_spark_count)
        {
            var _random_deviation = random_range(-15, 15);
            var _spark = instance_create_layer(x, y, "Instances", objElectricSpark);
            
            // Направление искр = противоположное от удара (-180) + небольшой рандом
            _spark.direction   = (last_hit_dir - 180) + _random_deviation;
            _spark.image_angle = _spark.direction;
            _spark.speed       = 2 + random(3);
        }
        
        // Включаем таймер вспышки круга на 3 кадра
        spark_flash = 3;
        
        // Сразу выключаем, чтобы искры и таймер сработали только один раз за попадание
        should_spark = false;
    }
    
    if (sprite_index != sprColombianVestStun)
    {
        if (weapon != WEAPONS.UNARMED && instance_exists(my_target) && !scrHasClearView(x, y, my_target.x, my_target.y)) { state = STATES.SEARCH; exit; }
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