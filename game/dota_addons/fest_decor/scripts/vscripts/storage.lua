

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


function storage:SetGoodPoints(points)
	GoodTempPoints = points
end

function storage:SetBadPoints(points)
	BadTempPoints = points
end


function storage:GetGoodPoints()
	return GoodTempPoints
end

function storage:GetBadPoints()
	return BadTempPoints
end


storage:start()