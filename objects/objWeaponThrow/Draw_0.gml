// DEBUG
//draw_text(x + 15, y + 45, "Current Weapon : " + string(weapon));
//draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,true)

// 1. Фиксированный радиус поменьше (без пульсации)
var _glow_radius = 14;

// 2. РИСУЕМ СТАТИЧНУЮ МЯГКУЮ БЕЛУЮ ПОДСВЕТКУ
draw_set_alpha(0.22); // Прозрачность круга
gpu_set_blendmode_ext(bm_src_alpha, bm_one); // Режим мягкого неонового свечения

// Рисуем стабильный градиентный круг на полу
draw_circle_color(x, y, _glow_radius, c_white, c_black, false);

// Возвращаем настройки рисования обратно в дефолт
gpu_set_blendmode(bm_normal);
draw_set_alpha(1.0);


// 3. ТВОЙ ОРИГИНАЛЬНЫЙ КОД (рисует оружие поверх круга)
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, my_angle, image_blend, image_alpha);