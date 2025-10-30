function Atla(_xoffset, _yoffset, _width, _height, _number) constructor
{
    ___xoffset = _xoffset;
    ___yoffset = _yoffset;
    ___width = _width;
    ___height = _height;
    ___number = _number;
    
    static set_sprite_index = function(_sprite_index, _index)
    {
        self[$ "___sprites_indeces"] ??= [];
        
        ___sprites_indeces[@ _index] = _sprite_index;
        ___sprites_indeces_length = array_length(___sprites_indeces);
        
        return self;
    }
    
    static get_sprite_indeces = function()
    {
        return ___sprites_indeces;
    }
    
    static get_sprite_indeces_length = function()
    {
        return ___sprites_indeces_length;
    }
    
    static get_sprite_index = function(_index)
    {
        return ___sprites_indeces[_index % get_sprite_indeces_length()];
    }
    
    static get_xoffset = function()
    {
        return ___xoffset;
    }
    
    static get_yoffset = function()
    {
        return ___yoffset;
    }
    
    static get_width = function()
    {
        return ___width;
    }
    
    static get_height = function()
    {
        return ___height;
    }
    
    static get_number = function()
    {
        return ___number;
    }
    
    static set_is_rotated = function()
    {
        ___is_rotated = true;
        
        return self;
    }
    
    static is_rotated = function()
    {
        return self[$ "___is_rotated"] ?? false;
    }
}