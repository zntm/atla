function atla_draw(_page, _name, _index, _x, _y, _xscale, _yscale, _rotation, _colour, _alpha)
{
    var _atla_page = global.___atla_page[$ _page];
    
    if (_atla_page == undefined)
    {
        show_debug_message($"[ATLA] Page '{_page}' does not exist!");
        
        exit;
    }
    
    var _data = _atla_page[$ _name];
    
    if (_data == undefined)
    {
        show_debug_message($"[ATLA] Sprite '{_name}' in page '{_page}' does not exist!");
        
        exit;
    }
    
    var _surface = global.___atla_surface[$ _page];
    
    if (!surface_exists(_surface))
    {
        var _buffer = global.___atla_surface_buffer[$ _page];
        
        if (!buffer_exists(_buffer))
        {
            show_debug_message($"[ATLA] Surface '{_page}' does not exist!");
            
            exit;
        }
        
        var _surface_size = global.___atla_surface_size[$ _page];
        
        global.___atla_surface[$ _page] = surface_create(
            (_surface_size >> 0)  & 0xffff,
            (_surface_size >> 16) & 0xffff
        );
        
        buffer_set_surface(_buffer, global.___atla_surface[$ _page], 0);
        
        _surface = global.___atla_surface[$ _page];
        
        var _surface_texture = global.___atla_surface_texture[$ _page];
         
        if (_surface_texture != undefined) && (surface_exists(_surface_texture))
        {
            texture_flush(_surface_texture);
        }
        
        _surface_texture = surface_get_texture(_surface);
        
        global.___atla_surface_texture[$ _page] = _surface_texture;
        global.___atla_surface_uvs[$ _page] = texture_get_uvs(_surface_texture); 
    }
    
    var _page_position = global.___atla_page_position[$ _page][_data.get_sprite_index(floor(_index))];
    
    var _position_xoffset = _page_position.get_xoffset();
    var _position_yoffset = _page_position.get_yoffset();
    
    var _x1 = _page_position.get_x();
    var _y1 = _page_position.get_y();
    
    var _x2 = _page_position.get_width();
    var _y2 = _page_position.get_height();
    
    var _draw_xoffset = _position_xoffset;
    var _draw_yoffset = _position_yoffset;
    
    var _draw_xscale = _xscale;
    var _draw_yscale = _yscale;
    
    if (_data.is_rotated())
    {
        _draw_xoffset = _position_yoffset;
        _draw_yoffset = _x2 - _position_xoffset;
        
        var _temp = _x2;
        
        _x2 = _y2;
        _y2 = _temp;
        
        var _temp2 = _draw_xscale;
        
        _draw_xscale = _draw_yscale;
        _draw_yscale = _temp2;
        
        _rotation -= 90;
    }
    
    var _cos =  dcos(_rotation);
    var _sin = -dsin(_rotation);
    
    var _xoffset = _draw_xoffset * _draw_xscale;
    var _yoffset = _draw_yoffset * _draw_yscale;
    
    draw_surface_general(
        _surface,
        _x1,
        _y1,
        _x2,
        _y2,
        _x - (_xoffset * _cos) + (_yoffset * _sin),
        _y - (_xoffset * _sin) - (_yoffset * _cos),
        _draw_xscale,
        _draw_yscale,
        _rotation,
        _colour,
        _colour,
        _colour,
        _colour,
        _alpha
    );
}