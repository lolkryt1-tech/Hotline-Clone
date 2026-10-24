/// @param {Real} _weapon_enum Оружие для проверки
/// @return {Bool} Возвращает true, если оружие тяжелое
function scrWeaponIsHeavy(_weapon_enum)
{
    switch (_weapon_enum)
    {
        case WEAPONS.SLEDGEHAMMER:
        // case WEAPONS.MACHETE:    // Место под будущее тяжелое оружие 1
            return true;
            
        default:
            return false;
    }
}
