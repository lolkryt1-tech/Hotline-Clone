function LevelSelect_CreateGrade()
{
    // Если объект уже существует, ничего не делаем.
    if (grade_ui != noone && instance_exists(grade_ui))
    {
        return;
    }

    var _cur_rec = level_records[target_scroll];

    // Уровень ещё не имеет ранга.
    if (_cur_rec.best_rank < 0)
    {
        return;
    }

    // Создаём объект и передаём ему ранг.
    grade_ui = instance_create_layer(0, 0, "Instances", objScoreGradeUI);

    grade_ui.setRank(_cur_rec.best_rank);
}