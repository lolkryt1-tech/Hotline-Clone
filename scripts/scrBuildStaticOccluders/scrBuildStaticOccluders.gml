function scrBuildStaticOccluders(_renderer)
{
    // Создаём один статический окклюдер
    var _occluder = new BulbStaticOccluder(_renderer);
    
    // Перебираем ВСЕ стены на уровне и добавляем их как рёбра
    with (objSolidTall)
    {
        // Добавляем прямоугольник стены как 4 ребра (по часовой стрелке)
        _occluder.AddEdge(bbox_left,  bbox_top,    bbox_right, bbox_top);    // верх
        _occluder.AddEdge(bbox_right, bbox_top,    bbox_right, bbox_bottom); // право
        _occluder.AddEdge(bbox_right, bbox_bottom, bbox_left,  bbox_bottom); // низ
        _occluder.AddEdge(bbox_left,  bbox_bottom, bbox_left,  bbox_top);    // лево
    }
    
    // Обновляем статические окклюдеры в рендерере
    _renderer.RefreshStaticOccluders();
    
    // Сохраняем ссылку, чтобы Bulb не удалил окклюдер (важно!)
    global.static_occluder = _occluder;
    
    show_debug_message("Static occluders built: " + string(instance_number(objSolidTall)) + " walls");
}