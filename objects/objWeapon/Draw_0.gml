// 1. Считаем текущее смещение по синусоиде
var _y_offset = sin(hover_timer) * hover_amplitude;

// 2. УВЕЛИЧЕННЫЙ РАДИУС: базовый 22 пикселя + плавное дыхание на 4 пикселя вбок
var _glow_radius = 22 + (cos(hover_timer) * 4);


// === ЛОГИКА ОКРАШИВАНИЯ ПРИ ЗАЖАТОЙ MOUSE 4 ===
var _glow_color = c_white;
var _weapon_color = image_blend; // Сохраняем стандартный цвет (обычно c_white)

// Mouse 4 зажата -> Зеленеет ближний бой
if (mouse_check_button(mb_side1) && weapon_type == TYPE.MELEE) 
{
    _glow_color = c_lime;          // Подсветка станет ярко-зелёной
    _weapon_color = c_lime;        // Само оружие окрасится в зелёный
}

// Mouse 5 зажата -> Краснеет дальний бой
if (mouse_check_button(mb_side2) && weapon_type == TYPE.RANGE) 
{
    _glow_color = c_red;           // Подсветка станет ярко-красной
    _weapon_color = c_red;         // Само оружие окрасится в красный
}

// === РИСУЕМ МЯГКУЮ ПОДСВЕТКУ УВЕЛИЧЕННОГО РАДИУСА ===
// Оставляем тусклую альфу (0.22), чтобы большой круг не выжигал глаза и смотрелся стильно
draw_set_alpha(0.22);

// Включаем расширенный режим смешивания
gpu_set_blendmode_ext(bm_src_alpha, bm_one);

// Рисуем градиент: теперь цвет центра зависит от _glow_color (белый или зелёный)
draw_circle_color(x, y, _glow_radius, _glow_color, c_black, false);

// Возвращаем нормальный режим рисования и дефолтную альфу
gpu_set_blendmode(bm_normal);
draw_set_alpha(1.0);


// 3. РИСУЕМ ТЕНЬ
draw_sprite_ext(sprite_index, image_index, x + 1, y + 2, image_xscale, image_yscale, my_angle, c_black, 0.4);

// 4. РИСУЕМ САМО ОРУЖИЕ
// Заменили image_blend на нашу переменную _weapon_color, чтобы пушка окрашивалась
draw_sprite_ext(sprite_index, image_index, x, y + _y_offset, image_xscale, image_yscale, my_angle, _weapon_color, image_alpha);

// ОТРЕСОВКА ДЕБАГ-ИНФОРМАЦИИ
/*
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);

draw_text(x, y - 15, image_index);


