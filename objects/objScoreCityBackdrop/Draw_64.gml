var _gui_h = display_get_gui_height();
var _horizon_y = _gui_h * 0.5;

// Ленивая инициализация ширины при первом рендере (когда scale_x уже передан)
if (!initialized) {
    var _gui_w = display_get_gui_width();
    spr_w = sprite_get_width(sprScoreCityScape) * scale_x;
    half_w = spr_w * 0.5;
    needed_backdrops = ceil(_gui_w / spr_w) + 1;
    initialized = true;
}

// Расчет текущего качания
var _current_offset_y = sin(wave_time) * wave_amp;
var _draw_y = _horizon_y + _current_offset_y - pull_up;

// Красим силуэт в цвет, переданный из менеджера
gpu_set_fog(true, fog_color, 0, 0);

// Клеим панораму во всю ширину экрана
for (var i = 0; i < needed_backdrops; i++) {
    var _draw_x = (i * spr_w) + half_w;
    
    draw_sprite_ext(
        sprScoreCityScape, 0, 
        _draw_x, _draw_y, 
        scale_x, scale_y, 
        0, fog_color, draw_alpha
    );
}

// Сбрасываем туман
gpu_set_fog(false, c_white, 0, 0);
