depth = 9;

// ========================================
// ПОДСКАЗКИ
// ========================================

tips = [
    "A charged knife throw can hurt fat enemies",
	"Keep shooting at dying fat enemies to take them down faster",
	"Shoot leaning vest enemies to kill them"
	
];

current_tip = "";
previous_tip_index = -1;

// Выбираем первую подсказку
var _tip_count = array_length(tips);
var _tip_index = irandom(_tip_count - 1);

current_tip = tips[_tip_index];
previous_tip_index = _tip_index;


// ========================================
// ПОСЛЕДОВАТЕЛЬНОСТЬ ПОЯВЛЕНИЯ
// ========================================

intro_started = false;
intro_complete = false;

line_progress = 0;
hint_alpha = 0;
hint_progress = 0;
tip_reveal = 0;


// ========================================
// ЗАДЕРЖКА ПЕРЕД ПОЯВЛЕНИЕМ
// ========================================

intro_timer = 0;
intro_delay = 1.0;


// ========================================
// СМЕНА ПОДСКАЗКИ
// ========================================

changing_tip = false;


// ========================================
// СКОРОСТЬ АНИМАЦИИ
// ========================================

line_speed = 0.06;
fade_speed = 0.04;
hint_slide_speed = 0.06;
tip_reveal_speed = 0.06;


// ========================================
// ОФОРМЛЕНИЕ
// ========================================

tip_font = fntTitleTips;

tip_color = make_color_rgb(175, 175, 185);
line_color = make_color_rgb(100, 100, 115);
hint_color = make_color_rgb(115, 115, 125);

line_width = 260;


// ========================================
// ПОЗИЦИОНИРОВАНИЕ
// ========================================

tip_offset_y = 310;
line_offset_y = 337;
hint_offset_y = 353;


// ========================================
// ПОВЕРХНОСТЬ ДЛЯ МАСКИ ТЕКСТА
// ========================================

tip_surface = -1;
tip_surface_w = 0;
tip_surface_h = 0;


// === НИКАКИХ ПОДСКАЗОК ===
if (global.settings.enable_tips == false) { instance_destroy(); }