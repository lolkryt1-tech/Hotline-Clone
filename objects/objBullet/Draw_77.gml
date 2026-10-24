if (instance_exists(objLightController)) {
    var _sx = (x - global.cam_x) * global.cam_scale_x;
    var _sy = (y - global.cam_y) * global.cam_scale_y;

    draw_sprite_ext(sprite_index, image_index, _sx, _sy, image_xscale * global.cam_scale_x, image_yscale * global.cam_scale_y, image_angle, image_blend, image_alpha);
}