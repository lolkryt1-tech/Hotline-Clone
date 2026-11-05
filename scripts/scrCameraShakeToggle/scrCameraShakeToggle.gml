/// @param {Struct} _preset Пресет оружия
/// @param {String} _effect Эффект: "kick", "bounce" или "perlin"

function scrCameraShakeToggle(_preset, _effect)
{
    var _enabled_key = _effect + "_enabled";
    var _saved_key = _effect + "_saved";

    var _fields;

    switch (_effect)
    {
        case "kick":   _fields = ["strength", "rotation", "attack", "release"]; break;
        case "bounce": _fields = ["strength", "rotation", "frequency", "damping"]; break;
        case "perlin": _fields = ["strength"]; break;
        default: return;
    }

    var _active = variable_struct_get(_preset, _effect);
    var _saved = variable_struct_get(_preset, _saved_key);
    var _enabled = variable_struct_get(_preset, _enabled_key);

    for (var i = 0; i < array_length(_fields); i++)
    {
        var _field = _fields[i];

        if (_enabled)
        {
            variable_struct_set(_saved, _field, variable_struct_get(_active, _field));
            variable_struct_set(_active, _field, 0);
        }
        else
        {
            variable_struct_set(_active, _field, variable_struct_get(_saved, _field));
        }
    }

    variable_struct_set(_preset, _enabled_key, !_enabled);
}