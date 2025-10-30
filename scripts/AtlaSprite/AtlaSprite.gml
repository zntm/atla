function AtlaSprite(_name, _sprite, _position_index, _index, _number, _xoffset, _yoffset, _width, _height) constructor
{
    ___name = _name;
    ___sprite = _sprite;
    ___xoffset = _xoffset;
    ___yoffset = _yoffset;
    ___position_index = _position_index;
    ___index = _index;
    ___number = _number;
    ___width = _width;
    ___height = _height;
    
    static get_name = function()
    {
        return ___name;
    }
    
    static get_sprite = function()
    {
        return ___sprite;
    }
    
    
    static get_xoffset = function()
    {
        return ___xoffset;
    }
    
    static get_yoffset = function()
    {
        return ___yoffset;
    }
    
    static get_position_index = function()
    {
        return ___position_index;
    }
    
    static get_index = function()
    {
        return ___index;
    }
    
    static get_number = function()
    {
        return ___number;
    }
    
    static set_position = function(_x, _y)
    {
        set_x(_x);
        set_y(_y);
        
        return self;
    }
    
    static set_x = function(_x)
    {
        ___x = _x;
        
        return self;
    }
    
    static get_x = function()
    {
        return self[$ "___x"] ?? 0;
    }
    
    static set_y = function(_y)
    {
        ___y = _y;
        
        return self;
    }
    
    static get_y = function()
    {
        return self[$ "___y"] ?? 0;
    }
    
    static get_width = function()
    {
        return ___width;
    }
    
    static get_height = function()
    {
        return ___height;
    }
}