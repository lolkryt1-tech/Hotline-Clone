dont_destroy = false;


// === AUDIO EMITTER ===

music_emitter = audio_emitter_create();
music_bus = audio_bus_create();

audio_emitter_bus(music_emitter, music_bus);

// === AUDIO EFFECTS ===

// Low-pass filter
music_lpf = audio_effect_create(
    AudioEffectType.LPF2,
    {
        cutoff: 20000,
        q: 1
    }
);

// Reverb
music_reverb = audio_effect_create(
    AudioEffectType.Reverb1,
    {
        size: 0.6,
        damp: 0.7,
        mix: 0
    }
);

// Назначаем эффекты на музыкальную шину
music_bus.effects[0] = music_lpf;
music_bus.effects[1] = music_reverb;

// === MUFFLE SETTINGS ===

muffle_amount = 0;
muffle_speed = 0.08;

// Громкость при разных условиях
zone_volume = 0.6;
menu_volume = 0.7;

// Сила приглушения
zone_muffle = 0.8;
menu_muffle = 0.35;