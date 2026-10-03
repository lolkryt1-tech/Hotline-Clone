my_target = scrTargetUpdate(objPlayer);

if (keyboard_check(vk_alt)) {
    if (mouse_wheel_up())								zoom_level -= 0.1;
    if (mouse_wheel_down())								zoom_level += 0.1;
    if (mouse_check_button_pressed(mb_middle))			zoom_level = 1;
    zoom_level = clamp(zoom_level, zoom_min, zoom_max);
}

#region приближение + сглаживание

var target_w = base_width * zoom_level;
var target_h = base_height * zoom_level;

var camera_w = camera_get_view_width(_cam);
var camera_h = camera_get_view_height(_cam);

var new_w = lerp(camera_w, target_w, 0.5);
var new_h = lerp(camera_h, target_h, 0.5);

camera_set_view_size(_cam, new_w, new_h);

#endregion

#region слежка + центрирование + сглаживание

var look_distance = 0.8;
if (keyboard_check(vk_shift)) look_distance = 0.5;

var target_x = lerp(x, my_target.x, look_distance);
var target_y = lerp(y, my_target.y, look_distance);

var current_camera_x = camera_get_view_x(_cam);
var current_camera_y = camera_get_view_y(_cam);

var new_cam_x = lerp(current_camera_x, target_x - (new_w / 2), 0.2);
var new_cam_y = lerp(current_camera_y, target_y - (new_h / 2), 0.2);

camera_set_view_pos(_cam, new_cam_x, new_cam_y);

#endregion


// ==========================================
// === ЛОГИКА НЕЖНОГО ГОЛЛАНДСКОГО УГЛА ===
// ==========================================
var _target_angle = 0;

if (shake > 0) 
{
    // Наращиваем таймер чуть медленнее (0.4 вместо 0.8) для плавного покачивания
    shake_timer += 0.4; 
    
    // Считаем идеальный целевой угол покачивания по синусоиде
    _target_angle = sin(shake_timer) * shake;
    
    // Мягко гасим силу наклона (каждый кадр уменьшаем на 10%)
    shake *= 0.90; 
    
    // Если наклон стал совсем мизерным, обрубаем его
    if (shake < 0.05) shake = 0;
}
else 
{
    shake = 0;
    shake_timer = 0; 
}

// Получаем текущий угол наклона камеры в этот кадр
var _current_angle = camera_get_view_angle(_cam);

// НЕЖНЫЙ ЛЕРП: плавно перетекаем из текущего угла в целевой со скоростью 0.1
var _new_angle = lerp(_current_angle, _target_angle, 0.1);

// Применяем сглаженный, вязкий угол наклона к камере
camera_set_view_angle(_cam, _new_angle);
