--[[
Gyrocopter AI
]]

require( "ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
	behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorRun, BehaviorLaunchMissile, CastUlt, BehaviorThrowHook } )
end

function AIThink()
	if thisEntity:IsNull() or not thisEntity:IsAlive() then
		return nil -- deactivate this think function
	end
	return behaviorSystem:Think()
end

--------------------------------------------------------------------------------------------------------

function CollectRetreatMarkers()
	local result = {}
	local i = 1
	local wp = nil
	while true do
		wp = Entities:FindByName( nil, string.format("tide_%d", i ) )
		if not wp then
			return result
		end
		local position = wp:GetOrigin()
		position.z = 0
		table.insert( result, position )
		i = i + 1
	end
end
POSITIONS_retreat = CollectRetreatMarkers()

BehaviorRun =
{
	order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = POSITIONS_retreat[ RandomInt(1, #POSITIONS_retreat) ],
	}
}

function BehaviorRun:Evaluate()
	return 2 -- must return a value > 0, so we have a default
end

function BehaviorRun:Initialize()
end

function BehaviorRun:Begin()
	self.endTime = GameRules:GetGameTime() + 1
end

function BehaviorRun:Continue()
	self.endTime = GameRules:GetGameTime() + 1
end

function BehaviorRun:Think(dt)
	local currentPos = thisEntity:GetOrigin()
	currentPos.z = 0

	if ( self.order.Position - currentPos ):Length() < 500 then
		self.order.Position = POSITIONS_retreat[ RandomInt(1, #POSITIONS_retreat) ]
	end
end

--------------------------------------------------------------------------------------------------------

BehaviorLaunchMissile = {}

function BehaviorLaunchMissile:Evaluate()
	self.ability = thisEntity:FindAbilityByName("tidehunter_gush_battleship")
	local target
	local desire = 0

	if self.ability and self.ability:IsFullyCastable() and self.ability:GetCooldownTimeRemaining() < 1 then
			local allEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
			local allEnemies2 = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, thisEntity:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
		for k,v in pairs(allEnemies2) do allEnemies[k] = v end
		
		if #allEnemies > 0 then
			target = allEnemies[RandomInt( 1, #allEnemies )]
		end
	end

	if target and target~=thisEntity then
		desire = 5
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			UnitIndex = thisEntity:entindex(),
			TargetIndex = target:entindex(),
			AbilityIndex = self.ability:entindex()
		}
	end

	return desire
end

function BehaviorLaunchMissile:Begin()
	self.endTime = GameRules:GetGameTime() + 5
end

BehaviorLaunchMissile.Continue = BehaviorLaunchMissile.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

function BehaviorLaunchMissile:Think(dt)
	if not self.ability:IsFullyCastable() and not self.ability:IsInAbilityPhase() then
		self.endTime = GameRules:GetGameTime()
	end
end

--------------------------------------------------------------------------------------------------------

CastUlt = {}

function CastUlt:Evaluate()
	self.ultability = thisEntity:FindAbilityByName("tidehunter_ravage_battleship")
	local target
	local desire = 0

	if self.ultability and self.ultability:IsFullyCastable() and self.ultability:GetCooldownTimeRemaining() < 1 then
		local allEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
		local allEnemies2 = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
		for k,v in pairs(allEnemies2) do allEnemies[k] = v end
		
		if #allEnemies > 0 then
			target = allEnemies[RandomInt( 1, #allEnemies )]
		end
		
	end

	if target  and target~=thisEntity then
		desire = 6
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.ultability:entindex()
		}
	end

	return desire
end

function CastUlt:Begin()
	self.endTime = GameRules:GetGameTime() + 5
end

CastUlt.Continue = BehaviorLaunchMissile.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset


--------------------------------------------------------------------------------------------------------
BehaviorThrowHook = {}

function BehaviorThrowHook:Evaluate()
	local desire = 0
	
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.hookAbility = thisEntity:FindAbilityByName( "pudge_meat_hook_battleship_tide" )
	
	if self.hookAbility and self.hookAbility:IsFullyCastable() and self.hookAbility:GetCooldownTimeRemaining() < 1 then
		local allEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
		local allEnemies2 = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, thisEntity:GetOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
		for k,v in pairs(allEnemies2) do allEnemies[k] = v end
		
		if #allEnemies > 0 then
			target = allEnemies[RandomInt( 1, #allEnemies )]
		end
		local targetPoint = target:GetOrigin()
		if target then
			if target:GetTeamNumber() == DOTA_TEAM_GOODGUYS or target:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				desire = 7
				self.order =
				{
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					UnitIndex = thisEntity:entindex(),
					AbilityIndex = self.hookAbility:entindex(),
					Position = targetPoint
				}
			end
		end
	end

	return desire
end

function BehaviorThrowHook:Begin()
	self.endTime = GameRules:GetGameTime() + 1


end

BehaviorThrowHook.Continue = BehaviorThrowHook.Begin




