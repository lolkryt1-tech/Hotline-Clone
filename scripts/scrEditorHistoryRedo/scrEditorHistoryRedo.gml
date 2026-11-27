/// @function scrEditorHistoryRedo()
/// @description Повторяет последнее отменённое действие.

function scrEditorHistoryRedo()
{
    var _editor = instance_find(objLevelEditor, 0);

    if (_editor == noone) return false;

    var _history = _editor.editor_history;

    if (_history.position >= array_length(_history.actions))
        return false;

    var _action = _history.actions[_history.position];

    // === ПОИСК ОБРАБОТЧИКА ===

    for (var i = 0; i < array_length(_history.handlers); i++)
    {
        var _handler = _history.handlers[i];

        if (_handler.type != _action.type) continue;

        var _success = _handler.redo(_action.data);

        if (_success)
        {
            _history.position++;
            return true;
        }

        return false;
    }

    return false;
}