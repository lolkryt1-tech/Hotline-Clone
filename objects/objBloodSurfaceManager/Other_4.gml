/*
if (surface_exists(global.surf_blood)) 
{
    surface_free(global.surf_blood);
    global.surf_blood = -1;
}
if (!layer_exists("Blood_Layer")) 
{
    layer_create(8000, "Blood_Layer");
}

layer_element_move(self, layer_get_id("Blood_Layer"));