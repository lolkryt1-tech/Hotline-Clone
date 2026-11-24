/// @function scrSettingsKeybindLayout(_gui_w, _gui_h)
/// @description Рассчитывает адаптивную геометрию страницы KEYBINDS.

function scrSettingsKeybindLayout(_gui_w, _gui_h)
{
    var _layout = {};

    // VISUAL TUNING

    var MARGIN_X = 60;

    var HEADER_GAP = 42;

    var CATEGORY_HEIGHT = 26;
    var CATEGORY_TO_ROW_GAP = 12;
    var CATEGORY_SPACING = 34;

    var ROW_HEIGHT = 52;
    var ROW_SPACING = 12;

    var KEYCAP_HEIGHT = 38;
    var KEYCAP_MIN_WIDTH = 54;
    var KEYCAP_PADDING_X = 14;

    var LIST_TOP_OFFSET = 235;
    var FOOTER_HEIGHT = 110;
    var LIST_BOTTOM_GAP = 20;

    // TYPOGRAPHY

    _layout.font_action = fntKeybindAction;
    _layout.font_key = fntKeybindKey;
    _layout.font_category = fntKeybindCategory;
    _layout.font_header = fntKeybindHeader;

    // HORIZONTAL GEOMETRY

    _layout.margin_x = MARGIN_X;

    _layout.title_x = MARGIN_X;
    _layout.title_y = clamp(_gui_h * 0.055, 35, 65);

    _layout.subtitle_x = MARGIN_X;
    _layout.subtitle_y = _layout.title_y + 48;

    _layout.header_y = _layout.title_y + HEADER_GAP + 60;

    _layout.action_x = MARGIN_X;
    _layout.key_right = _gui_w - MARGIN_X;

    // CATEGORY GEOMETRY

    _layout.category_height = CATEGORY_HEIGHT;
    _layout.category_to_row_gap = CATEGORY_TO_ROW_GAP;
    _layout.category_spacing = CATEGORY_SPACING;

    // ROW GEOMETRY

    _layout.row_height = ROW_HEIGHT;
    _layout.row_spacing = ROW_SPACING;
    _layout.row_step = ROW_HEIGHT + ROW_SPACING;

    // KEYCAP GEOMETRY

    _layout.keycap_height = KEYCAP_HEIGHT;
    _layout.keycap_min_width = KEYCAP_MIN_WIDTH;
    _layout.keycap_padding_x = KEYCAP_PADDING_X;

    // LIST AREA

    _layout.list_top = LIST_TOP_OFFSET;
    _layout.footer_top = _gui_h - FOOTER_HEIGHT;
    _layout.list_bottom = _layout.footer_top - LIST_BOTTOM_GAP;

    // CATEGORY DATA

    _layout.category_names = [
        "MOVEMENT",
        "COMBAT",
        "SYSTEM"
    ];

    _layout.category_starts = [
	    0,
	    6,
	    12
	];

    // DEBUG

    _layout.debug_enabled = false;

    return _layout;
}