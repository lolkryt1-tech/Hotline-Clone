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

// Подсказка метания ножа
if (charge_knife_hint_alpha > 0)
{
    draw_set_alpha(charge_knife_hint_alpha);
    draw_text_transformed(_center_x, _gui_h * 0.95, "HOLD  [MMB]  TO CHARGE KNIFE", 0.75, 0.75, 0);
}

// Подсказка добивания ножом
if (knife_kill_hint_alpha > 0)
{
    draw_set_alpha(knife_kill_hint_alpha);
    draw_text_transformed(_center_x, _gui_h * 0.90, "[SPACE] - QUICK KILL,  [LMB] - NORMAL KILL", 0.75, 0.75, 0);
}

// 3. ВОССТАНАВЛИВАЕМ ВСЁ КАК БЫЛО
draw_set_font(_old_font);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);
draw_set_alpha(_old_alpha);
