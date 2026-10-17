// Включаем звук зачистки один раз при создании
audio_play_sound(sndFloorCleared, 10, false);

image_speed = 0;

// Настройки таймингов (в кадрах)
fade_in_time  = 15;  // 0.25 сек на появление и схождение половин
hold_time     = 45;  // 0.75 сек держится на экране
fade_out_time = 15;  // 0.25 сек на исчезновение

state     = 0;           
timer     = 0;           
gui_alpha = 0;       

split_offset = 120;  // Расстояние раздвоения букв на старте
