function scrTriggerSpawnEnemy(_trigger)
{
    with (_trigger)
    {
        // Спавним врага
        var _enemy = instance_create_layer(spawn_x, spawn_y, "Instances", spawn_object);
        
        // Настраиваем
        _enemy.skin = spawn_skin;
        _enemy.class = spawn_class;
        _enemy.faction = FACTION.COLOMBIAN;
        _enemy.weapon = spawn_weapon;
        _enemy.ammo = spawn_ammo;
        _enemy.my_sprites = scrEnemyGetSprite(spawn_skin, spawn_weapon);
        _enemy.sprite_index = _enemy.my_sprites.sprites.walk;
        
        // Ставим состояние INVESTIGATE
        _enemy.state = STATES.INVESTIGATE;
        _enemy.noise_x = target_x;
        _enemy.noise_y = target_y;
        
        // my_target = noone, но noise_x/y ведут его
        _enemy.my_target = noone;
    }
}