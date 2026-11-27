scrEditorInitialize();

scrEditorHistoryTileCellsRegister();

// === СОЗДАНИЕ КОМПОНЕНТОВ ===

if (!instance_exists(objEditorWorkspace)) instance_create_depth(x, y, 10, objEditorWorkspace);
if (!instance_exists(objEditorAssetBrowser)) instance_create_depth(x, y, -100, objEditorAssetBrowser);