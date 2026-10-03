draw_sprite_ext(enemy_sprite, enemy_image_index, x, y, 1, 1, my_angle, c_white, 1);


var _offset_dist = 6; 
var _player_x = x + lengthdir_x(_offset_dist, my_angle);
var _player_y = y + lengthdir_y(_offset_dist, my_angle);

draw_sprite_ext(sprite_index, image_index, _player_x, _player_y, 1, 1, my_angle, c_white, 1);