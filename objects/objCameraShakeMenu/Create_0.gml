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

// === ПРЕСЕТЫ ОРУЖИЯ ===

weapon_presets = [
    { id: "pistol", name: "Pistol" },
    { id: "shotgun", name: "Shotgun" },
    { id: "m16", name: "M16" },
    { id: "sniper", name: "Sniper" }
];

// Выбираем пресет в зависимости от оружия игрока
selected_preset = "pistol";
if (instance_exists(objPlayer))
{
    var _weapon = objPlayer.current_weapon;

    switch (_weapon)
    {
        case WEAPONS.PISTOL:  selected_preset = "pistol";  break;
        case WEAPONS.SHOTGUN: selected_preset = "shotgun"; break;
        case WEAPONS.M16:     selected_preset = "m16";     break;
        case WEAPONS.SNIPER:  selected_preset = "sniper";  break;
    }
}

// === ВЫПАДАЮЩИЙ СПИСОК ===

preset_dropdown_open = false;
preset_scroll = 0;

preset_dropdown_x = 12;
preset_dropdown_y = 65;
preset_dropdown_w = 150;
preset_item_h = 24;
preset_visible_count = 6;

// === ПЕРЕКЛЮЧАТЕЛИ ЭФФЕКТОВ ===

effect_button_x = 16;
effect_button_y = 115;
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


// === РЕДАКТИРОВАНИЕ ЗНАЧЕНИЙ ===

editing_slider = -1;
editing_value = "";
editing_original_value = "";

editing_cursor = 0;
editing_selection_start = 0;
editing_selection_end = 0;

editing_mouse_select = false;
editing_last_valid_value = 0;