//if (sprite_index == my_sprites.sprites.attack)		{ sprite_index = my_sprites.sprites.walk;}

if (sprite_index == sprColombianAttackPipe)		{ sprite_index = sprColombianWalkPipe;}
if (sprite_index == sprColombianAttackBat)		{ sprite_index = sprColombianWalkBat;}
if (sprite_index == sprColombianAttackKnife)	{ sprite_index = sprColombianWalkKnife;}

if (sprite_index == sprColombianAttack9mm)		{ sprite_index = sprColombianWalk9mm; }
if (sprite_index == sprColombianAttackShotgun)	{ sprite_index = sprColombianWalkShotgun; if(state != STATES.ATTACKRANGE) { reload = 20; } }
if (sprite_index == sprColombianAttackM16)		{ sprite_index = sprColombianWalkM16;}