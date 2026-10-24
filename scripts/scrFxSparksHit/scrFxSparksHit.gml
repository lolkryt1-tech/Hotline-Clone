// =========================================================================
// scrFxSparksHit —  спавн искр от попадания.
//
// @param {real} _x         X центра
// @param {real} _y         Y центра
// @param {real} _dir       Направление удара (искры полетят в -180 от него)
// @param {real} _speed     Базовая скорость искр (по умолчанию 2)
// @param {real} _count_min Минимум искр (по умолчанию 4)
// @param {real} _count_max Максимум искр (по умолчанию 7)
// =========================================================================
function scrFxSparksHit(_x, _y, _dir, _speed = 2, _count_min = 6, _count_max = 10)
{
    var _n = irandom_range(_count_min, _count_max);
    repeat (_n)
    {
        var _dev = random_range(-15, 15);
        var _spark = instance_create_layer(_x, _y, "Instances", objElectricSpark);
        _spark.direction   = (_dir - 180) + _dev;
        _spark.image_angle = _spark.direction;
        _spark.speed       = _speed + random(3);
    }
}