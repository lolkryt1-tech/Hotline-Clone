function LevelSelect_UpdateAnimations()
{
    title_pulse += 0.05;

    if (fade_state == 1)
    {
        fade_alpha = max(0, fade_alpha - fade_speed);
    }
    else if (fade_state == -1)
    {
        fade_alpha = min(1, fade_alpha + fade_speed);
    }
}