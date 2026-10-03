// 1. Отрисовываем врага на его месте
draw_sprite_ext(enemy_sprite, enemy_image_index, x, y, 1, 1, my_angle, c_white, 1);

// === РАСЧЕТ ДВОЙНОГО СМЕЩЕНИЯ ИГРОКА (ВПЕРЕД/НАЗАД + ВЛЕВО) ===
var _offset_dist = 2;  // Ваше смещение по оси взгляда
var _side_offset = 2;   // Смещение влево в пикселях (подберите нужное число для идеальной подгонки)

// Базовая позиция со смещением вперед/назад
var _player_x = x + lengthdir_x(_offset_dist, my_angle);
var _player_y = y + lengthdir_y(_offset_dist, my_angle);

// Добавляем смещение строго влево (угол взгляда + 90 градусов)
_player_x += lengthdir_x(_side_offset, my_angle + 90);
_player_y += lengthdir_y(_side_offset, my_angle + 90);

// 2. Отрисовываем игрока в новой скорректированной позиции
draw_sprite_ext(sprite_index, image_index, _player_x, _player_y, 1, 1, my_angle, c_white, 1);