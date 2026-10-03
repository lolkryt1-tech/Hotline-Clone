if (keyboard_check_pressed(vk_escape)) {
    is_paused = !is_paused;
	
	if (is_paused)
	{
		objPauseManager.pause_tag("Pausable");
	}
	else
	{
		objPauseManager.unpause_tag("Pausable");
	}
}	