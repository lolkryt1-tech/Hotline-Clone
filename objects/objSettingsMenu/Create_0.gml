depth = -15000;


// ========================================
// СОСТОЯНИЯ И ПЕРЕЧИСЛЕНИЯ
// ========================================

enum SETTINGS_STATE
{
    HOME,
    OPENING,
    CATEGORY,
    CLOSING
}

enum SETTINGS_CONTEXT
{
    MAIN_MENU,
    PAUSE_MENU
}

enum SETTINGS_PAGE
{
    HOME,
    GAME,
    VISUAL,
    CONTROLS,
    VOLUME_EXTRA,
    KEYBINDS,
    MOUSE
}

enum KEYBIND_MODE
{
    NONE,
    WAITING,
    CONFLICT,
    RESET_CONFIRM
}

enum SETTING_TYPE
{
    NONE,
    TOGGLE,
    SLIDER,
    ACTION
}


// ========================================
// СОСТОЯНИЕ МЕНЮ
// ========================================

menu_state = SETTINGS_STATE.HOME;
menu_context = SETTINGS_CONTEXT.MAIN_MENU;

return_instance = noone;
menu_active = true;

selected_index = 0;
home_selected_index = 0;

current_page = SETTINGS_PAGE.HOME;
page_title = "";


// ========================================
// НАВИГАЦИЯ ПО СТРАНИЦАМ
// ========================================

page_stack = [SETTINGS_PAGE.HOME];
parent_selected_index_stack = [0];

page_items = {};
page_items[$ SETTINGS_PAGE.CONTROLS] = [
    "KEYBINDS",
    "MOUSE"
];

page_children = {};
page_children[$ SETTINGS_PAGE.CONTROLS] = [
    SETTINGS_PAGE.KEYBINDS,
    SETTINGS_PAGE.MOUSE
];


// ========================================
// ПУНКТЫ МЕНЮ
// ========================================

// ========================================
// ОПИСАНИЯ НАСТРОЕК
// ========================================

// === ГЛАВНАЯ СТРАНИЦА ===

// ========================================
// ГЛАВНАЯ СТРАНИЦА — ЕДИНЫЙ СПИСОК
// ========================================

home_menu_items = [
    {
        id: "sound_volume",
        label: "SOUNDS",
        type: SETTING_TYPE.SLIDER,
        setting: "sound_volume",
        min: 0,
        max: 1,
        step: 0.05,
        display_scale: 100,
        suffix: "%",
        page: -1
    },
    {
        id: "music_volume",
        label: "MUSIC",
        type: SETTING_TYPE.SLIDER,
        setting: "music_volume",
        min: 0,
        max: 1,
        step: 0.05,
        display_scale: 100,
        suffix: "%",
        page: -1
    },
    {
        id: "game",
        label: "GAME",
        type: SETTING_TYPE.NONE,
        setting: "",
        page: SETTINGS_PAGE.GAME
    },
    {
        id: "visual",
        label: "VISUAL",
        type: SETTING_TYPE.NONE,
        setting: "",
        page: SETTINGS_PAGE.VISUAL
    },
    {
        id: "controls",
        label: "CONTROLS",
        type: SETTING_TYPE.NONE,
        setting: "",
        page: SETTINGS_PAGE.CONTROLS
    },
    {
        id: "volume_extra",
        label: "VOLUME EXTRA",
        type: SETTING_TYPE.NONE,
        setting: "",
        page: SETTINGS_PAGE.VOLUME_EXTRA
    }
];

// === ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ ЗВУКОВ ===

volume_extra_setting_items = [
    {
        id: "enable_music_filters",
        label: "ENABLE MUSIC FILTERS",
        type: SETTING_TYPE.TOGGLE,
        setting: "enable_music_filters"
    }
];


// === НАСТРОЙКИ МЫШИ ===

mouse_setting_items = [
    {
        id: "mouse_sensitivity",
        label: "SENSITIVITY",
        type: SETTING_TYPE.SLIDER,
        setting: "mouse_sensitivity",
        min: 0.1,
        max: 3.0,
        step: 0.05,
        display_scale: 100,
        suffix: "%"
    },
    {
        id: "camera_roughness",
        label: "CAMERA ROUGHNESS",
        type: SETTING_TYPE.SLIDER,
        setting: "camera_roughness",
        min: 5,
        max: 100,
        step: 1,
        display_scale: 1,
        suffix: "%"
    },
    {
        id: "raw_camera",
        label: "RAW CAMERA",
        type: SETTING_TYPE.TOGGLE,
        setting: "raw_camera"
    }
];

game_items = [
    {
        id: "enable_tips",
        label: "ENABLE TIPS",
        type: SETTING_TYPE.TOGGLE,
        setting: "enable_tips"
    }
];



visual_items = [
	{
        id: "crosshair_size",
        label: "CROSSHAIR SIZE",
        type: SETTING_TYPE.SLIDER,
        setting: "crosshair_size",
        min: 0.1,
        max: 3.0,
        step: 0.01,
        display_scale: 100,
        suffix: "%"
	}
];



controls_items = [];

controls_menu_items = [
    "KEYBINDS",
    "MOUSE",
];


// ========================================
// ЕДИНЫЙ РЕЕСТР НАСТРОЕК СТРАНИЦ
// ========================================

settings_page_items = [];

settings_page_items[SETTINGS_PAGE.HOME] = home_menu_items;
settings_page_items[SETTINGS_PAGE.GAME] = game_items;
settings_page_items[SETTINGS_PAGE.VISUAL] = visual_items;
settings_page_items[SETTINGS_PAGE.CONTROLS] = controls_items;
settings_page_items[SETTINGS_PAGE.VOLUME_EXTRA] = volume_extra_setting_items;
settings_page_items[SETTINGS_PAGE.KEYBINDS] = [];
settings_page_items[SETTINGS_PAGE.MOUSE] = mouse_setting_items;

// ========================================
// ГЕНЕРАЦИЯ СПИСКА ДЛЯ ОТРИСОВКИ
// ========================================

keys_items = [];

for (var i = 0; i < array_length(global.bind_definitions); i++)
{
    array_push(keys_items, global.bind_definitions[i].label);
}


// ========================================
// АНИМАЦИЯ
// ========================================

home_offset_x = 0;
home_target_offset_x = -600;

volume_percent_offset_x = 0;

page_offset_x = 600;
page_target_offset_x = 600;

depth_current = 0;
depth_target = 0;
depth_closing_start = 0;

transition_speed = 0.15;
transition_active = false;

transition_selected_index = 0;
debug_layout = false;


// ========================================
// АНИМАЦИЯ ЗАГОЛОВКА И РОДИТЕЛЬСКОЙ СТРАНИЦЫ
// ========================================

sub_title = "";

sub_title_progress = 0;

sub_title_start_x = 0;
sub_title_start_y = 0;

sub_title_target_x = 0;
sub_title_target_y = 60;

arent_fly_progress = 1;

parent_fly_y_current = 60;
parent_fly_start_y = 380;
parent_fly_target_y = 60;

controls_slot_y = [180, 245];


// ========================================
// ТАЙМЕР АВТОПОВТОРА ПОЛЗУНКОВ
// ========================================

axis_repeat_timer = 0;
axis_repeat_started = false;


// ========================================
// ПРОКРУТКА KEYBINDS
// ========================================

keybind_scroll_y = 0;
keybind_scroll_target = 0;
keybind_scroll_speed = 0.18;


// ========================================
// ПЕРЕНАЗНАЧЕНИЕ КЛАВИШ
// ========================================

keybind_mode = KEYBIND_MODE.NONE;

keybind_rebind_index = -1;
keybind_pending_key = -1;
keybind_conflict_index = -1;

keybind_conflict_selection = 0;
keybind_reset_selection = 0;

keybind_wait_release = false;

keybind_capture_start_time = 0;
keybind_block_start = false;


// ========================================
// ВИЗУАЛЬНАЯ ОБРАТНАЯ СВЯЗЬ KEYBINDS
// ========================================

keybind_feedback_index = -1;
keybind_feedback_timer = 0;
keybind_feedback_key = -1;

// Одновременная подсветка всех изменённых клавиш после DEFAULT.
keybind_feedback_indices = [];
