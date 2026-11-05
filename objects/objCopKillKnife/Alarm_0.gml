if (enemy_skin == SKIN.COLOMBIANREGULAR) 
{ 
    enemy_sprite = sprColombianDieKnife; 
}

if (enemy_skin == SKIN.COLOMBIANVEST) 
{ 
    enemy_sprite = sprColombianVestDieKnife; 
}

// Если это быстрая казнь, мы урезаем замах, но финал ВСЁ РАВНО на 8 кадрах (так как в спрайте 8 кадров)
if (is_fast_execution)
{
    hurt_index = 2; // Удар происходит быстрее
}
