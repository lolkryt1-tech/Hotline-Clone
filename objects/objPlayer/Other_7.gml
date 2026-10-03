// Холодное
if (sprite_index = sprCopAttackPunch)	{ image_yscale *= -1 sprite_index = sprCopWalkUnarmed; }
if (sprite_index = sprCopAttackPipe)	{ image_yscale *= -1 sprite_index = sprCopWalkPipe; }
if (sprite_index = sprCopAttackBat)		{ image_yscale *= -1 sprite_index = sprCopWalkBat; }



// Огнестрел
if (sprite_index == sprCopAttack9mm)	{ sprite_index = sprCopWalk9mm; }
if (sprite_index == sprCopAttackShotgun) { sprite_index = sprCopWalkShotgun; }
if (sprite_index == sprCopAttackM16)	{ sprite_index = sprCopWalkM16; }