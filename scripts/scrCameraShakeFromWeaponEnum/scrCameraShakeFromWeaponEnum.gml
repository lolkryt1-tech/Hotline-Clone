function scrCameraShakeFromWeaponEnum(_weapon_enum)
{
    var _id = SHAKE_WEAPON.PISTOL;
    switch (_weapon_enum)
    {
        case WEAPONS.PISTOL:  _id = SHAKE_WEAPON.PISTOL;  break;
        case WEAPONS.SHOTGUN: _id = SHAKE_WEAPON.SHOTGUN; break;
        case WEAPONS.M16:     _id = SHAKE_WEAPON.M16;     break;
        case WEAPONS.SNIPER:  _id = SHAKE_WEAPON.SNIPER;  break;
        default: return; // для оружия без тряски
    }
    scrCameraShakePlay(SHAKE_CAT.WEAPONS, _id);
}