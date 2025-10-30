randomize();

var _2 = ((GM_build_type == "run") ? $"{filename_dir(GM_project_filename)}/datafiles" : "");

var _ = file_read_directory(
    _2
);

for (var i = 0; i < array_length(_); ++i)
{
    atla_push("test", sprite_add($"{_2}/{_[i]}", irandom_range(1, 4), false, false, irandom_range(0, 4), irandom_range(0, 4)), string(i));
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