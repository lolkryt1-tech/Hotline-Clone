/// @description Копирует все параметры одного пресета оружия,
/// включая активные значения, сохранённые значения и переключатели.
///
/// @param {Struct} _source Исходный пресет
/// @param {Struct} _target Пресет, в который копируются настройки


function scrCameraShakeCopyPreset(_source, _target)
{
    // === ПЕРЕКЛЮЧАТЕЛИ ===
    _target.kick_enabled			= _source.kick_enabled;
    _target.bounce_enabled			= _source.bounce_enabled;
    _target.perlin_enabled			= _source.perlin_enabled;

    // === KICK ===
    _target.kick.strength			= _source.kick.strength;
    _target.kick.rotation			= _source.kick.rotation;
    _target.kick.attack				= _source.kick.attack;
    _target.kick.release			= _source.kick.release;

    _target.kick_saved.strength		= _source.kick_saved.strength;
    _target.kick_saved.rotation		= _source.kick_saved.rotation;
    _target.kick_saved.attack		= _source.kick_saved.attack;
    _target.kick_saved.release		= _source.kick_saved.release;
	
	
    // === BOUNCE ===
	_target.bounce.strength			= _source.bounce.strength;
	_target.bounce.rotation			= _source.bounce.rotation;
	_target.bounce.frequency		= _source.bounce.frequency;
	_target.bounce.damping			= _source.bounce.damping;

	_target.bounce_saved.strength	= _source.bounce_saved.strength;
	_target.bounce_saved.rotation	= _source.bounce_saved.rotation;
	_target.bounce_saved.frequency	= _source.bounce_saved.frequency;
	_target.bounce_saved.damping	= _source.bounce_saved.damping;
	
	
    // === PERLIN ===
    _target.perlin.strength			= _source.perlin.strength;
    _target.perlin_saved.strength	= _source.perlin_saved.strength;
}