// === НИКАКИХ ПОДСКАЗОК ===
if (global.settings.enable_tips == false) { instance_destroy(); }

hover_timer += 0.05; 

// === 1. ПОДСКАЗКА МЕТАНИЯ НОЖА ===
if (instance_exists(objPlayer) && (charge_knife_shown_hint == false))
{
    if (objPlayer.sprite_index == sprCopWalkKnife || objPlayer.sprite_index == sprCopAttackKnife)
    {
        charge_knife_hint_timer = 360;
        charge_knife_shown_hint = true;
    }
}

if (charge_knife_hint_timer > 0)
{
    charge_knife_hint_timer -= 1;
    charge_knife_hint_alpha = lerp(charge_knife_hint_alpha, 0.75, 0.1);
}
else
{
    charge_knife_hint_alpha = lerp(charge_knife_hint_alpha, 0, 0.1);
}


// === 2. ПОДСКАЗКА ДОБИВАНИЯ НОЖОМ (ЧИСТАЯ ПРИВЯЗКА К ОБЪЕКТУ) ===
if (instance_exists(objCopKillKnife))
{
    // Пока врага добивают, подсказка БУДЕТ гореть (если ещё не заблокирована насовсем)
    if (knife_kill_shown_hint == false)
    {
        knife_kill_hint_alpha = lerp(knife_kill_hint_alpha, 0.75, 0.1);
    }
}
else
{
    // Как только объект пропал — плавно тушим
    knife_kill_hint_alpha = lerp(knife_kill_hint_alpha, 0, 0.1);
    
    // Блокируем ТОЛЬКО когда текст полностью исчез после окончания анимации
    if (knife_kill_hint_alpha <= 0.01 && knife_kill_hint_alpha > 0)
    {
        knife_kill_shown_hint = true;
    }
}
