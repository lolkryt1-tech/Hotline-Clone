my_angle = 0;

image_speed = 0;
friction = 0.4;
depth = -5000;

// Эти параметры ОБЯЗАТЕЛЬНО передаются извне в момент удара о стену
skin	= 0;
class   = 0;
faction = 0;

fric = 0.15;
is_GettingUp = false;

sprDeadLeanMelee = noone;
sprDeadLeanShotgun = noone;
sprDeadLeanMachinegun = noone;

// Таймер до подъема врага от стены (120 кадров = 2 секунды)
call_later(120, time_source_units_frames, function() 
{
	is_GettingUp = true;
});
