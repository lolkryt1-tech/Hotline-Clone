// 1. Инициализация
if (target_angle == 0 && base_angle != 0) {
    target_angle = base_angle;
    image_angle = base_angle;
}

// 2. ПРОВЕРКА ИГРОКА В ЗОНЕ (ИСПРАВЛЕНО)
var _player_in_zone = false;
if (instance_exists(objPlayer)) {
    var _zone_cx = x + lengthdir_x(zone_offset_forward, base_angle);
    var _zone_cy = y + lengthdir_y(zone_offset_forward, base_angle);
    
    var _dx = objPlayer.x - _zone_cx;
    var _dy = objPlayer.y - _zone_cy;
    
    var _cos = dcos(-base_angle);
    var _sin = dsin(-base_angle);
    var _local_x = _dx * _cos - _dy * _sin;
    var _local_y = _dx * _sin + _dy * _cos;
    
    if (abs(_local_x) <= zone_width / 2 && abs(_local_y) <= zone_height / 2) {
        _player_in_zone = true;
    }
}

// 3. ОПРЕДЕЛЯЕМ ЦЕЛЕВОЙ УГОЛ
if (_player_in_zone) {
    is_open = true;
    target_angle = base_angle + (max_open_angle * open_direction);
} else {
    is_open = false;
    target_angle = base_angle;
}

// 4. ПОВОРОТ С ФИКСИРОВАННОЙ СКОРОСТЬЮ
var _angle_diff = angle_difference(target_angle, image_angle);
var _step = min(abs(_angle_diff), rotation_speed);

if (_angle_diff != 0) {
    image_angle += sign(_angle_diff) * _step;
}

// 5. ОГРАНИЧИВАЕМ УГОЛ
var _current_offset = angle_difference(image_angle, base_angle);
if (abs(_current_offset) > max_open_angle) {
    image_angle = base_angle + (sign(_current_offset) * max_open_angle);
}

// 6. ЗВУКИ
var _current_angle = abs(angle_difference(image_angle, base_angle));

if (!sound_opened_played && _current_angle > 5) {
    audio_play_sound(sndCarOpen, 1, false);
    sound_opened_played = true;
    sound_closed_played = false;
}

if (!sound_closed_played && _current_angle < 1) {
    if (sound_opened_played) {
        audio_play_sound(sndCarClose, 1, false);
        sound_closed_played = true;
        sound_opened_played = false;
    } else {
        sound_closed_played = true;
    }
}