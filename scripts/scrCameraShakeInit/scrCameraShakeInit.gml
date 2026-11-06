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
                { id: "unarmed",      name: "Unarmed",      defaults: { kick: 0.0,  bounce: 0.0 }, exec: "unarmed_stomp" },
                { id: "knife",        name: "Knife",        defaults: { kick: 0.5,  bounce: 0.0 }, exec: "knife" },
                { id: "bat",          name: "Bat",          defaults: { kick: 1.0,  bounce: 0.0 }, exec: "blunt" },
                { id: "pipe",         name: "Pipe",         defaults: { kick: 1.0,  bounce: 0.0 }, exec: "blunt_pipe" },
                { id: "sledgehammer", name: "Sledgehammer", defaults: { kick: 1.5,  bounce: 1.5 }, exec: "sledgehammer" },
                { id: "pistol",       name: "Pistol",       defaults: { kick: 0.35, bounce: 0.0 }, exec: "unarmed_stomp" },
                { id: "shotgun",      name: "Shotgun",      defaults: { kick: 0.8,  bounce: 0.8 }, exec: "firearm_blunt" },
                { id: "m16",          name: "M16",          defaults: { kick: 0.2,  bounce: 0.0 }, exec: "firearm_blunt" },
                { id: "sniper",       name: "Sniper",       defaults: { kick: 0.6,  bounce: 0.0 }, exec: "firearm_blunt" }
            ]
        },
        {
            id: "actions",
            name: "Actions",
            auto: false,
            presets: [
                { id: "knock_door",   name: "Knock Door",   defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "knock_thrown", name: "Knock Thrown", defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "kill_blunt",   name: "Kill Blunt",   defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "kill_cut",     name: "Kill Cut",     defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "kill_slash",   name: "Kill Slash",   defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "die_blunt",    name: "Die Blunt",    defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "die_cut",      name: "Die Cut",      defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "die_slash",    name: "Die Slash",    defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "die_shot",     name: "Die Shot",     defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "die",          name: "Die",          defaults: { kick: 0.0, bounce: 0.0 } }
            ]
        },
        {
            id: "executions",
            name: "Executions",
            auto: false,
            presets: [
                { id: "unarmed_stomp", name: "Unarmed Stomp", defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "firearm_blunt", name: "Firearm Blunt", defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "knife",         name: "Knife",         defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "knife_quick",   name: "Knife Quick",   defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "lean",          name: "Lean",          defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "blunt",         name: "Blunt",         defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "blunt_pipe",    name: "Blunt Pipe",    defaults: { kick: 0.0, bounce: 0.0 } },
                { id: "sledgehammer",  name: "Sledgehammer",  defaults: { kick: 0.0, bounce: 0.0 } }
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