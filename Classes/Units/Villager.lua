local Super = require('Classes.Unit')
local Villager = Class(Super)

local Farm = require('Classes.Buildings.Farm')
local House = require('Classes.Buildings.House')
local Barrack = require('Classes.Buildings.Barrack')
local HealthBar = require('Classes.HealthBar')

local ressourceSheet = graphics.newImageSheet("images/charactersB.png", {width = 32,  height = 48, numFrames = 96})

--STATIC CLASS FUNCTIONS
function Villager:canTrain(player)
    return player.money > 10 and player.food > 5 and Unit:canTrain(player)
end

--NON-STATIC/ INSTANCE FUNCTIONS
function Villager:initialize(player, options)
    options = options or {}

    local index = options.type or math.random(0, 7)
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

    Super.initialize(self, player, self.image)
    self.maxHp = 20
    self.hp = 20
    self.strength = 1
    self.speed = 2

    self.player:setPopulation( self.player.population + 1 )
    self.player:setFood( self.player.food - 5 )
end

function Villager:buildFarm()
    if(Farm:canBuild(self.player)) then
        print( tostring( self.player ).." is building a new farm..." )
        return Farm:new(self.player)
    else
        print( "not enough ressources to build a farm !" )
        return nil
    end
end

function Villager:buildBarrack()
    if(Barrack:canBuild(self.player)) then
        print( tostring( self.player ).." is building a new barrack..." )
        return Barrack:new(self.player)
    else
        print( "not enough ressources to build a barrack !" )
        return nil
    end
end

function Villager:buildHouse()
    if(House:canBuild(self.player)) then
        print( tostring( self.player ).." is building a new house..." )
        return House:new(self.player)
    else
        print( "not enough ressources to build a house !" )
        return nil
    end
end

function Villager:cutTree( tree )
    tree:cutBy(self)
end

function Villager:__tostring()
    return "Villager"..Super:__tostring(self)
end


return Villager
