function scrInstanceExistsPause(_obj_ord_id)
{
	if (instance_exists(_obj_ord_id)) return true;
	
	var _paused_elements = objPauseManager.pause_elements;
	for (i = 0; i < array_length(_paused_elements); i++)
	{
		var _id = _paused_elements[i];
		if (_id == _obj_ord_id || _id.object_index == _obj_ord_id) return true;
	}
	
	return false;
}