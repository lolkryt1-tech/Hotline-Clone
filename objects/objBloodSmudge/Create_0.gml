addspeed = 0.1 + random(0.2);
image_speed = 0;
image_xscale = 1;
image_yscale = image_xscale;
sprite_index = choose(sprBloodSmudge, sprBloodSmudge2, sprBloodSmudge3);
image_blend = merge_color(c_red, c_maroon, 0.5 + random(0.1));
smudgesprite = 42;
speckangle = (image_angle - 30) + random(60);
is_blood_spawned = 0;
stored_speed = 0;
blur = 0;
train = 1;
surface = 1;

friction = 0.2;

stored_speed = 0;
is_blood_spawned = false

alarm[0] = 60; // Через 30 кадров рисуем на поверхности и удаляем

global.blood_render_counter--;
depth = global.blood_render_counter;
