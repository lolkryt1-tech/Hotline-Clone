function scrCameraGame()
{
    // Обычный геймплей: объект эффектора сидит строго на мышке
    x = mouse_x;
    y = mouse_y;

    // Автоматический рассвет
    if (fade_darkness > 0) 
    {
        fade_darkness = max(fade_darkness - fade_speed, 0.0);
    }
}