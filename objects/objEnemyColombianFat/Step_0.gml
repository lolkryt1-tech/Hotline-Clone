desired_angle = direction;


if (fat_is_bleeding) fat_blood_current--;

if (fat_blood_current <= 0 && state != STATES.FATDIE) 
{ 
    state = STATES.FATDIE; 
    sprite_index = sprColombianFatDie; 
    image_index = 1;
    
    // Сразу отключаем навигацию GameMaker, если она использовалась
    path_end();
    current_speed = 0;
    speed = 0;
    
    exit; 
} 


switch (state)
{
	case STATES.IDLE:   scrEnemyIdle();   break;
	case STATES.STEP: scrEnemyStep() break;
	case STATES.CHASE:  scrEnemyChase();  break;
	case STATES.ATTACKMELEE: scrEnemyAttackMelee() break;
	case STATES.ATTACKRANGE: scrEnemyAttackRange() break;
	case STATES.SEARCH: scrEnemySearch(); break;
	case STATES.AFTERMATH: scrEnemyAftermath(); break;
	case STATES.UNARMEDSEARCH: scrEnemyUnarmedSearch() break;
	case STATES.INVESTIGATE: scrEnemyInvestigate() break;
	case STATES.FATDIE: scrEnemyFatDie() break;
}

scrEnemyMovement();
scrProcessShellSpawn();