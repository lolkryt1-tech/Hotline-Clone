
/// === ASSET BROWSER ===

// === РАЗМЕРЫ ОКНА ===
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

window_width = min(680, _gui_w - 32);
window_height = min(470, _gui_h - 32);

// === ПОЛОЖЕНИЕ ОКНА ===
window_x = _gui_w - window_width - 24;
window_y = _gui_h - window_height - 24;

// === ПЕРЕМЕЩЕНИЕ ===
is_dragging = false;
drag_offset_x = 0;
drag_offset_y = 0;

// === РАЗМЕРЫ ЭЛЕМЕНТОВ ===
header_height = 26;
tabs_height = 30;
close_size = 22;

// === BUILD: TYPE ===
build_type = "TILES";

// === BUILD: TILESET DISPLAY ===
tileset_display_scale = 2;

tileset_scroll_x = 0;
tileset_scroll_y = 0;

// === ПЕРЕТАСКИВАНИЕ TILESET ===
tileset_pan_dragging = false;
tileset_pan_start_x = 0;
tileset_pan_start_y = 0;
tileset_pan_start_scroll_x = 0;
tileset_pan_start_scroll_y = 0;

// === ВЫБОР ТАЙЛА ===
hover_tile_x = -1;
hover_tile_y = -1;

selected_tile_x = -1;
selected_tile_y = -1;
selected_tile_index = -1;

// === BUILD: TILESETS ===
tileset_ids = [
    tlRugs,
    tlTiles,
    tlFloors
];

tileset_names = [];

for (var i = 0; i < array_length(tileset_ids); i++)
{
    array_push(tileset_names, tileset_get_name(tileset_ids[i]));
}

// === BUILD: TILESET SPRITES ===
tileset_sprite_ids = [
    sprRugs,
    sprTiles,
    sprFloors
];

// === ВЫБРАННЫЙ TILESET ===
selected_tileset_index = 0;
selected_tileset = array_length(tileset_names) > 0 ? tileset_names[0] : "";
selected_tileset_sprite = array_length(tileset_sprite_ids) > 0 ? tileset_sprite_ids[0] : -1;
tileset_dropdown_open = false;

// === BUILD: TILESET INFO ===
tileset_index = array_length(tileset_ids) > 0 ? tileset_ids[0] : -1;
tileset_info = tileset_index != -1 ? tileset_get_info(tileset_index) : undefined;

// === BUILD: TILESET TEXTURE ===
tileset_texture = tileset_index != -1 ? tileset_get_texture(tileset_index) : -1;
tileset_uvs = tileset_index != -1 ? tileset_get_uvs(tileset_index) : [];

tileset_texel_width = tileset_texture != -1 ? texture_get_texel_width(tileset_texture) : 0;
tileset_texel_height = tileset_texture != -1 ? texture_get_texel_height(tileset_texture) : 0;


// === BUILD: TILE LAYERS ===

tile_layers = [
    {name: "Tile Layer 1", visible: true, locked: false, tilemaps: []},
    {name: "Tile Layer 2", visible: true, locked: false, tilemaps: []}
];

active_layer = 0;



// === РАЗМЕРЫ TILEMAP ===

var _workspace = instance_find(objEditorWorkspace, 0);

if (_workspace == noone)
{
    show_debug_message("ERROR: objEditorWorkSpace не найден при создании Asset Browser.");
}
else
{
    var _map_width = _workspace.floor_width div 16;
    var _map_height = _workspace.floor_height div 16;

    var _floor_origin_x = _workspace.floor_x;
    var _floor_origin_y = _workspace.floor_y;


    // === СОЗДАНИЕ TILEMAP ===

    for (var i = 0; i < array_length(tile_layers); i++)
    {
        var _base_depth = -101 - i * 4;

        // FLOOR
        var _floor_layer = layer_create(
            _base_depth,
            "Editor_TL" + string(i + 1) + "_Floors"
        );

        var _floor_map = layer_tilemap_create(
            _floor_layer,
            _floor_origin_x,
            _floor_origin_y,
            tlFloors,
            _map_width,
            _map_height
        );

        // TILES
        var _tiles_layer = layer_create(
            _base_depth - 1,
            "Editor_TL" + string(i + 1) + "_Tiles"
        );

        var _tiles_map = layer_tilemap_create(
            _tiles_layer,
            _floor_origin_x,
            _floor_origin_y,
            tlTiles,
            _map_width,
            _map_height
        );

        // RUGS
        var _rugs_layer = layer_create(
            _base_depth - 2,
            "Editor_TL" + string(i + 1) + "_Rugs"
        );

        var _rugs_map = layer_tilemap_create(
            _rugs_layer,
            _floor_origin_x,
            _floor_origin_y,
            tlRugs,
            _map_width,
            _map_height
        );

        // СОХРАНЯЕМ TILEMAP В ЛОГИЧЕСКОМ СЛОЕ
        tile_layers[i].tilemaps = [
            {
                tileset: tlFloors,
                layer_id: _floor_layer,
                tilemap_id: _floor_map
            },
            {
                tileset: tlTiles,
                layer_id: _tiles_layer,
                tilemap_id: _tiles_map
            },
            {
                tileset: tlRugs,
                layer_id: _rugs_layer,
                tilemap_id: _rugs_map
            }
        ];
    }
}



// === ПРОКРУТКА TILE LAYERS ===
layers_scroll = 0;
layers_visible_count = 3;
layers_row_height = 26;

layers_scroll_dragging = false;
layers_scroll_drag_offset = 0;


// === ПЕРЕИМЕНОВАНИЕ TILE LAYERS ===
rename_active = false;
rename_layer_index = -1;

last_layer_click = -1;
last_layer_click_time = 0;

rename_double_click_time = 350;

// === УДАЛЕНИЕ TILE LAYERS ===
delete_confirm_active = false;
delete_confirm_index = -1;

// === ПЕРЕТАСКИВАНИЕ TILE LAYERS ===
layer_dragging = false;
layer_drag_candidate = -1;
layer_drag_start_x = 0;
layer_drag_start_y = 0;
layer_drag_mouse_y = 0;
layer_drag_target = -1;

// === ПОДСКАЗКИ ИНСТРУМЕНТОВ ===
tooltip_target = "";
tooltip_timer = 0;
tooltip_delay = 30;
tooltip_alpha = 0;