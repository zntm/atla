randomize();

for (var i = 0; i < 256; ++i)
{
    var _w = irandom_range(1, 128);
    var _h = irandom_range(1, 128);
    
    var _surface = surface_create(_w, 128);
    
    surface_set_target(_surface);
    
    draw_clear_alpha(irandom(0xffffff), 1);
    
    surface_reset_target();
    
    var _ = sprite_create_from_surface(_surface, 0, 0, _w, _h, false, false, 0, 0);
    
    atla_push("test", _, string(i));
    
    surface_free(_surface);
}