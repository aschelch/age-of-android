-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)
display.setDefault('anchorX', 0)
display.setDefault('anchorY', 0)

require('Classes.Class')

local tools = require('tools')

local loadsave = require("lib.loadsave")
local Player = require('Classes.Player')
local Map = require('Classes.Map')
local Villager = require('Classes.Units.Villager')
local Soldier = require('Classes.Units.Soldier')
local Farm = require('Classes.Buildings.Farm')
local Barrack = require('Classes.Buildings.Barrack')
local Tree = require('Classes.Tree')

local level1 = require("data.maps.level1")

local settings

local minimap
local floor
local map
local statusbar
local units = {}
local currentPlayer
local currentUnit

local music = audio.loadStream('sounds/POL-sacred-temple-short.wav')


function Main()


    currentPlayer = Player:new("aschelch")
    playerB = Player:new("bot")

    loadSettings()
    initMap()
    initStatusBar()
    initMainBar()

    villagerA = Villager:new(currentPlayer, {type=3})
    villagerB = Villager:new(playerB, {type=4})

    map:addObject( villagerA.group )
    map:addObject( villagerB.group )

    local tapOnUnit = function (unit)
        if(unit) then
            if(unit.player == currentPlayer ) then
                currentUnit = unit
            elseif (currentUnit) then
                if(tools.distanceBetween(currentUnit.position, unit.position) > 1) then
                    currentUnit:move({
                        x = unit.position.x-1,
                        y = unit.position.y,
                        onMoveComplete = function()
                            currentUnit:attack(unit)
                        end
                    })

                else
                    currentUnit:attack(unit)
                end
            end
        end

        return true
    end

    villagerA.tap = tapOnUnit
    villagerB.tap = tapOnUnit

    ----[[

    villagerA:setPosition(map, {x = 5, y= 5})
    villagerB:setPosition(map, {x = 6, y= 5})


    soldierA = Soldier:new(currentPlayer, {type=1})
    soldierA.tap = tapOnUnit
    soldierA:setPosition(map, {x = 7, y= 5})

    map:addObject( soldierA.group )

    map:addEventListener( "tap", function(event)
        if(currentUnit) then
            currentUnit:move({
                x = math.floor((event.x - event.target.x) / 32),
                y = math.floor((event.y - event.target.y) / 32)
            })
        end
    end )

    --if(settings.musicOn) then
    --    audio.setVolume( 0.25 )
    --    audio.play(music, {loops = -1, fadein = 5000,})
    --end
end

function initStatusBar()

    statusbar = require('Classes.StatusBar')
    statusbar:setCurrentPlayer(currentPlayer)

end

function initMainBar()

    mainbar = require('Classes.MainBar')

end

function loadSettings()
    settings = loadsave.loadTable("settings.json")

    if( not settings ) then
        settings = {}
        settings.soundOn = true
        settings.musicOn = true

        loadsave.saveTable(settings, "settings.json")
    end
end

function initMap()

    map = Map:new('data.maps.level1')

    populateTrees(math.random(50, 100))

end

function populateTrees(number)
    local trees = {}
    -- Create some trees
    for variable = 0, number, 1 do
        tree = Tree:new( {
            x = math.random( map.width/32 ),
            y = math.random( map.height/32 )
        })

        tree.tap = function (tree)
            if(tree and currentUnit)then
                if(tools.distanceBetween(currentUnit.group, tree.image) > 50) then
                    currentUnit:move({
                        x = tree.x,
                        y = tree.y,
                        onMoveComplete = function()
                            currentUnit:cutTree(tree)
                        end
                    })
                else
                    currentUnit:cutTree(tree)
                end
            end
            return true
        end

        map:addObject( tree.image )
    end

end

Main()
