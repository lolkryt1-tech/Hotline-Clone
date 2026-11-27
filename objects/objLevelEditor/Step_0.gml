// === UNDO ===

if (keyboard_check_pressed(ord("Z")) && keyboard_check(vk_control))
{
    scrEditorHistoryUndo();
}

// === REDO ===

if (keyboard_check_pressed(ord("Y")) && keyboard_check(vk_control))
{
    scrEditorHistoryRedo();
}