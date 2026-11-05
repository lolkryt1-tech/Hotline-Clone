if (target_alpha <= 0.01) exit;

// --- 1. Обводка ---
var _outline_color = is_s_rank ? c_white : c_black;
var _current_outline = outline_thick * grow_progress;

draw_set_color(_outline_color);
for (var dx = -_current_outline; dx <= _current_outline; dx += max(1, _current_outline)) {
    for (var dy = -_current_outline; dy <= _current_outline; dy += max(1, _current_outline)) {
        if (dx != 0 || dy != 0) {
            draw_sprite_ext(sprScoreGrade, rank_subimg, target_x + dx, target_y + dy, rank_scale, rank_scale, 0, _outline_color, target_alpha);
        }
    }
}

// --- 2. Спрайт ---
if (is_s_rank) {
    // S: шейдер с белым flash
    var _ct = merge_color(color_top, c_white, white_flash);
    var _cb = merge_color(color_bot, c_white, white_flash);
    
    shader_set(shdGradient);
    shader_set_uniform_f(u_rank_top, color_get_red(_ct) / 255, color_get_green(_ct) / 255, color_get_blue(_ct) / 255);
    shader_set_uniform_f(u_rank_bot, color_get_red(_cb) / 255, color_get_green(_cb) / 255, color_get_blue(_cb) / 255);
    shader_set_uniform_f(u_rank_scan, color_get_red(color_scan) / 255, color_get_green(color_scan) / 255, color_get_blue(color_scan) / 255);
    shader_set_uniform_f(u_rank_pulse, pulse_timer);
    
    draw_sprite_ext(sprScoreGrade, rank_subimg, target_x, target_y, rank_scale, rank_scale, 0, c_white, target_alpha);
    
    shader_reset();
} else {
    // Не-S: чёрный flash
    var _final_color = merge_color(color_top, c_black, black_flash);
    draw_sprite_ext(sprScoreGrade, rank_subimg, target_x, target_y, rank_scale, rank_scale, 0, _final_color, target_alpha);
}

// --- 3. Частицы (только для S) ---
if (is_s_rank && part_sys != noone && part_system_exists(part_sys)) {
    part_system_drawit(part_sys);
}