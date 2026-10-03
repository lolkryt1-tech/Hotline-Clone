image_speed = 0;
image_alpha = 1;
image_blend = merge_color(c_red, c_maroon, 0.5);
friction = 0.5;

sprite_index = choose(sprSplat1, sprSplat2, sprSplat3, sprSmudge1, sprSmudge2, sprSmudge3);

advancespeed = 0.2 + random(0.05);
isSplated = false;

global.blood_render_counter--;
depth = global.blood_render_counter;

alarm[0] = 60; // Через 15 кадров рисуем на поверхности и удаляем