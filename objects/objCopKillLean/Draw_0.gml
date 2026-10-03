// 1. Рисуем врага на его законном месте
draw_sprite_ext(enemy_sprite, enemy_image_index, x, y, 1, 1, my_angle, c_white, 1);

// === РАСЧЕТ ДВОЙНОГО СМЕЩЕНИЯ ИГРОКА (НАЗАД + ВЛЕВО) ===
var _offset_dist = -16; // Отодвигаем назад
var _side_offset = 2;   // Смещаем влево (поменяйте число для нужной дистанции)

// Базовые координаты со смещением назад
var _player_x = x + lengthdir_x(_offset_dist, my_angle);
var _player_y = y + lengthdir_y(_offset_dist, my_angle);

// Добавляем смещение влево (угол + 90 градусов относительно взгляда)
_player_x += lengthdir_x(_side_offset, my_angle + 90);
_player_y += lengthdir_y(_side_offset, my_angle + 90);

// 2. Рисуем игрока в правильной смещенной позиции
draw_sprite_ext(sprite_index, image_index, _player_x, _player_y, 1, 1, my_angle, c_white, 1);
