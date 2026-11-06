function scrCameraShakeSave()
{
    ini_open("config.ini");

    ini_write_real("CameraShake", "enabled", global.camera_shake.enabled);

    var _effects = ["kick", "bounce", "perlin"];

    for (var i = 0; i < array_length(global.camera_shake.categories); i++)
    {
        var _cat = global.camera_shake.categories[i];
        var _cat_presets = variable_struct_get(global.camera_shake.presets, _cat.id);

        for (var j = 0; j < array_length(_cat.presets); j++)
        {
            var _pid = _cat.presets[j].id;
            var _preset = variable_struct_get(_cat_presets, _pid);
            var _section = _cat.id + "_" + _pid;

            ini_write_real(_section, "kick_enabled",   _preset.kick_enabled);
            ini_write_real(_section, "bounce_enabled", _preset.bounce_enabled);
            ini_write_real(_section, "perlin_enabled", _preset.perlin_enabled);

            for (var k = 0; k < array_length(_effects); k++)
            {
                var _effect = _effects[k];
                var _active = variable_struct_get(_preset, _effect);
                var _saved  = variable_struct_get(_preset, _effect + "_saved");

                var _fields;
                switch (_effect)
                {
                    case "kick":   _fields = ["strength", "rotation", "attack", "release"]; break;
                    case "bounce": _fields = ["strength", "rotation", "frequency", "damping"]; break;
                    case "perlin": _fields = ["strength"]; break;
                }

                for (var f = 0; f < array_length(_fields); f++)
                {
                    var _field = _fields[f];

                    ini_write_real(_section, _effect + "_" + _field,
                        variable_struct_get(_active, _field));

                    ini_write_real(_section, _effect + "_saved_" + _field,
                        variable_struct_get(_saved, _field));
                }
            }
        }
    }

    ini_close();
}