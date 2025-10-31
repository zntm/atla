function atla_get_uvs(_page, _name)
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
        show_debug_message($"[ATLA] Sprite '{_page}' does not exist!");
        
        exit;
    }
    
    return _data.get_uvs();
}