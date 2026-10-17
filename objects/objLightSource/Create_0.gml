depth = -16000;
light_color     = c_white;
light_intensity = 1.5;
light_scale     = 2.0;

if (instance_exists(objLightController))
{
    light = new BulbLight(objLightController.renderer, sLight128, 0, x, y);
    light.blend     = light_color;
    light.intensity = light_intensity;
    light.xscale    = light_scale;
    light.yscale    = light_scale;
}