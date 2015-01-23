local Super = require('Classes.Unit')
local Soldier = Class(Super)

local ressourceSheet = graphics.newImageSheet("images/charactersC.png", {width = 32,  height = 48, numFrames = 96})

--STATIC CLASS FUNCTIONS
function Soldier:canTrain(player)
    return player.money > 10 and player.food > 5 and player.population < player.populationMax
end

--NON-STATIC/ INSTANCE FUNCTIONS
function Soldier:initialize(player)


    local index = math.random(0, 1)
    if(index > 3) then index = index + 12 end

    self.image = display.newSprite(ressourceSheet, {
        { name = "standing-south", frames = {index*3+2},},
        { name = "standing-west", frames = {index*3+14},},
        { name = "standing-east", frames = {index*3+26},},
        { name = "standing-north", frames = {index*3+38},},
        { name = "walking-south", frames = {index*3+1,index*3+3}, time = 700, loopCount = 0,},
        { name = "walking-west", frames = {index*3+13,index*3+15}, time = 700, loopCount = 0,},
        { name = "walking-east", frames = {index*3+25,index*3+27}, time = 700, loopCount = 0,},
        { name = "walking-north", frames = {index*3+37,index*3+39}, time = 700, loopCount = 0,},
    })
    self.image:setSequence("standing-south")
    self.image.anchorY = 0.75
    self.image.anchorX = 0.5

    Super.initialize(self, player, self.image )

    self.maxHp = 50
    self.hp = 50
    self.strength = 10
    self.speed = 3


    self.player:setPopulation( self.player.population + 1 )
    self.player:setMoney( self.player.money - 10 )
    self.player:setFood( self.player.food - 5 )
end

function Soldier:__tostring()
    return "Soldier"..Super:__tostring(self)
end

return Soldier
