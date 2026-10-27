// Базовые дефолтные значения (перезапишутся при спавне)
scale_x = 1.0;
scale_y = 1.0;
pull_up = 0;
wave_amp = 0;
wave_speed = 0.01;
fog_color = c_black;
draw_alpha = 1.0;

wave_time = random(100);

// Рассчитываем переменные сетки отрисовки
var _gui_w = display_get_gui_width();
var _orig_w = sprite_get_width(sprScoreCityScape);

// Пересчет ширины сделаем на первом шаге Draw, чтобы учесть scale_x
initialized = false;
spr_w = 0;
half_w = 0;
needed_backdrops = 0;
