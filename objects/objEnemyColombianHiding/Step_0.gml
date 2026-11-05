switch (state)
{
    case STATES.HIDERDUCK:   scrEnemyHiderDuck();   break;
    case STATES.HIDERSHOOT:  scrEnemyHiderShoot();  break;
}

direction = my_angle;

scrProcessShellSpawn();