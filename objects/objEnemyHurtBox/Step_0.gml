// Проверка безопасности
if (owner == noone || !instance_exists(owner)) 
{
    instance_destroy();
    exit;
}

x = owner.x;
y = owner.y;
direction = owner.direction;