if (state != CAMSTATES.GAME) return;

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

cam_follow_x = lerp(cam_follow_x, target_x_pos - (new_w / 2), 0.2);
cam_follow_y = lerp(cam_follow_y, target_y_pos - (new_h / 2), 0.2);
#endregion



// === SCREEN SHAKE ===
var _dt = delta_time / 1000000;

scrCameraKickShakeUpdate(_dt);
scrCameraBounceShakeUpdate(_dt);

camera_set_view_pos(_cam,
    cam_follow_x + kick_offset_x + bounce_offset_x,
    cam_follow_y + kick_offset_y + bounce_offset_y
);

camera_set_view_angle(_cam,
    cam_base_angle + kick_offset_angle + bounce_offset_angle
);