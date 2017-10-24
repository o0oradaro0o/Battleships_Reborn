

if storage == nil then
  print ( '[Timers] creating storage' )
  storage = {}
  storage.__index = storage
end

function storage:new( o )
  o = o or {}
  setmetatable( o, storage )
  return o
end

function storage:start() -- Runs whenever the itemFunctions.lua is ran
	print('[storage] itemFunctions started!')
	  storage = self
  self.storage = {}
end

GoodTempPoints = 0
BadTempPoints = 0


GoodStoredPoints = 20
BadStoredPoints = 20

function storage:AddGoodStoredPoints(points)
	GoodStoredPoints = GoodStoredPoints + 1
end

function storage:AddBadStoredPoints(points)
	BadStoredPoints = BadStoredPoints + 1
end


function storage:SetGoodPoints(points)
	GoodTempPoints = points
end

function storage:SetBadPoints(points)
	BadTempPoints = points
end


function storage:GetGoodPoints()
	return GoodTempPoints+GoodStoredPoints
end

function storage:GetBadPoints()
	return BadTempPoints+BadStoredPoints
end


storage:start()