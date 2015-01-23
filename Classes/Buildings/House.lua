local Super = require('Classes.Building')
local House = Class(Super)

--STATIC CLASS FUNCTIONS
function House:canBuild(player)
    return player.wood > 10
end

--NON-STATIC/ INSTANCE FUNCTIONS
function House:initialize(player)
    self.hp = 200
    self.capacity = 5
    self.player = player

    self.player:setWood(self.player.wood - 10)

end

function House:__tostring()
    return "House (hp:"..self.hp..")"
end

return House
