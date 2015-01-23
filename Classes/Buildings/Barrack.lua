local Super = require('Classes.Building')
local Barrack = Class(Super)

local Soldier = require('Classes.Units.Soldier')

--STATIC CLASS FUNCTIONS
function Barrack:canBuild(player)
    return player.wood > 50 and player.money > 20
end

--NON-STATIC/ INSTANCE FUNCTIONS
function Barrack:initialize(player)
    self.hp = 300
    self.player = player

    self.player:setMoney(self.player.money - 20)
    self.player:setWood(self.player.wood - 50)
end

function Barrack:trainSoldier()
    if(Soldier:canTrain(self.player)) then
        print( "training new soldier..." )
        return Soldier:new(self.player)
    else
        print( "not enough money !" )
        return nil
    end
end

function Barrack:__tostring()
    return "Barrack (hp:"..self.hp..")"
end

return Barrack
