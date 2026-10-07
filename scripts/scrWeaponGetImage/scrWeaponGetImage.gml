function scrWeaponGetImage(_weapon)
{
	if (_weapon == WEAPONS.KNIFE)	 return 0;
    if (_weapon == WEAPONS.BAT)		 return 1;
    if (_weapon == WEAPONS.PIPE)	 return 2;
    if (_weapon == WEAPONS.PISTOL)	 return 3;
	if (_weapon == WEAPONS.SHOTGUN)	 return 4;
	if (_weapon == WEAPONS.M16)		 return 5;
    
    return 0;
}
