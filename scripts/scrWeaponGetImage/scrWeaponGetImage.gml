function scrWeaponGetImage(_weapon)
{
    if (_weapon == WEAPONS.BAT)		 return 0;
    if (_weapon == WEAPONS.PIPE)	 return 1;
    if (_weapon == WEAPONS.PISTOL)	 return 2;
	if (_weapon == WEAPONS.SHOTGUN)	 return 3;
	if (_weapon == WEAPONS.M16)		 return 4;
    
    return 0;
}
