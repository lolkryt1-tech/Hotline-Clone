// Создаем глобальные системы для всех эффектов
global.sys_smoke = part_system_create(psSmoke);
global.sys_sparks = part_system_create(psSparks);

// Достаем типы частиц из ассетов
var _smoke_info = particle_get_info(psSmoke);
global.type_smoke = _smoke_info.emitters[0].parttype.ind;
// Удаляем дефолтный эмиттер, чтобы он не спавнил частицы в 0,0
part_emitter_destroy(global.sys_smoke, _smoke_info.emitters[0].ind);

var _sparks_info = particle_get_info(psSparks);
global.type_sparks = _sparks_info.emitters[0].parttype.ind;
part_emitter_destroy(global.sys_sparks, _sparks_info.emitters[0].ind);

// Настраиваем альфу (если не настроена в редакторе)
part_type_alpha3(global.type_smoke, 0.8, 0.4, 0.0);

// Счетчик для удаления систем (если понадобится)