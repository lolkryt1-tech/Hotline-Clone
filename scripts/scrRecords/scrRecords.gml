
/// @desc Форматирует время в секундах в строку ЧЧ:ММ:СС:мс
function formatTime(_seconds) {
    if (_seconds >= 999999) return "No record";
    var _h  = floor(_seconds / 3600);
    var _m  = floor((_seconds mod 3600) / 60);
    var _s  = floor(_seconds mod 60);
    var _ms = floor((_seconds mod 1) * 100);
    return ((_h < 10) ? "0" + string(_h) : string(_h)) + ":" +
           ((_m < 10) ? "0" + string(_m) : string(_m)) + ":" +
           ((_s < 10) ? "0" + string(_s) : string(_s)) + ":" +
           ((_ms < 10) ? "0" + string(_ms) : string(_ms));
}


/// @function getRecordSection(_level_name)
/// @description Формирует название секции рекордов уровня с учётом сложности.
function getRecordSection(_level_name)
{
    var _section = "Level_" + string(_level_name);

    _section = string_replace_all(_section, " ", "_");
    _section = string_replace_all(_section, "[", "");
    _section = string_replace_all(_section, "]", "");

    _section += global.hard ? "_Hard" : "_Normal";

    return _section;
}


/// @function loadLevelRecord(_level_name)
/// @description Загружает рекорд уровня для текущей сложности.
function loadLevelRecord(_level_name)
{
    var _section = getRecordSection(_level_name);

    var _rec = {
        best_time: 999999,
        best_rank: -1,
        best_score: 0
    };

    ini_open("levels_records.ini");

    _rec.best_time = ini_read_real(_section, "best_time", 999999);
    _rec.best_rank = ini_read_real(_section, "best_rank", -1);

    _rec.best_score = ini_read_real(_section, "best_score", 0);

    ini_close();

    return _rec;
}


/// @function saveLevelRecord(_level_name, _new_time, _new_rank, _new_score)
/// @description Сохраняет новый рекорд уровня для текущей сложности.
function saveLevelRecord(_level_name, _new_time, _new_rank, _new_score)
{
    var _section = getRecordSection(_level_name);
    var _rec = loadLevelRecord(_level_name);
    var _updated = false;

    // === СРАВНЕНИЕ РЕЗУЛЬТАТОВ ===
    if (_new_rank > _rec.best_rank)
    {
        _rec.best_rank = _new_rank;
        _updated = true;
    }

    if (_new_time < _rec.best_time)
    {
        _rec.best_time = _new_time;
        _updated = true;
    }

    if (_new_score > _rec.best_score)
    {
        _rec.best_score = _new_score;
        _updated = true;
    }

    if (!_updated)
    {
        return false;
    }

    // === СОХРАНЕНИЕ В INI ===
    ini_open("levels_records.ini");

    ini_write_real(_section, "best_time", _rec.best_time);
    ini_write_real(_section, "best_rank", _rec.best_rank);
    ini_write_real(_section, "best_score", _rec.best_score);

    ini_close();

    return true;
}


/// @desc Конвертирует строку ранга ("S", "A", ...) в число.
function rankStringToNum(_rank_str) {
    switch (_rank_str) {
        case "S": return 4;
        case "A": return 3;
        case "B": return 2;
        case "C": return 1;
        default:  return 0;
    }
}
