image_angle = 0;
image_index = 0;
image_speed = 0;
depth = -3000;
speed = 0;

enum CHARACTER{
	COP
}

// === ПАРАМЕТРЫ ПЕРСОНАЖА И ОРУЖИЯ ===
character            = CHARACTER.COP;
current_weapon       = WEAPONS.UNARMED;
isRange_weapon		 = false;
my_sprites           = scrPlayerGetWeaponSprite(character, current_weapon);
sprite_index         = my_sprites.walk
pickup_radius        = 24;
standart_y_scale	 = image_yscale;
ammo				 = 0;
depth				 = -6000;
faction				 = FACTION.PLAYER;
MMB_hold_timer		 = 0;
prep_thrown			 = false;
knife_just_picked_up = false;

// Здоровье (1 = умрет от первой пули, 2 = перенесет одну пулю и умрет от второй)
max_energy           = choose(1, 2); 
energy               = max_energy;

// === ДВИЖЕНИЕ И ФИЗИКА ===
movement_speed       = 3.0;
hor_velocity         = 0;
ver_velocity         = 0;
walking_direction    = 0;
my_angle             = point_direction(x, y, mouse_x, mouse_y);

// === УПРАВЛЕНИЕ (ВВОД) ===
move_input           = 0;
get_input            = 0;

// === АНИМАЦИЯ НОГ ===
legs_direction       = 0;
legs_image_index     = 0;
legs_animation_speed = 0.25;

// === БОЕВАЯ СИСТЕМА ===
is_attacking         = false;
attack_delay         = 0;

// === ОТРИСОВКА НА ЭКРАНЕ ===
icon_shake_angle = 0;  
icon_shake_vel   = 0;  
icon_shake_dir   = -1; // Переключатель: -1 это влево, +1 это вправо
ammo_color_factor = 0;
ammo_scale_pulse = 0;

// === СПАВН ГИЛЬЗЫ ДРОБОВИКА
shell_ready_to_spawn = -1;


// === ФАЗЫ ОТДЕЛЬНО ДЛЯ КОПА, А ИМЕННО РАЗВОРОТ ДРОБОВИКА ===
old_angle         = my_angle; // Угол мыши на прошлом кадре
is_turning        = false;    // Флаг: активен ли занос торса
turn_phase        = 0;        // Фаза анимации (0 - вперед, 1 - удержание, 2 - реверс)
turn_hold_timer   = 0;        // Таймер зависания на последнем кадре
// Накопитель резкого разворота
flick_timer       = 0;        // Таймер окна времени для совершения рывка
flick_accum_angle = 0;        // Накопленный угол поворота за это окно



persistent = true;

//if (instance_exists(objPlayer)) { instance_destroy(); }


// === ДЕБАГ ===
global.debug = 0;
debug_melee_timer = 0;

// === ПЕРЕМЕЩЕНИЕ МЕЖДУ ЭТАЖАМИ ===
global.next_player_x = x;
global.next_player_y = y;
global.next_effector_x = x;
global.next_effector_y = y;
global.is_cleaning_level = false