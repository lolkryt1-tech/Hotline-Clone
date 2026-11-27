/// @function scrEditorHistoryRegister(_type, _undo_handler, _redo_handler)
/// @description Регистрирует обработчики отмены и повтора операции.

function scrEditorHistoryRegister(_type, _undo_handler, _redo_handler)
{
    if (_type == "") return false;

    if (is_undefined(_undo_handler) || is_undefined(_redo_handler))
        return false;

    var _editor = instance_find(objLevelEditor, 0);

    if (_editor == noone) return false;

    var _history = _editor.editor_history;

    // === ПРОВЕРКА СУЩЕСТВУЮЩЕГО ОБРАБОТЧИКА ===

    for (var i = 0; i < array_length(_history.handlers); i++)
    {
        if (_history.handlers[i].type == _type)
        {
            _history.handlers[i].undo = _undo_handler;
            _history.handlers[i].redo = _redo_handler;

            return true;
        }
    }

    // === ДОБАВЛЕНИЕ ОБРАБОТЧИКА ===

    array_push(_history.handlers, {
        type: _type,
        undo: _undo_handler,
        redo: _redo_handler
    });

    return true;
}