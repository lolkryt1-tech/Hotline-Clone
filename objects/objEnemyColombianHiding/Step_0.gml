// Выполнение стейт-машины ИИ
switch (state)
{
    case STATES.HIDERDUCK:   scrEnemyHiderDuck();   break;
    case STATES.HIDERSHOOT:  scrEnemyHiderShoot();  break;
}

// Встроенный direction используем ТОЛЬКО если врагу нужно двигаться физически.
// Хитбокс (mask_index) при этом остается ровным и не вращается.
direction = my_angle;

// Базовые скрипты движения и спавна гильз
scrProcessShellSpawn();