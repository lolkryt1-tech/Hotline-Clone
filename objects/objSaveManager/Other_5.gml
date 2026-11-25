// === УДАЛЯЕМ КВИКСЕЙВЫ ПРИ ПЕРЕХОДЕ НА ДРУГОЙ ЭТАЖ ===
if (file_exists("quick_save.dat"))
{
    file_delete("quick_save.dat");
}

if (file_exists("quick_save_blood.dat"))
{
    file_delete("quick_save_blood.dat");
}