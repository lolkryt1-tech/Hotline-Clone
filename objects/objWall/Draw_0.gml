// ==========================================
// 1. ПОДГОТОВКА И РАСЧЕТ ГЕОМЕТРИИ
// ==========================================
var _pure_height = sprite_get_height(sprite_index);
var _half_len = (_pure_height * image_yscale) / 2 - 4;

// Вычисляем точные координаты для верхнего и нижнего торцов
var _top_x = x + lengthdir_x(_half_len, image_angle - 90);
var _top_y = y + lengthdir_y(_half_len, image_angle - 90);

var _bot_x = x + lengthdir_x(_half_len, image_angle + 90);
var _bot_y = y + lengthdir_y(_half_len, image_angle + 90);

// Создаем динамический список для поиска ВСЕХ пересекающихся стен
var _wall_list = ds_list_create();
var _wall_count = instance_place_list(x, y, objWall, _wall_list, false);

// Массив для хранения координат ВСЕХ найденных перекрестий
var _cross_positions = []; 

if (_wall_count > 0) {
    for (var i = 0; i < _wall_count; i++) {
        var _other_wall = _wall_list[| i];
        
        // Проверяем перпендикулярность
        var _angle_diff = abs(image_angle - _other_wall.image_angle);
        if (_angle_diff == 90 || _angle_diff == 270) {
            
            // Считаем динамическую точку пересечения креста
            var _cx = (abs(lengthdir_y(1, image_angle + 90)) > 0.5) ? x : _other_wall.x;
            var _cy = (abs(lengthdir_y(1, image_angle + 90)) > 0.5) ? _other_wall.y : y;
            
            // Запоминаем точку пересечения в массив
            array_push(_cross_positions, { cx: _cx, cy: _cy });
        }
    }
}

// Очищаем DS-список, чтобы избежать утечек памяти
ds_list_destroy(_wall_list);

var _total_crosses = array_length(_cross_positions);


// ==========================================
// 2. ОТРИСОВКА ВСЕХ ТЕНЕЙ (ПОДЛОЖКА)
// ==========================================
var _shadow_offset_x = 2;
if (global.hard == true) {
    _shadow_offset_x = -2; 
}

// Оставляем ТОЛЬКО тень самой стены. Тени углов удалены навсегда.
draw_sprite_ext(sprite_index, image_index, x + _shadow_offset_x, y, image_xscale, image_yscale, image_angle, c_black, 0.5);


// ==========================================
// 3. ОТРИСОВКА САМИХ СПРАЙТОВ (ОСНОВА)
// ==========================================
// Сама стена
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// Основные спрайты углов рисуются только при draw_corners = true
if (draw_corners == true) 
{
    // Торцевые углы сверху и снизу
    draw_sprite_ext(sprWallCorner, corner_subimage, _top_x, _top_y, image_xscale, 1, image_angle, image_blend, image_alpha);
    draw_sprite_ext(sprWallCorner, corner_subimage, _bot_x, _bot_y, image_xscale, 1, image_angle, image_blend, image_alpha);

    // Центральные перекрестия поверх всего
    for (var i = 0; i < _total_crosses; i++) {
        var _pos = _cross_positions[i];
        draw_sprite_ext(sprWallCorner, corner_subimage, _pos.cx, _pos.cy, image_xscale, 1, image_angle, image_blend, image_alpha);
    }
}
