function scrDestroyManagers()
{
	instance_destroy(objSaveManager);
	instance_destroy(objBloodSurfaceManager);
	instance_destroy(objDepthManager);
	instance_destroy(objParticleManager);
	instance_destroy(objPathManager);
	instance_destroy(objPauseManager);
	instance_destroy(objPauseMenu);
	instance_destroy(objGameManager);
	instance_destroy(objEffector);
	instance_destroy(objPlayer);
	instance_destroy(objLevelStatistic);
}