event_inherited();

// === ПАРАМЕТРЫ ПЕРСОНАЖА И ОРУЖИЯ ===
faction              = FACTION.COLOMBIAN;
class                = CLASS.FATVEST;
skin				 = SKIN.COLOMBIANFATVEST;
weapon               = WEAPONS.FISTS;
isRange_weapon       = false;

if (sprite_index == sprColombianFatWalkUnarmed)	{ isRange_weapon = false; weapon = WEAPONS.FISTS; }
if (sprite_index == sprColombianFatVestWalkHuntingRifle)		{ isRange_weapon = true;  weapon = WEAPONS.SNIPER;  ammo = 10; }
//if (sprite_index == sprColombianFatWalkShotgun)    { isRange_weapon = true;  weapon = WEAPONS.SHOTGUN; ammo = 6; }
//if (sprite_index == sprColombianWalkM16)		{ isRange_weapon = true;  weapon = WEAPONS.M16;		ammo = 24; }

my_sprites           = scrEnemyGetSprite(skin, weapon);

// === СОСТОЯНИЯ И ИИ ===
state                = STATES.STEP;
state_previous       = state;
move_type            = MOVETYPE.RANDOM;
my_target            = noone;
reaction_time        = 15;

fat_dead = false;

sprFatDead = sprColombianFatDead;
sprFatKnocked = sprColombianFatVestGetUp;