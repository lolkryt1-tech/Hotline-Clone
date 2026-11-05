// === СОСТОЯНИЕ 1: ПОЯВЛЕНИЕ БУКВ ===
if (text_state == "spawning")
{
    spawn_timer++;

    // Считаем индекс текущей буквы (скорость теперь строго постоянная)
    var _active_letter_index = floor(spawn_timer / spawn_delay);

    // Анимация букв
    var _all_letters_spawned = true;
    for (var i = 0; i < text_length; i++)
    {
        if (i <= _active_letter_index)
        {
            letter_alpha[i] = lerp(letter_alpha[i], 1.0, 0.1);
            letter_timer[i]++;
            
            if (letter_timer[i] == 1)
            {
                letter_scale[i] = scale_peak;
            }
            else
            {
                letter_scale[i] = lerp(letter_scale[i], scale_base, 0.15);
            }
        }
        
        // Проверяем, закончила ли буква анимацию
        if (letter_alpha[i] < 0.95 || abs(letter_scale[i] - scale_base) > 0.05)
        {
            _all_letters_spawned = false;
        }
    }

    // Если все буквы вывелись и встали на место — переходим в режим ожидания
    if (_all_letters_spawned && _active_letter_index >= text_length - 1)
    {
        text_state = "waiting";
    }
}
// === СОСТОЯНИЕ 2: УДЕРЖАНИЕ НА ЭКРАНЕ ===
else if (text_state == "waiting")
{
    wait_timer--;
    if (wait_timer <= 0)
    {
        text_state = "fading";
    }
}
// === СОСТОЯНИЕ 3: ПЛАВНОЕ ИСЧЕЗНОВЕНИЕ ===
else if (text_state == "fading")
{
    global_alpha = lerp(global_alpha, 0.0, 0.05); // Плавное затухание всей строки
    
    // Как только текст стал полностью невидим — уничтожаем объект
    if (global_alpha <= 0.01)
    {
        instance_destroy();
    }
}
