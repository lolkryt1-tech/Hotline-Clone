function scrClearFloorData()
{
    var _r = 0;
    
    // Перебираем вообще все комнаты, которые существуют в твоём проекте
    while (room_exists(_r))
    {
        var _room_name = room_get_name(_r);
        
        var _file_name       = _room_name + ".dat";
        var _blood_file_name = _room_name + "_blood.dat"; // ДОБАВЛЕНО: имя файла крови
        
        // 1. Если старый файл сохранения этажа лежит на диске — удаляем его
        if (file_exists(_file_name))
        {
            file_delete(_file_name);
        }
        
        // 2. ДОБАВЛЕНО: Если файл крови этого этажа существует — удаляем и его
        if (file_exists(_blood_file_name))
        {
            file_delete(_blood_file_name);
        }
        
        _r++;
    }
    
    show_debug_message("=== ВСЕ ФАЙЛЫ ЭТАЖЕЙ И КРОВИ УСПЕШНО ОЧИЩЕНЫ ===");
}
