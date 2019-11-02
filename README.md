# lua2D
A simple2D lua game with rudimentarytesting frameowrk and APIs for interacting with the game world and players.

Developed using SciTE Lua for Windows https://code.google.com/archive/p/luaforwindows/downloads.
Ensure lua is installed on your machine.
To run in Windows powershell: PS <DRIVE>:\<FILEPATH> lua .\testRunner.lua

Developer guide
Framework has been designed in a modular fashion to allow script writters to:

Lazially load any level data to a level. 
Easily configure and add game objects and items to data points in 2d space. 
Create new players. 
Register levels with players. 
Register the same level data with more than one player for simulating a multiplayer scenario. 
Move players around in 2D space. 
Pick up items and assign to players inventory. 
Drop items anywhere in the game world. 

Example:

level = Level.new()

level.load(someleveldata) -- lazily load level data

player1 = Player.new(1)

player1:regsiterLevel(level)

player1:teleport(200, 200)

player1:pickup("potion")

player1:teleport(300, 200)

player1:drop("potion")
