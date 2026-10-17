timer++;

switch (state)
{
    case 0: // Фаза 1: Схождение половин к центру
        gui_alpha = lerp(0, 1, timer / fade_in_time);
        split_offset = lerp(120, 0, timer / fade_in_time); 
        if (timer >= fade_in_time) { state = 1; timer = 0; gui_alpha = 1; split_offset = 0; }
        break;
        
    case 1: // Фаза 2: Удержание
        gui_alpha = 1;
        split_offset = 0;
        if (timer >= hold_time) { state = 2; timer = 0; }
        break;
        
    case 2: // Фаза 3: Растворение
        gui_alpha = lerp(1, 0, timer / fade_out_time);
        if (timer >= fade_out_time) { instance_destroy(); }
        break;
}
