anim_time += 0.016;

// Линейное вваливание дыма слева направо
if (smoke_progress < 1.0) {
    smoke_progress = min(1.0, smoke_progress + 0.01);
}
