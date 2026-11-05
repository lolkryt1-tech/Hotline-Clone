function scrCameraShakeCreatePresets()
{
    return {
        pistol: {
            kick_enabled: true,
            bounce_enabled: false,
            perlin_enabled: false,

            kick:       { strength: 0.35, rotation: 0.25, attack: 0.04, release: 0.15 },
            kick_saved: { strength: 0.35, rotation: 0.25, attack: 0.04, release: 0.15 },

            bounce:       { strength: 0, rotation: 0, frequency: 4.0, damping: 10.0 },
            bounce_saved: { strength: 0.35, rotation: 0.25, frequency: 4.0, damping: 10.0 },

            perlin:       { strength: 0 },
            perlin_saved: { strength: 0 }
        },

        shotgun: {
            kick_enabled: true,
            bounce_enabled: true,
            perlin_enabled: false,

            kick:       { strength: 0.8, rotation: 0.4, attack: 0.025, release: 0.22 },
            kick_saved: { strength: 0.8, rotation: 0.4, attack: 0.025, release: 0.22 },

            bounce:       { strength: 0.8, rotation: 0.4, frequency: 4.0, damping: 10.0 },
            bounce_saved: { strength: 0.8, rotation: 0.4, frequency: 4.0, damping: 10.0 },

            perlin:       { strength: 0 },
            perlin_saved: { strength: 0 }
        },

        m16: {
            kick_enabled: true,
            bounce_enabled: false,
            perlin_enabled: false,

            kick:       { strength: 0.2, rotation: 0.15, attack: 0.02, release: 0.1 },
            kick_saved: { strength: 0.2, rotation: 0.15, attack: 0.02, release: 0.1 },

            bounce:       { strength: 0, rotation: 0, frequency: 4.0, damping: 10.0 },
            bounce_saved: { strength: 0.2, rotation: 0.15, frequency: 4.0, damping: 10.0 },

            perlin:       { strength: 0 },
            perlin_saved: { strength: 0 }
        },

        sniper: {
            kick_enabled: true,
            bounce_enabled: false,
            perlin_enabled: false,

            kick:       { strength: 0.6, rotation: 0.35, attack: 0.03, release: 0.2 },
            kick_saved: { strength: 0.6, rotation: 0.35, attack: 0.03, release: 0.2 },

            bounce:       { strength: 0, rotation: 0, frequency: 4.0, damping: 10.0 },
            bounce_saved: { strength: 0.6, rotation: 0.35, frequency: 4.0, damping: 10.0 },

            perlin:       { strength: 0 },
            perlin_saved: { strength: 0 }
        }
    };
}