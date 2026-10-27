// --- ЛОГИКА СПАВНА ПАЛЬМ ВДОЛЬ ДОРОГИ ---
spawn_timer++;
if (spawn_timer >= spawn_delay) {
    spawn_timer = 0;
    
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _center_x = _gui_w * 0.5;
    var _horizon_y = _gui_h * 0.5;
    
    // Точка старта — прямо у краев дороги на горизонте (из СЛОЯ 3 в Draw GUI)
    var _road_w_top = 80; 
    var _road_w_bot = _gui_w * 0.75; // Финальная ширина дороги внизу экрана
    var _end_y = _gui_h + 100; 
    
    var _shared_subimg = irandom(sprite_get_number(sprScorePalmTree) - 1);
    
    // 1. Пальма ВЛЕВО (вылетает из левого бортика горизонта и идет к левому нижнему углу дороги)
    var _p1 = instance_create_layer(_center_x - _road_w_top, _horizon_y, "Instances", objScorePalm);
    _p1.image_index = _shared_subimg;
    _p1.start_x = _center_x - _road_w_top;
    _p1.start_y = _horizon_y;
    _p1.target_x = _center_x - _road_w_bot - 1000; // Смещаем чуть левее обочины, чтобы не наезжала на неон
    _p1.target_y = _end_y;
    _p1.image_xscale = 1;       
    
    // 2. Пальма ВПРАВО (вылетает из правого бортика горизонта и идет к правому нижнему углу дороги)
    var _p2 = instance_create_layer(_center_x + _road_w_top, _horizon_y, "Instances", objScorePalm);
    _p2.image_index = _shared_subimg;
    _p2.start_x = _center_x + _road_w_top;
    _p2.start_y = _horizon_y;
    _p2.target_x = _center_x + _road_w_bot + 1000; // Смещаем чуть правее обочины
    _p2.target_y = _end_y;
    _p2.image_xscale = -1;       
}

// Прокрутка сетки дороги
grid_scroll += grid_speed;
if (grid_scroll >= 1.0) {
    grid_scroll -= 1.0;
}
