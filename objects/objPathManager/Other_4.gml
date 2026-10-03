// Этот код сработает, когда игра зайдет в Room1 и узнает её реальный размер (3000х3000)
if (room != Start) 
{
    // 1. Очищаем старую микро-сетку из boot_up, чтобы не было утечки памяти
    if (variable_global_exists("mp_grid")) { mp_grid_destroy(global.mp_grid); }
    
    // 2. Создаем новую сетку под честный размер текущей комнаты 3000х3000
    global.mp_grid = mp_grid_create(0, 0, room_width div 16, room_height div 16, 16, 16);
    
    // 3. Сканируем и добавляем стены на карту проходимости (замените objSolid на вашу реальную стену, если надо)
    mp_grid_add_instances(global.mp_grid, objSolid, false);
}