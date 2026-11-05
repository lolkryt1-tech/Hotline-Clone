function scrCameraShakeLoad()
{
    var _presets = global.camera_shake.presets;
    var _weapons = ["pistol", "shotgun", "m16", "sniper"];
    var _effects = ["kick", "bounce", "perlin"];

    ini_open("config.ini");

    global.camera_shake.enabled = ini_read_real(
        "CameraShake",
        "enabled",
        global.camera_shake.enabled
    );

    for (var i = 0; i < array_length(_weapons); i++)
    {
        var _weapon = _weapons[i];
        var _preset = variable_struct_get(_presets, _weapon);

        _preset.kick_enabled = ini_read_real(_weapon, "kick_enabled", _preset.kick_enabled);
        _preset.bounce_enabled = ini_read_real(_weapon, "bounce_enabled", _preset.bounce_enabled);
        _preset.perlin_enabled = ini_read_real(_weapon, "perlin_enabled", _preset.perlin_enabled);

        for (var j = 0; j < array_length(_effects); j++)
        {
            var _effect = _effects[j];
            var _active = variable_struct_get(_preset, _effect);
            var _saved = variable_struct_get(_preset, _effect + "_saved");

            var _fields;

            switch (_effect)
            {
                case "kick":
                    _fields = ["strength", "rotation", "attack", "release"];
                    break;

                case "bounce":
                    _fields = ["strength", "rotation", "frequency", "damping"];
                    break;

                case "perlin":
                    _fields = ["strength"];
                    break;
            }

            for (var k = 0; k < array_length(_fields); k++)
            {
                var _field = _fields[k];

                variable_struct_set(
                    _active,
                    _field,
                    ini_read_real(
                        _weapon,
                        _effect + "_" + _field,
                        variable_struct_get(_active, _field)
                    )
                );

                variable_struct_set(
                    _saved,
                    _field,
                    ini_read_real(
                        _weapon,
                        _effect + "_saved_" + _field,
                        variable_struct_get(_saved, _field)
                    )
                );
            }
        }
    }

    ini_close();
}
