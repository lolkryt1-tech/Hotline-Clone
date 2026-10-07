function scrPlayerDieBlunt(_killer)
{
	audio_play_sound(sndHit3, 1, false);
	objEffector.shake = 5;
	
	var _px = 0;
	var _py = 0;
	var _victim_id = noone;

	if (instance_exists(objPlayer))
	{
		_victim_id = instance_find(objPlayer, 0);
	}
	else 
	{
		_victim_id = instance_find(objPlayerExecution, 0);
	}

	if (_victim_id == noone) exit;

	_px = _victim_id.x;
	_py = _victim_id.y;
	
	var _push_dir = point_direction(_killer.x, _killer.y, _px, _py);
    
	
	instance_destroy(_victim_id);
    
	// Спавним труп игрока
	var _corpse = instance_create_layer(_px, _py, "Instances", objPlayerDead);
	_corpse.image_index = irandom_range(1, 14);
	_corpse.direction   = _push_dir;
	_corpse.speed       = 5;
	_corpse.my_angle    = _push_dir;
}
