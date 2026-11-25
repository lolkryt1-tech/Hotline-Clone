scrClearFloorData();

// Удаляем Quick Save
if (file_exists("quick_save.dat"))
{
    file_delete("quick_save.dat");
}

if (file_exists("quick_save_blood.dat"))
{
    file_delete("quick_save_blood.dat");
}