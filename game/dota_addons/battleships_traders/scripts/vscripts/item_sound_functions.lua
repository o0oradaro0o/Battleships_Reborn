
function getEnemies(casterUnit, range, handles)

local enemies = FindUnitsInRadius(casterUnit:GetTeamNumber(), 
		casterUnit:GetOrigin(), 
		nil, 
		range, 
		handles.team, 
		handles.types, 
		handles.flags, 
		0, 
		false)

	return enemies
	
end


function poisonSound1(keys)
--Play sound for firing level-1 poison-type weapons

	local casterUnit = keys.caster
	local range = 900	
	local handles = {}
	handles.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	handles.types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_HERO
	handles.flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
		
	if #getEnemies(casterUnit,range,handles) > 0 then
		EmitSoundOnClient("Hero_VenomancerWard.Attack", PlayerResource:GetPlayer(casterUnit:GetPlayerID())) --PlayerResource:GetPlayer(playerID)
	end		
end

function poisonSound2(keys)
--Play sound for firing level-2 poison-type weapons

	local casterUnit = keys.caster
	local range = 900	
	local handles = {}
	handles.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	handles.types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_HERO
	handles.flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
		
	if #getEnemies(casterUnit,range,handles) > 0 then
		EmitSoundOnClient("Hero_Venomancer.Attack", PlayerResource:GetPlayer(casterUnit:GetPlayerID())) --PlayerResource:GetPlayer(playerID)
	end		
end

function poisonSound3(keys)
--Play sound for firing level-2 poison-type weapons

	local casterUnit = keys.caster
	local range = 900	
	local handles = {}
	handles.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	handles.types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_HERO
	handles.flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
		
	if #getEnemies(casterUnit,range,handles) > 0 then
		EmitSoundOnClient("Hero_Venomancer.Attack", PlayerResource:GetPlayer(casterUnit:GetPlayerID())) --PlayerResource:GetPlayer(playerID)
	end		
end