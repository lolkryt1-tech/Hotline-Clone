// 1. ЗАПОМИНАЕМ НАСТРОЙКИ, КОТОРЫЕ БЫЛИ ДО НАС
var _old_font   = draw_get_font();
var _old_halign = draw_get_halign();
var _old_valign = draw_get_valign();
var _old_alpha  = draw_get_alpha();

// 2. НАСТРАИВАЕМ РИСОВАНИЕ ПОД НАШИ ТЕКСТЫ
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _center_x = _gui_w * 0.5;

draw_set_font(fntMainMenu);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


// ========================================
// ПОДСКАЗКА МЕТАНИЯ НОЖА (ЗАМАХ)
// ========================================
if (charge_knife_hint_alpha > 0)
{
    // Берем код клавиши из биндов (действие "weapon_ability")
    var _charge_key = global.settings.binds[$ "weapon_ability"];
    var _key_name = "?";
    
    // Если бинд назначен (не -1), переводим код в текст
    if (_charge_key != -1)
        _key_name = scrKeyCodeToName(_charge_key);

    draw_set_alpha(charge_knife_hint_alpha);
    
    // Собираем строку динамически
    var _hint_text = "HOLD  [" + _key_name + "]  TO CHARGE KNIFE";
    
    draw_text_transformed(_center_x, _gui_h * 0.95, _hint_text, 0.75, 0.75, 0);
}


// ========================================
// ПОДСКАЗКА ДОБИВАНИЯ
// ========================================
if (knife_kill_hint_alpha > 0)
{
    // Берем коды для "execution" (SPACE) и "attack" (LMB)
    var _exec_key = global.settings.binds[$ "execution"];
    var _attack_key = global.settings.binds[$ "attack"];
    
    var _exec_name = "?";
    var _attack_name = "?";
    
    if (_exec_key != -1) _exec_name = scrKeyCodeToName(_exec_key);
        
    if (_attack_key != -1) _attack_name = scrKeyCodeToName(_attack_key);

    draw_set_alpha(knife_kill_hint_alpha);
    
    // Собираем строку динамически
    var _hint_text = "[" + _exec_name + "] - QUICK KILL,  [" + _attack_name + "] - NORMAL KILL";
    
    draw_text_transformed(_center_x, _gui_h * 0.90, _hint_text, 0.75, 0.75, 0);
}


// 3. ВОССТАНАВЛИВАЕМ ВСЁ КАК БЫЛО
draw_set_font(_old_font);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);
draw_set_alpha(_old_alpha);