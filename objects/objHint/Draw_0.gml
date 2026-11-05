if (instance_exists(objWeapon) && instance_exists(objEnemyColombianFatVest)) 
{
    with (objWeapon) 
    {
        if (image_index == 3) 
        {
            // Настройки плавного движения
            var _base_offset = -20; 
            var _wave_amplitude = 8;
            
            // Считаем положение стрелки
            var _draw_x = x + (_base_offset + sin(other.hover_timer) * _wave_amplitude);
            var _draw_y = y;

            // Рисуем стрелку
            draw_sprite_ext(
                other.sprite_index, 
                other.image_index, 
                _draw_x, 
                _draw_y, 
                other.image_xscale, 
                other.image_yscale, 
                other.image_angle, 
                other.image_blend, 
                other.image_alpha
            );
        }
    }
}
