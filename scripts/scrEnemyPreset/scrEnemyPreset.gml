/// @function scrEnemyGetPreset(_preset)
/// @description Возвращает конфигурацию врага по пресету.

function scrEnemyGetPreset(_preset)
{
	enum ENEMY_PRESET
	{
		COLOMBIANREGULAR,
		COLOMBIANFAT,
		COLOMBIANDODGER,
		COLOMBIANVEST
	}
	
	
    switch (_preset)
    {
        case ENEMY_PRESET.COLOMBIANREGULAR:
            return {
                spawn_object: objEnemyColombian,
                spawn_skin: SKIN.COLOMBIANREGULAR,
                spawn_class: CLASS.REGULAR,
                spawn_faction: FACTION.COLOMBIAN
            };

        case ENEMY_PRESET.COLOMBIANFAT:
            return {
                spawn_object: objEnemyColombianFat,
                spawn_skin: SKIN.COLOMBIANFAT,
                spawn_class: CLASS.FAT,
                spawn_faction: FACTION.COLOMBIAN
            };

        case ENEMY_PRESET.COLOMBIANDODGER:
            return {
                spawn_object: objEnemyColombianDodger,
                spawn_skin: SKIN.COLOMBIANDODGER,
                spawn_class: CLASS.DODGER,
                spawn_faction: FACTION.COLOMBIAN
            };
			
		case ENEMY_PRESET.COLOMBIANVEST:
            return {
                spawn_object: objEnemyColombianVest,
                spawn_skin: SKIN.COLOMBIANVEST,
                spawn_class: CLASS.VEST,
                spawn_faction: FACTION.COLOMBIAN
            };
    }

    show_debug_message(
        "scrEnemyGetPreset: неизвестный пресет " + string(_preset)
    );

    return {
        spawn_object: objEnemyColombian,
        spawn_skin: SKIN.COLOMBIANREGULAR,
        spawn_class: CLASS.REGULAR,
        spawn_faction: FACTION.COLOMBIAN,
    };
}