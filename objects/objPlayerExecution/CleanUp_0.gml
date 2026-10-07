if (global.is_cleaning_level == true ) exit;

// Находим живого игрока на карте
var _alive_player = instance_find(objPlayer, 0);

if (_alive_player != noone)
{
    // === СЦЕНАРИЙ А: КАЗНЬ ЗАВЕРШИЛАСЬ УСПЕШНО ===
    // Игрок жив, просто перенаправляем врагов обратно на него через наш коммутатор
	scrAddKillStats(1000, true);
    scrEnemyUpdateTargetID(id, _alive_player); 
}
else
{
    // === СЦЕНАРИЙ Б: ИГРОКА УБИЛИ ВО ВРЕМЯ КАЗНИ ===
    // Вся информация о жертве (enemy_skin, enemy_class, enemy_faction) берётся прямо из текущего инстанса казни
    
    if (triggered_hurt)
    {
        // 1. Удар уже нанесен -> враг мертв. Спавним честный мертвый труп
        var _enemy_corpse = instance_create_layer(x, y, "Instances", objDeadBody);
        _enemy_corpse.sprite_index = enemy_sprite;
        
        // ИСПРАВЛЕНО: Берем кадр врага прямо из текущего состояния анимации казни
        _enemy_corpse.image_index  = enemy_image_index; 
        
        _enemy_corpse.my_angle     = my_angle;
        _enemy_corpse.isExecuted   = true;
        _enemy_corpse.skin         = enemy_skin;
        _enemy_corpse.class        = enemy_class;
    }
    else
    {
        // 2. Игрок не успел ударить -> враг выживает и падает в нокаут!
        // Спавним объект летящего нокаута, как вы и просили
        var _enemy_knocked = instance_create_layer(x, y, "Instances", objEnemyKnockedOut);
        
        _enemy_knocked.skin        = enemy_skin;
        _enemy_knocked.class       = enemy_class;
        _enemy_knocked.faction     = enemy_faction;
        _enemy_knocked.direction   = my_angle; // Летит по направлению замаха
        _enemy_knocked.my_angle    = my_angle - 180;
        _enemy_knocked.image_index = 1;
    }
}
