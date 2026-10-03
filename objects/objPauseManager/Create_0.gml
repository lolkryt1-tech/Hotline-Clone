pause_elements = [];
pause_queue = [];
unpause_queue = [];

pause_object = function(obj_ord_id){
	array_push(pause_queue, obj_ord_id);
}

unpause_object = function(obj_ord_id){
	array_push(unpause_queue, obj_ord_id);
}

pause_tag = function(_tag_or_tags){
	var _assets = tag_get_asset_ids(_tag_or_tags, asset_object);
	for (i = 0; i < array_length(_assets); i++){
		pause_object(_assets[i]);
	}
}

unpause_tag = function(_tag_or_tags){
	var _assets = tag_get_asset_ids(_tag_or_tags, asset_object);
	for (i = 0; i < array_length(_assets); i++){
		unpause_object(_assets[i]);
	}
}