/// @function scrCameraShakePlay
/// @description Вызывает тряску камеры из указанной категории и пресета.
/// @param {String} _cat_id "weapons" / "actions" / "executions"
/// @param {String} _preset_id "pistol" / "kill_blunt" / "sledgehammer"

function scrCameraShakePlay(_cat_id, _preset_id)
{
    if (!global.camera_shake.enabled) return;
    
    // Защита от пустых строк (например, если оружие не найдено)
    if (_cat_id == "" || _preset_id == "") return;
    
    var _cat = variable_struct_get(global.camera_shake.presets, _cat_id);
    if (!variable_struct_exists(_cat, _preset_id)) return;
    
    var _preset = variable_struct_get(_cat, _preset_id);
    
    with (objEffector)
    {
        if (_preset.kick_enabled)
            scrCameraKickShakeStart(_preset.kick.strength, _preset.kick.rotation, _preset.kick.attack, _preset.kick.release);
        if (_preset.bounce_enabled)
            scrCameraBounceShakeStart(_preset.bounce.strength, _preset.bounce.rotation, _preset.bounce.frequency, _preset.bounce.damping);
    }
}