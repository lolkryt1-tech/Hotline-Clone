/// @param {Real} _skin    Скин жертвы (SKIN.*)
/// @param {Real} _weapon  Оружие казни (WEAPONS.*)
/// @param {Real} _class   Класс жертвы (CLASS.*)
function scrGetExecutionSprite(_skin, _weapon)
{
    switch (_skin)
    {
        case SKIN.COLOMBIANREGULAR:
            return sprColombianDieBlunt;

        case SKIN.COLOMBIANVEST:
            return sprColombianVestDieBlunt;

        case SKIN.COLOMBIANFAT:
            if (_weapon == WEAPONS.SLEDGEHAMMER)
            {
                return sprCopKillFatSledgeHammer;
            }
            return sprColombianDieBlunt; // фолбэк, если не кувалда

        case SKIN.COLOMBIANFATVEST:
            if (_weapon == WEAPONS.SLEDGEHAMMER)
            {
                return sprCopKillFatVestSledgeHammer;
            }
            return sprColombianVestDieBlunt; // фолбэк

        default:
            return sprColombianDieBlunt; // подстраховка
    }
}