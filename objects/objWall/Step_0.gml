/*
// 2. Расчет торцов (Берем чистую высоту из ассетов)
var _pure_height = sprite_get_height(sprite_index);
var _half_len = (_pure_height * image_yscale) / 2;
_half_len = _half_len - 4;

var _top_x = x + lengthdir_x(_half_len, image_angle - 90);
var _top_y = y + lengthdir_y(_half_len, image_angle - 90);

var _bot_x = x + lengthdir_x(_half_len, image_angle + 90);
var _bot_y = y + lengthdir_y(_half_len, image_angle + 90);

// 3. ЖЕСТКОЕ УДЕРЖАНИЕ ТОРЦЕВЫХ УГЛОВ (Твой рабочий код)
if (!instance_exists(corner_top)) {
    corner_top = instance_create_depth(_top_x, _top_y, -15900, objWallCorner);
}
if (!instance_exists(corner_bot)) {
    corner_bot = instance_create_depth(_bot_x, _bot_y, -15900, objWallCorner);
}

// 4. ИСПРАВЛЕННЫЙ СПАВН НА ПЕРЕСЕЧЕНИИ (ДИНАМИЧЕСКИЙ КРЕСТ)
// Проверяем полноценное пересечение масок стен в пространстве
var _other_wall = instance_place(x, y, objWall);

if (_other_wall != noone && _other_wall != id) {
    var _angle_diff = abs(image_angle - _other_wall.image_angle);
    
    if ((_angle_diff == 90 || _angle_diff == 270) && (id > _other_wall.id)) {
        
        // ВЫЧИСЛЯЕМ ТОЧНУЮ ТОЧКУ ПЕРЕСЕЧЕНИЯ СТЕН:
        // Если текущая стена вертикальная (image_angle = 0 или 180), то перекрестие берет X от нее, а Y от горизонтальной.
        // Если наоборот — то наоборот. Для простоты берем координаты пересечения масок:
        var _cross_x = (abs(lengthdir_y(1, image_angle + 90)) > 0.5) ? x : _other_wall.x;
        var _cross_y = (abs(lengthdir_y(1, image_angle + 90)) > 0.5) ? _other_wall.y : y;

        if (!instance_exists(corner_center)) {
            corner_center = instance_create_depth(_cross_x, _cross_y, -15905, objWallCorner);
        }
        
        if (instance_exists(corner_center)) {
            corner_center.x = _cross_x;
            corner_center.y = _cross_y;
            corner_center.image_angle = image_angle;
            corner_center.image_xscale = image_xscale;
        }
    } else {
        if (instance_exists(corner_center)) { instance_destroy(corner_center); corner_center = noone; }
    }
} else {
    if (instance_exists(corner_center)) { instance_destroy(corner_center); corner_center = noone; }
}