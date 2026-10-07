event_inherited();

// === ПАРАМЕТРЫ ПЕРСОНАЖА И ОРУЖИЯ ===
faction              = FACTION.COLOMBIAN;
class                = CLASS.REGULAR;
skin				 = SKIN.COLOMBIANREGULAR;
weapon               = WEAPONS.PIPE;
isRange_weapon       = false;

if (sprite_index == sprColombianWalkUnarmed)	{ isRange_weapon = false; weapon = WEAPONS.UNARMED; }
if (sprite_index == sprColombianWalkBat)		{ isRange_weapon = false; weapon = WEAPONS.BAT; }
if (sprite_index == sprColombianWalkPipe)		{ isRange_weapon = false; weapon = WEAPONS.PIPE; }
if (sprite_index == sprColombianWalk9mm)		{ isRange_weapon = true;  weapon = WEAPONS.PISTOL;  ammo = 15; }
if (sprite_index == sprColombianWalkShotgun)    { isRange_weapon = true;  weapon = WEAPONS.SHOTGUN; ammo = 6; }
if (sprite_index == sprColombianWalkM16)		{ isRange_weapon = true;  weapon = WEAPONS.M16;		ammo = 24; }

my_sprites           = scrEnemyGetSprite(skin, weapon);

// === СОСТОЯНИЯ И ИИ ===
state                = STATES.STEP;
state_previous       = state;
move_type            = MOVETYPE.RANDOM;
my_target            = noone;
reaction_time        = 15;
if (sprite_index = sprColombianWalkUnarmed) { state = STATES.UNARMEDSEARCH }

// === ДВИЖЕНИЕ И ФИЗИКА ===
//max_speed				= 2.75; // Единственная максимальная скорость для бега и поиска

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