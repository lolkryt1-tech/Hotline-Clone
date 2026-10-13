// === ПРОВЕРКА УДАРА ИГРОКА ===
// Проверяем существование игрока и то, что телевизор еще НЕ полностью разбит
if (instance_exists(objPlayer) && (sprite_index == sprTVBig || sprite_index == sprTVBigBreak))
{
    var _p = objPlayer;
    
    // Если игрок атакует в ближнем бою
    if (_p.sprite_index == _p.my_sprites.attack && _p.isRange_weapon == false)
    {
        var _reach             = 24;
        var _attack_half_angle = 45;
        
        var _mouse_dir  = point_direction(_p.x, _p.y, mouse_x, mouse_y);
        var _target_dir = point_direction(_p.x, _p.y, x, y);
        var _dist       = point_distance(_p.x, _p.y, x, y);
        
        var _is_hit = false;
        
        // --- ЗОНА Б: КОНУС АТАКИ ---
        if (_dist <= _reach)
        {
            if (abs(angle_difference(_mouse_dir, _target_dir)) <= _attack_half_angle)
            {
                var _block_los = tag_get_asset_ids("Block_LOS", asset_object);
                var _los_wall = collision_line(_p.x, _p.y, x, y, _block_los, false, true);
                if (_los_wall == noone) 
                {
                    _is_hit = true;
                }
            }
        }
        
        // --- ПОПАДАНИЕ (ВЗРЫВ ТЕЛЕВИЗОРА) ---
        if (_is_hit)
        {   
            // Звуки и тряска экрана
            audio_play_sound(sndGlass1, 0, false);
            if (life > 0) audio_play_sound(sndTaser, 0, false);
            audio_play_sound(sndExplode, 0, false);
            
            objEffector.shake = 1;
            
            // Выбираем случайный вариант разрушения
            image_index = choose(0, 1);
            
            // --- ОБЩИЕ ЭФФЕКТЫ ДЛЯ ОБОИХ ВАРИАНТОВ ---
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
            
            // --- УНИКАЛЬНЫЕ ОЛКОЛКИ ДЛЯ КАЖДОГО IMAGE_INDEX ---
            if (image_index == 0)
            {
                repeat (16)
                {
                    var my_id = instance_create_layer((x - 6) + random(12), (y - 6) + random(12), "Instances", objTVBigParts);
                    my_id.direction = point_direction(x, y, my_id.x, my_id.y);
                    my_id.speed = 2 + random(3);
                }
            }
            else if (image_index == 1)
            {
                repeat (16)
                {
                    var my_id = instance_create_layer(((x + lengthdir_x(5, image_angle + 45)) - 3) + random(6), ((y + lengthdir_y(5, image_angle + 45)) - 3) + random(6), "Instances", objTVBigParts);
                    my_id.direction = point_direction(x, y, my_id.x, my_id.y);
                    my_id.speed = 2 + random(3);
                }
            }
            
            // --- СПАВН СТЕКЛЯННЫХ ОСКОЛКОВ (Только если ТВ был целым) ---
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
            
            // Переключаем телевизор в состояние "сломан"
            sprite_index = sprTVBigBroken;
            image_speed  = 0;
        } 
    }
}

// === ЛОГИКА ИСКРЕНИЯ ПОСЛЕ ПОЛОМКИ ===
// Этот блок работает независимо от ударов игрока, каждую секунду уменьшая жизнь ТВ
if (sprite_index == sprTVBigBreak || sprite_index == sprTVBigBroken)
{
    if (life > 0)
    {
        life -= 1;
        
        // Случайные молнии
        if (round(random(3)) == 2)
        {
            var my_id = instance_create_layer(x, y, "Instances", objElectricity);
            my_id.direction = random(360);
            my_id.speed = random(1);
        }
        
        // Случайные искры
        if (round(random(2)) == 1)
        {
            var my_id = instance_create_layer((x - 8) + random(16), (y - 8) + random(16), "Instances", objElectricSpark);
            my_id.direction = point_direction(x, y, my_id.x, my_id.y);
            my_id.speed = 3 + random(2);
            my_id.image_angle = my_id.direction;
        }
    }
    else
    {
        // Когда заряды кончились — перестаем анимировать
        image_speed = 0;
        if (sprite_index == sprTVBigBreak) 
        {
            image_index = 0;
        }
    }
}
