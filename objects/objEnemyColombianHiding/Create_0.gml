event_inherited();

// === ПАРАМЕТРЫ ПЕРСОНАЖА И ОРУЖИЯ ===
faction              = FACTION.COLOMBIAN;
class                = CLASS.REGULAR;
skin				 = SKIN.COLOMBIANREGULAR;
weapon               = WEAPONS.PIPE;

//if (sprite_index == sprColombianHiding9mm)	{ weapon = WEAPONS.PISTOL; ammo = 15; }
//if (sprite_index == sprColombianHidingM16)	{ weapon = WEAPONS.M16; ammo = 24; }
if (sprite_index == sprColombianHidingShotgun)	{weapon = WEAPONS.SHOTGUN;  ammo = 6; }

my_sprites           = scrEnemyGetSprite(skin, weapon);

// === СОСТОЯНИЯ И ИИ ===
state					= STATES.HIDERDUCK;
state_previous			= state;
move_type				= MOVETYPE.RANDOM;
my_target				= noone;
reaction_time			= 15;

sprDeadCut				= sprColombianDeadCut; 
sprDeadBlunt			= sprColombianDeadBlunt; 
sprDeadeadSlash			= sprColombianDieBlunt; 
sprDeadMachineGun		= sprColombianDeadMachinegun;
sprDeadShotgun			= sprColombianDeadShotgun;
        
sprKnocked				= sprColombianGetUp; 
sprKnockedLean			= sprColombianGetUpLean;
sprDeadLeanMelee        = sprColombianDeadLeanMelee;
sprDeadLeanShotgun		= sprColombianDeadLeanShotgun;
sprDeadLeanMachinegun	= sprColombianDeadLeanMachinegun;