if (fade_out)
{
    image_alpha -= fade_speed;
    if (image_alpha <= 0)
    {
        image_alpha = 0;
        fade_out    = false;
    }
}

if (fade_in)
{
    image_alpha += fade_speed;
    if (image_alpha >= 1)
    {
        image_alpha = 1;
        fade_in     = false;
    }
}