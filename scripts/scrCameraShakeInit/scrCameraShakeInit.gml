/// @function scrCameraShakeInit()
/// @description Инициализирует глобальную систему тряски камеры.
/// Создаёт настройки эффектов, исходные значения и рабочие пресеты.


function scrCameraShakeInit()
{
    global.camera_shake = {
        enabled: true,

        perlin: {
            speed: 1.0
        },

        defaults: scrCameraShakeCreatePresets(),
        presets: scrCameraShakeCreatePresets()
    };
	
	global.camera_shake.backup = undefined;
	global.camera_shake.backup_enabled = global.camera_shake.enabled;
}