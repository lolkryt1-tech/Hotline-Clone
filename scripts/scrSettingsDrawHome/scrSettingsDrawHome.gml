/// @function scrSettingsDrawHome(_menu, _gui_w)
/// @description Отрисовывает главную страницу настроек.

function scrSettingsDrawHome(_menu, _gui_w)
{
	var _offset_x = _menu.home_offset_x;					// Текст уезжает влево при переходе
	var _progress = _menu.transition_progress;
	var _selected_index = _menu.transition_selected_index;

	
    draw_set_color(c_white);
    draw_text(50 + _offset_x, 60, "SETTINGS");

    // === ПОЛЗУНКИ ГРОМКОСТИ ===

    var _slider_x = 280;
    var _slider_w = 160;
    var _slider_h = 8;

	for (var i = 0; i < 2; i++)
	{
	    var _y = 145 + i * 55;
	    var _selected = (i == _menu.selected_index);

	    var _value = (i == 0) ? global.settings.sound_volume : global.settings.music_volume;

	    var _text = _menu.home_items[i];
	    scrSettingsDrawItem(50 + _offset_x, _y, _text, _selected);
		
		scrSettingsDrawSlider(_slider_x + _offset_x, _y, _slider_w, _slider_h, _value, _selected);

		draw_set_halign(fa_right);
		draw_text(_gui_w - 50 + _menu.volume_percent_offset_x, _y, string(round(_value * 100)) + "%");
		draw_set_halign(fa_left);
	}

	// === КАТЕГОРИИ ===
	
	// Первые два занимают ползунки звука и музкыки
	for (var i = 2; i < array_length(_menu.home_items); i++)
	{
	    var _y = 270 + (i - 2) * 55;
	    var _selected = (i == _menu.selected_index);
	    var _text = _menu.home_items[i];

	    // Выбранная категория перемещается вверх
	    if (_menu.transition_active && i == _selected_index)
	    {
	        var _target_x = 50;
	        var _target_y = 60;

	        var _draw_x = lerp(50, _target_x, _progress);
	        var _draw_y = lerp(_y, _target_y, _progress);

	        scrSettingsDrawItem(_draw_x, _draw_y, _text, false);
	    }
	    else
		{
		    _selected = (i == _menu.selected_index);
		    scrSettingsDrawItem(50 + _offset_x,_y, _text, _selected);
		}
	}
}