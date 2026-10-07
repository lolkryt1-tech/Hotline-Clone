desired_angle = direction;


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
	case STATES.DODGE: scrEnemyDodge() break;
}

scrEnemyMovement();
scrProcessShellSpawn();