function scrQuickSaveNotificationStep()
{
    if (!quick_save_notification_visible) return;

    var _dt = delta_time / 1000000;

    quick_save_notification_timer -= _dt;

    // Независимая анимация оформления
    quick_save_notification_anim_time += _dt;

    // Плавное появление
    if (quick_save_notification_timer > 1.6)
    {
        quick_save_notification_alpha += _dt / 0.2;
    }
    // Плавное исчезновение
    else if (quick_save_notification_timer <= 0.3)
    {
        quick_save_notification_alpha -= _dt / 0.3;
    }

    quick_save_notification_alpha = clamp(
        quick_save_notification_alpha, 0, 1
    );

    // Смещение снизу вверх
    quick_save_notification_offset_y =
        lerp(10, 0, quick_save_notification_alpha);

    // Завершение показа
    if (quick_save_notification_timer <= 0)
    {
        scrQuickSaveNotificationHide();
    }
}