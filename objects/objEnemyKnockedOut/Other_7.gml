// 1. Быстро определяем нужный объект на основе фракции
var _object_to_spawn = objEnemyColombian; // По умолчанию колумбиец

switch (class)
{
    case CLASS.REGULAR:
        _object_to_spawn = objEnemyColombian;
        break;
}

// 2. Спавним живого врага
var _revived = instance_create_layer(x, y, "Instances", _object_to_spawn);

// 3. Передаем ему все параметры обратно
_revived.faction        = faction;
_revived.class          = class;
_revived.weapon         = WEAPONS.UNARMED; // Встает безоружным
_revived.reaction_time  = 0;
_revived.my_angle       = direction - 180;
_revived.direction      = direction - 180;
_revived.state          = STATES.UNARMEDSEARCH;

// 4. ГИБКАЯ НАСТРОЙКА: Спрашиваем у общей функции спрайт ходьбы под этот класс
_revived.my_sprites     = scrEnemyGetSprite(_revived.class, _revived.weapon);
_revived.sprite_index   = _revived.my_sprites.sprites.walk; 

// 5. Уничтожаем лежачую куклу, так как живой враг уже на карте
instance_destroy();