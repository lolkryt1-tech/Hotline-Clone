/// @function scrCameraShakeWeaponToString
/// @description Превращает константу WEAPONS в строковый id пресета.
function scrCameraShakeWeaponToString(_weapon)
{
    switch (_weapon)
    {
		case WEAPONS.UNARMED:      return "unarmed";
        case WEAPONS.KNIFE:        return "knife";
        case WEAPONS.BAT:          return "bat";
        case WEAPONS.PIPE:         return "pipe";
        case WEAPONS.SLEDGEHAMMER: return "sledgehammer";
        case WEAPONS.PISTOL:       return "pistol";
        case WEAPONS.SHOTGUN:      return "shotgun";
        case WEAPONS.M16:          return "m16";
        case WEAPONS.SNIPER:       return "sniper";
    }
    return "";
}