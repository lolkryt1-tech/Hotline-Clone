for (i = 0; i < array_length(pause_queue); i++){
	with(pause_queue[i]){
		array_push(other.pause_elements, id);
	}
}
pause_queue = [];

for (i = 0; i < array_length(unpause_queue); i++){
	with(unpause_queue[i]){
		var _index = array_get_index(other.pause_elements, id);
		if (_index != -1){
			array_delete(other.pause_elements, _index, 1);
		}
	}
}
unpause_queue = [];

for (i = 0; i < array_length(pause_elements); i++){
	instance_deactivate_object(pause_elements[i]);
}