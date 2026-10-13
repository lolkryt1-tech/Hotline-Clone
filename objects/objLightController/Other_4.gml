/// Room Start Event for objLightController

// Применяем настройки (на случай, если переопределено в Creation Code)
renderer.ambientColor = ambient_color;
renderer.soft = use_soft_shadows;
renderer.smooth = use_smooth_lighting;

// Далее ваш код создания окклюдеров...
var _count = 0;
var _occluder = new BulbStaticOccluder(renderer);
with (objSolidTall)
{
    _count++;
    _occluder.AddEdge(bbox_left,  bbox_top,    bbox_right, bbox_top);
    _occluder.AddEdge(bbox_right, bbox_top,    bbox_right, bbox_bottom);
    _occluder.AddEdge(bbox_right, bbox_bottom, bbox_left,  bbox_bottom);
    _occluder.AddEdge(bbox_left,  bbox_bottom, bbox_left,  bbox_top);
}

renderer.RefreshStaticOccluders();