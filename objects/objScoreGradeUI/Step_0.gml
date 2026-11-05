// ==================================================
// РОСТ МАСШТАБА
// ==================================================

if (grow_progress < 1.0)
{
    grow_progress = min(1.0, grow_progress + grow_speed);
}

rank_scale = rank_scale_base * grow_progress;


// ==================================================
// АНИМАЦИЯ S-РАНГА
// ==================================================

if (is_s_rank)
{
    if (white_flash > 0)
    {
        white_flash = max(0, white_flash - flash_fade);
    }

    pulse_timer += pulse_speed;

    // Создаём частицы после получения координат от меню.
    if (!particle_spawned && target_x != 0 && target_y != 0)
    {
        particle_spawned = true;

        part_sys = part_system_create(pmGradeFlash);

        part_system_depth(part_sys, depth + 1);
        part_system_position(part_sys, target_x, target_y);
        part_system_automatic_update(part_sys, true);

        var _info = particle_get_info(pmGradeFlash);

        for (var i = 0; i < array_length(_info.emitters); i++)
        {
            part_emitter_burst(
                part_sys,
                _info.emitters[i].ind,
                _info.emitters[i].parttype.ind,
                5
            );
        }
    }
}
else
{
    if (black_flash > 0)
    {
        black_flash = max(0, black_flash - flash_fade);
    }
}