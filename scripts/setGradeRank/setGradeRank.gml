function scrGradeUI_SetRank(_rank)
{
    rank_subimg = _rank;
    is_s_rank = (_rank == 4);

    switch (_rank)
    {
        case 0:
            color_top = color_F;
            color_bot = color_F;
            break;

        case 1:
            color_top = color_C;
            color_bot = color_C;
            break;

        case 2:
            color_top = color_B;
            color_bot = color_B;
            break;

        case 3:
            color_top = color_A;
            color_bot = color_A;
            break;

        case 4:
            color_top = color_S_top;
            color_bot = color_S_bot;
            break;

        default:
            color_top = color_F;
            color_bot = color_F;
            break;
    }
}