enum CAMSTATES {
    GAME,
    CUtSCENE,
    LEVEL_END
}

// ==========================================
// === ИНИЦИАЛИЗАЦИЯ ТРЯСКИ КАМЕРЫ ===
// ==========================================

scrCameraShakeInit();
scrCameraShakeLoad();

_cam = view_camera[0];
depth = -15900;

cam_follow_x = camera_get_view_x(_cam);
cam_follow_y = camera_get_view_y(_cam);

// ==========================================
// === ИНЕРЦИЯ СЛЕЖЕНИЯ КАМЕРЫ ===
// ==========================================
cam_velocity_x = 0;
cam_velocity_y = 0;

my_target = 0;

cam_target_x = x;
cam_target_y = y;

base_width = 480;
base_height = 270;

zoom_level = 1.0;
zoom_min = 0.5;
zoom_max = 2.5;

state = CAMSTATES.GAME;

cutscene_timer = 0;
cutscene_fly_y = 0;


// ==========================================
// === KICK SHAKE ===
// ==========================================

kick_active = false;
kick_timer = 0;

kick_direction_x = 0;
kick_direction_y = 0;

kick_strength = 0;
kick_rotation = 0;

kick_attack_time = 0.05;
kick_release_time = 0.15;

kick_offset_x = 0;
kick_offset_y = 0;
kick_offset_angle = 0;


// ==========================================
// === BOUNCE SHAKE ===
// ==========================================

bounce_active = false;
bounce_timer = 0;

bounce_direction_x = 0;
bounce_direction_y = 0;

bounce_strength = 0;
bounce_rotation = 0;
bounce_frequency = 4.0;
bounce_damping = 10.0;

bounce_offset_x = 0;
bounce_offset_y = 0;
bounce_offset_angle = 0;



// ==========================================
// === PERLIN SHAKE ===
// ==========================================

perlin_active = false;
perlin_timer = 0;

perlin_seed_x = random(1000);
perlin_seed_y = random(1000);
perlin_seed_angle = random(1000);

perlin_offset_x = 0;
perlin_offset_y = 0;
perlin_offset_angle = 0;


// ==========================================
// === МЕНЮ НАСТРОЙКИ ТРЯСКИ ПРИ СТРЕЛЬБЕ ===
// ==========================================
global.camera_shake_menu_open = false;
global.camera_shake_menu_hover = false;
global.camera_shake_menu_dragging = false;

// ==========================================
// === ЗАТУХАНИЕ ЭКРАНА В КОНЦЕ УРОВНЯ ===
// ==========================================

curtain_y = 0;
curtain_speed = 10;

target_car_x = 0;
target_car_y = 0;


// ==========================================
// === БАЗОВЫЙ УГОЛ КАМЕРЫ ===
// ==========================================

cam_base_angle = (global.hard) ? 180 : 0;

if (instance_exists(objPlayer))
{
    camera_set_view_pos(_cam, objPlayer.x, objPlayer.y);
}

camera_set_view_angle(_cam, cam_base_angle);


// ==========================================
// === ВИРТУАЛЬНЫЙ КУРСОР ===
// ==========================================
global.cursor_sprite = sprEffector;

global.cursor_screen_x = window_get_width() * 0.5;
global.cursor_screen_y = window_get_height() * 0.5;

window_set_cursor(cr_none);



// ==========================================
// === ЗАТЕМНЕНИЕ ЭКРАНА ===
// ==========================================

fade_darkness = 2.0;
fade_speed = 0.05;


// ==========================================
// === ИНИЦИАЛИЗАЦИЯ ШРИФТА ===
// ==========================================

draw_set_font(fntAmmo);
var _dump1 = string_width("PRESS R TO RESTART0123456789");


// ==========================================
// === ГЛОБАЛЬНЫЕ ПАРАМЕТРЫ КАМЕРЫ ===
// ==========================================

global.cam = view_camera[0];

global.cam_w = camera_get_view_width(global.cam);
global.cam_h = camera_get_view_height(global.cam);

global.last_window_w = window_get_width();
global.last_window_h = window_get_height();

global.cam_scale_x = global.last_window_w / global.cam_w;
global.cam_scale_y = global.last_window_h / global.cam_h;

global.cam_x = camera_get_view_x(global.cam);
global.cam_y = camera_get_view_y(global.cam);


// ==========================================
// === ХАРД-МОД ===
// ==========================================

global.hard_sign = (global.hard) ? -1 : 1;
global.hard_ang = (global.hard) ? 180 : 0;