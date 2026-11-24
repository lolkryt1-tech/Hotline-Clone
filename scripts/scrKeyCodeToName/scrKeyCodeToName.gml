/// @function scrKeyCodeToName(_key)
/// @description Превращает код клавиши в строку для отображения.

function scrKeyCodeToName(_key)
{
    // Мышь
    if (_key == mb_left)   return "LMB";
    if (_key == mb_right)  return "RMB";
    if (_key == mb_middle) return "MMB";
    if (_key == mb_side1)  return "MOUSE4";
    if (_key == mb_side2)  return "MOUSE5";

    // Буквы и цифры
    if (_key >= ord("A") && _key <= ord("Z")) return chr(_key);
    if (_key >= ord("0") && _key <= ord("9")) return chr(_key);

    // Специальные клавиши
    switch (_key)
    {
        // Основные
        case 8:            return "BACKSPACE";
        case 9:            return "TAB";
        case vk_enter:     return "ENTER";
        case vk_shift:     return "SHIFT";
        case vk_control:   return "CTRL";
        case vk_alt:       return "ALT";
        case vk_escape:    return "ESC";
        case vk_space:     return "SPACE";
        case 20:           return "CAPSLOCK";
        case 19:           return "PAUSE";
        case 144:          return "NUMLOCK";
        case 145:          return "SCROLL LOCK";
        case 44:           return "PRINT SCREEN";

        // Левые и правые модификаторы
        case 160:          return "L SHIFT";
        case 161:          return "R SHIFT";
        case 162:          return "L CTRL";
        case 163:          return "R CTRL";
        case 164:          return "L ALT";
        case 165:          return "R ALT";

        // Навигация
        case vk_up:        return "UP";
        case vk_down:      return "DOWN";
        case vk_left:      return "LEFT";
        case vk_right:     return "RIGHT";
        case 33:           return "PAGE UP";
        case 34:           return "PAGE DOWN";
        case 35:           return "END";
        case 36:           return "HOME";
        case 45:           return "INSERT";
        case 46:           return "DELETE";

        // Функциональные клавиши
        case vk_f1:        return "F1";
        case vk_f2:        return "F2";
        case vk_f3:        return "F3";
        case vk_f4:        return "F4";
        case vk_f5:        return "F5";
        case vk_f6:        return "F6";
        case vk_f7:        return "F7";
        case vk_f8:        return "F8";
        case vk_f9:        return "F9";
        case vk_f10:       return "F10";
        case vk_f11:       return "F11";
        case vk_f12:       return "F12";

        // NumPad
        case 96:           return "NUM 0";
        case 97:           return "NUM 1";
        case 98:           return "NUM 2";
        case 99:           return "NUM 3";
        case 100:          return "NUM 4";
        case 101:          return "NUM 5";
        case 102:          return "NUM 6";
        case 103:          return "NUM 7";
        case 104:          return "NUM 8";
        case 105:          return "NUM 9";
        case 106:          return "NUM *";
        case 107:          return "NUM +";
        case 109:          return "NUM -";
        case 110:          return "NUM .";
        case 111:          return "NUM /";

        // Дополнительные клавиши
        case 91:           return "L WIN";
        case 92:           return "R WIN";
        case 93:           return "MENU";

        // Знаки препинания
        case 186:          return ";";
        case 187:          return "=";
        case 188:          return ",";
        case 189:          return "-";
        case 190:          return ".";
        case 191:          return "/";
        case 192:          return "`";
        case 219:          return "[";
        case 220:          return "\\";
        case 221:          return "]";
        case 222:          return "'";
    }

    return "?";
}
