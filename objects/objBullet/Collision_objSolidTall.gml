my_id = instance_create_layer(x, y, "Instances", objSmokeHit);
my_id.image_angle = direction;
my_id.direction = direction - 180;
my_id.speed = random(1);
amount = random(0.5);
my_id.color1 = merge_color(c_gray, c_dkgray, amount);
my_id.color2 = merge_color(c_dkgray, c_black, amount);

repeat (4)
{
    my_id = instance_create_layer(x + lengthdir_x(14, direction), y + lengthdir_y(14, direction), "Instances", objWallDebris);
    my_id.direction = direction - 140 - random(80);
    my_id.speed = random(4);
}


audio_play_sound(choose(sndBulletWallImpact, sndBulletWallImpact1, sndBulletWallImpact2, sndBulletWallImpact3, sndBulletWallImpact4), 10, false);
instance_destroy();