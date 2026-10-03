function scrCopFlipShotgun()
{
	if (current_weapon != WEAPONS.SHOTGUN) return;
	
    // 1. Получаем текущее направление взгляда на прицел (куда направлена мышь)
    var _current_mouse_dir = point_direction(x, y, objEffector.x, objEffector.y);

    // Высчитываем чистую разницу в градусах между ПРОШЛЫМ кадром и ТЕКУЩИМ
    var _frame_diff = abs(angle_difference(old_angle, _current_mouse_dir));
    
    // Запоминаем текущий угол для следующего кадра
    old_angle = _current_mouse_dir;

    var _max_frames = sprite_get_number(sprCopTurnShotgun) - 1;
    
    // Скорость смены кадров на возврате (сделай меньше, если хочешь чтобы раскручивался медленнее)
    var _custom_flip_speed = 0.25; 


    // Если мышка сдвинулась быстрее обычного (например, больше 15 градусов за 1 кадр)
    if (_frame_diff > 15)
    {
        // Если окно сбора еще не открыто — открываем его на 6 кадров игры
        if (flick_timer <= 0)
        {
            flick_timer = 6;       // Время (в кадрах игры) на совершение рывка
            flick_accum_angle = 0; // Сбрасываем накопитель
        }
            
        // Накапливаем угол поворота мыши прямо на ходу
        flick_accum_angle += _frame_diff;
    }

    // Тикаем таймером окна сбора вниз
    if (flick_timer > 0)
    {
        flick_timer--;
            
        // ЕСЛИ ЗА ВРЕМЯ ОКНА УСПЕЛИ НАКРУТИТЬ 120+ ГРАДУСОВ
        if (flick_accum_angle >= 120)
        {
            flick_timer = 0; // Закрываем окно сбора
                
            is_turning = true;
            turn_phase = 1;            // Сразу включаем Стейт 1 (Зависание на пике)
            sprite_index = sprCopTurnShotgun; 
            image_index = _max_frames; // Мгновенно выносим ствол в максимальную точку скручивания
            turn_hold_timer = 24;      // Таймер удержания этого пика в кадрах игры
        }
    }

    // === ФАЗА УПРАВЛЕНИЯ АНИМАЦИЕЙ ЗАНОСА ===
    if (is_turning)
    {
        // Флип намертво держит свой спрайт и не сбивается обычными выстрелами
        if (sprite_index != sprCopTurnShotgun)
        {
            sprite_index = sprCopTurnShotgun;
        }

        switch (turn_phase)
        {
            case 1: // === ЗАВИСАНИЕ НА ПОСЛЕДНЕМ КАДРЕ (В начале поворота) ===
                image_index = _max_frames; // Жестко держим последний кадр
                turn_hold_timer--;         
                
                if (turn_hold_timer <= 0)
                {
                    turn_phase = 2; // Время вышло, плавно возвращаем торс назад
                }
                break;

            case 2: // === РЕВЕРС (ПЛАВНЫЙ ОТСКОК НАЗАД К ХОДЬБЕ) ===
                // ИСПРАВЛЕНО: Убрали умножение * 2.5, чтобы он возвращался со скоростью _custom_flip_speed (0.15) плавно и весомо
                image_index -= _custom_flip_speed * 1.25; 
                
                if (image_index <= 0)
                {
                    image_index = 0;
                    is_turning = false; // ПОЛНЫЙ КОНЕЦ ЗАНОСА
                    
                    // Возвращаем обычную ходьбу текущего оружия
                    sprite_index = my_sprites.walk; 
                }
                break;
        }
    }
}
