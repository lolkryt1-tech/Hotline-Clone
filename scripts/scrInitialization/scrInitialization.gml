function scrInitialization()
{
	if (!instance_exists(objEffector)) { instance_create_layer(x, y, "Instances", objEffector); }
	if (!instance_exists(objDepthManager)) { instance_create_layer(0, 0, "Instances", objDepthManager); }
	if (!instance_exists(objPathManager)) { instance_create_layer(0, 0, "Instances", objPathManager); }
	if (!instance_exists(objBloodSurfaceManager)) { instance_create_layer(0, 0, "Blood_layer", objBloodSurfaceManager); }
	if (!instance_exists(objSaveManager)) { instance_create_layer(0, 0, "Instances", objSaveManager); }
}