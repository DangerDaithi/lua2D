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

function LevelDataPoint.new(x, y, isPlayerAccesible, worldObjects)
	local info = {}
	info.x = x
	info.y = y
	if isPlayerAccesible == nil then -- bit smelly setting default value like this
		isPlayerAccesible = true
	end
	info.worldObjects = worldObjects
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

level_metatab.__index = Level


--[[
	the player class *********************
]]
Player = {}
local player_metatab = {}

function Player.new(id, level)
	local info = {}
	info.id = id
	info.level = level
	setmetatable(info, player_metatab)
	return info
end

function Player.getPlayerid(player)
	return player.id
end

function Player:regsiterLevel(level)
	player_metatab.level = level

end

function Player:getLevel()
	return player_metatab.level
end

player_metatab.__index = Player


--[[
	some free functions *********************
]]

function getLevelData()
	local levelData = {}
	table.insert(levelData, LevelDataPoint.new(150, 150))
	table.insert(levelData, LevelDataPoint.new(150, 175))
	table.insert(levelData, LevelDataPoint.new(150, 200))
	table.insert(levelData, LevelDataPoint.new(150, 225))
	table.insert(levelData, LevelDataPoint.new(150, 250))
	table.insert(levelData, LevelDataPoint.new(150, 300))
	table.insert(levelData, LevelDataPoint.new(150, 350))
	table.insert(levelData, LevelDataPoint.new(175, 150))
	table.insert(levelData, LevelDataPoint.new(175, 175))
	table.insert(levelData, LevelDataPoint.new(175, 200))
	table.insert(levelData, LevelDataPoint.new(175, 225))
	table.insert(levelData, LevelDataPoint.new(175, 250))
	table.insert(levelData, LevelDataPoint.new(175, 300))
	table.insert(levelData, LevelDataPoint.new(175, 350))
	table.insert(levelData, LevelDataPoint.new(200, 150))
	table.insert(levelData, LevelDataPoint.new(200, 175))
	table.insert(levelData, LevelDataPoint.new(200, 200))
	table.insert(levelData, LevelDataPoint.new(200, 225))
	table.insert(levelData, LevelDataPoint.new(200, 250))
	table.insert(levelData, LevelDataPoint.new(200, 300))
	table.insert(levelData, LevelDataPoint.new(200, 350))
	table.insert(levelData, LevelDataPoint.new(250, 150))
	table.insert(levelData, LevelDataPoint.new(250, 175))
	table.insert(levelData, LevelDataPoint.new(250, 200))
	table.insert(levelData, LevelDataPoint.new(250, 225))
	table.insert(levelData, LevelDataPoint.new(250, 250))
	table.insert(levelData, LevelDataPoint.new(250, 300))
	table.insert(levelData, LevelDataPoint.new(250, 350))
	table.insert(levelData, LevelDataPoint.new(300, 150))
	table.insert(levelData, LevelDataPoint.new(300, 175))
	table.insert(levelData, LevelDataPoint.new(300, 200, false)) -- player cannot go to (300, 200)
	table.insert(levelData, LevelDataPoint.new(300, 225))
	table.insert(levelData, LevelDataPoint.new(300, 250))
	table.insert(levelData, LevelDataPoint.new(300, 300))
	table.insert(levelData, LevelDataPoint.new(300, 350))
	table.insert(levelData, LevelDataPoint.new(350, 150))
	table.insert(levelData, LevelDataPoint.new(350, 175))
	table.insert(levelData, LevelDataPoint.new(350, 200))
	table.insert(levelData, LevelDataPoint.new(350, 225))
	table.insert(levelData, LevelDataPoint.new(350, 250))
	table.insert(levelData, LevelDataPoint.new(350, 300))
	table.insert(levelData, LevelDataPoint.new(350, 350))
	return levelData
end


--[[
	test runner *********************
]]

level = Level.new()
level.load(getLevelData()) -- lazily load level data
-- print(table.getn(getLevelData()))
--[[
for _,datapoint in ipairs(getLevelData()) do
        print(datapoint:playerAccesible())
		print(datapoint:getX().. ", ".. datapoint:getY())
end

]]

player1 = Player.new(1)
player1:regsiterLevel(level)





