/// @desc Проверяет, чистая ли линия взгляда между объектами
/// @param _x1 Стартовый X
/// @param _y1 Стартовый Y
/// @param _x2 Целевой X
/// @param _y2 Целевой Y
function scrHasClearView(_x1, _y1, _x2, _y2) 
{
    // Ищем на линии только те объекты, которые реально должны слепить: 
    // Твои старые высокие стены (objSolidTall) И твои двери ()
    var _hit = collision_line(_x1, _y1, _x2, _y2, [objSolidTall, objWoodenDoor], false, true);
    
    // Если на пути нашлась стена или дверь — видимости НЕТ (возвращаем false)
    if (_hit != noone) 
    {
        return false;
    }
    
    // Если преград нет (или на пути только окна objSolid) — видимость ЧИСТАЯ (возвращаем true)
    return true; 
}
