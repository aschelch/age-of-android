
local function distanceBetween(from, to)
    return math.sqrt(math.pow(math.abs(from.y - to.y), 2) + math.pow(math.abs(from.x - to.x), 2))
end

local function heading(from, to)
    if(math.abs(from.y - to.y) > math.abs(from.x - to.x)) then
        if(to.y <= from.y) then
            return "north"
        else
            return "south"
        end
    else
        if(to.x <= from.x) then
            return "west"
        else
            return "east"
        end
    end
end

local function depthSort( displayGroup )
    local objects = {}
    for i=1,displayGroup.numChildren do
        if (displayGroup[i].time) then
            print(displayGroup[i].time)
        end
        objects[#objects+1] = {displayGroup[i].x, displayGroup[i].y, displayGroup[i]}
    end
    table.sort( objects, function(a,b)
        if(a[2] == b[2]) then
            return a[1] > b[1]
        else
            return a[2] > b[2]
        end
    end )
    for i=1,#objects do displayGroup:insert( objects[i][3] ) end
end

local function walkableMapFromTMX(lvl)
    local t = {}
    local idx = 1
    for h = 1, lvl.layers[1].height do
        t[h] = {}
        for w = 1, lvl.layers[1].width do
            t[h][w] = lvl.layers[1].data[idx]
            idx = idx + 1
        end
    end
    return t
end

return {
    distanceBetween = distanceBetween,
    heading = heading,
    depthSort = depthSort,
    walkableMapFromTMX = walkableMapFromTMX
}
