/// @function scrEditorHistoryPush(_type, _data)
/// @description Добавляет выполненную операцию в историю действий.

function scrEditorHistoryPush(_type, _data)
{
    if (_type == "") return false;

    var _editor = instance_find(objLevelEditor, 0);

    if (_editor == noone) return false;

    var _history = _editor.editor_history;

    // === ПРОВЕРКА РЕГИСТРАЦИИ ===

    var _registered = false;

    for (var i = 0; i < array_length(_history.handlers); i++)
    {
        if (_history.handlers[i].type == _type)
        {
            _registered = true;
            break;
        }
    }

    if (!_registered) return false;

    // === УДАЛЕНИЕ ВЕТКИ REDO ===

    var _action_count = array_length(_history.actions);
    var _position = clamp(_history.position, 0, _action_count);

    if (_position < _action_count)
    {
        var _new_actions = array_create(_position);

        for (var i = 0; i < _position; i++)
            _new_actions[i] = _history.actions[i];

        _history.actions = _new_actions;
    }

    // === ДОБАВЛЕНИЕ ОПЕРАЦИИ ===

    array_push(_history.actions, {
        type: _type,
        data: _data
    });

    _history.position = array_length(_history.actions);

    return true;
}