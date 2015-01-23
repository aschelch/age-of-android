local StatusBar = display.newGroup( )

local background = display.newImage("images/backgroundStatusBar.png", 0, 0)
StatusBar:insert( background )

StatusBar:insert(display.newImage("images/icon_wood.png", 12, 4))
local woodField = display.newText("", 40, 4, 'Courier', 16)
StatusBar:insert(woodField)

StatusBar:insert(display.newImage("images/icon_food.png", 86, 4))
local foodField = display.newText("", 114, 4, 'Courier', 16)
StatusBar:insert(foodField)

StatusBar:insert(display.newImage("images/icon_gold.png", 160, 4))
local moneyField = display.newText("", 184, 4, 'Courier', 16)
StatusBar:insert(moneyField)

StatusBar:insert(display.newImage("images/icon_people.png", 234, 4))
local populationField = display.newText("", 266, 4, 'Courier', 16)
StatusBar:insert(populationField)

function StatusBar:setCurrentPlayer(player)
    self.player = player

    if(self.player) then
        Runtime:addEventListener("onWoodChanged", self)
        Runtime:addEventListener("onFoodChanged", self)
        Runtime:addEventListener("onMoneyChanged", self)
        Runtime:addEventListener("onPopulationChanged", self)

        self:onWoodChanged()
        self:onFoodChanged()
        self:onMoneyChanged()
        self:onPopulationChanged()
    end

end

function StatusBar:onWoodChanged( event )
    woodField.text = self.player.wood
    return true
end

function StatusBar:onFoodChanged( event )
    foodField.text = self.player.food
    return true
end

function StatusBar:onMoneyChanged( event )
    moneyField.text = self.player.money
    return true
end
function StatusBar:onPopulationChanged( event )
    populationField.text = self.player.population.."/"..self.player.populationMax
    return true
end

return StatusBar
