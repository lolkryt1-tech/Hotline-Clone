function scrCheckBuildingFullyCleared()
{
    // Узнаем, сколько всего этажей прописано в нашей миссии
    var _total_floors = global.current_level.total_floors;
    
    // Запускаем цикл, который быстро просмотрит весь наш блокнот этажей
    for (var i = 0; i < _total_floors; i++)
    {
        // Если мы нашли хотя бы один этаж, где галочка до сих пор равна false (не зачищен)...
        if (global.current_level.floors[i].is_cleared == false)
        {
            return false; // ...сразу выходим из функции и говорим: "Здание НЕ зачищено!"
        }
    }
    
    // Если цикл пролистал все этажи и нигде не нашёл false — значит, всё чисто!
    return true; 
}