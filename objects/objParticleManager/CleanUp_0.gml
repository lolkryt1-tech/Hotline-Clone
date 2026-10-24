// Уничтожаем системы при выходе из игры
if (part_system_exists(global.sys_smoke)) part_system_destroy(global.sys_smoke);
if (part_system_exists(global.sys_sparks)) part_system_destroy(global.sys_sparks);