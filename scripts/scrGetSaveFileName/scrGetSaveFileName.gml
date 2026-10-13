function scrGetSaveFileName(_room_index = -1)
{
    if (_room_index == -1) _room_index = global.current_level.current_floor;
    
    if (_room_index < 0 || _room_index >= global.current_level.total_floors)
    {
        show_debug_message("ОШИБКА: Неверный индекс этажа: " + string(_room_index));
        return "";
    }
    
    var _prefix = global.current_level.floors[_room_index].file_prefix;
    return _prefix + ".dat";
}

/// @desc Возвращает имя файла крови для текущего этажа
function scrGetBloodFileName(_room_index = -1)
{
    if (_room_index == -1) _room_index = global.current_level.current_floor;
    
    if (_room_index < 0 || _room_index >= global.current_level.total_floors)
    {
        return "";
    }
    
    var _prefix = global.current_level.floors[_room_index].file_prefix;
    return _prefix + "_blood.dat";
}