function scrClearFloorData()
{
    var _r = 0;
    
    while (room_exists(_r))
    {
        var _room_name = room_get_name(_r);
        
        // Ищем этаж, к которому относится эта комната
        for (var i = 0; i < global.current_level.total_floors; i++)
        {
            var _floor = global.current_level.floors[i];
            if (_floor.room_name == _room_name || _floor.file_prefix == _room_name)
            {
                var _file_name       = scrGetSaveFileName(i);
                var _blood_file_name = scrGetBloodFileName(i);
                
                if (file_exists(_file_name))       file_delete(_file_name);
                if (file_exists(_blood_file_name)) file_delete(_blood_file_name);
            }
        }
        
        _r++;
    }
    
    show_debug_message("=== ВСЕ ФАЙЛЫ ЭТАЖЕЙ И КРОВИ УСПЕШНО ОЧИЩЕНЫ ===");
}