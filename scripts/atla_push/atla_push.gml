function atla_push(_page, _sprite, _name)
{
    if (global.___atla_page[$ _page] == undefined)
    {
        global.___atla_page[$ _page] = {}
        global.___atla_page_position[$ _page] = []; 
        
        global.___atla_surface[$ _page] = {}
        global.___atla_surface_buffer[$ _page] = -1;
        global.___atla_surface_size[$ _page] = (___ATLA_INIT_SIZE << 16) | ___ATLA_INIT_SIZE;
    }
    else if (global.___atla_page[$ _page][$ _name] != undefined)
    {
        show_debug_message($"[ATLA] There already exists a sprite named '{_name}' in the atlas '{_page}'!");
        
        exit;
    }
    
    var _xoffset = sprite_get_xoffset(_sprite);
    var _yoffset = sprite_get_yoffset(_sprite);
    
    var _width  = sprite_get_width(_sprite);
    var _height = sprite_get_height(_sprite);
    var _number = sprite_get_number(_sprite);
    
    for (var i = 0; i < _number; ++i)
    {
        array_push(global.___atla_page_position[$ _page], new AtlaSprite(_name, _sprite, array_length(global.___atla_page_position[$ _page]), i, _number, _xoffset, _yoffset, _width, _height));
    }
    
    global.___atla_page[$ _page][$ _name] = new Atla(_xoffset, _yoffset, _width, _height, _number);
    
    array_sort(global.___atla_page_position[$ _page], function(_a, _b)
    {
        var _a_width  = _a.get_width();
        var _a_height = _a.get_height();
        
        var _b_width  = _b.get_width();
        var _b_height = _b.get_height();
        
        // Use the larger dimension (after potential rotation)
        var _a_size = max(_a_width, _a_height);
        var _b_size = max(_b_width, _b_height);
        
        // Primary sort: by size (descending - larger first)
        if (_a_size != _b_size)
        {
            return _b_size - _a_size;
        }
        
        // Secondary sort: by frame count (descending - more frames first)
        var _a_number = _a.get_number();
        var _b_number = _b.get_number();
        
        if (_a_number != _b_number)
        {
            return _b_number - _a_number;
        }
        
        // Tertiary sort: by position index (ascending - earlier first)
        return _a.get_position_index() - _b.get_position_index();
        
    });
    
    var _atla_page = global.___atla_page[$ _page];
    
    var _atla_page_position = global.___atla_page_position[$ _page];
    var _atla_page_position_length = array_length(_atla_page_position);
    
    var _surface_width  = ___ATLA_INIT_SIZE;
    var _surface_height = ___ATLA_INIT_SIZE;
    
    // First pass: place all sprites linearly left-to-right, top-to-bottom
    var _current_x = 0;
    var _current_y = 0;
    var _current_row_height = 0;
    
    for (var i = 0; i < _atla_page_position_length;)
    {
        var _position = _atla_page_position[i];
        var _i = _position.get_index();
        var _position_name = _position.get_name();
        
        var _w = _position.get_width();
        var _h = _position.get_height();
        
        if (_w > _h)
        {
            var _temp = _w;
            _w = _h;
            _h = _temp;
            
            global.___atla_page[$ _page][$ _position_name].set_is_rotated();
        }
        
        var _n = _position.get_number();
        var _total_width = _w * _n;
        
        // Wrap to next row if needed
        if (_current_x + _total_width >= ___ATLA_MAX_SIZE)
        {
            _current_x = 0;
            _current_y += _current_row_height;
            _current_row_height = 0;
        }
        
        // Place all frames of this sprite
        for (var j = 0; j < _n; ++j)
        {
            global.___atla_page[$ _page][$ _position_name].set_sprite_index(i + j, j);
            global.___atla_page_position[$ _page][@ i + j].set_position(_current_x + (_w * j), _current_y);
        }
        
        _current_x += _total_width;
        _current_row_height = max(_current_row_height, _h);
        _surface_width = max(_surface_width, _current_x);
        _surface_height = max(_surface_height, _current_y + _current_row_height);
        
        i += _n;
    }
    
    // Second pass: compact sprites to top-left by finding optimal Y position
    for (var i = 0; i < _atla_page_position_length;)
    {
        var _s = _atla_page_position[i];
        var _sprite_name = _s.get_name();
        
        var _x = _s.get_x();
        var _y = _s.get_y();
        
        var _w = _s.get_width();
        var _h = _s.get_height();
        
        var _n = _s.get_number();
        
        if (_atla_page[$ _sprite_name].is_rotated())
        {
            var _temp = _w;
            
            _w = _h;
            _h = _temp;
        }
        
        var _new_y = 0;
        
        // Find the maximum Y position of all sprites that overlap horizontally
        for (var j = 0; j < i;)
        {
            var _prev_sprite = _atla_page_position[j];
            var _prev_name = _prev_sprite.get_name();
            
            var _prev_x = _prev_sprite.get_x();
            var _prev_y = _prev_sprite.get_y();
            
            var _prev_w = _prev_sprite.get_width();
            var _prev_h = _prev_sprite.get_height();
            
            var _prev_n = _prev_sprite.get_number();
            
            if (_atla_page[$ _prev_name].is_rotated())
            {
                var _temp = _prev_w;
                
                _prev_w = _prev_h;
                _prev_h = _temp;
            }
            
            // Check horizontal overlap
            if (_x < _prev_x + (_prev_w * _prev_n) && _x + (_w * _n) > _prev_x)
            {
                _new_y = max(_new_y, _prev_y + _prev_h);
            }
            
            j += _prev_n;
        }
        
        for (var j = 0; j < _n; ++j)
        {
            _atla_page_position[i + j].set_position(_x + (_w * j), _new_y);
        }
        
        _surface_height = max(_surface_height, _new_y + _h);
        
        i += _n;
    }
    
    _surface_width  = power(2, ceil(log2(_surface_width)));
    _surface_height = power(2, ceil(log2(_surface_height)));
    
    global.___atla_surface_size[$ _page] = (_surface_height << 16) | _surface_width;
    
    var _surface = global.___atla_surface[$ _page];
    
    if (!surface_exists(_surface))
    {
        _surface = surface_create(_surface_width, _surface_height);
        
        global.___atla_surface[$ _page] = _surface;
    }
    else if (surface_get_width(_surface) != _surface_width) || (surface_get_height(_surface) != _surface_height)
    {
        var _temp = surface_create(_surface_width, _surface_height);
        
        surface_set_target(_temp);
        
        draw_surface(_surface, 0, 0);
        
        surface_reset_target();
        
        surface_free(_surface);
        
        _surface = _temp;
        
        global.___atla_surface[$ _page] = _surface;
    }
    
    surface_set_target(_surface);
    draw_clear_alpha(c_black, 0);
    
    for (var i = 0; i < _atla_page_position_length; ++i)
    {
        var _ = _atla_page_position[i];
        
        var _sprite2 = _.get_sprite();
        var _index   = _.get_index();
        
        var _x = _.get_x();
        var _y = _.get_y();
        
        var _data = _atla_page[$ _.get_name()];
        
        if (_data.is_rotated())
        {
            draw_sprite_ext(_sprite2, _index, _x + _.get_yoffset(), _y + _data.get_width() - _.get_xoffset(), 1, 1, 90, c_white, 1);
        }
        else
        {
            draw_sprite(_sprite2, _index, _x + _.get_xoffset(), _y + _.get_yoffset());
        }
    }
    
    var _buffer = global.___atla_surface_buffer[$ _page];
    var _buffer_size = _surface_width * _surface_height * 4;
    
    if (!buffer_exists(_buffer))
    {
        global.___atla_surface_buffer[$ _page] = buffer_create(_buffer_size, buffer_fast, 1);
    }
    else if (buffer_get_size(_buffer) != _buffer_size)
    {
        buffer_delete(_buffer);
        
        global.___atla_surface_buffer[$ _page] = buffer_create(_buffer_size, buffer_fast, 1);
    }
    
    buffer_get_surface(global.___atla_surface_buffer[$ _page], _surface, 0);
    
    var _surface_texture = global.___atla_surface_texture[$ _page];
    
    if (_surface_texture != undefined) && (surface_exists(_surface_texture))
    {
        texture_flush(_surface_texture);
    }
    
    _surface_texture = surface_get_texture(_surface);
    
    global.___atla_surface_texture[$ _page] = _surface_texture;
    global.___atla_surface_uvs[$ _page] = texture_get_uvs(_surface_texture); 
    
    surface_reset_target();
}