function scrPlayerDieBlunt(_killer)
{
	audio_play_sound(sndHit3, 1, false);
	objEffector.shake = 5;
	
    if (!instance_exists(objPlayer)) exit;
    
    var _px = objPlayer.x;
    var _py = objPlayer.y;
    
    var _push_dir = point_direction(_killer.x, _killer.y, _px, _py);
    
    instance_destroy(objPlayer);
    
    var _corpse = instance_create_layer(_px, _py, "Instances", objPlayerDead);
    
	_corpse.image_index = irandom_range(1, 14);
	_corpse.direction = _push_dir;
	_corpse.speed  = 5;
				
	_corpse.my_angle = _push_dir;
}