if (variable_global_exists("mp_grid") && global.mp_grid != noone) 
{
    mp_grid_destroy(global.mp_grid);
    global.mp_grid = noone;
}

