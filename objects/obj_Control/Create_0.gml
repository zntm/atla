randomize();

var _2 = ((GM_build_type == "run") ? $"{filename_dir(GM_project_filename)}/datafiles" : "");

var _ = file_read_directory(
    _2
);

a = [];

length = array_length(_);

for (var i = 0; i < length; ++i)
{
    var _s = sprite_add($"{_2}/{_[i]}", 1, false, false, 0, 0);
    
    sprite_set_offset(_s, sprite_get_width(_s) / 2, sprite_get_height(_s) / 2);
    
    var _t = current_time;
    
    for (var j = 0; j < 2; ++j)
    {
        atla_push("test", _s, $"{i}{j}");
    }
    
    a[i] = current_time - _t;
    
    show_debug_message($"{i}: {current_time - _t}ms")
}

function file_read_directory(_directory)
{
    var _array = [];
    
    for (var _file = file_find_first($"{_directory}/*", fa_directory); _file != ""; _file = file_find_next())
    {
        array_push(_array, _file);
    }
    
    file_find_close();
    
    return _array;
}

function buffer_load_text(_directory)
{
    var _buffer = buffer_load(_directory);
    
    var _text = buffer_read(_buffer, buffer_text);
    
    buffer_delete(_buffer);
    
    return _text;
}

function buffer_load_json(_directory)
{
    try
    {
        return json_parse(buffer_load_text(_directory));
    }
    catch (_error)
    {
        return -1;
    }
}

l = 0