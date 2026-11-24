// ========================================
// ЗАДЕРЖКА ПЕРЕД ПОЯВЛЕНИЕМ
// ========================================

if (!intro_started)
{
    intro_timer += delta_time / 1000000;

    if (intro_timer >= intro_delay)
    {
        intro_started = true;
    }
}


// ========================================
// ПОСЛЕДОВАТЕЛЬНОСТЬ АНИМАЦИИ
// ========================================

if (intro_started)
{
    // ------------------------------------
    // 1. ЛИНИЯ РАСТЯГИВАЕТСЯ ОТ ЦЕНТРА
    // ------------------------------------

    if (line_progress < 1)
    {
        line_progress = min(1, line_progress + line_speed);
    }


    // ------------------------------------
    // 2. ПОЯВЛЯЕТСЯ PRESS SPACE
    // ------------------------------------

    if (line_progress >= 1)
    {
        hint_alpha = min(1, hint_alpha + fade_speed);
        hint_progress = min(1, hint_progress + hint_slide_speed);
    }


    // ------------------------------------
    // 3. ПОЯВЛЕНИЕ И СМЕНА ОСНОВНОЙ ПОДСКАЗКИ
    // ------------------------------------

    if (hint_alpha >= 1 && hint_progress >= 1)
    {
        if (changing_tip)
        {
            // Закрываем старую подсказку от краёв к центру
            tip_reveal = max(0, tip_reveal - tip_reveal_speed);

            // Когда старая подсказка полностью исчезла
            if (tip_reveal <= 0)
            {
                var _tip_count = array_length(tips);

                if (_tip_count > 1)
                {
                    var _new_index = irandom(_tip_count - 2);

                    if (_new_index >= previous_tip_index)
                    {
                        _new_index++;
                    }

                    previous_tip_index = _new_index;
                    current_tip = tips[_new_index];
                }

                changing_tip = false;
            }
        }
        else if (tip_reveal < 1)
        {
            // Открываем новую подсказку от центра к краям
            tip_reveal = min(1, tip_reveal + tip_reveal_speed);

            if (tip_reveal >= 1)
            {
                intro_complete = true;
            }
        }
    }


    // ------------------------------------
    // 4. НАЖАТИЕ SPACE
    // ------------------------------------

    if (intro_complete && !changing_tip && keyboard_check_pressed(vk_space))
    {
        changing_tip = true;
        intro_complete = false;
    }
}
