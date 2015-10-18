
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
			EmitSoundOn("hero_jakiro.attack", casterUnit)
		elseif string.match(item, "ult") then--ultimate fire-type
			EmitSoundOn("Hero_Phoenix.Attack", casterUnit)
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

function fireSoundAura(keys)
--Play sound on units affected by fire ultimate burn.
	local casterUnit = keys.caster
	local targetUnit = keys.target

	if targetUnit ~= nil then
		EmitSoundOn("Hero_OgreMagi.Ignite.Damage", targetUnit)
	end

end

function plasmaSoundFire(keys)
--Play sound for firing plasma-type weapons
	
	local casterUnit = keys.caster
	local item = keys.ability:GetAbilityName() --ability is how item name is passed in
	local range = 800	 
	local handles = {}
	handles.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	handles.types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_HERO
	handles.flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
		
	if #getEnemies(casterUnit,range,handles) > 0 then
		if string.match(item, "two") then--level-2 plasma-type
			EmitSoundOn("Hero_VengefulSpirit.Attack", casterUnit) 
		elseif string.match(item, "three") then--level-3 plasma-type
			EmitSoundOn("Hero_Terrorblade_Morphed.Attack", casterUnit)
		elseif string.match(item, "ult") then--ultimate plasma-type
			EmitSoundOn("Hero_Zuus.ArcLightning.Target", casterUnit)
		else --level-1 plasma-type
			EmitSoundOn("Hero_Bane.Attack", casterUnit)
		end		
	end		
end

function plasmaSoundImpact(keys)
--Play sound for impacting plasma-type weapons
	local targetUnit = keys.target	
	--Very simple now. All plasma-type impacts have the same sound. 
	EmitSoundOn("Hero_VengefulSpirit.ProjectileImpact", targetUnit)	
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

	local targetUnit = keys.target
	local item = keys.ability:GetAbilityName() --ability is how item name is passed in
	
	if string.match(item, "ult") then --ultimate poison-type has a special impact
		EmitSoundOn("hero_viper.CorrosiveSkin", targetUnit)
	else --all other poison-type weapons share the same impact sound
		EmitSoundOn("Hero_VenomancerWard.ProjectileImpact", targetUnit)
	end

end 

function lightSoundFire(keys)
--Play sound for firing light-type weapons
	
	local casterUnit = keys.caster
	local item = keys.ability:GetAbilityName() --ability is how item name is passed in
	local range = 1000	 
	local handles = {}
	handles.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	handles.types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_HERO
	handles.flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
		
	if #getEnemies(casterUnit,range,handles) > 0 then
		if string.match(item, "two") then--level-2 light-type
			EmitSoundOn("Hero_Puck.Attack", casterUnit) 			
		elseif string.match(item, "three") then--level-3 light-type
			EmitSoundOn("Hero_KeeperOfTheLight.Attack", casterUnit)
		elseif string.match(item, "ult") then--ultimate light-type
			EmitSoundOn("Hero_SkywrathMage.Attack", casterUnit)
		else --level-1 light-type
			EmitSoundOn("ShadowShaman_Ward.Attack", casterUnit)
		end		
	end		
end

function lightSoundImpact(keys)
--Play sound for impacting light-type weapons
	local targetUnit = keys.target	
	--Very simple now. All light-type impacts have the same sound. 
	EmitSoundOn("Hero_SkywrathMage.ProjectileImpact", targetUnit)		
end 

function iceSoundFire(keys)
--Play sound for firing ice-type weapons
	
	local casterUnit = keys.caster
	local item = keys.ability:GetAbilityName() --ability is how item name is passed in
	local range = 1200
	local handles = {}
	handles.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	handles.types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_HERO
	handles.flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
		
	if #getEnemies(casterUnit,range,handles) > 0 then
		if string.match(item, "two") then--level-2 ice-type
			EmitSoundOn("Hero_Lich.Attack", casterUnit) 			
		elseif string.match(item, "three") then--level-3 ice-type
			EmitSoundOn("Hero_Ancient_Apparition.Attack", casterUnit)
		elseif string.match(item, "ult") then--ultimate ice-type
			EmitSoundOn("Hero_Ancient_Apparition.Attack", casterUnit)
			Timers:CreateTimer( 0.05, function()
				EmitSoundOn("Hero_Ancient_Apparition.IceBlastRelease.Tick", casterUnit)
			end)			
		else --level-1 ice-type
			EmitSoundOn("hero_Crystal.attack", casterUnit)
		end		
	end		
end