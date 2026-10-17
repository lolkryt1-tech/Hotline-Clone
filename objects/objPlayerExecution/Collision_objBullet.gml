// =========================================================================
// 1. ПРОВЕРКА ФРАКЦИИ ПУЛИ
// =========================================================================
if (other.faction == faction) 
{
	exit; 
}

// Запоминаем параметры первой прилетевшей пули
var _bullet_dir     = other.direction; 
var _bullet_calibre = other.calibre;
var _bullet_faction = other.faction;

var _pellets_hit = 1; // Засчитываем текущую пулю

// =========================================================================
// 2. ЕДИНАЯ СИСТЕМА СБОРА И УНИЧТОЖЕНИЯ ПУЛЬ ДЛЯ ИГРОКА
// =========================================================================
if (_bullet_calibre == CALIBRE.SHOTGUN)
{
    instance_destroy(other); // Стираем первую дробинку
    
    // Пылесосим остальные вражеские дробинки вокруг игрока в этом же кадре
    var _bullet_list = ds_list_create();
    var _num_bullets = collision_circle_list(x, y, 24, objBullet, false, true, _bullet_list, false);
    
    for (var i = 0; i < _num_bullets; i++)
    {
        var _found_bullet = _bullet_list[| i];
        if (_found_bullet.faction != faction && _found_bullet.faction == _bullet_faction && _found_bullet.calibre == CALIBRE.SHOTGUN)
        {
            _pellets_hit += 1; 
            instance_destroy(_found_bullet); // Уничтожаем, чтобы не сработали на следующем кадре
        }
    }
    ds_list_destroy(_bullet_list);
    
    if (_pellets_hit < 3) _pellets_hit = 3; 
}
else 
{
    // Обычная пуля просто уничтожается
    instance_destroy(other);
}

// =========================================================================
// 3. СПАВН ЭФФЕКТОВ И РАСЧЕТ ЗДОРОВЬЯ
// =========================================================================
// Спавним облако крови
var _blood_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
_blood_smoke.speed        = 1.5;
_blood_smoke.direction    = _bullet_dir - 180;
_blood_smoke.my_angle     = _bullet_dir - 180; 

// ИСПРАВЛЕНИЕ: Вычитаем здоровье честно — по 1 за КАЖДУЮ пойманную дробинку!
energy -= _pellets_hit;

// Дополнительный сок: тряска экрана от попадания по игроку (умножаем на количество дроби для эффекта)
if (instance_exists(objEffector)) 
{ 
    objEffector.shake = 3.5 * min(_pellets_hit, 3); // Ограничим тряску, чтобы экран не улетел
}

// Если здоровье еще осталось — игрок выжил, просто выходим
if (energy > 0) 
{
	var _played_sound = audio_play_sound(choose(sndBulletHit1, sndBulletHit2, sndBulletHit3), 1, false);
	if (_played_sound != -1) audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
	exit; 
}

// =========================================================================
// 4. ЕСЛИ ЭНЕРГИЯ ЗАКОНЧИЛАСЬ — ИГРОК УМИРАЕТ И СПАВНИТ ТРУП
// =========================================================================
// Воспроизводим тяжелый звук смертельного попадания
var _hit_sound = choose(sndBulletHit1, sndBulletHit2, sndBulletHit3);
var _played_sound = audio_play_sound(_hit_sound, 1, false);
if (_played_sound != -1) audio_sound_pitch(_played_sound, random_range(0.9, 1.1));

// Спавним труп игрока на его координатах
var _dead_body = instance_create_layer(x, y, "Instances", objPlayerDead);

// НАСТРОЙКА СПРАЙТА И СКОРОСТИ ОТЛЁТА В ЗАВИСИМОСТИ ОТ КОЛИЧЕСТВА ДРОБИН
if (_bullet_calibre == CALIBRE.SHOTGUN && _pellets_hit >= 2)
{
    // Если игрока разнесло плотным залпом дроби (2 и более дробинок)
    _dead_body.sprite_index = sprCopDeadShotgun; 
    _dead_body.speed        = 4.0; // Сочный отлёт назад
}
else
{
    // Если убит обычным калибром ИЛИ прилетела всего 1 случайная дробинка по касательной
    _dead_body.sprite_index = sprCopDeadMachinegun; 
    _dead_body.speed        = 2.5; // Обычное падение
}

_dead_body.direction    = _bullet_dir;
_dead_body.my_angle     = _bullet_dir; 

// Скармливаем трупу переменные для брызг крови и шейдеров
_dead_body.hit_type     = HIT_TYPE.BULLET;
_dead_body.go_splat     = 1;

// Полностью уничтожаем живой инстанс игрока
instance_destroy();