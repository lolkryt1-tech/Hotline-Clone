function scrBuildStaticOccluders(_renderer)
{
    var _occluder = new BulbStaticOccluder(_renderer);
    
    with (objSolidTall)
    {
        _occluder.AddEdge(bbox_left,  bbox_top,    bbox_right, bbox_top);
        _occluder.AddEdge(bbox_right, bbox_top,    bbox_right, bbox_bottom);
        _occluder.AddEdge(bbox_right, bbox_bottom, bbox_left,  bbox_bottom);
        _occluder.AddEdge(bbox_left,  bbox_bottom, bbox_left,  bbox_top);
    }
    
    _renderer.RefreshStaticOccluders();
    global.static_occluder = _occluder;
}