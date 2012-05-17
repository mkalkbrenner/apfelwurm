
-- 'Wurmspiel

function draw_worm(worm)
    crash = false
    for index, value in ipairs(worm.x) do
        putimage(worm.x[index], worm.y[index], worm.image)
        if 1 ~= index and worm.x[1] == worm.x[index] and worm.y[1] == worm.y[index] then
            crash = true
        end
    end
    return crash
end



openwindow(640, 480, 32, "Apfelwurm")

mousehide()

setframetimer(80)

colourkey(0, 0, 0)

backmusic = loadmusic("sound/spring-weather-1.mp3")
playmusic(backmusic, 255, -1)

crunchsound = loadsound("sound/20267_Koops_Apple_Crunch_04.wav")

grid = 32
grid_x = 20
grid_y = 14

slow_down = 0

worm = {}
worm.image = createimage(grid, grid)
worm.x = {}
worm.y = {}
worm.x[1] = grid * 10
worm.y[1] = grid * 10
worm.add_x = 0
worm.add_y = 0
worm.length = 5

startimagedraw(worm.image)
    local width = grid / 2
    colour(100, 100, 0)
    fillcircle(width, width, width - 3)
    colour(150, 150, 0)
    fillcircle(width, width, width - 6)
    colour(200, 200, 0)
    fillcircle(width, width, width - 9)
stopimagedraw()

fruits = {}
fruits.image = loadimage("gfx/erdbeere.png")
fruits.x = {}
fruits.y = {}
fruits.max = 10

move = {}
move.x = 0
move.y = -1
move.do_x = 0
move.do_y = -1

background_sprite = loadimage("gfx/grass.bmp");
for x = 1, grid_x do
    for y = 1, grid_y do
        putimage(x * grid - grid, y * grid - grid, background_sprite)
    end
end
--' grab the background as whole
background = grabimage(0, 0, grid_x * grid, grid_y * grid)

i_grid = 1
i_length = 1
crash = false
points = 0

repeat
    for slow = 0, slow_down do
        wait(timeleft())
    end

    cls()

    key = getkey()

    if keystate(274) and -1 ~= move.do_y then
        move.x = 0
        move.y = 1
    elseif keystate(273) and 1 ~= move.do_y then
        move.x = 0
        move.y = -1
    elseif keystate(275) and -1 ~= move.do_x then
        move.x = 1
        move.y = 0
    elseif keystate(276) and 1 ~= move.do_x then
        move.x = -1
        move.y = 0
    end

    if i_grid == grid then
        i_grid = 1
        add = 1
        move.do_x = move.x
        move.do_y = move.y
    else
        i_grid = i_grid + 1
        if i_grid == grid / 2 then
           add = 1
        end
    end

    if 1 == add then
       add = 0
       table.insert(worm.x, 2, worm.x[1])
       table.insert(worm.y, 2, worm.y[1])
       if i_length < worm.length then
           i_length = i_length + 1
       else
           table.remove(worm.x, worm.length + 1)
           table.remove(worm.y, worm.length + 1)
       end
    end

    worm.x[1] = worm.x[1] + move.do_x
    worm.y[1] = worm.y[1] + move.do_y

    for index, value in ipairs(fruits.x) do
        if imagecoll(worm.image, worm.x[1], worm.y[1], fruits.image, fruits.x[index], fruits.y[index]) then
           playsound(crunchsound, 255, 0, 0)
           table.remove(fruits.x, index)
           table.remove(fruits.y, index)
           worm.length = worm.length + 1
           points = points + 1
        end
    end

    new_fruit_x = 0
    new_fruit_y = 0

    if #fruits.x < fruits.max then
        new_fruit_x = grid * int(rnd() * (grid_x - 1)) + 8
        new_fruit_y = grid * int(rnd() * (grid_y - 1)) + 8 + grid
        io.stderr:write(new_fruit_x .. " " .. new_fruit_y .. "\n")
    end

    color(200, 200, 200)
    drawtext(1, 1, points)

    putimage(0, grid, background)

    draw_worm(worm)

    for index, value in ipairs(worm.x) do
        if new_fruit_x and imagecoll(worm.image, worm.x[index], worm.y[index], fruits.image, new_fruit_x, new_fruit_y) then
            new_fruit_x = 0;
            new_fruit_y = 0;
        end
    end

    if worm.x[1] < 0 or worm.x[1] > grid * grid_x - grid or worm.y[1] < grid or worm.y[1] > grid * grid_y + 1 then
        crash = true
    end

    for index, value in ipairs(fruits.x) do
        if new_fruit_x == fruits.x[index] and new_fruit_y == fruits.y[index] then
            new_fruit_x = 0;
            new_fruit_y = 0;
        end
    end

    if 0 ~= new_fruit_x then
        table.insert(fruits.x, new_fruit_x)
        table.insert(fruits.y, new_fruit_y)
    end

    for index, value in ipairs(fruits.x) do
        putimage(fruits.x[index], fruits.y[index], fruits.image)
    end

    wait(timeleft())

    redraw()
until 27 == key or crash

closewindow()

