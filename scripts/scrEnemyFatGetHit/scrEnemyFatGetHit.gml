/// @param {Id} _enemy_id Инстанс толстяка
/// @param {Real} _weapon_enum Оружие удара
/// @param {Real} _push_dir Направление полета
function scrEnemyFatGetHit(_enemy_id, _weapon_enum, _push_dir)
{
	with (_enemy_id)
	{
		// 1. Дропаем оружие толстяка на пол
		if (weapon != WEAPONS.FISTS)
		{
			var _dropped = instance_create_layer(x, y, "Instances", objWeapon);
			_dropped.weapon    = weapon;
			_dropped.my_angle  = irandom(360);
			_dropped.direction = irandom(360);
			_dropped.speed     = 5;
			_dropped.ammo      = ammo; 
		}

		// 2. Дроп очков
		if (can_hear == 0) 
		{
			instance_create_layer(x, y, "Instances", objHeadSet); 
		}

		// 3. Звук сильного удара кувалдой
		var _played_sound = audio_play_sound(sndWeaponHit, 1, false);
		if (_played_sound != -1) audio_sound_pitch(_played_sound, random_range(0.9, 1.1));

		// 4. Спавн куклы нокаута для толстяка
		var _fat_knocked = instance_create_layer(x, y, "Instances", objEnemyFatKnockedOut);
		_fat_knocked.skin      = skin;
		_fat_knocked.class	   = class;
		_fat_knocked.faction   = faction;
		_fat_knocked.my_angle  = _push_dir - 180;
		_fat_knocked.fat_blood_current = fat_blood_current;
		_fat_knocked.fat_is_bleeding   = fat_is_bleeding;
		_fat_knocked.sprFatDead		   = sprFatDead;
		_fat_knocked.sprite_index      = _enemy_id.sprFatKnocked;
		_fat_knocked.image_index = 1;
		_fat_knocked.direction = _push_dir;
		_fat_knocked.speed     = 2;

		// Эффекты и начисление комбо/очков (передаем false, так как удар не у стены)
		objEffector.shake = 2.0;

		// Уничтожаем живого толстяка
		instance_destroy();
	}
}
