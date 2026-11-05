enum SETTINGS_STATE
{
    HOME,
    OPENING,
    CATEGORY,
    CLOSING
}

// Текущее состояние меню
menu_state = SETTINGS_STATE.HOME;

// === ПРОГРЕСС ПЕРЕХОДА ===
transition_progress = 0;
transition_target = 0;
transition_speed = 0.15;



enum SETTINGS_CONTEXT {
    MAIN_MENU,
    PAUSE_MENU
}


// ОТКУДА ОТКРЫЛИ НАСТРОЙКИ
menu_context = SETTINGS_CONTEXT.MAIN_MENU;
return_instance = noone;


enum SETTINGS_PAGE {
    HOME,
    GAME,
    VISUAL,
    CONTROLS,
    VOLUME_EXTRA
}


current_page = SETTINGS_PAGE.HOME;	// ОТКРЫТАЯ СТРАНИЦА
selected_index = 0;					// ВЫБРАННЫЙ ПУНКТ

// Запоминаем выбранную категорию на HOME
home_selected_index = 0;

home_items = [
    "SOUNDS",
    "MUSIC",
	
    "GAME",
    "VISUAL",
    "CONTROLS",
    "VOLUME EXTRA"
];

// Временное название открытой категории
page_title = "";

game_items = [];
visual_items = [];
controls_items = [];
volume_extra_items = [
    "ENABLE MUSIC FILTERS"
];

// ДЕАКТИВАЦИЯ МЕНЮ, КОТОРОЕ ВЫЗВАЛО
menu_active = true;



// === АНИМАЦИЯ ПЕРЕХОДА ===

volume_percent_offset_x = 0;

home_offset_x = 0;				// Текущее смещение главной страницы
home_target_offset_x = -600;	// Насколько далеко элементы должны уехать
transition_speed = 0.15;		// Скорость анимации

// Смещение внутренней страницы
page_offset_x = 600;
page_target_offset_x = 600;



// === СОСТОЯНИЕ ПЕРЕХОДА ===

transition_active = false;
transition_progress = 0;
transition_speed = 0.15;

// Индекс категории, которую открываем
transition_selected_index = 0;