// 1. Считаем текущее смещение по синусоиде
var _y_offset = sin(hover_timer) * hover_amplitude;

// 2. УВЕЛИЧЕННЫЙ РАДИУС: базовый 22 пикселя + плавное дыхание на 4 пикселя вбок
var _glow_radius = 22 + (cos(hover_timer) * 4);


// === РИСУЕМ МЯГКУЮ БЕЛУЮ ПОДСВЕТКУ УВЕЛИЧЕННОГО РАДИУСА ===
// Оставляем тусклую альфу (0.22), чтобы большой круг не выжигал глаза и смотрелся стильно
draw_set_alpha(0.22);

// Включаем расширенный режим смешивания
gpu_set_blendmode_ext(bm_src_alpha, bm_one);

// Рисуем градиент: теперь он покроет большую площадь пола вокруг пушки
draw_circle_color(x, y, _glow_radius, c_white, c_black, false);

// Возвращаем нормальный режим рисования и дефолтную альфу
gpu_set_blendmode(bm_normal);
draw_set_alpha(1.0);


// 3. РИСУЕМ ТЕНЬ
draw_sprite_ext(sprite_index, image_index, x + 1, y + 2, image_xscale, image_yscale, my_angle, c_black, 0.4);

// 4. РИСУЕМ САМО ОРУЖИЕ
draw_sprite_ext(sprite_index, image_index, x, y + _y_offset, image_xscale, image_yscale, my_angle, image_blend, image_alpha);

draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,true)