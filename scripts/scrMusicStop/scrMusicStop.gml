function scrMusicStop(_fade_frames = 60)
{
    with (objMusicManager)
    {
        music_pending_asset = -1;
        music_fade_duration = max(1, _fade_frames);
        music_fade_timer = 0;
        music_fade_state = 2;
    }
}