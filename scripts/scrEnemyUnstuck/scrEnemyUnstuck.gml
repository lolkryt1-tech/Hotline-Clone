/// @desc Плавно выталкивает врага из стен наружу, если он застрял
function scrEnemyUnstuck()
{
    // Если маска врага прямо сейчас физически пересекается со стеной
    if (place_meeting(x, y, objSolid))
    {
        // Находим направление от центра стены к врагу, чтобы выталкивать в правильную сторону
        var _nearest_wall = instance_nearest(x, y, objSolid);
        var _push_dir = 0;
        
        if (_nearest_wall != noone)
        {
            _push_dir = point_direction(_nearest_wall.x, _nearest_wall.y, x, y);
        }
        else
        {
            _push_dir = my_angle + 180; // Если стена не нашлась, выталкиваем назад от направления взгляда
        }
        
        // Выталкиваем врага из твердых объектов на расстояние до 8 пикселей за кадр
        move_outside_solid(_push_dir, 8);
    }
}