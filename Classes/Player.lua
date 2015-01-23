local Player = Class()

function Player:initialize(name)
    self.name = name

    self.wood = 100
    self.food = 100
    self.money = 100
    self.populationMax = 5
    self.population = 0
    self.buildings = {}
    self.units = {}
end

function Player:setWood(value)
    self.wood = value
    print( "new wood "..value )
    Runtime:dispatchEvent({name="onWoodChanged", target=self, value=value})
end

function Player:setFood(value)
    self.food = value
    Runtime:dispatchEvent({name="onFoodChanged", target=self, value=value})
end

function Player:setMoney(value)
    self.money = value
    Runtime:dispatchEvent({name="onMoneyChanged", target=self, value=value})
end

function Player:setPopulation(value)
    self.population = value
    Runtime:dispatchEvent({name="onPopulationChanged", target=self, value=value})
end

function Player:__tostring()
    return "Player(name:"..self.name..",wood:"..self.wood..",food:"..self.food..",money:"..self.money..")"
end

return Player
