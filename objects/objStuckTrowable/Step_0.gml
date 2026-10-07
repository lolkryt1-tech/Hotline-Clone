// Если нож застрял в двери, двигаем и крутим его вслед за ней
if (is_stuck_in_door && instance_exists(attached_door))
{
    // Восстанавливаем глобальное направление от петли двери до ножа с учетом нового угла двери
    var _current_door_dir = attached_door.image_angle + rel_dir;
    
    // Сдвигаем координаты ножа по круговой орбите двери
    x = attached_door.x + lengthdir_x(rel_dist, _current_door_dir);
    y = attached_door.y + lengthdir_y(rel_dist, _current_door_dir);
    
    // Нож синхронно поворачивается вместе со структурой двери
    my_angle = attached_door.image_angle + rel_angle;
}
