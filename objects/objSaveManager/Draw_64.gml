
if (!quick_save_notification_visible) return;
if (quick_save_notification_alpha <= 0) return;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _alpha = quick_save_notification_alpha;
var _time = quick_save_notification_anim_time;

// ==================================================
// ПАРАМЕТРЫ ОФОРМЛЕНИЯ
// ==================================================

var _padding_x = 18;
var _padding_y = 14;

var _icon_size = 44;
var _icon_text_gap = 15;

var _accent_width = 3;
var _accent_gap = 12;

var _edge_margin = 30;

// ==================================================
// НЕОНОВАЯ ПАЛИТРА
// ==================================================

var _neon_colors =
[
    make_color_rgb(255, 35, 110),  // Малиновый
    make_color_rgb(220, 35, 255),  // Пурпурный
    make_color_rgb(65, 75, 255),   // Синий
    make_color_rgb(35, 220, 255)   // Голубой
];

// Плавное переливание между цветами
var _cycle = (_time * 0.65) mod 4;

var _color_index = floor(_cycle);
var _color_next = (_color_index + 1) mod 4;
var _color_blend = frac(_cycle);

var _neon_color = merge_colour(
    _neon_colors[_color_index],
    _neon_colors[_color_next],
    _color_blend
);

// ==================================================
// ШРИФТ И РАЗМЕРЫ ТЕКСТА
// ==================================================

draw_set_font(fntDebug);

var _text = "QUICK SAVED";
var _text_w = string_width(_text);
var _text_h = string_height(_text);

// ==================================================
// РАЗМЕРЫ ПОДЛОЖКИ
// ==================================================

var _box_w = _padding_x
           + _accent_width
           + _accent_gap
           + _icon_size
           + _icon_text_gap
           + _text_w
           + _padding_x;

var _box_h = max(_icon_size, _text_h) + _padding_y * 2;

// ==================================================
// ПОЛОЖЕНИЕ ПОДЛОЖКИ
// ==================================================

var _x2 = _gui_w - _edge_margin;
var _y2 = _gui_h - _edge_margin + quick_save_notification_offset_y;

var _x1 = _x2 - _box_w;
var _y1 = _y2 - _box_h;

// ==================================================
// СОХРАНЯЕМ НАСТРОЙКИ ОТРИСОВКИ
// ==================================================

var _old_alpha = draw_get_alpha();
var _old_color = draw_get_color();
var _old_font = draw_get_font();
var _old_halign = draw_get_halign();
var _old_valign = draw_get_valign();

// ==================================================
// ТЁМНАЯ ПОДЛОЖКА
// ==================================================

draw_set_alpha(_alpha * 0.95);
draw_set_color(make_color_rgb(12, 12, 18));

draw_rectangle(
    _x1, _y1,
    _x2, _y2,
    false
);

// ==================================================
// НЕОНОВОЕ СВЕЧЕНИЕ И РАМКА
// ==================================================

// Внешнее свечение
draw_set_alpha(_alpha * 0.18);
draw_set_color(_neon_color);

draw_rectangle(
    _x1 - 2, _y1 - 2,
    _x2 + 2, _y2 + 2,
    true
);

// Основная рамка
draw_set_alpha(_alpha);
draw_set_color(_neon_color);

draw_rectangle(
    _x1, _y1,
    _x2, _y2,
    true
);

// ==================================================
// ВЕРТИКАЛЬНАЯ НЕОНОВАЯ ПОЛОСА
// ==================================================

var _accent_x = _x1 + _padding_x;
var _accent_y1 = _y1 + _padding_y;
var _accent_y2 = _y2 - _padding_y;

draw_set_alpha(_alpha * 0.3);
draw_set_color(_neon_color);

draw_rectangle(
    _accent_x - 2,
    _accent_y1 - 2,
    _accent_x + _accent_width + 2,
    _accent_y2 + 2,
    false
);

draw_set_alpha(_alpha);
draw_set_color(_neon_color);

draw_rectangle(
    _accent_x,
    _accent_y1,
    _accent_x + _accent_width,
    _accent_y2,
    false
);

// ==================================================
// ЦЕНТР ДИСКЕТЫ
// ==================================================

var _icon_center_x = _accent_x + _accent_width
                   + _accent_gap + _icon_size * 0.5;

var _icon_center_y = _y1 + _box_h * 0.5;

// ==================================================
// ПОКАЧИВАНИЕ ДИСКЕТЫ ВОКРУГ ЦЕНТРА
// ==================================================

var _rotation = sin(_time * 4) * 7;

var _sprite_w = sprite_get_width(sprSaveManager);
var _sprite_h = sprite_get_height(sprSaveManager);

var _scale = _icon_size / max(_sprite_w, _sprite_h);

// Координаты центра спрайта относительно его origin
var _pivot_x = (_sprite_w * 0.5 - sprite_get_xoffset(sprSaveManager)) * _scale;
var _pivot_y = (_sprite_h * 0.5 - sprite_get_yoffset(sprSaveManager)) * _scale;

// Угол вращения
var _angle = degtorad(_rotation);

// Компенсация смещения origin
var _draw_x = _icon_center_x
            - (_pivot_x * cos(_angle) - _pivot_y * sin(_angle));

var _draw_y = _icon_center_y
            - (_pivot_x * sin(_angle) + _pivot_y * cos(_angle));

draw_sprite_ext(
    sprSaveManager,
    0,
    _draw_x,
    _draw_y,
    _scale,
    _scale,
    _rotation,
    c_white,
    _alpha
);

// ==================================================
// ТЕКСТ QUICK SAVED
// ==================================================

draw_set_alpha(_alpha);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

draw_text(
    _icon_center_x + _icon_size * 0.5 + _icon_text_gap,
    _icon_center_y,
    _text
);

// ==================================================
// ВОССТАНАВЛИВАЕМ НАСТРОЙКИ ОТРИСОВКИ
// ==================================================

draw_set_alpha(_old_alpha);
draw_set_color(_old_color);
draw_set_font(_old_font);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);
