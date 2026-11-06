function scrCameraShakeHasChanges()
{
    var _backup = global.camera_shake.backup;
    var _presets = global.camera_shake.presets;

    if (_backup == undefined) return false;

    // Сравниваем общий переключатель
    if (abs(global.camera_shake.enabled - global.camera_shake.backup_enabled) > 0.001) return true;

    for (var i = 0; i < array_length(global.camera_shake.categories); i++)
    {
        var _cat = global.camera_shake.categories[i];
        var _cur_cat = variable_struct_get(_presets, _cat.id);
        var _bak_cat = variable_struct_get(_backup, _cat.id);

        for (var j = 0; j < array_length(_cat.presets); j++)
        {
            var _pid = _cat.presets[j].id;
            var _cur = variable_struct_get(_cur_cat, _pid);
            var _bak = variable_struct_get(_bak_cat, _pid);

            // Переключатели (они bool, но тоже сравним через abs на всякий случай)
            if (abs(_cur.kick_enabled - _bak.kick_enabled) > 0.001) return true;
            if (abs(_cur.bounce_enabled - _bak.bounce_enabled) > 0.001) return true;
            if (abs(_cur.perlin_enabled - _bak.perlin_enabled) > 0.001) return true;

            // kick
            var _ck = _cur.kick_enabled ? _cur.kick : _cur.kick_saved;
            var _bk = _bak.kick_enabled ? _bak.kick : _bak.kick_saved;
            
            if (abs(_ck.strength - _bk.strength) > 0.0001) return true;
            if (abs(_ck.rotation - _bk.rotation) > 0.0001) return true;
            if (abs(_ck.attack - _bk.attack) > 0.0001) return true;
            if (abs(_ck.release - _bk.release) > 0.0001) return true;

            // bounce
            var _cb = _cur.bounce_enabled ? _cur.bounce : _cur.bounce_saved;
            var _bb = _bak.bounce_enabled ? _bak.bounce : _bak.bounce_saved;
            
            if (abs(_cb.strength - _bb.strength) > 0.0001) return true;
            if (abs(_cb.rotation - _bb.rotation) > 0.0001) return true;
            if (abs(_cb.frequency - _bb.frequency) > 0.0001) return true;
            if (abs(_cb.damping - _bb.damping) > 0.0001) return true;

            // perlin
            var _cp = _cur.perlin_enabled ? _cur.perlin : _cur.perlin_saved;
            var _bp = _bak.perlin_enabled ? _bak.perlin : _bak.perlin_saved;
            
            if (abs(_cp.strength - _bp.strength) > 0.0001) return true;
        }
    }

    return false;
}