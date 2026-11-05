#region СБРАСЫВАЕМ ЭКРАН В ПЕРВОМ КАДРЕ
var _win_w = window_get_width();
var _win_h = window_get_height();
if (window_get_fullscreen()) {
    _win_w = display_get_width();
    _win_h = display_get_height();
}
surface_resize(application_surface, _win_w, _win_h);
display_set_gui_size(_win_w, _win_h);
#endregion


// 1. Создаем базу на слое "Instances"
if (!instance_exists(objGameManager))		{ instance_create_layer(x, y, "Instances", objGameManager); }
if (!instance_exists(objParticleManager))	{ instance_create_layer(0, 0, "Instances", objParticleManager); }
if (!instance_exists(objPlayer))			{ instance_create_layer(x, y, "Instances", objPlayer); }
if (!instance_exists(objEffector))			{ instance_create_layer(x, y, "Instances", objEffector); }
if (!instance_exists(objLevelStatistic))	{ instance_create_layer(x, y, "Instances", objLevelStatistic);}
if (!instance_exists(objDepthManager))		{ instance_create_layer(0, 0, "Instances", objDepthManager); }
if (!instance_exists(objPathManager))		{ instance_create_layer(0, 0, "Instances", objPathManager); }
if (!instance_exists(objSaveManager))		{ instance_create_layer(0, 0, "Instances", objSaveManager); }
if (!instance_exists(objPauseMenu))			{ instance_create_layer(0, 0, "Instances", objPauseMenu); }
if (!instance_exists(objPauseManager))		{ instance_create_layer(0, 0, "Instances", objPauseManager); }
if (!instance_exists(objSettingsManager))	{ instance_create_layer(x, y, "Instances", objSettingsManager); }
if (!instance_exists(objMusicManager))		{ instance_create_layer(x, y, "Instances", objMusicManager); }

// 1.1. На всякий обнуляем предыдущие сейвы
scrClearFloorData();

// 2. ИСПРАВЛЕНО: Автоматическое создание слоя для крови, если его нет в текущей комнате
var _blood_layer = layer_get_id("Blood_layer");

// Если вернулся -1 (слоя нет в boot_up), создаем его кодом на лету!
if (_blood_layer == -1) 
{
    _blood_layer = layer_create(8000, "Blood_layer"); // 100 — это глубина (depth) слоя
}

// Теперь функция гарантированно найдет слой и не вызовет ошибку
if (!instance_exists(objBloodSurfaceManager)) 
{ 
    instance_create_layer(0, 0, _blood_layer, objBloodSurfaceManager); 
}

// 3. Уходим в игровую комнату
room_goto(Room1);