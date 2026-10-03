if (!instance_exists(enemy_id)) { instance_destroy(); }
if (enemy_id.state != states.search) { instance_destroy(); }