// Текущее состояние прохождения здания (инициализируется при старте миссии)
global.current_level = {
    name: "Part 1: Prelude",
    total_floors: 3,
    current_floor: 0, // На каком этаже игрок прямо сейчас (0, 1, 2...)
    
    
    trigger_go_to_car: false, 
    
    // Массив этажей здания
    floors: [
        { file_prefix: "story_lvl1_f0", is_cleared: false }, // 1-й этаж
        { file_prefix: "story_lvl1_f1", is_cleared: false }, // 2-й этаж
        { file_prefix: "story_lvl1_f2", is_cleared: false }  // 3-й этаж
    ]
};

go_to_car_alpha = 0.0;
