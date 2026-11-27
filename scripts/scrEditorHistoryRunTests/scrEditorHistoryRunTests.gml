/// @function scrEditorHistoryRunTests()
/// @description Проверяет работу ядра Undo / Redo.

function scrEditorHistoryRunTests()
{
    var _editor = instance_find(objLevelEditor, 0);

    if (_editor == noone) return false;

    _editor.history_test_value = 0;

    scrEditorHistoryClear();

    // === РЕГИСТРАЦИЯ ОБРАБОТЧИКА ===

    if (!scrEditorHistoryRegister(
        "TEST_CHANGE",
        scrEditorHistoryTestUndo,
        scrEditorHistoryTestRedo
    ))
    {
        show_debug_message("HISTORY TEST: Registration FAILED");
        return false;
    }

    // === ДЕЙСТВИЕ A: +1 ===

    _editor.history_test_value += 1;

    if (!scrEditorHistoryPush("TEST_CHANGE", {amount: 1}))
        return false;

    // === ДЕЙСТВИЕ B: +10 ===

    _editor.history_test_value += 10;

    if (!scrEditorHistoryPush("TEST_CHANGE", {amount: 10}))
        return false;

    if (_editor.history_test_value != 11) return false;

    // === ДВА UNDO ===

    if (!scrEditorHistoryUndo()) return false;
    if (_editor.history_test_value != 1) return false;

    if (!scrEditorHistoryUndo()) return false;
    if (_editor.history_test_value != 0) return false;

    // === ДВА REDO ===

    if (!scrEditorHistoryRedo()) return false;
    if (_editor.history_test_value != 1) return false;

    if (!scrEditorHistoryRedo()) return false;
    if (_editor.history_test_value != 11) return false;

    // === ПРОВЕРКА УДАЛЕНИЯ ВЕТКИ REDO ===

    if (!scrEditorHistoryUndo()) return false;

    _editor.history_test_value += 5;

    if (!scrEditorHistoryPush("TEST_CHANGE", {amount: 5}))
        return false;

    if (_editor.history_test_value != 6) return false;

    if (scrEditorHistoryRedo()) return false;

    if (_editor.editor_history.position != 2) return false;

    if (array_length(_editor.editor_history.actions) != 2)
        return false;

    // === ЗАВЕРШЕНИЕ ТЕСТА ===

    scrEditorHistoryClear();

    _editor.history_test_value = 0;

    show_debug_message("HISTORY TEST: ALL TESTS PASSED");

    return true;
}