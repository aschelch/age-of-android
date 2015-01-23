local Unit = Class()

local tools = require('tools')

local HealthBar = require('Classes.HealthBar')

local kickSound = audio.loadSound('sounds/kick.mp3')

local coord = function(x)
    return x * 32 + 16
end


function Unit:initialize(player, image)
    self.x = 0
    self.y = 0
    self.maxHp = 100
    self.hp = 100
    self.strength = 1
    self.speed = 2
    self.player = player
    self.heading = "south"

    self.image = image
    self.image.x = 0
    self.image.y = 0
    self.image:addEventListener( "touch", self )
    self.image:addEventListener( "tap", self )


    self.healthbar = HealthBar:new(0, 0, 0, 0, 255, 0, 32, 2)
    self.healthbar.x = - 16
    self.healthbar.y = - 42
    self.healthbar:setProgress(self.hp, self.maxHp)

    self.group = display.newGroup( )
    self.group:insert( self.image )
    self.group:insert( self.healthbar )


end

function Unit:attack(opponent)
    --print ( tostring(self).." attack "..tostring(opponent) )
    opponent:hit(self.strength)
end

function Unit:hit(strength)
    self:setHp(self.hp - strength)

    --if(settings.soundOn) then
        audio.play( kickSound )
    --end

    if(self.hp <= 0) then
        self.group:removeSelf()
        print( tostring(self).." is dead" )
        return
    end

    self.image:setFillColor(255, 0, 0)
    local listener = function() self.image:setFillColor(255, 255, 255) end
    timer.performWithDelay( 150, listener )

end

function Unit:setPosition(map, position)
    self.map = map
    self.position = position
    self.group.x = coord(position.x)
    self.group.y = coord(position.y)
end

function Unit:setHp(value)
    self.hp = math.max(value, 0)
    self.healthbar:setProgress(self.hp, self.maxHp)
end

function Unit:move(option)

    self.path = self.map.pathfinder:getPath(self.position.x, self.position.y, option.x, option.y)
    self.pathLine = nil
    self.pathIndex = 2
    if self.path then


        for node, count in self.path:nodes() do
            --if(self.pathLine == nil) then
                --print(('newLine(%d, %d, %d, %d)'):format(coord(self.position.x), coord(self.position.y), coord(node.x), coord(node.y)))
                --self.pathLine = display.newLine( coord(node.x), coord(node.y), coord(node.x), coord(node.y))
            --else
                print(('append(%d, %d)'):format(coord(node.x), coord(node.y)))
                --self.pathLine:append(coord(node.x), coord(node.y))
            --end
        end


        self:moveToNextNode(option.onMoveComplete)
    end
end

function Unit:moveToNextNode(onMoveComplete)
    if self.path then
        --print(('Path found! Length: %.2f'):format(self.path:getLength()))
        for node, count in self.path:nodes() do
            if(count == self.pathIndex) then
                self:moveInternal({
                    x = node.x,
                    y = node.y,
                    onComplete = function()
                        self.pathIndex = self.pathIndex + 1
                        self:moveToNextNode(onMoveComplete)
                    end
                })
                return
            end
        end

        if(onMoveComplete)then
            onMoveComplete()
        end
    end
end

function Unit:moveInternal(option)

    local to = {
        x = coord(option.x),
        y = coord(option.y)
    }

    if(self.currentTransition) then
        transition.cancel( self.currentTransition )
    end

    self.heading = tools.heading(self.group, to)

    self.image:setSequence( "walking-"..self.heading )

    local distance = tools.distanceBetween(self.group, to)
    distance = distance / 32
    local time = distance / self.speed

    local stop = function (event)
        self.position.x = option.x
        self.position.y = option.y
        self.image:pause( )
        self.image:setSequence( "standing-"..self.heading )
        option.onComplete()
    end

    self.currentTransition = transition.moveTo(self.group, {
        tag = "move",
        x = to.x,
        y = to.y,
        time = time * 1000,
        onStart = function (event) self.image:play( ) end,
        onComplete = stop,
        onResume = function (event) self.image:play( ) end,
        onPause = stop,
    })


end

function Unit:tap(event)
    self.image:setFillColor(0.8)
    local listener = function() self.image:setFillColor(1) end
    timer.performWithDelay( 150, listener )

    return true
end

function Unit:touch(event)
    if event.phase == "began" then
        self.image:setFillColor(0.8)

    elseif event.phase == "ended" then
        self.image:setFillColor(1)

    end

    print( event.phase )

    return true
end

function Unit:__tostring(v)
    return "(hp:"..v.hp.."/"..v.maxHp..", strength:"..v.strength..", speed:"..v.speed..")"
end

return Unit
