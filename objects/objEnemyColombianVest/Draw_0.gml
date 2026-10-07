draw_set_font(fntDebug);
draw_sprite_ext(sprColombianLegs, legs_image_index, x, y, image_xscale, image_yscale, legs_direction, image_blend, image_alpha);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, my_angle, image_blend, image_alpha);



// 2. ВСЯ ЛОГИКА ОБНОВЛЕНИЯ И ОТРИСОВКИ ОЧКОВ/НАУШНИКОВ ВНУТРИ DRAW
if (can_hear == false) // ИСПРАВЛЕНО: Наушники/очки рисуются, если враг НЕ слышит
{
	// Запускаем расчет координат и угла headgear_angle
	scrUpdateHeadSet();
	
	// ИСПРАВЛЕНО: Заменили my_angle на headgear_angle, чтобы картинка начала крутиться на поиске!
	draw_sprite_ext(sprHeadGear, 0, headgear_x, headgear_y, image_xscale, image_yscale, headgear_angle, image_blend, image_alpha);
}

if (global.debug == 0) return;
draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,true)

var _w_name = "UNKNOWN";
    
// Переводим Enum пушки в понятный текст
if (weapon == WEAPONS.UNARMED) _w_name = "UNARMED";
if (weapon == WEAPONS.KNIFE) _w_name = "KNIFE";
if (weapon == WEAPONS.BAT)	   _w_name = "BAT";
if (weapon == WEAPONS.PIPE)    _w_name = "PIPE";
if (weapon == WEAPONS.PISTOL)  _w_name = "PISTOL";
if (weapon == WEAPONS.SHOTGUN)  _w_name = "SHOTGUN";
if (weapon == WEAPONS.M16)     _w_name = "M16";
    
// Настраиваем шрифт и цвет текста
draw_set_font(-1); // Дефолтный шрифт
draw_set_halign(fa_center);
    
// Рисуем черную подложку (тень), чтобы текст читался на любом фоне
draw_set_color(c_black);
draw_text(x + 1, y - 24 + 1, "Wp: " + _w_name);
    
// Рисуем сам текст (например, ярко-зеленый или желтый)
draw_set_color(c_lime);
draw_text(x, y - 24, "Wp: " + _w_name);
    
// Сбрасываем выравнивание цвета, чтобы не сломать остальную графику
draw_set_color(c_white);
draw_set_halign(fa_left);



// Состояние
if (global.debug = 1)
{
	/*
	draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,true)
	draw_text(x, y, state_names[state]);
	draw_text(x, y + 15, "attack_range: " + string(my_sprites.attack_range));
	draw_text(x, y + 30, current_speed);
	draw_text(x, y + 45, "Target_search_count: " + string(target_search_count));
	draw_text(x, y + 60, "Path_delay_timer: " + string(path_delay_timer));
	draw_text(x, y + 75, "Walk_on_trail: " + string(walk_on_trail));
	draw_text(x, y + 90, "impossible to path : " + string(impossible_to_path));
	*/
	//if my_target != noone && instance_exists(my_target) draw_text(x + 15, y, "my_target: " + string(my_target.object_index));
	draw_text(x + 15, y - 15, skin_names[skin]);
	draw_text(x + 15, y, state_names[state]);
	draw_text(x + 15, y + 15, "Is range weapon "  + string(isRange_weapon));
	
	draw_text(x + 15, y + 30, x);
	draw_text(x + 15, y + 45, y);
}


if (path_index == my_path) {
    // Настраиваем цвет и прозрачность линии пути
    draw_set_color(c_white); // Можно выбрать c_lime, c_yellow и т.д.
    
    // Отрисовываем путь. Аргументы: (индекс_пути, x_старта, y_старта, абсолютный_ли_путь)
    // Так как mp_grid_path строит абсолютные координаты комнаты, ставим true
    draw_path(my_path, x, y, true);
    
    // Сбрасываем настройки рисования обратно в дефолт, чтобы не сломать другие объекты
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

