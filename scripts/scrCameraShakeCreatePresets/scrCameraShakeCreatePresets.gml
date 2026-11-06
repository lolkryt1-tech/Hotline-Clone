function scrCameraShakeCreatePresets()
{
    var _result = {};
    
    for (var i = 0; i < array_length(global.camera_shake_categories); i++)
    {
        var _cat = global.camera_shake_categories[i];
        var _cat_result = {};
        
        for (var j = 0; j < array_length(_cat.presets); j++)
        {
            var _preset = _cat.presets[j];
            var _def = _preset.defaults;
            
            // Сохраняем exec, если он есть в categories
            var _exec_id = "";
            if (variable_struct_exists(_preset, "exec")) {
                _exec_id = _preset.exec;
            }
            
            variable_struct_set(_cat_result, _preset.id, {
                kick_enabled:   _def.kick > 0,
                bounce_enabled: _def.bounce > 0,
                perlin_enabled: false,
                
                kick:        { strength: _def.kick, rotation: _def.kick * 0.7, attack: 0.04, release: 0.15 },
                kick_saved:  { strength: _def.kick, rotation: _def.kick * 0.7, attack: 0.04, release: 0.15 },
                
                bounce:       { strength: _def.bounce, rotation: _def.bounce * 0.5, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: _def.bounce, rotation: _def.bounce * 0.5, frequency: 4.0, damping: 10.0 },
                
                perlin:       { strength: 0 },
                perlin_saved: { strength: 0 },
                
                exec: _exec_id
            });
        }
        
        variable_struct_set(_result, _cat.id, _cat_result);
    }
    
    return _result;
}