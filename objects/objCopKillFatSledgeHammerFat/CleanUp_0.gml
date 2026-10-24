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
	    // Динамически определяем спрайт трупа в зависимости от скина
	    var _corpse_spr = sprColombianFatDeadSledgeHammer;
	    switch (enemy_skin)
	    {
	        case SKIN.COLOMBIANFAT:     _corpse_spr = sprColombianFatDeadSledgeHammer;     break;
	        case SKIN.COLOMBIANFATVEST: _corpse_spr = sprColombianFatVestDeadSledgeHammer; break;
	    }

	    var _enemy_corpse = instance_create_layer(x, y, "Instances", objDeadBody);
	    _enemy_corpse.sprite_index = _corpse_spr; // Применяем правильный спрайт
    
	    // Берем кадр врага прямо из текущего состояния анимации казни
	    _enemy_corpse.image_index  = enemy_image_index;
    
	    _enemy_corpse.my_angle     = my_angle;
	    _enemy_corpse.isExecuted   = true;
	    _enemy_corpse.skin         = enemy_skin;
	    _enemy_corpse.class        = enemy_class;
	}
	else
	{
	    // 2. Игрок не успел ударить -> враг выживает и падает в нокаут!
	    var _enemy_knocked = instance_create_layer(x, y, "Instances", objEnemyFatKnockedOut);
    
	    // Динамически выбираем спрайт нокаута в зависимости от скина
	    var _knocked_spr = sprColombianFatGetUp;
	    switch (enemy_skin)
	    {
	        case SKIN.COLOMBIANFAT:     _knocked_spr = sprColombianFatGetUp;     break;
	        case SKIN.COLOMBIANFATVEST: _knocked_spr = sprColombianFatVestGetUp; break;
	    }
    
	    _enemy_knocked.sprite_index = _knocked_spr; // Применяем спрайт
	    _enemy_knocked.skin        = enemy_skin;
	    _enemy_knocked.class       = enemy_class;
	    _enemy_knocked.faction     = enemy_faction;
	    _enemy_knocked.direction   = my_angle;
	    _enemy_knocked.my_angle    = my_angle - 180;
	    _enemy_knocked.image_index = 1;
	}
}
