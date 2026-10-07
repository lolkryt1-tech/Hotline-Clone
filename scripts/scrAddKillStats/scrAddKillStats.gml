function scrAddKillStats(_base_score, _is_execution)
{
    global.combo_current += 1;
    global.combo_timer = global.combo_time_max;
    
    if (global.combo_current > global.combo_max_level) 
    {
        global.combo_max_level = global.combo_current;
    }
    
    global.total_score += _base_score * global.combo_current;
    global.enemies_killed += 1;
    
    if (_is_execution) 
    {
        global.executions_count += 1;
    }
    
    // Эффекты вспышки и увеличения (поднимаем вспышку до 1.0, чтобы белый цвет был заметен!)
    with (objLevelStatistic)
    {
        combo_scale = 1.4; // Текст увеличится в 1.4 раза
        combo_flash = 1.0; // Сделает его временно белым
    }
}
