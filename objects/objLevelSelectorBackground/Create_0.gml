depth = 100; // Самый дальний слой
anim_time = 0;

// Получаем ID переменных из шейдера
u_time = shader_get_uniform(shdPlasma, "u_time");
u_resolution = shader_get_uniform(shdPlasma, "u_resolution");