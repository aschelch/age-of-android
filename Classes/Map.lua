local Map = {}

local tools = require('tools')
local Grid = require ("lib.jumper.grid") -- The grid class
local Pathfinder = require ("lib.jumper.pathfinder") -- The pathfinder lass

function Map:new( file )
   local map = display.newGroup( )

   map.y = 32

   map.floor = display.newGroup()
   map:insert(map.floor)

   map.objects = display.newGroup()
   map:insert(map.objects)

   map.displayTopLeft = {
      x = 0,
      y = 32
   }

   map.displayBottomRight = {
      x = display.contentWidth,
      y = display.contentHeight-96
   }

   function map:load( file )

      data = require( file )

      if(data == nil) then return end

      -- TODO Chage iage dynamically, and handle multiple sheet
      local sheet = graphics.newImageSheet("images/tilesE.png", {
           width = data.tilewidth,
           height = data.tileheight,
           numFrames = 624
      })

      self.contentWidth = data.tilewidth * data.width
      self.contentHeight = data.tileheight * data.height

      local walkable = {}

      -- for each line
      for y=0, data.height-1, 1 do

         walkable[y] = {}

         -- for each column
         for x=0, data.width-1, 1 do

            local index = 1 + y*data.width + x

            -- for each layer
            for layer=1, #data.layers, 1 do

               local tileIndex = data.layers[layer].data[index]

               if(layer == 1) then
                  walkable[y][x] = tileIndex
               end

               -- If there is a tile here
               if(tileIndex ~= 0) then

                  local tile = display.newImage( sheet, tileIndex )

                  tile.x = x*32
                  tile.y = y*32

                  self.floor:insert(tile)

               end
            end
         end
      end

      -- Creates a grid object
      local grid = Grid(walkable)

      local isWalkable = function(v) return v == 1 or v == 93 end
      self.pathfinder = Pathfinder(grid, 'JPS', isWalkable)
      --self.pathfinder:setMode('ORTHOGONAL')

   end

   function map:addObject( obj )
      self.objects:insert( obj )
   end

   function map:touch(event)

        if event.phase == "began" then
            print("began map touch")


            event.target.markX = event.target.x    -- store x location of object
            event.target.markY = event.target.y    -- store y location of object

        elseif event.phase == "moved" then

            local x = (event.x - event.xStart) + event.target.markX
            local y = (event.y - event.yStart) + event.target.markY

            x = math.max(map.displayBottomRight.x-map.contentWidth, math.min(map.displayTopLeft.x, x))
            y = math.max(map.displayBottomRight.y-map.contentHeight, math.min(map.displayTopLeft.y, y))

            event.target.x, event.target.y = x, y    -- move object based on calculations above
        end

   end

   function map:enterFrame()
      --[[
      if(self.frameCount < 10) then
         self.frameCount = self.frameCount + 1
         return
      end
      self.frameCount = 0
      ]]


      local function redraw()
         for i = 1, self.objects.numChildren do
            self.objects[i]:toBack()
            --print("("..self.objects[i].x..", "..self.objects[i].y..")")
         end
      end

      tools.depthSort(self.objects)
      redraw()

   end

   map:load( file )

   Runtime:addEventListener( "enterFrame", map )

   map:addEventListener( "touch" )

   return map
end

return Map
