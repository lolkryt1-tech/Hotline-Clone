/// @function scrEditorHistoryClear()
/// @description Очищает историю действий.

function scrEditorHistoryClear()
{
    var _editor = instance_find(objLevelEditor, 0);

    if (_editor == noone) return false;

    var _history = _editor.editor_history;

    _history.actions = [];
    _history.position = 0;

    return true;
}