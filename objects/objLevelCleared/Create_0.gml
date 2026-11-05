// Звуки и музыка
audio_play_sound(sndLevelComplete, 1, 0);
scrMusicPlay(Level_Cleared, 1, 0);

// Настройка текста и шрифта
text_string = "LEVEL CLEARED";
font_to_use = fntLevelCleared;
text_length = string_length(text_string);

// Массивы для контроля анимации каждой буквы
letter_alpha  = array_create(text_length, 0.0);
letter_scale  = array_create(text_length, 0.0);
letter_timer  = array_create(text_length, 0);

// Тайминги появления (фиксированная скорость)
spawn_timer = 0;
spawn_delay = 3; // Количество кадров между появлением букв (настройте под себя)

// Настройки скейла при появлении
scale_peak = 1.6; 
scale_base = 1.0; 

// Переменные для исчезновения всего текста
global_alpha = 1.0;       
text_state = "spawning";  // Состояния: "spawning", "waiting", "fading"
wait_timer = 40;          // Сколько кадров текст висит перед исчезновением