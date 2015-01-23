local Tree = Class()

local ressourceSheet = graphics.newImageSheet("images/tilesB.png", {
    frames = {
        {x = 192, y = 128, width = 64, height = 64},
        {x = 0,   y = 224, width = 64, height = 64},
        {x = 0,   y = 288, width = 64, height = 64},
        {x = 96,  y = 416, width = 64, height = 96},
        {x = 160, y = 192, width = 32, height = 64, sourceX = 16, sourceWidth = 64},
        {x = 64,  y = 192, width = 32, height = 64, sourceX = 16, sourceWidth = 64},
        {x = 64,  y = 160, width = 32, height = 32, sourceX = 16, sourceY = 32, sourceWidth = 64, sourceHeight = 64},
        {x = 96,  y = 160, width = 32, height = 32, sourceX = 16, sourceY = 32, sourceWidth = 64, sourceHeight = 64},
    }
})

function Tree:initialize( param )
    param = param or {}
    self.type = param.type or math.random( 8 )
    self.x = param.x or 0
    self.y = param.y or 0
    self.quantity = math.random( 5 )

    self.image = display.newSprite(ressourceSheet, {
        { name = "normal", frames = {self.type} },
        { name = "cut",    frames = {math.random(7,8)}         },
    })
    self.image.x = self.x * 32 + 16
    self.image.y = self.y * 32 + 16
    self.image.anchorY = 0.75
    self.image.anchorX = 0.5

    self.image:addEventListener( "tap", self )

end

function Tree:cutBy( unit )

    local cutting = function( event )
        print( tostring(unit).." is cutting a "..tostring(tree) )

        unit.player:setWood(unit.player.wood + self.quantity)
        self.image:setSequence( "cut" )
    end

    timer.performWithDelay( 3000, cutting, 1)
end

function Tree:tap( event )
    print( "tap "..tostring(self) )

    self.image:setFillColor(0.8)
    local listener = function() self.image:setFillColor(1) end
    timer.performWithDelay( 150, listener )

    return true
end

function Tree:__tostring()
    return "Tree()"
end

return Tree
