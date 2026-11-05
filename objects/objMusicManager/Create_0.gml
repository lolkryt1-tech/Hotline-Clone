// Текущая музыка
music_current = -1;
music_current_asset = -1;

// Следующая музыка при переключении
music_next = -1;
music_next_asset = -1;

// Музыка, ожидающая загрузки Audio Group
music_pending_asset = -1;
music_pending_loop = true;

// Состояние перехода
music_fade_state = 0;
// 0 = ничего
// 1 = переключение музыки
// 2 = остановка музыки

music_fade_timer = 0;
music_fade_duration = 60;

// === АУДИООБРАБОТКА ===

music_emitter = audio_emitter_create();
music_bus = audio_bus_create();

audio_emitter_bus(music_emitter, music_bus);

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

// === MENU MUFFLE ===
menu_volume = 0.7;
menu_muffle = 0.45;

// === ZONE MUFFLE ===
zone_volume = 0.6;
zone_muffle = 0.8;

// === EFFECT TRANSITION ===
muffle_amount = 0;
muffle_speed = 0.08;

// === FILTER SETTINGS ===
normal_cutoff = 20000;
menu_cutoff = 2500;
zone_cutoff = 450;

// === REVERB SETTINGS ===
menu_reverb_mix = 0.35;