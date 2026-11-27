
/// @function scrEditorWorkspaceHandleTools(_over_browser)
/// @description Обрабатывает ввод инструментов рабочего пространства.

function scrEditorWorkspaceHandleTools(_over_browser)
{
    // === ПРОВЕРКА ASSET BROWSER ===

    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_browser == noone)
    {
        if (rectangle_active)
            scrEditorWorkspaceRestoreRectanglePreview();

        if (tile_history_active)
            scrEditorHistoryTileOperationFinish();

        rectangle_active = false;
        rectangle_action = "";

        pencil_last_x = -1;
        pencil_last_y = -1;

        return;
    }

    var _browser_open = false;
    var _active_tab = "";
    var _build_type = "";

    with (objLevelEditor)
    {
        _browser_open = editor_ui.asset_browser.is_open;
        _active_tab = editor_ui.asset_browser.active_tab;
    }

    _build_type = _browser.build_type;

    // === КООРДИНАТЫ МЫШИ ===

    var _mx = mouse_x;
    var _my = mouse_y;

    var _cols = floor(floor_width / grid_cell_size);
    var _rows = floor(floor_height / grid_cell_size);

    var _inside_workspace =
        _mx >= floor_x &&
        _my >= floor_y &&
        _mx < floor_x + floor_width &&
        _my < floor_y + floor_height;

    var _cell_x = floor((_mx - floor_x) / grid_cell_size);
    var _cell_y = floor((_my - floor_y) / grid_cell_size);

    // === КНОПКИ МЫШИ ===

    var _left_down = mouse_check_button(mb_left);
    var _right_down = mouse_check_button(mb_right);

    var _left_pressed = mouse_check_button_pressed(mb_left);
    var _right_pressed = mouse_check_button_pressed(mb_right);

    var _left_released = mouse_check_button_released(mb_left);
    var _right_released = mouse_check_button_released(mb_right);

    // === ПРОВЕРКА СОСТОЯНИЯ РЕДАКТОРА ===

    if (!_browser_open || _active_tab != "BUILD" || _build_type != "TILES")
    {
        if (rectangle_active)
            scrEditorWorkspaceRestoreRectanglePreview();

        if (tile_history_active)
            scrEditorHistoryTileOperationFinish();

        rectangle_active = false;
        rectangle_action = "";

        pencil_last_x = -1;
        pencil_last_y = -1;

        return;
    }

    // ==================================================
    // КАРАНДАШ
    // ==================================================

    if (active_tool == "PENCIL")
    {
        if (rectangle_active)
        {
            scrEditorWorkspaceRestoreRectanglePreview();

            rectangle_active = false;
            rectangle_action = "";
        }

        // === ЗАВЕРШЕНИЕ ОПЕРАЦИИ ===

        if (tile_history_active && !_left_down && !_right_down)
        {
            scrEditorHistoryTileOperationFinish();

            pencil_last_x = -1;
            pencil_last_y = -1;

            return;
        }

        if (_over_browser || !_inside_workspace)
        {
            pencil_last_x = -1;
            pencil_last_y = -1;
            return;
        }

        if (!_left_down && !_right_down)
        {
            pencil_last_x = -1;
            pencil_last_y = -1;
            return;
        }

        var _action = "";

        if (_left_down)
            _action = "DRAW";
        else if (_right_down)
            _action = "ERASE";

        if (_action == "") return;

        // === НАЧАЛО ОПЕРАЦИИ ===

        if (!tile_history_active)
        {
            if (_left_pressed || _right_pressed)
            {
                scrEditorHistoryTileOperationBegin(_browser.active_layer);
            }
            else
            {
                return;
            }
        }

        if (pencil_last_x == -1 || pencil_last_y == -1)
        {
            scrEditorWorkspaceApplyTile(_cell_x, _cell_y, _action);
        }
        else if (_cell_x != pencil_last_x || _cell_y != pencil_last_y)
        {
            scrEditorWorkspaceDrawPencilLine(
                pencil_last_x,
                pencil_last_y,
                _cell_x,
                _cell_y,
                _action
            );
        }

        pencil_last_x = _cell_x;
        pencil_last_y = _cell_y;

        return;
    }

    // ==================================================
    // ПРЯМОУГОЛЬНИК
    // ==================================================

    if (active_tool == "RECTANGLE")
    {
        if (!rectangle_active && _over_browser)
            return;

        // === НАЧАЛО ВЫДЕЛЕНИЯ ===

        if (!rectangle_active)
        {
            if (_left_pressed)
                rectangle_action = "DRAW";
            else if (_right_pressed)
                rectangle_action = "ERASE";
            else
                return;

            // Начинаем общую операцию истории
            if (!scrEditorHistoryTileOperationBegin(_browser.active_layer))
            {
                rectangle_action = "";
                return;
            }

            rectangle_active = true;

            rectangle_start_x = _cell_x;
            rectangle_start_y = _cell_y;

            rectangle_end_x = _cell_x;
            rectangle_end_y = _cell_y;
        }

        // === ОБНОВЛЕНИЕ КОНЕЧНОЙ КЛЕТКИ ===

        rectangle_end_x = _cell_x;
        rectangle_end_y = _cell_y;

        // === ПРЕДПРОСМОТР СТИРАНИЯ ===

        if (rectangle_action == "ERASE")
        {
            scrEditorWorkspacePreviewRectangleErase(
                rectangle_start_x,
                rectangle_start_y,
                rectangle_end_x,
                rectangle_end_y
            );
        }

        // === ЗАВЕРШЕНИЕ ВЫДЕЛЕНИЯ ===

        var _selection_finished =
            (rectangle_action == "DRAW" && _left_released) ||
            (rectangle_action == "ERASE" && _right_released);

        if (_selection_finished)
        {
            if (rectangle_action == "DRAW")
            {
                scrEditorWorkspaceApplyRectangle(
                    rectangle_start_x,
                    rectangle_start_y,
                    rectangle_end_x,
                    rectangle_end_y,
                    "DRAW"
                );
            }
            else if (rectangle_action == "ERASE")
            {
                scrEditorWorkspaceCommitRectanglePreview();
            }

            // Записываем всю операцию одной записью
            scrEditorHistoryTileOperationFinish();

            rectangle_active = false;
            rectangle_action = "";

            rectangle_start_x = -1;
            rectangle_start_y = -1;

            rectangle_end_x = -1;
            rectangle_end_y = -1;
        }
    }
}
