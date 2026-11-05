depth = 4;

// ==================================================
// МАСШТАБ И АНИМАЦИЯ
// ==================================================

rank_scale_base = 0.8;
rank_scale = 0.0;
rank_subimg = 0;

outline_thick = 3;

grow_progress = 0.0;
grow_speed = 0.05;

// ==================================================
// РАНГ И ЦВЕТА
// ==================================================

is_s_rank = false;

color_F = make_color_rgb(90, 95, 115);
color_C = make_color_rgb(140, 150, 180);
color_B = make_color_rgb(0, 243, 255);
color_A = make_color_rgb(255, 0, 128);

color_S_top = make_color_rgb(255, 230, 50);
color_S_bot = make_color_rgb(200, 150, 0);

color_top = color_F;
color_bot = color_F;
color_scan = c_white;

// ==================================================
// ВСПЫШКИ И ПУЛЬСАЦИЯ
// ==================================================

white_flash = 1.0;
black_flash = 1.0;

flash_fade = 0.04;

pulse_timer = 0;
pulse_speed = 0.01;

// ==================================================
// SHADER UNIFORMS
// ==================================================

u_rank_top = shader_get_uniform(shdGradient, "u_color_top");
u_rank_bot = shader_get_uniform(shdGradient, "u_color_bot");
u_rank_scan = shader_get_uniform(shdGradient, "u_color_scan");
u_rank_pulse = shader_get_uniform(shdGradient, "u_pulse");

// ==================================================
// ПОЗИЦИЯ И ПРОЗРАЧНОСТЬ
// ==================================================

target_x = 0;
target_y = 0;
target_alpha = 0;

// ==================================================
// PARTICLES
// ==================================================

part_sys = noone;
particle_spawned = false;

// ==================================================
// УСТАНОВКА РАНГА
// ==================================================

setRank = method(id, function(_rank)
{
    rank_subimg = clamp(round(_rank), 0, 4);

    is_s_rank = (rank_subimg == 4);

    switch (rank_subimg)
    {
        case 0:
            color_top = color_F;
            color_bot = color_F;
        break;

        case 1:
            color_top = color_C;
            color_bot = color_C;
        break;

        case 2:
            color_top = color_B;
            color_bot = color_B;
        break;

        case 3:
            color_top = color_A;
            color_bot = color_A;
        break;

        case 4:
            color_top = color_S_top;
            color_bot = color_S_bot;
        break;
    }
});