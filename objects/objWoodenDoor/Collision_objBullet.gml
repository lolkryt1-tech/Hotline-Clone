// === 1. ЭФФЕКТЫ ПОПАДАНИЯ ДЛЯ ВСЕХ СОСТОЯНИЙ ДВЕРИ (ЗВУК, ДЫМ, БЕЛЫЕ ОСКОЛКИ) ===

// Воспроизводим случайный звук удара по дереву
audio_play_sound(choose(sndBulletWoodImpact, sndBulletWoodImpact2, sndBulletWoodImpact3), 10, false);

// Спавним дым в точке удара пули (отлетает назад с небольшим разбросом)
var _smoke = instance_create_layer(other.x, other.y, "Instances", objSmokeHit);
_smoke.image_angle = other.direction;
var _random_deviation = random_range(-15, 15);
_smoke.direction = (other.direction - 180) + _random_deviation;
_smoke.speed = random(1);

var _amount = random(0.5);
_smoke.color1 = merge_color(c_gray, c_dkgray, _amount);
_smoke.color2 = merge_color(c_dkgray, c_black, _amount);

// Спавним 4 белых осколка
repeat (4)
{
    var _debris = instance_create_layer(other.x, other.y, "Instances", objWallDebris);
    _debris.direction = other.direction - 140 - random(80);
    _debris.speed     = random(4);
	_debris.is_white_wall = false;
    
    // Окрашивание осколков в коричневые оттенки
    var _col_brown_light = make_color_rgb(115, 30, 0);  
    var _col_brown_dark  = make_color_rgb(92, 51, 23);   
    _debris.image_blend  = merge_color(_col_brown_light, _col_brown_dark, random(1));
}

// === 2. ПРОВЕРКА НА ЗАПЕРТУЮ ДВЕРЬ ===
// Если дверь закрыта на замок — эффекты выше сработали, пуля ломается, дверь не двигается
if (closed) 
{ 
    instance_destroy(other); 
    return; 
}

// === 3. РАСЧЕТ ИМПУЛЬСА ДЛЯ ОТКРЫТИЯ ===
// Проверяем, находится ли дверь в своём изначальном закрытом положении в проёме
var _is_at_start_position = (image_angle == start_angle);

// Вычисляем, с какой стороны прилетела пуля, чтобы знать, куда крутить дверь
var _angle_diff = angle_difference(other.direction, image_angle);
var _push_direction = (_angle_diff > 0) ? 1 : -1;

// Фиксируем, что дверь получила импульс (1 - от игрока/его оружия)
swinger = 1; 

// === 4. ЛОГИКА КАЛИБРОВ ===
switch (other.calibre)
{
    case CALIBRE.SMALL:
        // --- МАЛЕНЬКИЙ КАЛИБР ---
        if (_is_at_start_position) 
        {
            instance_destroy(other);
        }
        else 
        {
            swingspeed = 2 * _push_direction;
            instance_destroy(other);
        }
        break;
        
    case CALIBRE.MID:
        // --- СРЕДНИЙ КАЛИБР ---
        swingspeed = 4 * _push_direction;
        instance_destroy(other);
        break;
        
    case CALIBRE.BIG:
        // --- БОЛЬШОЙ КАЛИБР ---
        // Мощно толкает дверь и прошибает её насквозь (пуля летит дальше)
        swingspeed = 16 * _push_direction;
        audio_play_sound(sndBulletWallImpact, 10, false); 
        break;
        
    case CALIBRE.SHOTGUN:
        // --- ДРОБОВИК ---
        swingspeed = 24 * _push_direction;
        instance_destroy(other);
        break;
}