--[[
	the world object base class *********************
]]
WorldObject = {}
local worldObject_metatab = {}

function WorldObject.new(name)
	local info = {}
	info.name = name
	setmetatable(info, worldObject_metatab)
	return info
end
worldObject_metatab.__index = WorldObject


--[[
	the level datapoint class *********************
]]
LevelDataPoint = {}
local levelDataPoint_metatab = {}

function LevelDataPoint.new(x, y, worldObjects, isPlayerAccesible)
	local info = {}
	info.x = x
	info.y = y
	info.worldObjects = worldObjects
	if isPlayerAccesible == nil then -- bit smelly, but setting default value like this
		isPlayerAccesible = true
	end
	info.isPlayerAccesible = isPlayerAccesible
	setmetatable(info, levelDataPoint_metatab)
	return info
end

function LevelDataPoint.getX(dataPoint)
	return dataPoint.x
end

function LevelDataPoint.getY(dataPoint)
	return dataPoint.y
end

function LevelDataPoint.playerAccesible(dataPoint)
	return dataPoint.isPlayerAccesible
end
levelDataPoint_metatab.__index = LevelDataPoint

--[[
	the level class *********************
]]
Level = {}
local level_metatab = {}

function Level.new()
	local info = {}
	info.levelData = {}
	setmetatable(info, level_metatab)
	return info
end

function Level.load(levelData)
	level_metatab.levelData = levelData
end

function Level.getLevelData()
	return level_metatab.levelData
end
level_metatab.__index = Level

--[[
	the player class *********************
]]
Player = {}
local player_metatab = {}

function Player.new(id, level)
	local info = {}
	info.id = id
	info.maxBackpackCapacity = 5
	info.level = level
	info.backpack = {} -- player inventory
	info.currentPosition = LevelDataPoint.new(0, 0, {})
	setmetatable(info, player_metatab)
	return info
end

function Player.getMaxBackpackCapacity(player)
	return player.maxBackpackCapacity
end

function Player.getPlayerid(player)
	return player.id
end

function Player.regsiterLevel(player, level)
	player.level = level
end

function Player.getLevel(player)
	return player.level
end

function Player.pickup(player, name)

	if table.getn(player.currentPosition.worldObjects) == 0 then
		print("Player with id ".. player:getPlayerid() .. " has attempted to pick up an item at coords ("..player.currentPosition:getX()..","..player.currentPosition:getY() .."), but there are no items available at this position")
		return
	end

	if table.getn(player.backpack) >= player.maxBackpackCapacity then
		print("Player with id ".. player:getPlayerid() .. " has attmepted to pick up an item, but players backpack is full. Drop items first")
		return
	end

	--[[
		Check if the item is available to pickup,
		if so, add to player backpack and remove from world.
		Prob a better way to do this in lua than this linear search,
		and it's a little smelly, but it will have to do!
	]]
	local exists = false
	local index = 0
	for k, v in pairs(player.currentPosition.worldObjects) do
		if v[1].name == name then
		  index = index + 1
		  exists = true
		  table.insert(player.backpack, v[1])
		  break
		end
	end
	if exists then -- cleanup world
		table.remove(player.currentPosition.worldObjects, index)
	else
		print("Player with id ".. player:getPlayerid() .. " has attempted to pick up a " .. name .. " at coords ("..player.currentPosition:getX()..","..player.currentPosition:getY() .."), but ".. name .. " is not available at this position")
		return
	end
end

function Player.teleport(player, x, y)
	if player.level == nil then
		print("Must register a level to the player before teleporting")
		return
	end

	if player.level.getLevelData()[x..y] == nil then
		print("Player with id ".. player:getPlayerid() .. " has attempted to stray out of the permitted world bounds at ("..x..","..y..")")
		return
	end

	-- coords exist
	if player.level.getLevelData()[x..y]:playerAccesible() then

		print("Player with id ".. player:getPlayerid() .. " has moved from ("..player.currentPosition:getX()..","..player.currentPosition:getY() ..") to ("..x..","..y..")")
		player.currentPosition = player.level.getLevelData()[x..y] -- update the players current position

		-- log to std out if there are any world objects the player can use
		if table.getn(player.currentPosition.worldObjects) > 0 then
			print("There are "..table.getn(player.currentPosition.worldObjects).." available items at location ("..player.currentPosition:getX()..","..player.currentPosition:getY() ..")")
		end

	else
		print("Player has attempted to enter a restricted area at coords ("..x..","..y..")")
	end
end
player_metatab.__index = Player

--[[
	some free functions and data *********************
]]

local availableWorldObjects =
{
  ["knife"] = {WorldObject.new("knife")},
  ["potion"] = {WorldObject.new("potion")},
  ["cantrip"] = {WorldObject.new("cantrip")}
}

function getLevelData()
	local levelData = {}

	-- concatenate the x and y coords and use for key
	levelData["150150"] = LevelDataPoint.new(150, 150, {})
	levelData["150175"] = LevelDataPoint.new(150, 175, {})
	levelData["150200"] = LevelDataPoint.new(150, 200, {})
	levelData["150225"] = LevelDataPoint.new(150, 225, {})
	levelData["150250"] = LevelDataPoint.new(150, 250, {})
	levelData["150300"] = LevelDataPoint.new(150, 300, {})
	levelData["150350"] = LevelDataPoint.new(150, 350, {})

	levelData["175150"] = LevelDataPoint.new(175, 150, {})
	levelData["175175"] = LevelDataPoint.new(175, 175, {})
	levelData["175200"] = LevelDataPoint.new(175, 200, {})
	levelData["175225"] = LevelDataPoint.new(175, 225, {})
	levelData["175250"] = LevelDataPoint.new(175, 250, {})
	levelData["175300"] = LevelDataPoint.new(175, 300, {})
	levelData["175350"] = LevelDataPoint.new(175, 350, {})

	levelData["200150"] = LevelDataPoint.new(200, 150, {})
	levelData["200175"] = LevelDataPoint.new(200, 175, {})
	levelData["200200"] = LevelDataPoint.new(200, 200, {-- add 8 knives to (200, 200)
		availableWorldObjects["knife"],
		availableWorldObjects["knife"],
		availableWorldObjects["knife"],
		availableWorldObjects["knife"],
		availableWorldObjects["knife"],
		availableWorldObjects["knife"],
		availableWorldObjects["knife"],
		availableWorldObjects["knife"]})
	levelData["200225"] = LevelDataPoint.new(200, 225, {})
	levelData["200250"] = LevelDataPoint.new(200, 250, {})
	levelData["200300"] = LevelDataPoint.new(200, 300, {})
	levelData["200350"] = LevelDataPoint.new(200, 350, {})

	levelData["250150"] = LevelDataPoint.new(250, 150, {})
	levelData["250175"] = LevelDataPoint.new(250, 175, {})
	levelData["250200"] = LevelDataPoint.new(250, 200, {})
	levelData["250225"] = LevelDataPoint.new(250, 225, {})
	levelData["250250"] = LevelDataPoint.new(250, 250, {})
	levelData["250300"] = LevelDataPoint.new(250, 300, {})
	levelData["250350"] = LevelDataPoint.new(250, 350, {})

	levelData["300150"] = LevelDataPoint.new(300, 150, {})
	levelData["300175"] = LevelDataPoint.new(300, 175, {})
	levelData["300200"] = LevelDataPoint.new(300, 200, {}, false) -- player cannot go to (300, 200)
	levelData["300225"] = LevelDataPoint.new(300, 225, {})
	levelData["300250"] = LevelDataPoint.new(300, 250, {})
	levelData["300300"] = LevelDataPoint.new(300, 300, {})
	levelData["300350"] = LevelDataPoint.new(300, 350, {})

	levelData["350150"] = LevelDataPoint.new(350, 150, {})
	levelData["350175"] = LevelDataPoint.new(350, 175, {})
	levelData["350200"] = LevelDataPoint.new(350, 200, {})
	levelData["350225"] = LevelDataPoint.new(350, 225, {})
	levelData["350250"] = LevelDataPoint.new(350, 250, {})
	levelData["350300"] = LevelDataPoint.new(350, 300, {})
	levelData["350350"] = LevelDataPoint.new(350, 350, {})
	return levelData
end

--[[
	test runner *********************
]]

level = Level.new()
level.load(getLevelData()) -- lazily load level data
player1 = Player.new(1)
player1:regsiterLevel(level)
player1:teleport(200, 200) -- accessible, with 8 goodies
player1:teleport(200, 150) -- accessible
player1:pickup("potion") -- no items available
player1:teleport(300, 200) -- not accessible
player1:teleport(500, 200) -- out of world bounds
player1:teleport(200, 200) -- accessible, with 8 goodies
player1:pickup("knife") -- try to pick up 6 knives
player1:pickup("knife")
player1:pickup("knife")
player1:pickup("knife")
player1:pickup("knife")
player1:pickup("knife") -- backback full
player1:teleport(200, 225)

--[[
player2 = Player.new(2)
player2:regsiterLevel(level)
player2:teleport(200, 200)
player2:teleport(200, 150)
player2:pickup()
player2:teleport(300, 200)
player2:teleport(500, 200)
player2:teleport(200, 200)
]]




