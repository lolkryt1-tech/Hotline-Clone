if (instance_exists(objLightController)) {
    // Базовый расчет экранных координат (по масштабу окна)
    var _sx = (x - global.cam_x) * global.cam_scale_x;
    var _sy = (y - global.cam_y) * global.cam_scale_y;
    var _xscale = image_xscale * global.cam_scale_x;
    var _yscale = image_yscale * global.cam_scale_y;
    var _ang = image_angle;

    // В хардмоде инвертируем относительно АКТУАЛЬНОГО размера окна
    if (global.hard) {
        _sx = global.last_window_w - _sx;
        _sy = global.last_window_h - _sy;
        _xscale = -_xscale;
        _yscale = -_yscale;
        _ang += 180;
    }

    draw_sprite_ext(sprite_index, image_index, _sx, _sy, _xscale, _yscale, _ang, image_blend, image_alpha);
}
