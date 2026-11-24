// === РАЗМЕРЫ ОКНА ===

window_w = 400;
window_h = 840;
title_h = 28;

// === ПОЗИЦИЯ ===
x = global.camera_shake_menu_x;
y = global.camera_shake_menu_y;

// === ПЕРЕТАСКИВАНИЕ ОКНА ===

dragging = false;
drag_offset_x = 0;
drag_offset_y = 0;

// === ФЛАГИ СИНХРОНИЗАЦИИ ===
is_syncing_textboxes = false;

// === ВЫБОР ПРЕСЕТА ПРИ СТАРТЕ ===
selected_category = "weapons";
selected_preset = "pistol";

if (instance_exists(objPlayer))
{
    // Получаем строку ID оружия (например, "pipe" или "pistol")
    var _weapon_str = scrCameraShakeWeaponToString(objPlayer.current_weapon);
    
    // Если оружие распознано — выбираем его пресет
    if (_weapon_str != "") {
        selected_preset = _weapon_str;
    }
}

execution_manually_selected = false;


// === ВЫПАДАЮЩИЙ СПИСОК ПРЕСЕТОВ (слева) ===
last_weapon = instance_exists(objPlayer) ? objPlayer.current_weapon : -1;
preset_dropdown_open = false;
preset_scroll = 0;

preset_dropdown_x = 12;
preset_dropdown_y = 65;
preset_dropdown_w = 150;
preset_item_h = 24;
preset_visible_count = 6;

// === ВЫПАДАЮЩИЙ СПИСОК КАТЕГОРИЙ (справа) ===
category_dropdown_open = false;
category_scroll = 0;

category_dropdown_x = 220;
category_dropdown_y = 65;
category_dropdown_w = 160;
category_item_h = 24;
category_visible_count = 6;

// === ПЕРЕКЛЮЧАТЕЛИ ЭФФЕКТОВ ===

effect_button_x = 16;
effect_button_y = 120;
effect_button_w = 112;
effect_button_h = 26;
effect_button_gap = 12;

// === РАСПОЛОЖЕНИЕ ПОЛЗУНКОВ ===

slider_x = 40;
slider_w = 320;
slider_h = 8;
slider_handle_size = 10;
slider_dragging = -1;

// === ЗАГОЛОВКИ СЕКЦИЙ ===

slider_sections = [
    { name: "KICK",	  y: 180 },
    { name: "BOUNCE", y: 440 },
    { name: "PERLIN", y: 700 }
];

// === ПАРАМЕТРЫ ПОЛЗУНКОВ ===

sliders = [
    { effect: "kick", field: "strength", name: "STRENGTH", min: 0, max: 24, y: 210 },
    { effect: "kick", field: "rotation", name: "ROTATION", min: 0, max: 24, y: 260 },
    { effect: "kick", field: "attack", name: "ATTACK", min: 0, max: 24, y: 310 },
    { effect: "kick", field: "release", name: "RELEASE", min: 0, max: 24, y: 360 },

    { effect: "bounce", field: "strength", name: "STRENGTH", min: 0, max: 24, y: 470 },
    { effect: "bounce", field: "rotation", name: "ROTATION", min: 0, max: 24, y: 520 },
    { effect: "bounce", field: "frequency", name: "FREQUENCY", min: 0, max: 24, y: 570 },
    { effect: "bounce", field: "damping", name: "DAMPING", min: 0, max: 24, y: 620 },

    { effect: "perlin", field: "strength", name: "STRENGTH", min: 0, max: 24, y: 740 }
];

// === QUILL: СОЗДАНИЕ БОКСОВ ===
for (var i = 0; i < array_length(sliders); i++)
{
    var _slider = sliders[i];

    _slider.textbox = QuillSingle("", "0.00")
        .SetInputMode(QUILL_TEXTMODE_FLOAT)
        .SetSelectAllOnFocus(true);

    _slider.draw_x = 0;
    _slider.draw_y = 0;
    _slider.max_current = _slider.max;

    // Ввод в реальном времени (без клампа)
    _slider.textbox.OnChange(method(self, function(_tb, _value) {
        if (is_syncing_textboxes) return;
        if (_value == "" || _value == "." || _value == "-") return;
        var _num = real(_value);

        var _s = undefined;
        for (var k = 0; k < array_length(sliders); k++) {
            if (sliders[k].textbox == _tb) { _s = sliders[k]; break; }
        }
        if (_s == undefined) return;

        var _preset = scrCameraShakeGetSelectedPreset();
        var _data = scrCameraShakeMenuGetEffectData(_preset, _s.effect);
        
        var _old_val = variable_struct_get(_data, _s.field);
        if (abs(_old_val - _num) > 0.0001) {
            variable_struct_set(_data, _s.field, _num);
        }
    }));

    // Enter → поднятие max_current, кламп, переформат
    _slider.textbox.OnSubmit(method(self, function(_tb, _value) {
        if (_value == "" || _value == "." || _value == "-") return;
        var _num = real(_value);

        var _s = undefined;
        for (var k = 0; k < array_length(sliders); k++) {
            if (sliders[k].textbox == _tb) { _s = sliders[k]; break; }
        }
        if (_s == undefined) return;

        if (_num > _s.max) {
            _s.max_current = _num;
        } else {
            _s.max_current = _s.max;
            _num = clamp(_num, _s.min, _s.max);
        }

        var _preset = scrCameraShakeGetSelectedPreset();
        var _data = scrCameraShakeMenuGetEffectData(_preset, _s.effect);
        
        var _old_val = variable_struct_get(_data, _s.field);
        if (abs(_old_val - _num) > 0.0001) {
            variable_struct_set(_data, _s.field, _num);
        }

        _tb.SetValue(string_format(_num, 0, 2));
        _tb.Blur();
    }));
    
    // Клик мимо поля применяем как Enter (но без Enter)
    _slider.textbox.OnBlur(method(self, function(_tb) {
        if (is_syncing_textboxes) return;
        var _value = _tb.GetValue();

        var _num = 0;
        if (_value != "" && _value != "." && _value != "-") {
            _num = real(_value);
        }

        var _s = undefined;
        for (var k = 0; k < array_length(sliders); k++) {
            if (sliders[k].textbox == _tb) { _s = sliders[k]; break; }
        }
        if (_s == undefined) return;

        if (_num > _s.max) {
            _s.max_current = _num;
        } else {
            _s.max_current = _s.max;
            _num = clamp(_num, _s.min, _s.max);
        }

        var _preset = scrCameraShakeGetSelectedPreset();
        var _data = scrCameraShakeMenuGetEffectData(_preset, _s.effect);
        
        var _old_val = variable_struct_get(_data, _s.field);
        if (abs(_old_val - _num) > 0.0001) {
            variable_struct_set(_data, _s.field, _num);
        }

        _tb.SetValue(string_format(_num, 0, 2));
    }));
}

// Инициализация max_current при открытии
var _cat_presets = variable_struct_get(global.camera_shake.presets, selected_category);
var _preset = variable_struct_get(_cat_presets, selected_preset);
for (var i = 0; i < array_length(sliders); i++)
{
    var _data = scrCameraShakeMenuGetEffectData(_preset, sliders[i].effect);
    var _v = variable_struct_get(_data, sliders[i].field);
    sliders[i].max_current = max(sliders[i].max, _v);
}

// === КООРДИНАТЫ КНОПОК СНИЗУ ===
save_button_x = 24;
save_button_y = 800;

cancel_button_x = 136;
cancel_button_y = 800;

default_button_x = 268;
default_button_y = 800;

action_button_y = 800;
action_button_w = 104;
action_button_h = 30;
action_button_gap = 8;

// === СТИЛЬ ИНТЕРФЕЙСА ===
gui_font = fntDebug;
gui_text_color = c_white;
gui_secondary_color = make_color_rgb(150, 150, 160);
