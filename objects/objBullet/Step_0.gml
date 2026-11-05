if (invisible_timer > 0) invisible_timer--;

if (invisible_timer > 0) { image_alpha = 0; }
else { image_alpha = 0.7;}

image_blend = merge_color(c_white, c_yellow, random(1));
