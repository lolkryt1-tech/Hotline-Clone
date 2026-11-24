/// @desc Возвращает структуру миссии по индексу
/// @param {Real} _level_index Индекс миссии (0 = Part 1, 1 = Part 2, ...)
function scrGetLevelData(_level_index)
{
    // === СПИСОК ВСЕХ МИССИЙ В ИГРЕ ===
var _all_levels = [
        // === МИССИЯ 1 ===
        {
            name: "New Case",
            total_floors: 6,
            floors: [
                { file_prefix: "story_lvl1_f0", room_name: "Room1", is_cleared: false },
                { file_prefix: "story_lvl1_f1", room_name: "Room2", is_cleared: false },
                { file_prefix: "story_lvl1_f2", room_name: "Room3", is_cleared: false },
                { file_prefix: "story_lvl1_f3", room_name: "Room4", is_cleared: false },
                { file_prefix: "story_lvl1_f4", room_name: "Room5", is_cleared: false },
                { file_prefix: "story_lvl1_f5", room_name: "Room6", is_cleared: false }
            ],
            
			level_music: MUSIC_INTRO,
			total_triggers: (global.hard) ? 11 : 7,
			
            // === КОЛИЧЕСТВО ДЛЯ МАКСИМАЛЬНОГО РАНГА ===
            max_stats: (global.hard) ? {
                kills: 72, 
                combo: 72,
                execs: 5,
                score: 600000
            } : {
                kills: 52, 
                combo: 52,
                execs: 3,
                score: 300000
            }
        },
        
        // === МИССИЯ 2: PART 2 — ЧТО-ТО ===
        {
            name: "Part 2: Something",
            total_floors: 2,
            floors: [
                { file_prefix: "story_lvl2_f0", room_name: "Room4", is_cleared: false },
                { file_prefix: "story_lvl2_f1", room_name: "Room5", is_cleared: false }
            ]
        },
        
        // === МИССИЯ 3: PART 3 — ЧТО-ТО ЕЩЁ ===
        {
            name: "Part 3: Another",
            total_floors: 4,
            floors: [
                { file_prefix: "story_lvl3_f0", room_name: "Room6", is_cleared: false },
                { file_prefix: "story_lvl3_f1", room_name: "Room7", is_cleared: false },
                { file_prefix: "story_lvl3_f2", room_name: "Room8", is_cleared: false },
                { file_prefix: "story_lvl3_f3", room_name: "Room9", is_cleared: false }
            ]
        }
        
    ];
    
    // Если индекс вне диапазона — возвращаем первый
    if (_level_index < 0 || _level_index >= array_length(_all_levels))
    {
        return _all_levels[0];
    }
    
    return _all_levels[_level_index];
}