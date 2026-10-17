enum EXECUTION_TYPE
{
    UNARMED,
    BLUNT,
	SLASH,
	STAB,
    CUT,
}

depth = -3000;

faction = FACTION.PLAYER;
character = CHARACTER.COP;

max_energy           = choose(1, 2); 
energy               = max_energy;

/*
execution_type = 0;

my_angle = 0;
enemy_sprite = 0;
character_sprite = 0;

weapon = 0;

enemy_play_animation = 0;

hit_index = 0;
hurt_index = 0;
finish_index = 8;

is_execution = true;