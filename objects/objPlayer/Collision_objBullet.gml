// 1. ПРОВЕРКА ФРАКЦИИ ПУЛИ: Если пуля своя (выпущена игроком) — полностью игнорируем её
if (other.faction == faction) 
{
	exit; 
}


// Запоминаем направление полета пули перед её удалением
var _bullet_dir = other.direction; 


// 2. Уничтожаем прилетевшую пулю врага
instance_destroy(other);


// 3. Спавним облако крови
var _blood_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
_blood_smoke.speed        = 1.5;
_blood_smoke.direction    = _bullet_dir - 180;
_blood_smoke.my_angle     = _bullet_dir - 180; 


// 3. ПРОВЕРКА ЗДОРОВЬЯ (ENERGY): Вычитаем 1 единицу хп за попадание
energy--;

// Дополнительный сок: тряска экрана от попадания по игроку
if (instance_exists(objEffector)) { objEffector.shake = 3.5; }

// Если здоровье еще осталось — игрок выжил, просто выходим (экран может мигнуть красным)
if (energy > 0) 
{
	// Воспроизводим обычный звук попадания по мясу
	var _played_sound = audio_play_sound(choose(sndBulletHit1, sndBulletHit2, sndBulletHit3), 1, false);
	if (_played_sound != -1) audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
	exit; 
}

// === 4. ЕСЛИ ЭНЕРГИЯ ЗАКОНЧИЛАСЬ — ИГРОК УМИРАЕТ И СПАВНИТ ТРУП ===

// Воспроизводим тяжелый звук смертельного попадания
var _hit_sound = choose(sndBulletHit1, sndBulletHit2, sndBulletHit3);
var _played_sound = audio_play_sound(_hit_sound, 1, false);
if (_played_sound != -1) audio_sound_pitch(_played_sound, random_range(0.9, 1.1));

// Спавним труп игрока на его координатах
var _dead_body = instance_create_layer(x, y, "Instances", objPlayerDead);


// Задаем физику полета трупа от пули
_dead_body.sprite_index = sprCopDeadMachinegun;
_dead_body.speed        = 0.5;
_dead_body.direction    = _bullet_dir;
_dead_body.my_angle     = _bullet_dir; 

// Скармливаем трупу переменные для брызг крови и шейдеров
_dead_body.hit_type     = HIT_TYPE.BULLET;
_dead_body.go_splat     = 1;

// Полностью уничтожаем живой инстанс игрока
instance_destroy();
