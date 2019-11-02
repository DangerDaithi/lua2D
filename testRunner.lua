--[[
	LevelDataPoint class
]]

--[[
LevelDataPoint = {x = 0, y = 0, worldobjects = {}, isPlayerAccesible = false}

function LevelDataPoint:new(o, x, y, isPlayerAccesible)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.x = x
	self.y = y
	self.worldobjects = worldobjects
	self.isPlayerAccesible = isPlayerAccesible
	return o
end

]]


--[[
	the level datapoint class
]]

LevelDataPoint = {}
local levelDataPoint_metatab = {}

function LevelDataPoint.new(x, y, isPlayerAccesible)
	local info = {}
	info.x = x
	info.y = y
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

levelDataPoint_metatab.__index = LevelDataPoint

--[[
	the level class
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
	the player class
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
	some free functions
]]

function tableLength(T)
	local count = 0
	  for _ in pairs(T) do count = count + 1 end
	  return count
end


--[[
	test runner
]]

levelData = {}
table.insert(levelData, LevelDataPoint.new(50, 75))

level = Level.new()
level.load(levelData)

player1 = Player.new(2)
player1:regsiterLevel("a level")




