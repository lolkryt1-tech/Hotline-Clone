function scrDrawPlayerSniperSight()
{
    // Если условия НЕ соблюдены — ищем свой лазер и уничтожаем его
    if (current_weapon != WEAPONS.SNIPER || attack_delay > 5) {
        with (objLaserSight) {
            if (owner_inst == other.id) {
                instance_destroy();
            }
        }
        return; // Выходим из функции, чтобы не создавать новый лазер
    }
    
    // Если условия соблюдены — проверяем, есть ли уже лазер
    var _has_laser = false;
    with (objLaserSight) {
        if (owner_inst == other.id) _has_laser = true;
    }

    // Если лазера нет — создаем
    if (!_has_laser) {
        var _laser = instance_create_layer(x, y, "Instances", objLaserSight);
        _laser.owner_inst = id;
        _laser.dir = my_angle;
        _laser.max_dist = 1200;
    }
}