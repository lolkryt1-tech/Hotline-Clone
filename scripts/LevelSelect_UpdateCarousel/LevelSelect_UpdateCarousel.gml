function LevelSelect_UpdateCarousel()
{
    if (state == LEVEL_STATE.LEAVING) return;

    var _distance = abs(scroll_value - target_scroll);

    // Плавное перемещение к выбранному уровню.
    if (_distance > 0.01)
    {
        if (_distance > 0.5) current_scroll_speed = lerp(current_scroll_speed, fast_scroll_speed, 0.1);
        else current_scroll_speed = lerp(current_scroll_speed, base_scroll_speed * 0.5, 0.2);

        if (scroll_value < target_scroll) scroll_value = min(target_scroll, scroll_value + current_scroll_speed);
        else scroll_value = max(target_scroll, scroll_value - current_scroll_speed);
    }
    else
    {
        scroll_value = target_scroll;
        current_scroll_speed = lerp(current_scroll_speed, base_scroll_speed, 0.1);
    }

    // Затухание эффекта разлёта линий.
    if (dash_spread > 0)
    {
        dash_spread = lerp(dash_spread, 0, 0.08);
        if (dash_spread < 0.1) dash_spread = 0;
    }
}
