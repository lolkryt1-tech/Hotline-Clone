function scrCameraNoise1D(_x, _seed)
{
    var _cell = floor(_x);
    var _t = _x - _cell;

    _t = _t * _t * (3 - 2 * _t);

    var _a = sin((_cell + _seed) * 127.1) * 43758.5453;
    var _b = sin((_cell + 1 + _seed) * 127.1) * 43758.5453;

    _a = (_a - floor(_a)) * 2 - 1;
    _b = (_b - floor(_b)) * 2 - 1;

    return lerp(_a, _b, _t);
}