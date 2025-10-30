if (surface_exists(global.atla_surface[$ "test"]))
    draw_surface(global.atla_surface[$ "test"], 0, 0);

atla_draw("test", string(floor(j % length)), j * 4, mouse_x, mouse_y, 1, 1, 0, c_white, 1)

j += 0.08;

for (var i = 0; i < array_length(a) - 1; ++i)
{
    draw_line(i * 4, 200 - (a[i] * 4), ((i + 1) * 4), 200 - (a[i + 1] * 4))
}