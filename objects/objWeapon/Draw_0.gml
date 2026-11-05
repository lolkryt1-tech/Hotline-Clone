// 1. Считаем текущее смещение по синусоиде
var _y_offset = sin(hover_timer) * hover_amplitude;

// === МОДИФИКАЦИЯ ДЛЯ REVERSE РЕЖИМА (ТОЛЬКО ТЕНЬ) ===
var _shadow_x_offset = 1;
var _shadow_y_offset = 2;

if (global.hard == true) 
{
    _shadow_x_offset = -1;           // Сдвигаем тень в противоположную сторону по X
    _shadow_y_offset = -2;           // Сдвигаем тень в противоположную сторону по Y
}
// ====================================================

// 2. УВЕЛИЧЕННЫЙ РАДИУС: базовый 22 пикселя + плавное дыхание на 4 пикселя вбок
var _glow_radius = 22 + (cos(hover_timer) * 4);


// === ЛОГИКА ОКРАШИВАНИЯ ПРИ ЗАЖАТОЙ MOUSE 4 ===
var _glow_color = c_white;
var _weapon_color = image_blend; 

if (mouse_check_button(mb_side1) && weapon_type == TYPE.MELEE) 
{
    _glow_color = c_lime;          
    _weapon_color = c_lime;        
}

if (mouse_check_button(mb_side2) && weapon_type == TYPE.RANGE) 
{
    _glow_color = c_red;           
    _weapon_color = c_red;         
}

// === РИСУЕМ МЯГКУЮ ПОДСВЕТКУ УВЕЛИЧЕННОГО РАДИУСА ===
draw_set_alpha(0.22);
gpu_set_blendmode_ext(bm_src_alpha, bm_one);
draw_circle_color(x, y, _glow_radius, _glow_color, c_black, false);
gpu_set_blendmode(bm_normal);
draw_set_alpha(1.0);


// 3. РИСУЕМ ТЕНЬ (Используем только инвертированные смещения)
draw_sprite_ext(sprite_index, image_index, x + _shadow_x_offset, y + _shadow_y_offset, image_xscale, image_yscale, my_angle, c_black, 0.4);

// 4. РИСУЕМ САМО ОРУЖИЕ (Стандартное покачивание и оригинальный my_angle)
draw_sprite_ext(sprite_index, image_index, x, y + _y_offset, image_xscale, image_yscale, my_angle, _weapon_color, image_alpha);
