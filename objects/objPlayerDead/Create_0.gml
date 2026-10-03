friction = 0.4;
image_speed = 0;
speed = 5; // Коп отлетает при смерти

// Инициализация базовых переменных трупа
hit_type = 0;
my_angle = 0;
create_blood_pool = 0;
go_splat = 1; // Флаг, разрешающий взорваться брызгами на первом кадре Step

// Настройка рендеринга слоев (новый труп поверх старых)
global.body_render_counter--;
depth = global.body_render_counter; 

// === GUI PANEL ===
// Вычисляем скрытую позицию в самом низу экрана (запас 150 пикселей)
restart_panel_y = display_get_gui_height() + 150; 
