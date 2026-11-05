// === ОПРЕДЕЛЯЕМ ОБЪЁМНОЕ СМЕЩЕНИЕ ТЕНИ СТЕНЫ ===
var _shadow_x_offset = 2;  // Тень падает вправо
var _shadow_y_offset = 2;  // Тень падает вниз

if (global.hard == true) 
{
    _shadow_x_offset = -2; // Инвертируем влево
    _shadow_y_offset = -2; // Инвертируем вверх
}
// ===============================================

// 1. Рисуем собственную тень объекта с объемным смещением
draw_sprite_ext(sprite_index, image_index, x + _shadow_x_offset, y + _shadow_y_offset, image_xscale, image_yscale, image_angle, c_black, 0.5);

// 2. Рисуем сам объект поверх тени
draw_self();
