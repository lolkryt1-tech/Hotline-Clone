/*
if (other.faction == faction) exit;

// 1. ВОСПРОИЗВЕДЕНИЕ СЛУЧАЙНОГО ЗВУКА ПОПАДАНИЯ И ПЕРЕМЕННЫЕ
var _hit_sound = choose(sndBulletHit1, sndBulletHit2, sndBulletHit3);
var _played_sound = audio_play_sound(_hit_sound, 1, false);

if (can_hear == 0) { instance_create_layer(x, y, "Instances", objHeadSet) }

if (_played_sound != -1)
{
    audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
}


var _bullet_dir = other.direction; 

// 3. Уничтожаем прилетевшую пулю
with (other) 
{
    instance_destroy();
}

// 4. Спавним труп на месте врага
var _dead_body = instance_create_layer(x, y, "Instances", objDeadBody);
_dead_body.sprite_index = my_sprites.sprites.deadMachineGun;
_dead_body.speed        = 0.5;
_dead_body.direction    = _bullet_dir;
_dead_body.my_angle     = _bullet_dir; 

// === КРИТИЧЕСКИЙ ФИКС: Скармливаем трупу переменные для брызг ДО уничтожения врага ===
_dead_body.hit_type = HIT_TYPE.BULLET;
_dead_body.go_splat = 1;
_dead_body.class    = class; // Передаем класс, чтобы работала ваша гибкая система

if (weapon != WEAPONS.UNARMED)
{
	var _dropped = instance_create_layer(x, y, "Instances", objWeapon);
	_dropped.direction = irandom(360);
	_dropped.speed = 5;
	
	_dropped.my_angle = irandom(360);
	_dropped.weapon = weapon;
}


instance_destroy();
