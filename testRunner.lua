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

function Player.drop(player, name)
	if table.getn(player.backpack) == 0 then
		print("Player with id ".. player:getPlayerid() .. " has attmepted to drop an item, but players backpack is empty. Pickup an item first")
		return
	end

	local exists = false
	local index = 0
	for k, v in pairs(player.backpack) do
		if v.name == name then
			index = index + 1
			exists = true
			table.insert(player.currentPosition.worldObjects, v)
			break
		end
	end
	if exists then -- cleanup players backback
		table.remove(player.backpack, index)
	else
		print("Player with id ".. player:getPlayerid() .. " has attempted to drop a " .. name .. " at coords ("..player.currentPosition:getX()..","..player.currentPosition:getY() .."), but plcayer does not have a ".. name .. " in their backpack")
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

function Player.getBackpack(player)
	return player.backpack
end
player_metatab.__index = Player


--[[
	some free functions and game data *********************
]]

local availableWorldObjects =
{
  ["knife"] = {WorldObject.new("knife")},
  ["potion"] = {WorldObject.new("potion")},
  ["cantrip"] = {WorldObject.new("cantrip")}
}

function cookLevelData()
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

	levelData["200150"] = LevelDataPoint.new(200, 150, {
		availableWorldObjects["potion"]
	})
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

	levelData["225150"] = LevelDataPoint.new(225, 150, {})
	levelData["225175"] = LevelDataPoint.new(225, 175, {})
	levelData["225200"] = LevelDataPoint.new(225, 200, {})
	levelData["225225"] = LevelDataPoint.new(225, 225, {})
	levelData["225250"] = LevelDataPoint.new(225, 250, {})
	levelData["225300"] = LevelDataPoint.new(225, 300, {})
	levelData["225350"] = LevelDataPoint.new(225, 350, {})

	levelData["250150"] = LevelDataPoint.new(250, 150, {})
	levelData["250175"] = LevelDataPoint.new(250, 175, {})
	levelData["250200"] = LevelDataPoint.new(250, 200, {})
	levelData["250225"] = LevelDataPoint.new(250, 225, {})
	levelData["250250"] = LevelDataPoint.new(250, 250, {})
	levelData["250300"] = LevelDataPoint.new(250, 300, {
		availableWorldObjects["cantrip"]})
	levelData["250350"] = LevelDataPoint.new(250, 350, {})

	levelData["275150"] = LevelDataPoint.new(275, 150, {})
	levelData["275175"] = LevelDataPoint.new(275, 175, {})
	levelData["275200"] = LevelDataPoint.new(275, 200, {})
	levelData["275225"] = LevelDataPoint.new(275, 225, {})
	levelData["275250"] = LevelDataPoint.new(275, 250, {})
	levelData["275300"] = LevelDataPoint.new(275, 300, {})
	levelData["275350"] = LevelDataPoint.new(275, 350, {})

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

function printPlayerBackpackContents(id, backpack)

	print("Player with id " .. id .. " has " .. table.getn(backpack) .. " items currently in backpack")
	for k, v in pairs(backpack) do
		print(v.name)
	end
end

--[[
	******************test runner *********************
]]

level = Level.new()
level.load(cookLevelData()) -- lazily load level data

--[[
	player 1 tests
]]

print("\nPLAYER 1 TEST CASES")
player1 = Player.new(1)
player1:regsiterLevel(level)

player1:teleport(200, 200) -- accessible, with 8 goodies
player1:teleport(200, 150) -- accessible

player1:teleport(300, 200) -- not accessible
player1:teleport(200, 200) -- accessible, with 8 goodies
player1:pickup("knife") -- try to pick up 6 knives
player1:pickup("knife")
player1:pickup("knife")
player1:pickup("knife")
player1:pickup("knife")
printPlayerBackpackContents(player1:getPlayerid(), player1:getBackpack())
player1:pickup("knife") -- backback full!

player1:teleport(225, 200)
player1:drop("knife") -- drop 3 knives
player1:drop("knife")
player1:drop("knife")
printPlayerBackpackContents(player1:getPlayerid(), player1:getBackpack())

player1:teleport(200, 150)
player1:pickup("potion") -- pickup a single potion
printPlayerBackpackContents(player1:getPlayerid(), player1:getBackpack())

--[[
	Console output for player1:

	PLAYER 1 TEST CASES
	Player with id 1 has moved from (0,0) to (200,200)
	There are 8 available items at location (200,200)
	Player with id 1 has moved from (200,200) to (200,150)
	There are 1 available items at location (200,150)
	Player has attempted to enter a restricted area at coords (300,200)
	Player with id 1 has moved from (200,150) to (200,200)
	There are 8 available items at location (200,200)
	Player with id 1 has 5 items currently in backpack
	knife
	knife
	knife
	knife
	knife
	Player with id 1 has attmepted to pick up an item, but players backpack is full. Drop items first
	Player with id 1 has moved from (200,200) to (225,200)
	Player with id 1 has 2 items currently in backpack
	knife
	knife
	Player with id 1 has moved from (225,200) to (200,150)
	There are 1 available items at location (200,150)
	Player with id 1 has 3 items currently in backpack
	knife
	knife
	potion
]]

--[[
	player 2 tests - shares the same level data as player1
]]

print("\nPLAYER 2 TEST CASES")
player2 = Player.new(2)
player2:regsiterLevel(level) -- share the same level data as player1!
player2:teleport(200, 200)
player2:teleport(200, 150)
player2:teleport(300, 200)
player2:teleport(500, 200) -- attempt to move out of bounds of game world
player2:teleport(200, 200) -- pickup the remaining knives that player 1 didn't pickup
player2:pickup("knife")
player2:pickup("knife")
player2:pickup("knife")
player2:pickup("knife") -- no more items left to pickup
printPlayerBackpackContents(player2:getPlayerid(), player2:getBackpack())

--[[
	Console output for player2:

	PLAYER 2 TEST CASES
	Player with id 2 has moved from (0,0) to (200,200)
	There are 3 available items at location (200,200)
	Player with id 2 has moved from (200,200) to (200,150)
	Player has attempted to enter a restricted area at coords (300,200)
	Player with id 2 has attempted to stray out of the permitted world bounds at (500,200)
	Player with id 2 has moved from (200,150) to (200,200)
	There are 3 available items at location (200,200)
	Player with id 2 has attempted to pick up an item at coords (200,200), but there are no items available at this position
	Player with id 2 has 3 items currently in backpack
	knife
	knife
	knife
]]


--[[
	player 3 tests - loads an entirely new level with fresh game data
]]

print("\nPLAYER 3 TEST CASES")
newLevel = Level.new()
newLevel.load(cookLevelData())
player3 = Player.new(3)
player3:regsiterLevel(newLevel) -- new freshly cooked level data
player3:teleport(275, 250)
player3:teleport(200, 150)
player3:teleport(275, 200)
player3:teleport(500, 200) -- attempt to move out of bounds of game world
player3:teleport(200, 150)
player3:pickup("potion") -- pickup a single potion
player3:teleport(250, 300)
player3:pickup("cantrip") -- pickup a single potion
printPlayerBackpackContents(player3:getPlayerid(), player3:getBackpack())

--[[
	Console output for player3:

	PLAYER 3 TEST CASES
	Player with id 3 has moved from (0,0) to (275,250)
	Player with id 3 has moved from (275,250) to (200,150)
	There are 1 available items at location (200,150)
	Player with id 3 has moved from (200,150) to (275,200)
	Player with id 3 has attempted to stray out of the permitted world bounds at (500,200)
	Player with id 3 has moved from (275,200) to (200,150)
	There are 1 available items at location (200,150)
	Player with id 3 has moved from (200,150) to (250,300)
	There are 1 available items at location (250,300)
	Player with id 3 has 2 items currently in backpack
	potion
	cantrip
]]
