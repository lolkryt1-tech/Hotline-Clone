friction = 0.2;
image_blend = merge_color(c_red, c_maroon, 0.5 + random(0.05));

global.blood_render_counter--
depth = global.blood_render_counter;

my_angle = 0;
image_speed = 0.5;

alarm[0] = 60;