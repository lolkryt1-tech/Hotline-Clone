// 1. Искусственно расширяем хитбокс на 1 кадр, чтобы "поймать" быструю пулю
image_xscale = 3;
image_yscale = 3;
global.my_id = id;
var _bullets_hit = 0;
instance_destroy(my_light);

// 2. Проверяем пули, попавшие в зону, наносим урон и уничтожаем их
with (objBullet)
{
    if (place_meeting(x, y, global.my_id))
    {
        _bullets_hit += 1;
        
        // Корректируем координаты спавна, чтобы дым не висел в воздухе из-за xscale=3.
        // Зажимаем (clamp) координаты пули в пределах реальных размеров телевизора (например, 16 пикселей от центра).
        // Если у твоего телика другой размер спрайта, можно поменять 16 на нужный радиус.
        var _smoke_x = clamp(x, global.my_id.x - 16, global.my_id.x + 16);
        var _smoke_y = clamp(y, global.my_id.y - 16, global.my_id.y + 16);
        
        // Создаем дым в скорректированной точке
        var _smoke = instance_create_layer(_smoke_x, _smoke_y, "Instances", objSmokeHit);
        _smoke.color1 = 8421504;
        _smoke.color2 = 4210752;
        _smoke.image_angle = image_angle;
        
        // Добавляем рандомное отклонение к направлению (например, в пределах 30 градусов: от -15 до +15)
        var _random_deviation = random_range(-15, 15);
        _smoke.direction = (image_angle - 180) + _random_deviation;
        
        _smoke.speed = 0.5 + random(1); // Чуть увеличили минимальную скорость, чтобы дым заметнее отлетал
        
        // Уничтожаем пулю, которая врезалась
        instance_destroy();
    }
}

// 3. Возвращаем телевизору нормальный размер
image_xscale = 1;
image_yscale = 1;

// Если в этом кадре попаданий не было или ТВ уже уничтожен — выходим
if (_bullets_hit == 0 || energie <= 0) exit;

// Отнимаем здоровье по количеству попавших пуль
energie -= _bullets_hit;
alert = 1; // Включаем тревогу у телевизора

// === ФАЗА 1: ТЕЛИК ПРОСТО СЛОМАЛСЯ (Энергия еще есть) ===
if (energie > 0)
{
    if (sprite_index == sprTVBig)
    {
        objEffector.shake = 1;
        sprite_index = sprTVBigBreak;
        audio_play_sound(sndGlass1, 0, false);
        audio_play_sound(sndTaser, 0, false);
        
        var i = 0;
        repeat (24)
        {
            var my_id = instance_create_layer(x + lengthdir_x(12, (image_angle - 45) + (i * 3.75)), y + lengthdir_y(12, (image_angle - 45) + (i * 3.75)), "Instances", objTVShards);
            my_id.direction = (image_angle - 45) + (i * 3.75);
            my_id.speed = 1 + random(3);
            i += 1;
        }
    }
}
// === ФАЗА 2: ПОЛНОЕ УНИЧТОЖЕНИЕ (Энергия кончилась) ===
else
{
    audio_play_sound(sndGlass1, 0, false);
    if (life > 0) audio_play_sound(sndTaser, 0, false);
    audio_play_sound(sndExplode, 0, false);
    
    global.shake = 6;
    image_index = choose(0, 1);
    
    // Общие эффекты взрыва для обоих вариантов обломков
    var i = random(1);
    repeat (8)
    {
        var length = 1 + random(2);
        var my_id = instance_create_layer(x + lengthdir_x(length, i * 45), y + lengthdir_y(length, i * 45), "Instances", objFirePuff);
        my_id.image_angle = (i * 45) - 180;
        my_id.direction = my_id.image_angle - 180;
        my_id.speed = 0.5 + random(1);
        my_id.friction = 0.1;
        i += 1;
    }
    
    repeat (4)
    {
        var my_id = instance_create_layer((x - 4) + random(8), (y - 4) + random(8), "Instances", objFireBall);
        my_id.direction = point_direction(x, y, my_id.x, my_id.y);
        my_id.speed = 0.25 + random(0.25);
    }
    
    repeat (16)
    {
        var my_id = instance_create_layer(x, y, "Instances", objFireSpark);
        my_id.direction = random(360);
        my_id.speed = 3 + random(3);
        my_id.image_angle = my_id.direction;
    }
    
    // Уникальные крупные обломки (теперь без смещения самого телика!)
    if (image_index == 0)
    {
        repeat (16)
        {
            var my_id = instance_create_layer((x - 6) + random(12), (y - 6) + random(12), "Instances", objTVBigParts);
            my_id.direction = point_direction(x, y, my_id.x, my_id.y);
            my_id.speed = 2 + random(3);
        }
    }
    else
    {
        repeat (16)
        {
            // Убрали смещения по lengthdir для x и y, спавним ровно по центру объекта
            var my_id = instance_create_layer((x - 3) + random(6), (y - 3) + random(6), "Instances", objTVBigParts);
            my_id.direction = point_direction(x, y, my_id.x, my_id.y);
            my_id.speed = 2 + random(3);
        }
    }
    
    // Дополнительный спавн осколков стекла, если он до этого кадра был абсолютно целым
    if (sprite_index == sprTVBig)
    {
        i = 0;
        repeat (24)
        {
            var my_id = instance_create_layer(x + lengthdir_x(12, (image_angle - 45) + (i * 3.75)), y + lengthdir_y(12, (image_angle - 45) + (i * 3.75)), "Instances", objTVShards);
            my_id.direction = (image_angle - 45) + (i * 3.75);
            my_id.speed = 1 + random(3);
            i += 1;
        }
    }
    
    // Окончательно переводим спрайт в состояние "сломан"
    sprite_index = sprTVBigBroken;
    image_speed = 0;
}
