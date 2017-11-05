

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


GoodStoredPoints = 0
BadStoredPoints = 0

function storage:AddGoodStoredPoints(points)
	print("points added : " .. points)
	print("GoodStoredPoints: " .. GoodStoredPoints)
	GoodStoredPoints = GoodStoredPoints + points
end

function storage:AddBadStoredPoints(points)
print("points added : " .. points)
print("BadStoredPoints: " .. BadStoredPoints)
	BadStoredPoints = BadStoredPoints + points
end


function storage:SetGoodPoints(points)
	GoodTempPoints = points
end

function storage:SetBadPoints(points)
	BadTempPoints = points
end



function storage:GetGoodStoredPoints()
	return GoodStoredPoints
end

function storage:GetBadStoredPoints()
	return BadStoredPoints
end


function storage:GetGoodPoints()
	return GoodTempPoints+GoodStoredPoints
end

function storage:GetBadPoints()
	return BadTempPoints+BadStoredPoints
end


storage:start()