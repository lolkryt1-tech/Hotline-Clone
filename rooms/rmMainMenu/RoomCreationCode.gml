scrInitialization();

if (!instance_exists(objSettingsManager))	{ instance_create_layer(0, 0, "Instances", objSettingsManager); }
if (!instance_exists(objMusicManager)) { instance_create_layer(0, 0, "Instances", objMusicManager); }