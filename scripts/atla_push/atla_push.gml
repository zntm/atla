function atla_push(_page, _sprite, _name)
{
    if (global.atla_page[$ _page] == undefined)
    {
        global.atla_page[$ _page] = {}
        global.atla_page_position[$ _page] = []; 
        
        global.atla_surface[$ _page] = {}
        global.atla_surface_buffer[$ _page] = -1;
        global.atla_surface_size[$ _page] = (ATLA_INIT_SIZE << 16) | ATLA_INIT_SIZE;
    }
    else if (global.atla_page[$ _page][$ _name] != undefined)
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
        array_push(global.atla_page_position[$ _page], new AtlaSprite(_name, _sprite, array_length(global.atla_page_position[$ _page]), i, _number, _xoffset, _yoffset, _width, _height));
    }
    
    global.atla_page[$ _page][$ _name] = new Atla(_xoffset, _yoffset, _width, _height, _number);
    
    array_sort(global.atla_page_position[$ _page], function(_a, _b)
    {
        var _a_width  = _a.get_width();
        var _a_height = _a.get_height();
        
        var _b_width  = _b.get_width();
        var _b_height = _b.get_height();
        
        if (_a_width > _a_height)
        {
            _a_height = _a_width;
        }
        
        if (_b_width > _b_height)
        {
            _b_height = _b_width;
        }
        
        var _a_position_index = _a.get_position_index();
        var _b_position_index = _b.get_position_index();
        
        var _a_index = _a.get_index();
        var _b_index = _b.get_index();
        
        var _aa = (_a_height * 0xffffff) + ((_a_position_index - _a_index + 1) * 0xffff);
        var _ba = (_b_height * 0xffffff) + ((_b_position_index - _b_index + 1) * 0xffff);
        
        if (_aa == _ba)
        {
            return _a_index - _b_index;
        }
        
        return
            _ba + ((_b.get_number() - _b_index) * 0xff) -
            _aa + ((_a.get_number() - _a_index) * 0xff);
        
    });
    
    var _atla_page = global.atla_page[$ _page];
    
    var _atla_page_position = global.atla_page_position[$ _page];
    var _atla_page_position_length = array_length(_atla_page_position);
    
    var _current_x = 0;
    var _current_y = 0;
    
    var _current_height = 0;
    
    var _surface_width  = ATLA_INIT_SIZE;
    var _surface_height = ATLA_INIT_SIZE;
    
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
            
            global.atla_page[$ _page][$ _position_name].set_is_rotated();
        }
        
        var _n = _position.get_number();
        
        if (_current_x + ((_n - _i) * _w) >= ATLA_MAX_SIZE)
        {
            _current_x = 0;
            _current_y += _current_height;
            
            if (_current_y > _surface_height)
            {
                _surface_height += _current_height;
            }
            
            _current_height = 0;
        }
        
        var _m = -1;
        
        for (var j = i - 1; j >= 0; --j)
        {
            var _prev_sprite = _atla_page_position[j];
            
            var _prev_x = _prev_sprite.get_x();
            var _prev_y = _prev_sprite.get_y();
            
            var _prev_w = _prev_sprite.get_width();
            var _prev_h = _prev_sprite.get_height();
            
            if (_atla_page[$ _prev_sprite.get_name()].is_rotated())
            {
                var _temp = _prev_w;
                
                _prev_w = _prev_h;
                _prev_h = _temp;
            }
            
            if (_current_y < _prev_y + _prev_h) || (_current_x + _w < _prev_x) continue;
            
            if (_m < _prev_y + _prev_h)
            {
                _m = _prev_y + _prev_h;
            }
            
            if (_current_x >= _prev_x + _prev_w) break;
        }
        
        for (var j = 0; j < _n; ++j)
        {
            global.atla_page[$ _page][$ _position_name].set_sprite_index(i + j, j);
            global.atla_page_position[$ _page][@ i + j].set_position(_current_x + (_w * j), _m);
        }
        
        _current_x += _w * _n;
        
        if (_h > _current_height)
        {
            _current_height = _h;
        }
        
        if (_current_x > _surface_width)
        {
            _surface_width = _current_x;
        }
        
        i += _n;
    }
    
    _surface_width  = power(2, ceil(log2(_surface_width)));
    _surface_height = power(2, ceil(log2(_surface_height)));
    
    global.atla_surface_size[$ _page] = (_surface_height << 16) | _surface_width;
    
    var _surface = global.atla_surface[$ _page];
    
    if (!surface_exists(_surface))
    {
        _surface = surface_create(_surface_width, _surface_height);
        
        global.atla_surface[$ _page] = _surface;
    }
    else if (surface_get_width(_surface) != _surface_width) || (surface_get_height(_surface) != _surface_height)
    {
        var _temp = surface_create(_surface_width, _surface_height);
        
        surface_set_target(_temp);
        
        draw_surface(_surface, 0, 0);
        
        surface_reset_target();
        
        surface_free(_surface);
        
        _surface = _temp;
        
        global.atla_surface[$ _page] = _surface;
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
            draw_sprite_ext(_sprite2, _index, _x + _.get_yoffset(), _y + sprite_get_width(_sprite2) - _.get_xoffset(), 1, 1, 90, c_white, 1);
        }
        else
        {
            draw_sprite(_sprite2, _index, _x + _.get_xoffset(), _y + _.get_yoffset());
        }
    }
    
    var _buffer = global.atla_surface_buffer[$ _page];
    var _buffer_size = _surface_width * _surface_height * 4;
    
    if (!buffer_exists(_buffer))
    {
        global.atla_surface_buffer[$ _page] = buffer_create(_buffer_size, buffer_fast, 1);
    }
    else if (buffer_get_size(_buffer) != _buffer_size)
    {
        buffer_delete(_buffer);
        
        global.atla_surface_buffer[$ _page] = buffer_create(_buffer_size, buffer_fast, 1);
    }
    
    buffer_get_surface(global.atla_surface_buffer[$ _page], _surface, 0);
    
    surface_reset_target();
}