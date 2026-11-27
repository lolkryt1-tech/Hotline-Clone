
/// @description Инициализация данных редактора уровней.
function scrEditorInitialize()
{
    /// === ДАННЫЕ УРОВНЯ ===
    level_data = {
        floors: []
    };


    /// === СОСТОЯНИЕ РЕДАКТОРА ===
    editor_state = {
        current_floor_index: 0,
        active_tool: "SELECT",
        active_layer_id: -1,
        selected_items: []
    };


    /// === СОСТОЯНИЕ ИНТЕРФЕЙСА ===
    editor_ui = {
        asset_browser: {
            is_open: true,
            active_tab: "BUILD"
        },

        tools: {
            is_open: true
        },

        inspector: {
            is_open: true
        }
    };


     // === ИСТОРИЯ ДЕЙСТВИЙ ===
    if (!variable_instance_exists(id, "editor_history"))
    {
        editor_history = {
            actions: [],
            position: 0,
            handlers: []
        };
    }


    // Инициализация завершена
    editor_initialized = true;

    return true;
}
