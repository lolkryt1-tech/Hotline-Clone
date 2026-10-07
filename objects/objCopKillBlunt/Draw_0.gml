var _offset_dist = 8;  // Смещение вперед вдоль тела врага
var _side_offset = 0;

var _player_x = x + lengthdir_x(_offset_dist, my_angle);
var _player_y = y + lengthdir_y(_offset_dist, my_angle);

_player_x += lengthdir_x(_side_offset, my_angle + 90);
_player_y += lengthdir_y(_side_offset, my_angle + 90);

draw_sprite_ext(enemy_sprite, enemy_image_index, x, y, 1, 1, my_angle, c_white, 1);
draw_sprite_ext(sprite_index, image_index, _player_x, _player_y, 1, 1, my_angle, c_white, 1);