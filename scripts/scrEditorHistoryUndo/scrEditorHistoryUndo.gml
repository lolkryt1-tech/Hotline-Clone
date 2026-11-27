/// @function scrEditorHistoryUndo()
/// @description Отменяет последнее действие.

function scrEditorHistoryUndo()
{
    var _editor = instance_find(objLevelEditor, 0);

    if (_editor == noone) return false;

    var _history = _editor.editor_history;

    if (_history.position <= 0) return false;

    var _action_index = _history.position - 1;
    var _action = _history.actions[_action_index];

    // === ПОИСК ОБРАБОТЧИКА ===

    for (var i = 0; i < array_length(_history.handlers); i++)
    {
        var _handler = _history.handlers[i];

        if (_handler.type != _action.type) continue;

        var _success = _handler.undo(_action.data);

        if (_success)
        {
            _history.position--;
            return true;
        }

        return false;
    }

    return false;
}