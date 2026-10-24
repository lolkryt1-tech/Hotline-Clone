/// @function scrEnemyLaserHandler()
function scrEnemyLaserHandler()
{
    // Если это не снайпер или он не в режиме снайперской атаки — гасим лазер
    if (state != STATES.ATTACKHITSCAN)
    {
        // Если лазер существует, плавно уменьшаем его альфу
        if (instance_exists(laser_sight)) 
        {
            laser_alpha = max(laser_alpha - 0.05, 0);
            
            // Передаем альфу в лазер
            laser_sight.draw_alpha = laser_alpha;
            
            // Если альфа упала до нуля — уничтожаем лазер
            if (laser_alpha <= 0) {
                with (laser_sight) { instance_destroy(); }
                laser_sight = noone;
            }
        }
    }
    
    // Если мы в режиме ATTACKHITSCAN, но лазер по какой-то причине не создан — создаем его
    if (state == STATES.ATTACKHITSCAN)
    {
        if (!instance_exists(laser_sight)) {
            laser_sight = instance_create_layer(x, y, "Instances", objLaserSight);
            laser_sight.owner_inst = id;
            laser_alpha = 0; // Сбрасываем альфу при создании
        }
    }
}