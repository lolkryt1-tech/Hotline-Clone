/*
if (is_triggered) exit;
if (!instance_exists(objPlayer)) exit;

if (place_meeting(x, y, objPlayer))
{
    scrTriggerSpawnEnemy(id);
    is_triggered = true;
}