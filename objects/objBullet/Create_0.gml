enum CALIBRE 
{
    PISTOL,    // Обычный пистолет / М16 (уничтожается при первом попадании)
    SHOTGUN,   // Дробинка дробовика (накапливает pellets_hit, уничтожается)
    MAGNUM     // Мощный патрон (пробивает обычных врагов насквозь, летит дальше!)
}

image_blend = merge_color(c_white, c_white, random(1));
image_alpha = 0.7;
image_speed = 0;
image_index = floor(random(4));




faction = noone;
caliber = noone;