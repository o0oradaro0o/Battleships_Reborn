--[[
Gyrocopter AI
]]

require( "ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
end

function AIThink()
	if thisEntity:IsNull() or not thisEntity:IsAlive() then
		return nil
	end

	if not IsValidAlive(thisEntity.target) then
		thisEntity.target = ChooseTarget()
	end

	if not IsValidAlive(thisEntity.target) then
		thisEntity:Stop()
		thisEntity:StartGesture(ACT_DOTA_SPAWN)
		return 0.25
	end

	thisEntity:MoveToNPC(thisEntity.target)

	return 0.25
end

-- Choose the closest enemy hero, and go for them
function ChooseTarget()
	local enemyHeroes = FindUnitsInRadius(
		DOTA_TEAM_NEUTRALS,
		thisEntity:GetOrigin(),
		nil,
		FIND_UNITS_EVERYWHERE,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		FIND_CLOSEST,
		false)

	-- filter out any crabs
	local enemies = {}
	for _, enemy in pairs(enemyHeroes) do
		if enemy:GetUnitName() ~= "npc_dota_hero_nyx_assassin" then
			table.insert(enemies, enemy)
		end
	end

	if #enemies == 0 then
		return nil
	end

	return GetRandomTableElement(enemies)
end