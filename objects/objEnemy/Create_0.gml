image_index = 0;
image_speed = 0;
depth       = global.player_render_counter - 1; // На единицу меньше чем у игрока
direction   = image_angle;

/*
enum STATES
{
	IDLE,
	STEP,
	CHASE,
	SEARCH,
	INVESTIGATE,
	ATTACKMELEE,
	ATTACKRANGE,
	AFTERMATH,
	UNARMEDSEARCH,
	DEBUG
}

enum MOVETYPE
{
	STATIC,
	RANDOM,
	PATROL
}

enum FACTION
{
	COLOMBIAN,
	GANG,
	PLAYER
}

enum CLASS
{
	REGULAR,
	DODGER,
	VEST,
	FAT
}
*/

state_names = ["idle", "step", "chase", "search", "Investigate" , "attackMelee", "attackRange", "aftermath", "unarmedSearch", "debug"];

// === ПАРАМЕТРЫ ПЕРСОНАЖА И ОРУЖИЯ ===
faction              = noone;
class                = noone;
weapon               = noone;
isRange_weapon       = noone;

// == СПАВН ХАРТБОКСА
my_hurtbox = instance_create_layer(x, y, "Instances", objEnemyHurtBox);
my_hurtbox.owner = id; // Передаем хартбоксу ID этого врага

my_sprites           = scrEnemyGetSprite(class, weapon);

// === СОСТОЯНИЯ И ИИ ===
state                = STATES.STEP;
state_previous       = state;
move_type            = MOVETYPE.RANDOM;
my_target            = noone;
reaction_time        = 15;

// === ДВИЖЕНИЕ И ФИЗИКА ===
max_speed            = 2.25; // Единственная максимальная скорость для бега и поиска
target_speed         = 0.0; // Целевая скорость (будет либо max_speed, либо 0)
current_speed        = 0.0; // Реальная скорость в текущий кадр
accel                = 0.08; // Плавность разгона
fric                 = 0.15; // Плавность торможения
my_angle             = image_angle;
desired_angle        = image_angle;

// === АНИМАЦИЯ НОГ ===
legs_direction       = 0;
legs_image_index     = 0;
legs_animation_speed = 0.25;

// === АКСЕСУАРЫ НА ГОЛОВУ ===
headgear_x = x;
headgear_y = y;

// === БОЕВАЯ СИСТЕМА ===
reload               = 20;
start_shooting		 = false;	// Когда был сделан первый выстрел поворачиваемся резко, а не плавно

// === ЗРЕНИЕ И ПОИСК ЦЕЛИ ===
vision_radius        = 300; // Радиус обзора
search_interval      = 10; // Проверка каждые 10 кадров (очень экономит FPS!)
search_timer         = irandom(search_interval); // Случайный старт, чтобы ИИ не «думали» все одновременно
targets_list         = ds_list_create(); // Создаем список один раз при создании объекта

// === РЕЖИМЫ ПОИСКА (SEARCH STATE) ===
search_timer         = 0; // Текущий активный таймер (в кадрах)
search_phase         = 0; // Текущая фаза: 0 — не ищет, 1 — стоит тупит, 2 — осматривается
last_seen_x          = x;
last_seen_y          = y;
safe_x               = x;
safe_y               = y;

// === ПОИСК ОРУЖИЯ (UNARMED SEARCH) ===
weapon_search_timer  = irandom_range(1, 10);
cached_weapon        = noone;
can_see_weapon       = false;
pickup_distance      = 16;
try_get_weapon_timer = 80;
hasTriedToGetWeapon  = false;

// === РЕЖИМ ИССЛЕДОВАНИЯ АКА СБЕГАЕТСЯ НА ШУМ ===
can_hear			 = 1;
noise_x				 = 0;
noise_y				 = 0;

// === ТИПЫ ПЕРЕМЕЩЕНИЯ (MOVEMENT TYPES) ===
random_move_timer    = 0; // Таймер до следующей смены направления
random_dir           = 0; // Текущее случайное направление движения
patrol_dir           = 0; // Текущее патрольное направление движения

// === СТРЕЙФ И ОБХОД ПРЕПЯТСТВИЙ ===
old_x                = x;
old_y                = y;
stuck_timer          = 0; // Таймер, который считает, как долго мы стоим на месте
strafe_dir           = choose(1, -1); // Направление стрейфа (1 — вправо, -1 — влево)
strafe_change_timer  = 0;

// === ПОИСК ПУТЕЙ (PATHFINDING) ===
my_path                      = path_add();
trail_spawn_delay            = 0;
searching_path_delay_timer   = 0;
path_delay_timer             = 0;
walk_on_trail                = 0;
searching_animation          = 0;
start_searching              = 0;

// === СИСТЕМА УРОНА ПО КАЛИБРАМ И ДРОБИ ===
pellets_hit  = 0;  // Счетчик попавших дробинок/пуль в текущем кадре
last_hit_dir = 0;  // Направление последнего попадания (для отлета трупа)
kill_instantly = false;

// === СПАВН ГИЛЬЗЫ ДРОБОВИКА
shell_ready_to_spawn = -1;

// === ОТЛАДКА (DEBUG) ===
can_chase            = false;
i_am_stuck           = false;
in_wall              = false;
i_am_stuck_ticks     = 0;
path_update_count    = 0;
target_search_count  = 0;
impossible_to_path   = 0;
