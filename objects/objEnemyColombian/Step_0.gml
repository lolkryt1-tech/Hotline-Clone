//my_target = scrTargetUpdate(my_target);
desired_angle = direction;

// ВЫКЛЮЧАЕМ ВСЁ НАХУЙ ЕСЛИ ЦЕЛЬ МЕРТВА И ПЕРЕХОДИМ В ОБЫЧНОЕ ХОЖДЕНИЕ
/*
if (my_target != noone && my_target.object_index == objPlayerDead && state != STATES.ATTACKMELEE && state != STATES.AFTERMATH) 
{ 
	speed = 0;
	path_end(); 
	state = STATES.STEP; 
	my_target = noone; 
	mask_index = sprPlayerMask;
	exit
}
*/


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
}

scrEnemyMovement();
scrProcessShellSpawn();