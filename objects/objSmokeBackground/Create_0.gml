depth = 10; // Должен быть БОЛЬШЕ (ниже), чем у текста названия уровня

anim_time = 0;
smoke_progress = 0.0;

// Генерируем случайное смещение для шейдера
smoke_seed_x = random_range(0, 1000);
smoke_seed_y = random_range(0, 1000);

// Инициализация юниформ
u_time       = shader_get_uniform(shdLevelTitleSmoke, "u_time");
u_resolution = shader_get_uniform(shdLevelTitleSmoke, "u_resolution");
u_color_base = shader_get_uniform(shdLevelTitleSmoke, "u_color_base");
u_color_glow = shader_get_uniform(shdLevelTitleSmoke, "u_color_glow");
u_progress   = shader_get_uniform(shdLevelTitleSmoke, "u_progress");
u_smoke_seed = shader_get_uniform(shdLevelTitleSmoke, "u_smoke_seed");
