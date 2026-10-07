if (instance_exists(my_hurtbox)) instance_destroy(my_hurtbox);

if (path_exists(my_path)) 
{
    path_delete(my_path); // Уничтожаем его
    
    // 2. Проверяем еще раз, чтобы убедиться, что он СТЕРТ
    if (!path_exists(my_path)) {
        show_debug_message("УСПЕХ: Путь врага " + string(id) + " полностью удален из памяти!");
    }
}

if (ds_exists(targets_list, ds_type_list)) 
{
    ds_list_destroy(targets_list);
}