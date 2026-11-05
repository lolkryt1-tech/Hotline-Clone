/// @desc Определение итогового ранга и сохранение рекорда
function scrScoreMenu_Rank() {
    var _p_kills = (stat_data[0].max > 0)
        ? min(stat_data[0].target / stat_data[0].max, 1) : 0;

    var _p_combo = (stat_data[1].max > 0)
        ? min(stat_data[1].target / stat_data[1].max, 1) : 0;

    var _p_execs = (stat_data[2].max > 0)
        ? min(stat_data[2].target / stat_data[2].max, 1) : 0;

    // Для обычных рангов по-прежнему смотрим на минимальный результат
    final_percent = min(_p_kills, _p_combo, _p_execs);

    final_rank_num = 0;

    // 100% для ранга S
    if (_p_kills == 1 && _p_combo == 1 && _p_execs == 1) {
        final_rank_num = 4; // Строго S
    }
    // Если хотя бы один параметр не идеален, распределяем по остальным рангам
    else if (final_percent >= 0.75) final_rank_num = 3; // A
    else if (final_percent >= 0.5)  final_rank_num = 2; // B
    else if (final_percent >= 0.25) final_rank_num = 1; // C

    saveLevelRecord(
        global.current_level.name,
        global.level_time / 60,
        final_rank_num,
        global.total_score
    );

    var _rec = loadLevelRecord(global.current_level.name);

    best_time_recorded = _rec.best_time;
    best_rank_recorded = _rec.best_rank;
    best_score_recorded = _rec.best_score;
}
