transition_timer++;
anim_time += 0.016;
gradient_offset += delta_time * 0.000001 * gradient_speed;

// Задержка перед появлением текста
if (!text_started) {
    text_start_timer++;

    if (text_start_timer >= text_start_delay) {
        text_started = true;
        text_char_timer = 0;
    }
}
else {
    // Появление текста по буквам
    if (text_visible_chars < string_length(level_name)) {
        text_char_timer++;

        if (text_char_timer >= text_char_delay) {
            text_char_timer = 0;
            text_visible_chars++;
        }
    }
}


