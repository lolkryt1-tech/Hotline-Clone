if (trigger_delay > 0) {  trigger_delay-- image_alpha = 0.5 }
wait_timer--;

if (!instance_exists(objEnemyColombian))
{
    is_unlocked = true; 
	image_alpha = 1;
    
    // Здесь можно воспроизвести сочный звук открытия двери/очистки уровня
    // audio_play_sound(sndLevelCleared, 1, false);
}