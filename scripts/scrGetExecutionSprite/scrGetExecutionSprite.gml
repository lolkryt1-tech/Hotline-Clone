/// @param {Real} _skin_enum Скин жертвы (из энума SKIN)
function scrGetExecutionSprite(_skin)
{
    switch (_skin)
    {
        case SKIN.COLOMBIANREGULAR: return sprColombianDieBlunt;
        case SKIN.COLOMBIANVEST:    return sprColombianVestDieBlunt;
        
        // Сюда в одну строчку добавляются новые скины по мере разработки:
        // case SKIN.COLOMBIANFAT:   return sprColombianFatDieBlunt;
        // case SKIN.GANGREGULAR:    return sprGangDieBlunt;
        
        default:                    return sprColombianDieBlunt; // Подстраховка
    }
}
