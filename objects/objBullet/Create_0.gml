enum CALIBRE 
{
    SMALL,      // Маленький (Пистолеты, ПП — открывает только приоткрытую дверь)
    MID,        // Средний (Автоматы, Винтовки — толкает закрытую дверь)
    BIG,        // Большой (Снайперские винтовки, Пулеметы — шьет дверь насквозь)
    SHOTGUN     // Дробовик (Особое поведение — уничтожает замок, сносит дверь в упор)
}

image_blend = merge_color(c_white, c_white, random(1));
image_alpha = 0.7;
image_speed = 0;
image_index = floor(random(4));
depth = -10000;




faction = noone;
caliber = noone;