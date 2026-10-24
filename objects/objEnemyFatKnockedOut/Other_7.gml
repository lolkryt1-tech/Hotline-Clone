image_speed = 0;              
image_index = image_number - 1;

// 1. Быстро определяем нужный объект на основе фракции
var _object_to_spawn = objEnemyColombianFat; // По умолчанию колумбиец

switch (skin)
{
    case SKIN.COLOMBIANFAT:
        _object_to_spawn = objEnemyColombianFat;
        break;
	
	case SKIN.COLOMBIANFATVEST:
		_object_to_spawn = objEnemyColombianFatVest;
		break;
}

// 2. Спавним живого врага
var _revived = instance_create_layer(x, y, "Instances", _object_to_spawn);

// 3. Передаем ему все параметры обратно
_revived.faction        = faction;
_revived.skin		    = skin;
_revived.weapon         = WEAPONS.FISTS;
_revived.my_angle       = direction - 180;
_revived.direction      = direction - 180;
_revived.state          = STATES.STEP;

_revived.fat_is_bleeding = fat_is_bleeding;
_revived.fat_blood_current = fat_blood_current;


// 4. ГИБКАЯ НАСТРОЙКА: Спрашиваем у общей функции спрайт ходьбы под этот класс
_revived.my_sprites     = scrEnemyGetSprite(_revived.skin, _revived.weapon);
_revived.sprite_index   = _revived.my_sprites.sprites.walk; 

// 5. Уничтожаем лежачую куклу, так как живой враг уже на карте
instance_destroy();