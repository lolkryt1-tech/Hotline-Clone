function LevelSelect_MoveSelection(_direction)
{
    var _new_position = target_scroll + _direction;

    // Проверяем границы карусели.
    if (_new_position < 0 || _new_position >= array_length(levels))
    {
        return;
    }

    target_scroll = _new_position;

    dash_spread = 30;

    audio_play_sound(sndPauseMenuScroll, 0, false);

    // Если полотно уже открыто, обновляем отображаемый ранг.
    if (state == LEVEL_STATE.CONFIRMING || state == LEVEL_STATE.WAITING)
    {
        LevelSelect_DestroyGrade();
        LevelSelect_CreateGrade();
    }
}