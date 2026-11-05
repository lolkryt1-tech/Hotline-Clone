function LevelSelect_DestroyGrade()
{
    if (grade_ui != noone && instance_exists(grade_ui))
    {
        instance_destroy(grade_ui);
    }

    grade_ui = noone;
}