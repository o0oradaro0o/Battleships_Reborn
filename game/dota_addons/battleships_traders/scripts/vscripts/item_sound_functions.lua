
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

function fireSoundFire(keys)
--Play sound for firing fire-type weapons
	
	local casterUnit = keys.caster
	local item = keys.ability:GetAbilityName() --ability is how item name is passed in
	local range = 700	 
	local handles = {}
	handles.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	handles.types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_HERO
	handles.flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
		
	if #getEnemies(casterUnit,range,handles) > 0 then
		if string.match(item, "two") then--level-2 fire-type
			EmitSoundOn("Hero_Lina.attack", casterUnit) 
		elseif string.match(item, "three") then--level-3 fire-type
			EmitSoundOn("Hero_Clinkz.SearingArrows", casterUnit)
		elseif string.match(item, "ult") then--ultimate fire-type
			EmitSoundOn("hero_jakiro.attack", casterUnit)
		else --level-1 fire-type
			EmitSoundOn("hero_jakiro.wing_movement", casterUnit)
		end		
	end		
end

function fireSoundImpact(keys)
--Play sound for impacting fire-type weapons
	local targetUnit = keys.target	
	--Very simple now. All fire-type impacts have the same sound. 
	--The fire-type ult has a burn sound for the aura in a different function. 
	EmitSoundOn("Hero_Lina.ProjectileImpact", targetUnit)	
end 

function fireAuraBurn(keys)
--Play sound on units affected by fire ultimate burn.
	local casterUnit = keys.caster
	local targetUnit = keys.target

	if targetUnit ~= nil then
		EmitSoundOn("Hero_OgreMagi.Ignite.Damage", targetUnit)
	end

end

function poisonSoundFire(keys)
--Play sound for firing poison-type weapons
	
	local casterUnit = keys.caster
	local item = keys.ability:GetAbilityName() --ability is how item name is passed in
	local range = 900	 
	local handles = {}
	handles.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	handles.types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_HERO
	handles.flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
		
	if #getEnemies(casterUnit,range,handles) > 0 then
		if string.match(item, "two") then--level-2 poison-type
			EmitSoundOn("Hero_VenomancerWard.Attack", casterUnit) 			
		elseif string.match(item, "three") then--level-3 poison-type
			EmitSoundOn("hero_viper.attack", casterUnit)
		elseif string.match(item, "ult") then--ultimate poison-type
			EmitSoundOn("hero_viper.PoisonAttack.Target", casterUnit)
		else --level-1 poison-type
			EmitSoundOn("Hero_Venomancer.Attack", casterUnit)
		end		
	end		
end

function poisonSoundImpact(keys)
--Play sound for impacting poison-type weapons

--Very simple now. All poison-type impacts have the same sound. 	
	local targetUnit = keys.target
	EmitSoundOn("Hero_VenomancerWard.ProjectileImpact", targetUnit)

end 

