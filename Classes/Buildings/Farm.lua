local Super = require('Classes.Building')
local Farm = Class(Super)

--STATIC CLASS FUNCTIONS
function Farm:canBuild(player)
    return player.wood > 20
end

--NON-STATIC/ INSTANCE FUNCTIONS


function Farm:initialize(player)
    self.hp = 200
    self.farmingRate = 1
    self.player = player

    self.player:setWood(self.player.wood - 20)

    local farming = function ( event )
        self.player:setFood(self.player.food + self.farmingRate)
    end

    timer.performWithDelay( 3000, farming, -1)
end

function Farm:__tostring()
    return "Farm (hp:"..self.hp..")"
end

return Farm
