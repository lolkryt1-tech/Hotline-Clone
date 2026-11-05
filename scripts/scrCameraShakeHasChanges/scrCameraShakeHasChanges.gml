function scrCameraShakeHasChanges()
{
    var _backup = global.camera_shake.backup;
    var _presets = global.camera_shake.presets;

    // === ОБЩИЙ ПЕРЕКЛЮЧАТЕЛЬ ===

    if (global.camera_shake.enabled != global.camera_shake.backup_enabled) return true;

    // === СПИСОК ПРЕСЕТОВ ===

    var _names = ["pistol", "shotgun", "m16", "sniper"];

    for (var i = 0; i < array_length(_names); i++)
    {
        var _current = variable_struct_get(_presets, _names[i]);
        var _original = variable_struct_get(_backup, _names[i]);

        // === ПЕРЕКЛЮЧАТЕЛИ ===

        if (_current.kick_enabled != _original.kick_enabled) return true;
        if (_current.bounce_enabled != _original.bounce_enabled) return true;
        if (_current.perlin_enabled != _original.perlin_enabled) return true;

        // === KICK ===

        var _current_kick = _current.kick_enabled ? _current.kick : _current.kick_saved;
        var _original_kick = _original.kick_enabled ? _original.kick : _original.kick_saved;

        if (_current_kick.strength != _original_kick.strength) return true;
        if (_current_kick.rotation != _original_kick.rotation) return true;
        if (_current_kick.attack != _original_kick.attack) return true;
        if (_current_kick.release != _original_kick.release) return true;

        // === BOUNCE ===

        var _current_bounce = _current.bounce_enabled ? _current.bounce : _current.bounce_saved;
        var _original_bounce = _original.bounce_enabled ? _original.bounce : _original.bounce_saved;

        if (_current_bounce.strength != _original_bounce.strength) return true;
        if (_current_bounce.rotation != _original_bounce.rotation) return true;
        if (_current_bounce.frequency != _original_bounce.frequency) return true;
        if (_current_bounce.damping != _original_bounce.damping) return true;

        // === PERLIN ===

        var _current_perlin = _current.perlin_enabled ? _current.perlin : _current.perlin_saved;
        var _original_perlin = _original.perlin_enabled ? _original.perlin : _original.perlin_saved;

        if (_current_perlin.strength != _original_perlin.strength) return true;
    }

    return false;
}