depth = 100;

color_sky_top = make_color_rgb(10, 5, 20);
color_sky_bot = make_color_rgb(40, 10, 60);
color_sea     = make_color_rgb(30, 10, 20);

// Таймер спавна пальм
spawn_timer = 0;
spawn_delay = 60; 

// Прокрутка сетки
grid_scroll = 0;
grid_speed = 0.001; 

// Спавним луну
instance_create_layer(0, 0, "Instances", objScoreMoon);

// Спавним 50 звезд при старте комнаты
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _horizon_y = _gui_h * 0.5;

repeat(50) {
    // Спавним в случайной точке неба (выше горизонта)
    var _star = instance_create_layer(random(_gui_w), random(_horizon_y - 15), "Instances", objScoreStar);

    // Сразу прокрутим им анимацию в случайное место, чтобы они не загорались одновременно
    _star.anim_time = random(pi); 
}

// === ПОСЛЕДОВАТЕЛЬНЫЙ СПАВН СЛОЕВ СЦЕНЫ ===
// 1. ДАЛЬНИЙ ГОРОД (Серо-фиолетовый, огромный, ЗА высотками)
var far_scape = instance_create_layer(0, 0, "Instances", objScoreCityBackdrop);
far_scape.depth = 96;
far_scape.scale_x = 1.7;
far_scape.scale_y = 8.0; 
far_scape.pull_up = 165;       
far_scape.wave_amp = 3;  
far_scape.wave_speed = 0.005; // ленивый параллакс
far_scape.fog_color = make_color_rgb(25, 15, 60); 
far_scape.draw_alpha = 0.75;  // с прозрачностью

// 2. ВЫСОТКИ (С блумом и окнами, СРЕДНИЙ ПЛАН)
instance_create_layer(0, 0, "Instances", objScoreCityScape);

// 3. БЛИЖНИЙ ГОРОД (Черный, поменьше, ПОВЕРХ ног высоток)
var close_scape = instance_create_layer(0, 0, "Instances", objScoreCityBackdrop);
close_scape.depth = 92;
close_scape.scale_x = 0.95;
close_scape.scale_y = 10.0; 
close_scape.pull_up = 105;       
close_scape.wave_amp = 5;  
close_scape.wave_speed = 0.012; // качается быстрее
close_scape.fog_color = make_color_rgb(5, 2, 12); 
close_scape.draw_alpha = 1.0;   // наглухо черный силуэт

// 4. САМЫЙ ПЕРЕДНИЙ ПЛАН (Дорога, солнце, сетка)
instance_create_layer(0, 0, "Instances", objScoreForeground);
