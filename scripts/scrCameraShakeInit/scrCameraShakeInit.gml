/// @function scrCameraShakeInit()
/// @description Инициализирует глобальную систему тряски камеры.
/// Создаёт настройки эффектов, исходные значения и рабочие пресеты.

function scrCameraShakeInit()
{
    // Сначала создаём категории (источник данных для CreatePresets)
       global.camera_shake_categories = [
        {
            id: "weapons",
            name: "Weapons",
            auto: true,
            presets: [
                { id: "unarmed",      name: "Unarmed",      exec: "unarmed_stomp" },
                { id: "knife",        name: "Knife",        exec: "knife" },
                { id: "bat",          name: "Bat",          exec: "blunt" },
                { id: "pipe",         name: "Pipe",         exec: "blunt_pipe" },
                { id: "sledgehammer", name: "Sledgehammer", exec: "sledgehammer" },
                { id: "pistol",       name: "Pistol",       exec: "unarmed_stomp" },
                { id: "shotgun",      name: "Shotgun",      exec: "firearm_blunt" },
                { id: "m16",          name: "M16",          exec: "firearm_blunt" },
                { id: "sniper",       name: "Sniper",       exec: "firearm_blunt" }
            ]
        },
        {
            id: "actions",
            name: "Actions",
            auto: false,
            presets: [
                { id: "knock_door",     name: "Knock Door" },
                { id: "knock_unarmed",  name: "Knock Unarmed" },
                { id: "kill_blunt",     name: "Kill Blunt" },
                { id: "kill_cut",       name: "Kill Cut" },
                { id: "kill_slash",     name: "Kill Slash" },
                { id: "die_blunt",      name: "Die Blunt" },
                { id: "die_cut",        name: "Die Cut" },
                { id: "die_slash",      name: "Die Slash" },
                { id: "die_shot",       name: "Die Shot" },
                { id: "enemy_shoot",    name: "Enemy Shoot" },
                { id: "tech_explosion", name: "Tech Explosion" }
            ]
        },
        {
            id: "executions",
            name: "Executions",
            auto: false,
            presets: [
                { id: "unarmed_stomp", name: "Unarmed Stomp" },
                { id: "firearm_blunt", name: "Firearm Blunt" },
                { id: "knife",         name: "Knife" },
                { id: "lean",          name: "Lean" },
                { id: "blunt",         name: "Blunt" },
                { id: "blunt_pipe",    name: "Blunt Pipe" },
                { id: "sledgehammer",  name: "Sledgehammer" }
            ]
        }
    ];

    // Теперь создаём структуру camera_shake
    global.camera_shake = {
        enabled: true,
        perlin: { speed: 1.0 },
        
        categories: global.camera_shake_categories,
        defaults: scrCameraShakeCreatePresets(),
        presets: scrCameraShakeCreatePresets(),
        
        backup: undefined,
        backup_enabled: true
    };
}