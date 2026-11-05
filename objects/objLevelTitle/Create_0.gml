depth = 0; // Находится ВЫШЕ дыма, чтобы текст не перекрывался

level_name = "";
if (variable_global_exists("current_level_index") && variable_global_exists("current_level")) {
    level_name = global.current_level.name;
} else {
    level_name = "New Case";
}

transition_timer = 0;
anim_time = 0;

text_visible_chars = 0;
text_char_timer = 0;
text_char_delay = 17.5;

// Задержка перед началом анимации (в кадрах)
text_start_delay = 40;
text_start_timer = 0;
text_started = false;


// Echo effect
echo_count = 25;
echo_interval = 3;
echo_decay = 0.75;

echo_history = [];
echo_max_history = echo_count * echo_interval + 1;

// Градиент
gradient_speed = 0.65;
gradient_offset = 0.0;

// Цвета
gradient_pink = make_color_rgb(201, 139, 183);
gradient_cyan = make_color_rgb(163, 184, 195);
gradient_white = make_color_rgb(220, 202, 216);

// Разброс оттенков эха
echo_color_variation = 0.25;