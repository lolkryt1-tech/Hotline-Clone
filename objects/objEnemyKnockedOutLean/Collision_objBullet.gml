// 1. ВОСПРОИЗВЕДЕНИЕ СЛУЧАЙНОГО ЗВУКА ПОПАДАНИЯ И ПЕРЕМЕННЫЕ
scrAddKillStats(250, false);
var _hit_sound = choose(sndBulletHit1, sndBulletHit2, sndBulletHit3);
var _played_sound = audio_play_sound(_hit_sound, 1, false);

if (_played_sound != -1)
{
    audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
}

// Запоминаем направление пули, если оно понадобится для каких-то частиц
var _bullet_dir = other.direction; 

// 3. Уничтожаем прилетевшую пулю
with (other) 
{
    instance_destroy();
}
// 4. Спавним труп на месте врага
var _dead_body = instance_create_layer(x, y, "Instances", objDeadBody);

// МЕНЯЕМ НА НАСТЕННЫЙ СПРАЙТ АВТОМАТНОЙ СМЕРТИ
_dead_body.sprite_index = sprDeadLeanMachinegun;
_dead_body.image_index  = irandom(2); // Садится в финальную статичную позу у стены

// КРИТИЧЕСКИЙ ФИКС: Труп никуда не летит (speed = 0) и сохраняет ровный угол стены!
_dead_body.speed        = 0; 
_dead_body.direction    = direction; // Сохраняем направление, которое было у objEnemyKnockedOutLean
_dead_body.my_angle     = my_angle;  // Сохраняем идеальный угол прижатия к стене (90, 180, 270, 360)

// === КРИТИЧЕСКИЙ ФИКС: Скармливаем трупу переменные для брызг ===
_dead_body.hit_type   = HIT_TYPE.BULLET;
_dead_body.go_splat   = 1; // Запустит взрывной спавн дыма и пятен на 360 градусов в Step трупа
_dead_body.skin		  = skin;
_dead_body.isExecuted = true; // Помечаем как казненного/настенного трупа, чтобы лужа набежала ровно под x,y

// 5. Уничтожаем сидячую куклу, уступая место полноценному трупу
instance_destroy();
