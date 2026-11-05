camera_set_view_pos(_cam, global.next_effector_x, global.next_effector_y);

var _base_angle = (global.hard) ? 180 : 0;
camera_set_view_angle(_cam, _base_angle);