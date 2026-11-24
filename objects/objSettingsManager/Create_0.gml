if (!audio_group_is_loaded(audiogroup_sounds))
{
    audio_group_load(audiogroup_sounds);
}



scrSettingsLoad();
scrSettingsApply();