sprite_index = sprBloodSquirt1;
image_yscale = -1 + (round(random(1)) * 2);
image_speed = 1 + random(0.1);
image_xscale = 1 + random(0.5);
image_angle = random(360);
dir = image_angle;
image_blend = merge_color(c_red, c_maroon, 0.5 + random(0.1));
image_alpha = random_range(0.75, 0.9);
train = 0;
surface = 1;

depth = 6000;