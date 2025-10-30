function atla_sort(_page)
{
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
        
        var _aa = (_a_height * 0xffffff) + ((_a_position_index - _a_index + 1) * 0xfff);
        var _ba = (_b_height * 0xffffff) + ((_b_position_index - _b_index + 1) * 0xfff);
        
        if (_aa == _ba)
        {
            return _a_index - _b_index;
        }
        
        return
            ((_b_height * 0xffffff) + ((_b_position_index + 1) * 0xfff) + ((_b.get_number() - _b_index) * 0xff)) -
            ((_a_height * 0xffffff) + ((_a_position_index + 1) * 0xfff) + ((_a.get_number() - _a_index) * 0xff));
        
    });
    
    var _data = global.atla_page_position[$ _page];
    
    var _length = array_length(_data);
    
    var _current_x = 0;
    var _current_y = 0;
    var _current_row_height = 0;
    
    var _width  = ATLA_INIT_SIZE;
    var _height = ATLA_INIT_SIZE;
    
    for (var i = 0; i < _length; ++i)
    {
        var _sprite = _data[i];
        
        var _name  = _sprite.get_name();
        
        var _w = _sprite.get_width();
        var _h = _sprite.get_height();
        
        if (_w > _h)
        {
            var _temp = _h;
            
            _w = _h;
            _h = _w;
            
            global.atla_page[$ _page][$ _name].is_rotated = true;
        }
        
        var _index = _sprite.get_index();
        
        if (_current_x + ((_sprite.get_number() - _index) * _w) >= ATLA_MAX_SIZE)
        {
            if (_current_y + _h >= ATLA_MAX_SIZE)
            {
                throw "Too much textures";
            }
            
            _current_x = 0;
            _current_y += _current_row_height;
            
            _current_row_height = _h;
        }
        else if (_h >= _current_row_height)
        {
            _current_row_height = _h;
        }
        /*
        var _max_y = 0;
        
        for (var j = i - 1; j >= 0; --j)
        {
            var _prev_sprite = global.atla_page_position[$ _page][j];
            
            var _prev_x = _prev_sprite.get_x();
            var _prev_y = _prev_sprite.get_y();
            
            var _prev_w = _prev_sprite.get_width();
            var _prev_h = _prev_sprite.get_height();
            
            if (global.atla_page[$ _page][$ _prev_sprite.get_name()].is_rotated)
            {
                var _temp = _prev_w;
                
                _prev_w = _prev_h;
                _prev_h = _temp;
            }
            
            if (_prev_x < _current_x + _w) && (_current_x < _prev_x + _prev_w)
            {
                _max_y = max(_max_y ?? 0, _prev_y + _prev_h);
            }
            
            if (_prev_x + _prev_w <= _current_x)
            {
                _current_y = _max_y;
                
                break;
            }
        }*/
        
        global.atla_page[$ _page][$ _name].sprite[@ _index] = i;
        
        _sprite.set_position(_current_x, _current_y);
        
        _current_x += _w;
        
        _width  = max(_width,  _current_x + _w);
        _height = max(_height, _current_y + _h);
    }
    
    global.atla_surface_size[$ _page] = (power(2, ceil(log2(_height))) << 16) | power(2, ceil(log2(_width)));
}