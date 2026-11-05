var _gui_h = display_get_gui_height();

for (var i = 0; i < array_length(beams); i++) {
    var _b = beams[i];
    
    // Пульсация прозрачности
    var _pulse = (sin(anim_time * _b.pulse_speed + _b.pulse_phase) + 1) * 0.5;
    var _current_alpha = _b.alpha * (0.5 + _pulse * 0.5);
    
    var _x1 = _b.x - _b.width * 0.5;
    var _x2 = _b.x + _b.width * 0.5;
    
    // Разбиваем луч на 5 сегментов по вертикали, чтобы он был "рваным"
    var _segments = 5;
    var _seg_h = _gui_h / _segments;
    
    for (var j = 0; j < _segments; j++) {
        var _y1 = j * _seg_h;
        var _y2 = _y1 + _seg_h;
        
        // Каждый сегмент имеет свою случайную прозрачность (шум)
        // Используем sin для плавного изменения шума
        var _noise = (sin(anim_time * 0.1 + j * 2.5 + i) + 1) * 0.5; 
        var _seg_alpha = _current_alpha * (0.5 + _noise * 0.8);
        
        // Рисуем широкий тусклый слой (свечение)
        draw_set_alpha(_seg_alpha * 0.5);
        draw_set_color(_b.color);
        draw_rectangle(_x1, _y1, _x2, _y2, false);
        
        // Рисуем узкий яркий центр
        var _inner_w = _b.width * 0.2;
        draw_set_alpha(_seg_alpha * 1.5);
        draw_set_color(merge_color(_b.color, c_white, 0.4)); // Делаем центр светлее
        draw_rectangle(_b.x - _inner_w * 0.5, _y1, _b.x + _inner_w * 0.5, _y2, false);
    }
}

draw_set_alpha(1);