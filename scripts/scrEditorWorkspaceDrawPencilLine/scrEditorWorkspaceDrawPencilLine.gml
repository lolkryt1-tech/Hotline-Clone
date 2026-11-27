/// @function scrEditorWorkspaceDrawPencilLine(_x0, _y0, _x1, _y1, _action)
/// @description Обрабатывает все клетки между двумя позициями карандаша.

function scrEditorWorkspaceDrawPencilLine(_x0, _y0, _x1, _y1, _action)
{
    var _dx = abs(_x1 - _x0);
    var _dy = abs(_y1 - _y0);

    var _sx = (_x0 < _x1) ? 1 : -1;
    var _sy = (_y0 < _y1) ? 1 : -1;

    var _err = _dx - _dy;

    var _x = _x0;
    var _y = _y0;

    while (true)
    {
        scrEditorWorkspaceApplyTile(_x, _y, _action);

        if (_x == _x1 && _y == _y1)
            break;

        var _e2 = 2 * _err;

        if (_e2 > -_dy)
        {
            _err -= _dy;
            _x += _sx;
        }

        if (_e2 < _dx)
        {
            _err += _dx;
            _y += _sy;
        }
    }
}