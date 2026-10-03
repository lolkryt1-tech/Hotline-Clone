if (surface_exists(global.surf_blood)) 
{
    surface_free(global.surf_blood);
    global.surf_blood = -1; // Сбрасываем в -1, чтобы в следующей комнате событие Draw создало чистую
}
