
/// @function scrEditorWorkspaceDrawTilePreview()
/// @description Показывает выбранный тайл под курсором.

function scrEditorWorkspaceDrawTilePreview()
{
	// Когда удаляем не отрисовываем
	if (mouse_check_button(mb_right)) return;
	
	
    // === ПРОВЕРКА ОБЪЕКТОВ ===
    var _editor = instance_find(objLevelEditor, 0);
    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_editor == noone || _browser == noone) return;

    // === ПРОВЕРКА СОСТОЯНИЯ РЕДАКТОРА ===
    var _browser_open = false;
    var _active_tab = "";

    with (_editor)
    {
        _browser_open = editor_ui.asset_browser.is_open;
        _active_tab = editor_ui.asset_browser.active_tab;
    }

    if (!_browser_open || _active_tab != "BUILD") return;
    if (_browser.build_type != "TILES") return;

    // === ПРОВЕРКА ВЫБРАННОГО ТАЙЛА ===
    if (_browser.selected_tileset_sprite == -1) return;
    if (_browser.selected_tile_index < 0) return;

    if (_browser.selected_tile_x < 0 || _browser.selected_tile_y < 0) return;
    if (is_undefined(_browser.tileset_info)) return;

    // === РАЗМЕРЫ ТАЙЛА ===
    var _tile_w = _browser.tileset_info.tile_width;
    var _tile_h = _browser.tileset_info.tile_height;

    if (_tile_w <= 0 || _tile_h <= 0) return;

    // === КООРДИНАТЫ КУРСОРА В ROOM ===
    var _mouse_x = mouse_x;
    var _mouse_y = mouse_y;
	
	// === КУРСОР НАД ASSET BROWSER ===
	var _gui_mouse_x = device_mouse_x_to_gui(0);
	var _gui_mouse_y = device_mouse_y_to_gui(0);

	if (_gui_mouse_x >= _browser.window_x
	&& _gui_mouse_x <= _browser.window_x + _browser.window_width
	&& _gui_mouse_y >= _browser.window_y
	&& _gui_mouse_y <= _browser.window_y + _browser.window_height)
	{
	    return;
	}

    if (_mouse_x < floor_x || _mouse_x >= floor_x + floor_width) return;
    if (_mouse_y < floor_y || _mouse_y >= floor_y + floor_height) return;

    // === ПРИВЯЗКА К СЕТКЕ ===
    var _preview_x = floor_x + floor((_mouse_x - floor_x) / _tile_w) * _tile_w;
    var _preview_y = floor_y + floor((_mouse_y - floor_y) / _tile_h) * _tile_h;

    // === КООРДИНАТЫ ТАЙЛА В SPRITE ===
    var _source_x = _browser.selected_tile_x * _tile_w;
    var _source_y = (_browser.selected_tile_y + 1) * _tile_h;

    // === ПРЕДПРОСМОТР ===
    draw_sprite_part_ext(
        _browser.selected_tileset_sprite,
        0,
        _source_x,
        _source_y,
        _tile_w,
        _tile_h,
        _preview_x,
        _preview_y,
        1,
        1,
        c_white,
        1
    );
}
