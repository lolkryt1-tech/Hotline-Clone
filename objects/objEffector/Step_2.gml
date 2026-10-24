my_target = scrTargetUpdate(objPlayer);

if (keyboard_check(vk_alt)) {
    if (mouse_wheel_up())                               zoom_level -= 0.1;
    if (mouse_wheel_down())                             zoom_level += 0.1;
    if (mouse_check_button_pressed(mb_middle))          zoom_level = 1;
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

var target_x_pos = lerp(x, my_target.x, look_distance);
var target_y_pos = lerp(y, my_target.y, look_distance);

var current_camera_x = camera_get_view_x(_cam);
var current_camera_y = camera_get_view_y(_cam);

var new_cam_x = lerp(current_camera_x, target_x_pos - (new_w / 2), 0.2);
var new_cam_y = lerp(current_camera_y, target_y_pos - (new_h / 2), 0.2);

camera_set_view_pos(_cam, new_cam_x, new_cam_y);
#endregion

// ==========================================
// === ЛОГИКА НЕЖНОГО ГОЛЛАНДСКОГО УГЛА ===
// ==========================================
var _target_angle = 0;
if (shake > 0) 
{
    shake_timer += 0.4; 
    _target_angle = sin(shake_timer) * shake;
    shake *= 0.90; 
    if (shake < 0.05) shake = 0;
}
else 
{
    shake = 0;
    shake_timer = 0; 
}
var _current_angle = camera_get_view_angle(_cam);
var _new_angle = lerp(_current_angle, _target_angle, 0.1);
camera_set_view_angle(_cam, _new_angle);
