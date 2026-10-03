draw_sprite_ext(enemy_sprite, enemy_image_index, x, y, 1, 1, my_angle, c_white, 1);

draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, my_angle, c_white, 1);

draw_text(x + 15, y, "isSwing: " + string(isSwinging));
draw_text(x + 15, y + 15, "image_index : " + string(image_index));


var _parent_index = object_get_parent(object_index);

// Переводим индекс в читаемый текст
var _parent_name = "Нет родителя";
if (_parent_index != -1) 
{
    _parent_name = object_get_name(_parent_index);
}

// Настройка текста
draw_set_font(-1);
draw_set_halign(fa_center);

// Рисуем текст прямо над головой игрока
draw_text_color(x, y - 20, "Родитель: " + _parent_name, c_white, c_white, c_white, c_white, 1);


if (instance_exists(objPlayer))
{
    // Берем object_index именно у найденного инстанса игрока
    var _player_parent_index = object_get_parent(objPlayer.object_index);
    
    var _name = "Нет родителя";
    if (_player_parent_index != -1) 
    {
        _name = object_get_name(_player_parent_index);
    }
    
    // Выводим текст в левом верхнем углу экрана (GUI) или над игроком
    draw_set_halign(fa_left);
    draw_text_color(32, 32, "Родитель игрока: " + _name, c_yellow, c_yellow, c_yellow, c_yellow, 1);
}