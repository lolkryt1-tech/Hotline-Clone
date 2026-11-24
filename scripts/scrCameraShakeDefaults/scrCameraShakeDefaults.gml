/// @function scrCameraShakeDefaults
/// @description Возвращает эталонные (дефолтные) настройки тряски камеры.
/// Эти значения используются при инициализации и при нажатии кнопки DEFAULT.

function scrCameraShakeDefaults()
{
    return {
        weapons: {
            pistol: {
                kick_enabled: true, bounce_enabled: false, perlin_enabled: false, exec: "unarmed_stomp",
                kick: { strength: 0.35, rotation: 0.245, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.35, rotation: 0.245, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            shotgun: {
                kick_enabled: true, bounce_enabled: true, perlin_enabled: false, exec: "firearm_blunt",
                kick: { strength: 0.8, rotation: 0.4, attack: 0.03, release: 0.22 },
                kick_saved: { strength: 0.8, rotation: 0.4, attack: 0.025, release: 0.22 },
                bounce: { strength: 0.8, rotation: 0.4, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.8, rotation: 0.4, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            m16: {
                kick_enabled: true, bounce_enabled: false, perlin_enabled: false, exec: "firearm_blunt",
                kick: { strength: 0.2, rotation: 0.14, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.2, rotation: 0.14, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            sniper: {
                kick_enabled: true, bounce_enabled: true, perlin_enabled: false, exec: "firearm_blunt",
                kick: { strength: 0.6, rotation: 0.35, attack: 0.03, release: 0.2 },
                kick_saved: { strength: 0.6, rotation: 0.35, attack: 0.03, release: 0.2 },
                bounce: { strength: 0.6, rotation: 0.4, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.6, rotation: 0.35, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            unarmed: {
                kick_enabled: true, bounce_enabled: false, perlin_enabled: false, exec: "unarmed_stomp",
                kick: { strength: 0.1, rotation: 0.05, attack: 0.15, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            knife: {
                kick_enabled: true, bounce_enabled: false, perlin_enabled: false, exec: "knife",
                kick: { strength: 0.1, rotation: 0.1, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.5, rotation: 0.35, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            bat: {
                kick_enabled: true, bounce_enabled: false, perlin_enabled: false, exec: "blunt",
                kick: { strength: 0.25, rotation: 0.15, attack: 0.1, release: 0.1 },
                kick_saved: { strength: 1.0, rotation: 0.7, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            pipe: {
                kick_enabled: true, bounce_enabled: false, perlin_enabled: false, exec: "blunt_pipe",
                kick: { strength: 0.35, rotation: 0.25, attack: 0.1, release: 0.1 },
                kick_saved: { strength: 1.0, rotation: 0.7, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            sledgehammer: {
                kick_enabled: true, bounce_enabled: false, perlin_enabled: false, exec: "sledgehammer",
                kick: { strength: 1.5, rotation: 0.5, attack: 0.15, release: 0.15 },
                kick_saved: { strength: 1.5, rotation: 1.05, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 0.0, damping: 0.0 },
                bounce_saved: { strength: 1.5, rotation: 0.75, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            }
        },
        actions: {
            knock_door: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 1.0, rotation: 2.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            knock_unarmed: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 1.5, rotation: 1.2, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            kill_blunt: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 2.0, rotation: 1.5, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            kill_cut: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                bounce: { strength: 1.0, rotation: 1.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            kill_slash: {
                kick_enabled: false, bounce_enabled: false, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            die_blunt: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                bounce: { strength: 2.0, rotation: 2.0, frequency: 6.0, damping: 6.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            die_cut: {
                kick_enabled: true, bounce_enabled: false, perlin_enabled: false,
                kick: { strength: 3.0, rotation: 1.0, attack: 0.05, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 0.0, damping: 0.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            die_slash: {
                kick_enabled: false, bounce_enabled: false, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            die_shot: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 2.0, rotation: 2.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            die: {
                kick_enabled: false, bounce_enabled: false, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            enemy_shoot: {
                kick_enabled: true, bounce_enabled: false, perlin_enabled: false,
                kick: { strength: 0.25, rotation: 0.14, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            tech_explosion: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 1.5, rotation: 1.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            }
        },
        executions: {
            unarmed_stomp: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 1.0, rotation: 1.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            firearm_blunt: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 2.0, rotation: 2.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            knife: {
                kick_enabled: true, bounce_enabled: false, perlin_enabled: false,
                kick: { strength: 0.75, rotation: 0.1, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 0.0, rotation: 0.0, frequency: 0.0, damping: 0.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            lean: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.04, release: 0.15 },
                bounce: { strength: 2.0, rotation: 2.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            blunt: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                bounce: { strength: 1.0, rotation: 1.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 1.0, rotation: 1.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            blunt_pipe: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                bounce: { strength: 3.0, rotation: 2.0, frequency: 4.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 4.0, damping: 10.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            },
            sledgehammer: {
                kick_enabled: false, bounce_enabled: true, perlin_enabled: false,
                kick: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                kick_saved: { strength: 0.0, rotation: 0.0, attack: 0.0, release: 0.0 },
                bounce: { strength: 3.0, rotation: 2.0, frequency: 6.0, damping: 10.0 },
                bounce_saved: { strength: 0.0, rotation: 0.0, frequency: 0.0, damping: 0.0 },
                perlin: { strength: 0.0 },
                perlin_saved: { strength: 0.0 }
            }
        }
    };
}