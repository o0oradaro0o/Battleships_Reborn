if abilityFunctions == nil then
	 ----print("[AbilityFunctions] creating abilityFunctions")
	abilityFunctions = {} -- Creates an array to let us beable to index abilityFunctions when creating new functions
	abilityFunctions.__index = abilityFunctions
end

function abilityFunctions:new() -- Creates the new class
	 ----print("[AbilityFunctions] abilityFunctions:new")
	o = o or {}
	setmetatable(o, abilityFunctions)
	return o
end

function abilityFunctions:start() -- Runs whenever the abilityFunctions.lua is ran
	 ----print("[AbilityFunctions] abilityFunctions started!")
end

function battleshipHealth(args)
end

function route(args)
	args.caster:MoveToPositionAggressive(args.target_points[1])
end

function removeAircrafts(keys)
	local casterUnit = keys.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	casterUnit:SetModel("models/Aircraft_boat_e.vmdl")
	casterUnit:SetOriginalModel("models/Aircraft_boat_e.vmdl")
end

function restoreAircrafts(keys)
	local casterUnit = keys.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	casterUnit:SetModel("models/Aircraft_boat2.vmdl")
	casterUnit:SetOriginalModel("models/Aircraft_boat2.vmdl")
end

function startDisco(keys) -- keys is the information sent by the ability
	local casterUnit = EntIndexToHScript(keys.caster_entindex) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	GiveVisionOfUnit(casterUnit)
end

function GiveVisionOfUnit(unit)
	unit:MakeVisibleDueToAttack(1,50)
	unit:MakeVisibleDueToAttack(2,50)
	unit:MakeVisibleDueToAttack(3,50)
	unit:MakeVisibleDueToAttack(4,50)
end

function ShowShip(keys) -- keys is the information sent by the ability
	local casterUnit = EntIndexToHScript(keys.caster_entindex) -- EntIndexToHScript takes
	local ability = keys.ability

	local enemies
	 ----print("[AbilityFunctions] ShowShip  Called")
	if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		enemies =
			FindUnitsInRadius(
			DOTA_TEAM_BADGUYS,
			casterUnit:GetOrigin(),
			nil,
			100000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			0,
			0,
			false
		)
	else
		enemies =
			FindUnitsInRadius(
			DOTA_TEAM_GOODGUYS,
			casterUnit:GetOrigin(),
			nil,
			100000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			0,
			0,
			false
		)
	end
	local fuckerWeShow
	local fuckerdist = 100000
	for _, fucker in pairs(enemies) do
		local heroDist = fucker:GetAbsOrigin() - casterUnit:GetAbsOrigin()

		if heroDist:Length() < fuckerdist then
			fuckerdist = heroDist:Length()
			fuckerWeShow = fucker
			 ----print("[AbilityFunctions] ShowShip  nearest is: " .. fuckerdist)
		end
	end
	local tracking_projectile = {
		EffectName = "particles/basic_projectile/hit_projectile.vpcf",
		Ability = ability,
		vSpawnOrigin = casterUnit:GetAbsOrigin(),
		Target = fuckerWeShow,
		Source = casterUnit,
		bHasFrontalCone = false,
		iMoveSpeed = 600,
		bReplaceExisting = false,
		bProvidesVision = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	}
	ProjectileManager:CreateTrackingProjectile(tracking_projectile)
	-- apply the armor debuff
	ability:ApplyDataDrivenModifier(casterUnit, fuckerWeShow, "hit_dearmor", {duration = 3})

	local visionTime = 0
	local visionTickRate = .2
	local visionDuration = 3

	Timers:CreateTimer(function()
		GiveVisionOfUnit(fuckerWeShow)

		visionTime = visionTime + visionTickRate

		if visionTime < visionDuration then
			return visionTickRate
		else
			return
		end
	end)
end

function peak(keys) -- keys is the information sent by the ability
	 ----print("[AbilityFunctions] peak  Called")
	local casterUnit = EntIndexToHScript(keys.caster_entindex)

	for _, hero in pairs(Entities:FindAllByClassname("npc_dota_hero*")) do
		 ----print("[ItemFunctions] peak found a hero!")
		if hero ~= nil and hero:IsRealHero() and casterUnit:GetTeam() ~= hero:GetTeam() then
			local casterPosition = casterUnit:GetAbsOrigin()
			local heroPosition = hero:GetAbsOrigin()
			local distance = (casterPosition - heroPosition):Length()
			if distance < 5000 then
				hero:MakeVisibleDueToAttack(1,50)
				hero:MakeVisibleDueToAttack(2,50)
				hero:MakeVisibleDueToAttack(3,50)
				hero:MakeVisibleDueToAttack(4,50)
				Timers:CreateTimer(
					.2,
					function()
						hero:MakeVisibleDueToAttack(1,50)
						hero:MakeVisibleDueToAttack(2,50)
						hero:MakeVisibleDueToAttack(3,50)
						hero:MakeVisibleDueToAttack(4,50)
					end
				)
			end
		end
	end
end

function rammingIt(args)
	local casterUnit = args.caster
	local ability = args.ability
	if not IsPhysicsUnit(casterUnit) then
		Physics:Unit(casterUnit)
	end

	-- Accelerate
	local direction = casterUnit:GetForwardVector()
	local level = ability:GetLevel()
	local vec = direction:Normalized() * (15 * level + 95)
	casterUnit:AddPhysicsVelocity(vec)
end

function rammingSpeedKnockback(args)
	local casterUnit = args.caster
	local ability = args.ability

	local radius = ability:GetSpecialValueFor("knockback_radius")
	local damage = ability:GetSpecialValueFor("damage")
	local duration = 0.5
	local knockback_duration = 0.5
	local knockback_distance = 143
	local knockback_height = 50
	-- Apply Knockback and damage
	local enemies = FindUnitsInRadius(
		casterUnit:GetTeam(),
		casterUnit:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false)

	knockback_properties = {
		center_x = casterUnit:GetAbsOrigin().x,
		center_y = casterUnit:GetAbsOrigin().y,
		center_z = casterUnit:GetAbsOrigin().z,
		duration = duration,
		knockback_duration = knockback_duration,
		knockback_distance = knockback_distance,
		knockback_height 	= knockback_height,
	}

	for _,enemy in pairs(enemies) do
		if not ability.pushed_units[enemy:GetEntityIndex()] then
			enemy:AddNewModifier(casterUnit, ability, "modifier_knockback", knockback_properties)

			ApplyDamage({
				victim = enemy,
				attacker = casterUnit,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL
			})

			ability.pushed_units[enemy:GetEntityIndex()] = true
		end
	end
end

function startRammingIt(args)
	local casterUnit = args.caster
	local ability = args.ability
	local level = ability:GetLevel()

	ability.pushed_units = {}

	StartAnimation(casterUnit, {duration = 2.2, activity = ACT_SCRIPT_CUSTOM_1, rate = (level + 2) / 4})
end

function DrumbAnimate(args)
	local casterUnit = args.caster

	local abil = casterUnit:GetAbilityByIndex(2)
	local level = abil:GetLevel()
	StartAnimation(casterUnit, {duration = 2.2 + .3 * level, activity = ACT_DOTA_RUN, rate = 1.5})
end

dumpingItDir = {}
function dumpingIt(args) 
	local casterUnit = args.caster
	if dumpingItDir[casterUnit] == nil or dumpingItDir[casterUnit] == 0 then
		dumpingItDir[casterUnit] = casterUnit:GetForwardVector()
	end

	if not IsPhysicsUnit(casterUnit) then
		Physics:Unit(casterUnit)
	end

	local direction = casterUnit:GetForwardVector()
	local abil = casterUnit:GetAbilityByIndex(3)
	local level = abil:GetLevel()
	local vec = direction:Normalized() * (100 * level + 300)
	casterUnit:SetPhysicsVelocity(vec)
end
function clearDir(args)
	local casterUnit = args.caster
	dumpingItDir[casterUnit] = 0
end

oneshots = {
	"item_oneshot_mango",
	"item_oneshot_scope",
	"item_oneshot_camo",
	"item_oneshot_chain",
	"item_oneshot_trap",
	"item_oneshot_booze",
	"item_oneshot_good_stuff",
	"item_oneshot_luck",
	"item_oneshot_firecrackers",
	"item_oneshot_sun_screen",
	"item_oneshot_earth",
	"item_oneshot_line",
	"item_oneshot_fish",
	"item_oneshot_power",
	"item_oneshot_brew",
	"item_oneshot_ham",
	"item_oneshot_info",
	"item_oneshot_net",
	"item_oneshot_sand"
}
function dumpingItem(args)
	local casterUnit = args.caster
	local a = RandomInt(1, 3)
	if a == 1 then
		local newItem = CreateItem(oneshots[RandomInt(1, #oneshots)], nil, nil)
		local drop = CreateItemOnPositionForLaunch(casterUnit:GetOrigin(), newItem)
		local direction = casterUnit:GetForwardVector()
		local vec = direction:Normalized() * -200
		newItem:LaunchLootInitialHeight(false, 0, 300, 0.75, casterUnit:GetOrigin() + vec)
	elseif a == 2 then
		local newItem = CreateItem(oneshots[RandomInt(1, #oneshots)], nil, nil)
		local drop = CreateItemOnPositionForLaunch(casterUnit:GetOrigin(), newItem)
		local direction = casterUnit:GetForwardVector()
		local vec = direction:Normalized() * -200
		newItem:LaunchLootInitialHeight(false, 0, 300, 0.75, casterUnit:GetOrigin() + vec)
	else
	end
end
function giveGold(args)
	local casterUnit = args.caster
	local herogold = casterUnit:GetGold()
	casterUnit:SetGold(herogold + 100, true)
	casterUnit:SetGold(0, false)
end

GunTicks = {}
function gunningIt(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	if not IsPhysicsUnit(casterUnit) then
		Physics:Unit(casterUnit)
	end
	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local direction = casterUnit:GetForwardVector()
	local abil = casterUnit:GetAbilityByIndex(2)
	local level = abil:GetLevel()
	local vec = direction:Normalized() * (20 * level + 40)
	casterUnit:AddPhysicsVelocity(vec)
	if GunTicks[casterUnit:GetOwner():GetPlayerID()] ~= nil then
		GunTicks[casterUnit:GetOwner():GetPlayerID()] = GunTicks[casterUnit:GetOwner():GetPlayerID()] + 1
		casterUnit:RemoveModifierByName("remove_wreaking_it")
		abil:ApplyDataDrivenModifier(casterUnit, casterUnit, "wreaking_it", nil)
	else
		GunTicks[casterUnit:GetOwner():GetPlayerID()] = 1
		casterUnit:RemoveModifierByName("remove_wreaking_it")
		abil:ApplyDataDrivenModifier(casterUnit, casterUnit, "wreaking_it", nil)
	end
end

function startGunningIt(args)
	local casterUnit = args.caster
	GunTicks[casterUnit:GetOwner():GetPlayerID()] = 1
end

function stopGunningIt(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	local direction = casterUnit:GetForwardVector()
	local vec = direction:Normalized() * 0.0

	Physics:Unit(casterUnit)

	casterUnit:SetPhysicsAcceleration(vec)
	casterUnit:RemoveModifierByName("wreaking_it")
end

function gunningItDamage(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')

	local casterUnit = args.caster
	if GunTicks[casterUnit:GetOwner():GetPlayerID()] ~= nil and GunTicks[casterUnit:GetOwner():GetPlayerID()] > 0 then
		-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local abil = casterUnit:GetAbilityByIndex(2)
		local level = abil:GetLevel()
		local dmg = casterUnit:GetMaxHealth() * 0.0005 * GunTicks[casterUnit:GetOwner():GetPlayerID()]

		local damageTable = {
			victim = casterUnit,
			attacker = casterUnit,
			damage = dmg,
			damage_type = DAMAGE_TYPE_PURE
		}

		ApplyDamage(damageTable)
	else
		casterUnit:RemoveModifierByName("wreaking_it")
		casterUnit:RemoveModifierByName("remove_wreaking_it")
	end
end

function PistolDamage(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	local abil = casterUnit:GetAbilityByIndex(0)
	local level = abil:GetLevel()
	local targetUnit = args.target
	local dmg = casterUnit:GetMaxHealth() * 0.00075 * level + (1.7 * level)
	local damageTable = {
		victim = targetUnit,
		attacker = casterUnit,
		damage = dmg,
		damage_type = DAMAGE_TYPE_PURE
	}

	ApplyDamage(damageTable)
end

function unstick(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local hero = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	local direction = hero:GetForwardVector()
	local vec = direction:Normalized() * 5.0
	local vecorig = hero:GetOrigin()
	hero:SetOrigin(vecorig + vec)
end

function fly(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local direction = casterUnit:GetForwardVector()
	local vec = direction:Normalized() * 21.0
	local vecorig = casterUnit:GetOrigin() * Vector(1, 1, 0) + Vector(0, 0, 300)

	casterUnit:SetOrigin(vecorig + vec)
end

function fly2(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local direction = casterUnit:GetForwardVector()
	local vec = direction:Normalized() * 21.0
	local vecorig = casterUnit:GetOrigin() * Vector(1, 1, 1)

	casterUnit:SetOrigin(vecorig + vec)
end

function fly3(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local direction = casterUnit:GetForwardVector()
	local vec = direction:Normalized() * 20.0
	local vecorig = casterUnit:GetOrigin() * Vector(1, 1, 1)
	casterUnit:SetOrigin(vecorig + vec)

	local abil = casterUnit:GetAbilityByIndex(1)
	if abil:IsFullyCastable() then
		--print("i can cast")
		local nearbyHero=FindUnitsInRadius( 
			casterUnit:GetTeamNumber(), 
			casterUnit:GetOrigin(), nil, 1000,
			 DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
			 DOTA_UNIT_TARGET_HERO, 0, 0, false )
			 
		if #nearbyHero~=0 then
			local  target=nearbyHero[RandomInt(1,#nearbyHero)]
			--print("i cast on " .. target:GetName())
			casterUnit:CastAbilityOnTarget(target, abil, -1)
		end
	elseif RandomInt(1,15)==5 then
		local hero = PlayerResource:GetSelectedHeroEntity(casterUnit:GetPlayerOwnerID())
		casterUnit:MoveToPositionAggressive(hero:GetOrigin())
	end
end

BurstTicks = {}
cooloffCalls = {}
function burstingIt(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster

	casterUnit:AddNewModifier(casterUnit, nil, "modifier_bloodseeker_thirst", {})
end
function burstingItDamage(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	local abil = casterUnit:GetAbilityByIndex(2)
	local level = abil:GetLevel()
	if casterUnit:HasModifier("bursting_it") then
		if BurstTicks[casterUnit:GetOwner():GetPlayerID()] ~= nil then
			BurstTicks[casterUnit:GetOwner():GetPlayerID()] = BurstTicks[casterUnit:GetOwner():GetPlayerID()] + 1
		else
			BurstTicks[casterUnit:GetOwner():GetPlayerID()] = 1
		end

		local dmg = casterUnit:GetMaxHealth() * 0.003 * BurstTicks[casterUnit:GetOwner():GetPlayerID()] / 10

		local damageTable = {
			victim = casterUnit,
			attacker = casterUnit,
			damage = dmg,
			damage_type = DAMAGE_TYPE_PURE
		}
		ApplyDamage(damageTable)
	end
	if not casterUnit:HasModifier("remove_wreaking_it") then
		cooloffCalls[casterUnit:GetOwner():GetPlayerID()] = 0
	end
end

function burstingItDamageRemove(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster

	if BurstTicks[casterUnit:GetOwner():GetPlayerID()] ~= nil and BurstTicks[casterUnit:GetOwner():GetPlayerID()] > 0 then
		local totalburst =
			BurstTicks[casterUnit:GetOwner():GetPlayerID()] * 6 / (6 - cooloffCalls[casterUnit:GetOwner():GetPlayerID()])
		BurstTicks[casterUnit:GetOwner():GetPlayerID()] =
			totalburst * (5 - cooloffCalls[casterUnit:GetOwner():GetPlayerID()]) / 6
	end
	if cooloffCalls[casterUnit:GetOwner():GetPlayerID()] ~= nil then
		cooloffCalls[casterUnit:GetOwner():GetPlayerID()] = cooloffCalls[casterUnit:GetOwner():GetPlayerID()] + 1
	end
end

function panic(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	local abil = casterUnit:GetAbilityByIndex(2)
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	local level = abil:GetLevel()
	moveBonus = casterUnit:GetHealthPercent()
	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local i = 0
	abil:ApplyDataDrivenModifier(casterUnit, casterUnit, "panic_time", nil)
	while i < 100 - moveBonus do
		abil:ApplyDataDrivenModifier(casterUnit, casterUnit, "panic_time", nil)
		i = i + 10
	end
end
function SwapMission(args)
	local heroBuying = args.caster
	local olditem = ""
	local diff = 0

	for itemSlot = 0, 5, 1 do
		if heroBuying ~= nil then
			local Item = heroBuying:GetItemInSlot(itemSlot)
			if Item ~= nil then
				olditem = Item:GetName()
				if string.match(olditem, "item_contract_easy") then
					diff = 1
					heroBuying:RemoveItem(Item)
				end
				if string.match(olditem, "item_contract_medium") then
					diff = 2
					heroBuying:RemoveItem(Item)
				end
				if string.match(olditem, "item_contract_hard") then
					diff = 3
					heroBuying:RemoveItem(Item)
				end
			end
		end
	end

	if diff ~= 0 then
		 ----print("inrange")
		local missionPool = Entities:FindAllByName("npc_dota_buil*")
		local chosenMission
		local missionDist
		while chosenMission == nil do
			local i = RandomInt(1, #missionPool)
			if
				not string.match(missionPool[i]:GetUnitName(), olditem) and not string.match(missionPool[i]:GetUnitName(), "ship") and
					(heroBuying:GetOrigin() - missionPool[i]:GetOrigin()):Length() > 2500
			 then
				chosenMission = missionPool[i]
			end
		end

		local newItem

		if diff == 1 then
			newItem = CreateItem(string.gsub(chosenMission:GetUnitName(), "npc_dota_shop", "item_contract_easy"), hero, hero)
		elseif diff == 2 then
			newItem = CreateItem(string.gsub(chosenMission:GetUnitName(), "npc_dota_shop", "item_contract_medium"), hero, hero)
		else
			newItem = CreateItem(string.gsub(chosenMission:GetUnitName(), "npc_dota_shop", "item_contract_hard"), hero, hero)
		end

		if newItem ~= nil then -- makes sure that the item exists and making sure it is the correct item
			 ----print("Item Is: " .. newItem:GetName())
			heroBuying:AddItem(newItem)

			EmitSoundOnClient("ui.npe_objective_given", PlayerResource:GetPlayer(heroBuying:GetPlayerID()))

			local data = {
				Player_ID = heroBuying:GetPlayerID(),
				Ally_ID = 0,
				x = chosenMission:GetAbsOrigin().x,
				y = chosenMission:GetAbsOrigin().y,
				z = chosenMission:GetAbsOrigin().z
			}
			CustomGameEventManager:Send_ServerToAllClients("Team_Cannot_Buy", data)
		end
	end
end

function CallBatFly(args) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] CallPuckDive started! ")

	local casterUnit = args.caster
	local ability = "batrider_firefly_battleship"

	local abil = casterUnit:GetAbilityByIndex(1)
	local level = abil:GetLevel()

	local abil1 = casterUnit:GetAbilityByIndex(3)
	local level2 = abil1:GetLevel()
	local removed = abil1:GetAbilityName()
	casterUnit:RemoveAbility(abil1:GetAbilityName())
	casterUnit:AddAbility(ability)

	--disjoint
	--ProjectileManager:ProjectileDodge(casterUnit)

	local abil2 = casterUnit:GetAbilityByIndex(3)
	abil2:SetLevel(level)
	abil2:CastAbility()
	casterUnit:RemoveAbility(abil2:GetAbilityName())
	casterUnit:AddAbility(removed)
end

function CallSlarkInvis(args) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] CallPuckDive started! ")

	local casterUnit = args.caster
	local ability = "slark_shadow_dance_battleship"

	local abil = casterUnit:GetAbilityByIndex(2)
	local level = abil:GetLevel()

	local abil1 = casterUnit:GetAbilityByIndex(3)
	local level2 = abil1:GetLevel()
	local replaced = abil1:GetAbilityName()
	casterUnit:RemoveAbility(abil1:GetAbilityName())
	casterUnit:AddAbility(ability)

	local abil2 = casterUnit:GetAbilityByIndex(3)
	abil2:SetLevel(level)
	abil2:CastAbility()
	casterUnit:RemoveAbility(abil2:GetAbilityName())
	casterUnit:AddAbility(replaced)

	--abil3:SetLevel(level2)

	Timers:CreateTimer(
		4,
		function()
			RemoveDD(args)
		end
	)
end

function checkCliff(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	FindClearSpaceForUnit(casterUnit, casterUnit:GetAbsOrigin(), true)
end

function CheckForRing(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	local allUnits =
		FindUnitsInRadius(
		DOTA_TEAM_BADGUYS,
		casterUnit:GetOrigin(),
		nil,
		80,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)
	local allUnits2 =
		FindUnitsInRadius(
		DOTA_TEAM_GOODGUYS,
		casterUnit:GetOrigin(),
		nil,
		80,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)
	if #allUnits == 1 then
		local creature =
			CreateUnitByName("npc_dota_rng_ind", casterUnit:GetOrigin(), true, nil, nil, casterUnit:GetTeamNumber())
	end
end

function CallPuckDive(args) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] CallPuckDive started! ")
	local casterUnit = args.caster
	local ability = "dive_battleship_puck"

	--disjoint
	ProjectileManager:ProjectileDodge(casterUnit)

	local abil = casterUnit:GetAbilityByIndex(1)
	local level = abil:GetLevel()
	StartAnimation(casterUnit, {duration = .3 + .2 * level, activity = ACT_SCRIPT_CUSTOM_0, rate = 2 / (.3 + .1 * level)})
end

function SwimBrakDamageTaken(args) 
	PrintTable(args)
	local targetUnit = args.caster
	if args.dmg>10 then
		targetUnit:AddNewModifier(creature, nil, "modifier_stunned", {duration = 3.0})
	
	end
end

function RainbowDied(args)
	 ----print("[ability] rainbow died started! ")
	local casterUnit = args.caster
	local abil = casterUnit:GetAbilityByIndex(2)
	local level = abil:GetLevel()
	local i = 0

	while level + 4 > i do
		local creature =
			CreateUnitByName(
			"npc_dota_rainbow_unit",
			casterUnit:GetOrigin() * Vector(1, 1, 0) + Vector(0, 0, 200),
			true,
			nil,
			nil,
			casterUnit:GetTeamNumber()
		)
		creature:AddNewModifier(creature, nil, "modifier_kill", {duration = 5})
		i = i + 1
	end
end

-- uses a variable which gets the actual ability in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
-- makes sure that the ability exists and making sure it is the correct ability
function toggle_item(keys) -- keys is the information sent by the ability
	 ----print("[AbilityFunctions] toggle_item  Called")

	local casterUnit = EntIndexToHScript(keys.caster_entindex) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as earthshaker_blade_dance.
	if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 5, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
			if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
				local Item = casterUnit:GetItemInSlot(itemSlot) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
				if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
					Item:ToggleAbility()
				end
			end
		end
	end
end

function TeleHome(keys) -- keys is the information sent by the ability
	Timers:CreateTimer(
		0.1,
		function()
			 ----print("[AbilityFunctions] toggle_item  Called")
			local casterUnit = EntIndexToHScript(keys.caster_entindex)
			local vecorig = Vector(0, 0, 0)
			if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				vecorig = Vector(-30, -5104, 0) + RandomVector(RandomFloat(0, 100))
			elseif casterUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				vecorig = Vector(0, 5540, 0) + RandomVector(RandomFloat(0, 100))
			end
			FindClearSpaceForUnit(casterUnit, vecorig, true)
		end
	)
end

function keepUp(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	local targetUnit = args.target
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local hp1 = casterUnit:GetHealth() / casterUnit:GetMaxHealth()
	local hp2 = targetUnit:GetHealth() / targetUnit:GetMaxHealth()
	local newhp = (hp1 + hp2) / 2
	if hp1 < newhp - .007 then
		casterUnit:SetHealth(casterUnit:GetHealth() + .007 * casterUnit:GetMaxHealth())
	elseif hp1 > newhp + .007 then
		casterUnit:SetHealth(casterUnit:GetHealth() - .007 * casterUnit:GetMaxHealth())
	else
		casterUnit:SetHealth(newhp * casterUnit:GetMaxHealth())
	end

	if hp2 < newhp - .007 then
		targetUnit:SetHealth(targetUnit:GetHealth() + .007 * targetUnit:GetMaxHealth())
	elseif hp2 > newhp + .007 then
		targetUnit:SetHealth(targetUnit:GetHealth() - .007 * targetUnit:GetMaxHealth())
	else
		targetUnit:SetHealth(newhp * targetUnit:GetMaxHealth())
	end
end
function swapToGiraffe(args) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] swaptogiraffe started! ")

	local casterUnit = args.caster
	local ability = "giraffe_grab"

	local abil = casterUnit:GetAbilityByIndex(0)
	local level = abil:GetLevel()
	casterUnit:RemoveAbility(abil:GetAbilityName())
	casterUnit:AddAbility(ability)
	local abil2 = casterUnit:GetAbilityByIndex(0)
	abil2:SetLevel(level)
	abil2:StartCooldown(5.0)
end

function monkeyBuisness(args) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] drag started! ")
	local targetUnit = args.target
	local newTarget
	local caster = args.caster

	local enemies =
		FindUnitsInRadius(
		targetUnit:GetTeamNumber(),
		targetUnit:GetOrigin(),
		nil,
		900,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)
	if #enemies > 0 then
		local index = RandomInt(1, #enemies)
		newTarget = enemies[index]
		local info = {
			Ability = caster:GetAbilityByIndex(0),
			Source = targetUnit,
			Target = newTarget,
			vSourceLoc = targetUnit:GetAbsOrigin(),
			EffectName = "particles/basic_projectile/monkey_buisness_effect.vpcf",
			bProvidesVision = false,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber(),
			bDeleteOnHit = false,
			iMoveSpeed = 522,
			vVelocity = 522
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
	end

	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
end

function getDown(args)
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local direction = casterUnit:GetForwardVector()
	local vec = direction:Normalized() * 50.0
	local vecorig = casterUnit:GetOrigin()

	casterUnit:MoveToPosition(vecorig + vec)
end

function giraffeGrab(args) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] drag started! ")

	local targetPos = args.target:GetAbsOrigin()
	local targetUnit = args.target
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	local casterPos = args.caster:GetAbsOrigin()
	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local direction = casterPos - targetPos
	local vec = direction:Normalized() * 22.0
	if direction:Length() > 200 and not string.match(targetUnit:GetUnitName(), "rng") then
		local vecorig = targetUnit:GetOrigin()
		targetUnit:SetOrigin(vecorig + vec)
	end
end

function moceCarrierIn(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local direction = casterUnit:GetForwardVector()
	local vec = direction:Normalized() * 50.0
	local vecorig = casterUnit:GetOrigin()

	casterUnit:SetOrigin((vecorig + vec) * Vector(1, 1, 0) + Vector(0, 0, 300))
end
function moceCarrierOut(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local direction = casterUnit:GetForwardVector()
	local vec = direction:Normalized() * -50.0
	local vecorig = casterUnit:GetOrigin()

	casterUnit:SetOrigin(vecorig + vec)
end

function killMe(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	local damageTable = {
		victim = casterUnit,
		attacker = casterUnit,
		damage = 10000,
		damage_type = DAMAGE_TYPE_PURE
	}

	ApplyDamage(damageTable)
end

function DmgAura(keys)
	local casterUnit = keys.caster
	local range = 400
	local handles = {}
	handles.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	handles.types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_HERO
	handles.flags = DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
	local dmg=25;
	if #getEnemies(casterUnit,range,handles) > 0 then
	  for _,en in pairs(getEnemies(casterUnit,range,handles)) do
		local damageTable = {
		  victim = en,
		  attacker = casterUnit,
		  damage = dmg,
		  damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
	  end
  
	end
  end

  
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

function submerge(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	 ----print("[ItemFunctions]  sub down " .. tostring(casterUnit:GetMana()))
	casterUnit:SetModel("models/sub_boat_down.vmdl")
	casterUnit:SetOriginalModel("models/sub_boat_down.vmdl")
	if casterUnit:GetMana() < 10 then
		local damageTable = {
			victim = casterUnit,
			attacker = casterUnit,
			damage = 11,
			damage_type = DAMAGE_TYPE_PURE
		}

		ApplyDamage(damageTable)
	end
end

function submergedmg(args) 
	local casterUnit = args.caster
	if casterUnit:GetMana() < 10 then
		local damageTable = {
			victim = casterUnit,
			attacker = casterUnit,
			damage = 35,
			damage_type = DAMAGE_TYPE_PURE
		}
		ApplyDamage(damageTable)
	end
end

function rise(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	args.ability:GetName()
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	casterUnit:SetModel("models/sub_boat.vmdl")
	casterUnit:SetOriginalModel("models/sub_boat.vmdl")
	args.ability:StartCooldown(1.0)
end

function inTheHold(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	local targetUnit = args.target
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	local direction = casterUnit:GetForwardVector()
	local vec = direction:Normalized() * 5
	local vecorig = casterUnit:GetOrigin() * Vector(1, 1, 0) + Vector(0, 0, 80) + vec
	targetUnit:SetOrigin(vecorig)
end

function salvagePercent(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	local targetUnit = args.unit
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	local abil = casterUnit:GetAbilityByIndex(2)
	local level = abil:GetLevel()
	if targetUnit:IsRealHero() then
		casterUnit:SetHealth(casterUnit:GetHealth() + (targetUnit:GetMaxHealth() * (level / 100 + .05)))
	else
		casterUnit:SetHealth(casterUnit:GetHealth() + (targetUnit:GetMaxHealth() * (.3)))
	end
end
function bilgeMana(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	local abil = casterUnit:GetAbilityByIndex(1)
	local level = abil:GetLevel()
	casterUnit:SetMana(casterUnit:GetMana() + level * 50)
end

function bomberSpawn(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster

	local creature
	creature = CreateUnitByName("npc_dota_air_craft_bomber", casterUnit:GetOrigin(), true, nil, nil, casterUnit:GetTeam())

	creature.vOwner = casterUnit:GetOwner()
	creature:SetControllableByPlayer(casterUnit:GetOwner():GetPlayerID(), true)
	--Sets the waypath to follow. path_wp1 in this example
	local direction = casterUnit:GetForwardVector()
	creature:SetForwardVector(direction)
	creature:SetInitialGoalEntity(waypointlocation)
end

function turnAround(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	local direction = casterUnit:GetForwardVector() * Vector(-1, -1, 1)
	casterUnit:SetForwardVector(direction)
end

function inTheHoldSpawn(args) -- keys is the information sent by the ability
	local casterUnit = args.caster

	local creature
	--print ("team is: " .. team .. "     spawn is: " .. team .. "_spawn_" .. lane .. "     comparison yields" .. tostring(team == "north"))
	--hscript CreateUnitByName( string name, vector origin, bool findOpenSpot, hscript, hscript, int team)
	if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		local waypointlocation = Entities:FindByName(nil, "south_wp_right3")
		creature = CreateUnitByName("npc_dota_boat_south_two", casterUnit:GetOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	else
		local waypointlocation = Entities:FindByName(nil, "north_wp_right3")
		creature = CreateUnitByName("npc_dota_boat_north_two", casterUnit:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	end
	--Sets the waypath to follow. path_wp1 in this example
	creature.vOwner = casterUnit:GetOwner()
	creature:SetControllableByPlayer(casterUnit:GetOwner():GetPlayerID(), true)
	creature:SetInitialGoalEntity(waypointlocation)
	creature:CreatureLevelUp(7)
end

function pushBack(args)
	local targetPos = args.target:GetAbsOrigin()
	local targetUnit = args.target
	local casterPos = args.caster:GetAbsOrigin()
	local direction = casterPos - targetPos
	local vec = direction:Normalized() * -90.0

	if not IsPhysicsUnit(targetUnit) then
		Physics:Unit(targetUnit)
	end

	targetUnit:AddPhysicsVelocity(vec)
end

function pushBackRefund(args) -- keys is the information sent by the ability
	-- ----print('[ItemFunctions] gunning_it started! ')
	if args.target ~= args.caster then --not self target
	else --disable self target, refund spell. callback event.ability:OnChannelFinish(true) not needed
		args.ability:RefundManaCost()
		args.ability:EndCooldown()
	end
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
----BROKEN SEA PLANE ABILITIES--------------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Gets starting HP for Sea Plane Ruse.
herohp = {}
function reflectGetStartHp(args)
	local casterUnit = args.caster
	herohp[casterUnit:GetOwner():GetPlayerID()] = casterUnit:GetHealth()
end

-- Deals damage to the enemy and heals self.
function reflect(args)
	-- Set up ability, get HP from cast time.
	local caster = args.caster
	local abil = caster:GetAbilityByIndex(2)
	local startHP = herohp[caster:GetOwner():GetPlayerID()]

	-- Calculate the amount of damage to be reflected / healed
	local ruseDmg = (startHP - caster:GetHealth()) * abil:GetLevelSpecialValueFor("dmg", abil:GetLevel() - 1)
	ruseDmg = math.max(ruseDmg, 0)

	-- Deal reflected damage to the enemy
	local target = args.target
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = ruseDmg,
		damage_type = DAMAGE_TYPE_PURE
	}

	if caster:IsAlive() and target:IsAlive() then
		ApplyDamage(damageTable)

    -- Add back reflected damage as health
    caster:SetHealth(caster:GetHealth() + ruseDmg)

    local sound = "Hero_Terrorblade.Sunder.Target"
    target:EmitSound(sound)

    -- Show the particle caster-> target
    local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"  
    local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, target )

    ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

    -- Show the particle target-> caster
    local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )

    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end

	 ----print("[ItemFunctions] damage done")
end

function mightStart(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	local ability = args.ability
	local numunits = 0

	 ----print("[ItemFunctions] mightStart started!")
	local enemies

	--hscript CreateUnitByName( string name, vector origin, bool findOpenSpot, hscript, hscript, int team)
	if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		enemies =
			FindUnitsInRadius(
			DOTA_TEAM_BADGUYS,
			casterUnit:GetOrigin(),
			nil,
			800,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			0,
			0,
			false
		)
	else
		enemies =
			FindUnitsInRadius(
			DOTA_TEAM_GOODGUYS,
			casterUnit:GetOrigin(),
			nil,
			800,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			0,
			0,
			false
		)
	end

	for _, fucker in pairs(enemies) do
		if casterUnit.strbonus then
			local dmg = (casterUnit.strbonus * ability:GetLevelSpecialValueFor("damage_tooltip", ability:GetLevel() - 1) ) / #enemies
			local damageTable = {
				victim = fucker,
				attacker = casterUnit,
				damage = dmg,
				damage_type = DAMAGE_TYPE_PURE
			}
			local tracking_projectile = {
				EffectName = "particles/basic_projectile/might.vpcf",
				Ability = casterUnit:GetAbilityByIndex(1),
				vSpawnOrigin = casterUnit:GetAbsOrigin(),
				Target = fucker,
				Source = args.source or casterUnit,
				bHasFrontalCone = false,
				iMoveSpeed = 2500,
				bReplaceExisting = false,
				bProvidesVision = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}
			fucker:AddNewModifier(casterUnit, nil, "modifier_stunned", {duration = .1 * casterUnit.strbonus / #enemies})

			ProjectileManager:CreateTrackingProjectile(tracking_projectile)
			ApplyDamage(damageTable)
		end
	end

	numunits =
		FindUnitsInRadius(
		casterUnit:GetTeamNumber(),
		casterUnit:GetOrigin(),
		nil,
		800,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_CREEP,
		0,
		0,
		false
	)
	numheroes =
		FindUnitsInRadius(
		casterUnit:GetTeamNumber(),
		casterUnit:GetOrigin(),
		nil,
		800,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		0,
		0,
		false
	)
	 ----print("[ItemFunctions] RmightStart started! units is:" .. #numunits)
	 ----print("[ItemFunctions] RmightStart started! heroes is:" .. #numheroes)

	local hpPer = casterUnit:GetHealthPercent()
	 ----print("[ItemFunctions] RmightStart started! hpPer is:" .. hpPer)
	 ----print("[ItemFunctions] new max health should be" .. casterUnit:GetMaxHealth() + 35 * #numunits)
	casterUnit.strbonus = #numunits * ability:GetLevelSpecialValueFor("strength_bonus_creep", ability:GetLevel() - 1) + #numheroes * ability:GetLevelSpecialValueFor("strength_bonus_hero", ability:GetLevel() - 1) 

	casterUnit:ModifyStrength(casterUnit.strbonus)

	local modifierName = "hp_boost"

	if not casterUnit:HasModifier(modifierName) then
		ability:ApplyDataDrivenModifier(casterUnit, casterUnit, modifierName, nil)
	end

	casterUnit:SetModifierStackCount(modifierName, casterUnit, casterUnit.strbonus)

	for k, v in pairs(numheroes) do
		numunits[k] = v
	end

	for _, friend in pairs(numunits) do
		local tracking_projectile = {
			EffectName = "particles/basic_projectile/might_good.vpcf",
			Ability = casterUnit:GetAbilityByIndex(1),
			vSpawnOrigin = friend,
			Target = casterUnit,
			Source = friend,
			bHasFrontalCone = false,
			iMoveSpeed = 750,
			bReplaceExisting = false,
			bProvidesVision = false,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
		}

		ProjectileManager:CreateTrackingProjectile(tracking_projectile)
	end
end

function mightStop(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	 ----print("[ItemFunctions] Rmightstop started")
	casterUnit:SetBaseStrength(0)
end

function airBlast(args) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] drag started! ")
	local targetUnit = args.target
	local newTarget
	local caster = args.caster

	local info = {
		Ability = caster:GetAbilityByIndex(2),
		EffectName = "particles/basic_projectile/blast_effect.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = 1500,
		fStartRadius = 200,
		fEndRadius = 200,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = caster:GetForwardVector() * -700,
		bProvidesVision = true,
		iVisionRadius = 600,
		iVisionTeamNumber = caster:GetTeamNumber()
	}

	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function dragonBlast(args) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] dragonBlast started! ")

	local targetUnit = args.target
	local newTarget
	local caster = args.caster
	local enemies
	--hscript CreateUnitByName( string name, vector origin, bool findOpenSpot, hscript, hscript, int team)
	if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		enemies =
			FindUnitsInRadius(
			DOTA_TEAM_BADGUYS,
			targetUnit:GetOrigin(),
			nil,
			900,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			0,
			0,
			false
		)
	else
		enemies =
			FindUnitsInRadius(
			DOTA_TEAM_GOODGUYS,
			targetUnit:GetOrigin(),
			nil,
			900,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			0,
			0,
			false
		)
	end

	if #enemies > 0 then
		local index = RandomInt(1, #enemies)
		newTarget = enemies[index]
		local info = {
			Ability = caster:GetAbilityByIndex(1),
			Source = targetUnit,
			Target = newTarget,
			vSourceLoc = targetUnit:GetOrigin(),
			EffectName = "particles/basic_projectile/dragon_proj.vpcf",
			bProvidesVision = false,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber(),
			bDeleteOnHit = false,
			iMoveSpeed = 950,
			vVelocity = 950
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
	end
end

function fireGas(args) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] dragonBlast started! ")

	local targetUnit = args.target
	local caster = args.caster

	local info = {
		Ability = caster:GetAbilityByIndex(1),
		Source = caster,
		Target = targetUnit,
		vSourceLoc = targetUnit:GetOrigin(),
		EffectName = "particles/basic_projectile/swamp_gas_proj.vpcf",
		bProvidesVision = false,
		iVisionRadius = 1000,
		iVisionTeamNumber = caster:GetTeamNumber(),
		bDeleteOnHit = false,
		iMoveSpeed = 750,
		vVelocity = 750,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function hackNav(args) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] dragonBlast started! ")

	local targetPos = args.target:GetAbsOrigin()
	local targetUnit = args.target
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	local casterPos = args.caster:GetAbsOrigin()
	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local direction = casterPos - targetPos
	local vec = direction:Normalized() * -1.0
	if math.abs((targetUnit:GetForwardVector() + vec):Length()) < 1.85 then
		targetUnit:SetForwardVector(targetUnit:GetForwardVector() + vec)
	end
end

function unstickPush(args)
	local casterUnit = args.caster
	local target = args.target
	-- print("unstick push is going wooo!")
	if not IsPhysicsUnit(target) then
		Physics:Unit(target)
	end
	local direction = target:GetPhysicsVelocity()
	local vec = direction:Normalized() * -1.0

	target:SetPhysicsAcceleration(vec * 0)

	local vecorig = target:GetOrigin()

	FindClearSpaceForUnit(target, vecorig, true)
end

function faceRan(args)
	local casterUnit = args.caster
	 ----print("[faceRan]  called  ")
	local vec = RandomVector(RandomFloat(0, 100))
	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	casterUnit:SetForwardVector(vec)
	casterUnit:SetOrigin(casterUnit:GetOrigin() * Vector(1, 1, 0))
end

function Rise(args)
	local casterUnit = args.caster
	 ----print("[rise]  called  ")
	local height = casterUnit:GetOrigin() * Vector(0, 0, 1)
	if height:Length() < 190 then
		casterUnit:SetOrigin(casterUnit:GetOrigin() + Vector(0, 0, 2))
	end
end

function aircraftDied(args)
	local casterUnit = args.caster
	if casterUnit ~= nil and casterUnit:IsOwnedByAnyPlayer() and casterUnit:GetPlayerOwnerID() ~= -1 then
		local id = casterUnit:GetOwner():GetPlayerID()
		for _, plane in pairs(Entities:FindAllByClassname("npc_dota_creat*")) do
			 ----print("[aircraftDied]  found a plane  ")
			if plane ~= nil and string.match(plane:GetUnitName(), "air") and id == plane:GetOwner():GetPlayerID() then
				 ----print("[aircraftDied]  killed a plane  ")
				plane:ForceKill(true)
			end
		end
	end
end

function RemoveSelf(args)
	Timers:CreateTimer(
		0.03,
		function()
			local casterUnit = args.caster
			casterUnit:ForceKill(true)
			return nil
		end
	)
end

function PingDest(args)
	 print("[ItemFunctions] PingDest ")
	local itemName = args.ability:GetName()
	 print(itemName)
	local itemStrippedEasy = string.gsub(itemName, "item_contract_easy", "")
	local itemStrippedMedium = string.gsub(itemName, "item_contract_medium", "")
	local itemStrippedHard = string.gsub(itemName, "item_contract_hard", "")
	local chosenMission
	for _, mission in pairs(Entities:FindAllByName("npc_dota_buil*")) do
		if
			string.match(mission:GetUnitName(), itemStrippedEasy) or string.match(mission:GetUnitName(), itemStrippedMedium) or
				string.match(mission:GetUnitName(), itemStrippedHard)
		 then
			chosenMission = mission
		end
	end

	 print(chosenMission:GetUnitName())
	if chosenMission ~= nil then
		local data = {
			Player_ID = args.caster:GetOwner():GetPlayerID(),
			x = chosenMission:GetAbsOrigin().x,
			y = chosenMission:GetAbsOrigin().y,
			z = chosenMission:GetAbsOrigin().z
		}
		CustomGameEventManager:Send_ServerToAllClients("ping_loc", data)
	end
end

function killCd(args)
	local caster = args.caster
	caster:GetAbilityByIndex(0):EndCooldown()
	caster:GetAbilityByIndex(1):EndCooldown()
	caster:GetAbilityByIndex(2):EndCooldown()
	if caster:GetAbilityByIndex(3) then
		caster:GetAbilityByIndex(3):EndCooldown()
	end
end

function killCdHalf(args)
	local caster = args.caster
	local cdleft = caster:GetAbilityByIndex(0):GetCooldownTimeRemaining()
	if cdleft > 0 then
		 ----print(cdleft)
		caster:GetAbilityByIndex(0):EndCooldown()
		caster:GetAbilityByIndex(0):StartCooldown(cdleft / 2)
	end
	cdleft = caster:GetAbilityByIndex(1):GetCooldownTimeRemaining()
	if cdleft > 0 then
		 ----print(cdleft)
		caster:GetAbilityByIndex(1):EndCooldown()
		caster:GetAbilityByIndex(1):StartCooldown(cdleft / 2)
	end
	cdleft = caster:GetAbilityByIndex(2):GetCooldownTimeRemaining()
	if cdleft > 0 then
		 ----print(cdleft)
		caster:GetAbilityByIndex(2):EndCooldown()
		caster:GetAbilityByIndex(2):StartCooldown(cdleft / 2)
	end
	cdleft = caster:GetAbilityByIndex(3):GetCooldownTimeRemaining()
	if cdleft > 0 then
		 ----print(cdleft)
		caster:GetAbilityByIndex(3):EndCooldown()
		caster:GetAbilityByIndex(3):StartCooldown(cdleft / 2)
	end
end

function latchOn(args)
	local casterUnit = args.caster
	local target
	for _, unit in pairs(Entities:FindAllByNameWithin("npc_dota*", casterUnit:GetOrigin(), 300)) do
		if target == nil and unit ~= casterUnit then
			target = unit
		end
		if
			unit ~= casterUnit and
				(target:GetOrigin() - casterUnit:GetOrigin()):Length() > (unit:GetOrigin() - casterUnit:GetOrigin()):Length()
		 then
			target = unit
		end
	end

	direction = target:GetForwardVector()
	casterUnit:SetForwardVector(direction)
	local vec = direction:Normalized() * -15
	local vecorig = target:GetOrigin() + vec
	local vecorig = target:GetOrigin()
	FindClearSpaceForUnit(casterUnit, vecorig, true)
end

function throwJav(args) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] drag started! ")
	local targetUnit = args.target
	local newTarget
	local caster = args.caster

	local info = {
		Ability = args.ability,
		EffectName = "particles/basic_projectile/jav_effect.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = 1800,
		fStartRadius = 150,
		fEndRadius = 150,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = caster:GetForwardVector() * 1900,
		bProvidesVision = true,
		iVisionRadius = 600,
		iVisionTeamNumber = caster:GetTeamNumber()
	}

	projectile = ProjectileManager:CreateLinearProjectile(info)
end
function JavDmg(args)
	local casterUnit = args.caster
	local targetUnit = args.target
	local dmg = targetUnit:GetMaxHealth() * 0.2

	local damageTable = {
		victim = targetUnit,
		attacker = casterUnit,
		damage = dmg,
		damage_type = DAMAGE_TYPE_PURE
	}

	ApplyDamage(damageTable)
end

function OilDmg(args)
	local casterUnit = args.caster
	local targetUnit = args.target
	local dmg = targetUnit:GetMaxHealth() * 0.05

	local damageTable = {
		victim = targetUnit,
		attacker = casterUnit,
		damage = dmg,
		damage_type = DAMAGE_TYPE_PURE
	}

	ApplyDamage(damageTable)
end

function moveToRandom(args)
	local targetUnit = args.target
	local vec = RandomVector(RandomFloat(100, 200))
	targetUnit:MoveToPosition(targetUnit:GetOrigin() + vec)
end

function moveToRandomTradePost(args)
	local casterUnit = args.caster
	local missionPool = Entities:FindAllByName("npc_dota_buil*")
	local chosenMission

	while chosenMission == nil do
		local i = RandomInt(1, #missionPool)
		if not string.match(missionPool[i]:GetUnitName(), "ship") then
			chosenMission = missionPool[i]
			 ----print(chosenMission:GetOrigin())
		end
	end
	casterUnit:MoveToPosition(chosenMission:GetOrigin())
	if daralectOwnerArray[creature] == nil or not daralectOwnerArray[creature]:IsAlive() then
		casterUnit:RemoveSelf()
	end
end

function Blur(keys)
	local caster = keys.caster
	local ability = keys.ability
	local casterLocation = caster:GetAbsOrigin()
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	local enemyHeroes =
		FindUnitsInRadius(
		caster:GetTeam(),
		casterLocation,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		0,
		0,
		false
	)

	if #enemyHeroes > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "unghost_ship", {})
		caster:RemoveModifierByName("ghost_ship")
	else
		if caster:HasModifier("unghost_ship") then
			Timers:CreateTimer(
				0.1,
				function()
					caster:RemoveModifierByName("unghost_ship")
				end
			)

			Timers:CreateTimer(
				0.2,
				function()
					ability:ApplyDataDrivenModifier(caster, caster, "ghost_ship", {})
				end
			)
		end
	end
end

daralectOwnerArray = {}
daralectArray = {}
function DropOrGo(args)
	local casterUnit = args.caster
	local hasDaralect = false
	if daralectArray[casterUnit] ~= nil and not daralectArray[casterUnit]:IsNull() then
		creepDirection = daralectArray[casterUnit]:GetForwardVector()
		creepOri = daralectArray[casterUnit]:GetOrigin()

		casterUnitDirection = casterUnit:GetForwardVector()
		casterOri = casterUnit:GetOrigin()

		casterUnit:SetForwardVector(creepDirection)
		casterUnit:SetOrigin(creepOri)
		daralectArray[casterUnit]:SetForwardVector(casterUnitDirection)
		daralectArray[casterUnit]:SetOrigin(casterOri)
		return
	end

	local missionPool = Entities:FindAllByName("npc_dota_buil*")

	if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		creature =
			CreateUnitByName("daralect_vessle", casterUnit:GetOrigin(), true, casterUnit:GetOwner(), nil, DOTA_TEAM_GOODGUYS)
		local chosenMission
		while chosenMission == nil do
			local i = RandomInt(1, #missionPool)
			if not string.match(missionPool[i]:GetUnitName(), "ship") then
				chosenMission = missionPool[i]
			end
		end
		daralectOwnerArray[creature] = casterUnit
		daralectArray[casterUnit] = creature
		Timers:CreateTimer(
			0.03,
			function()
				creature:MoveToPositionAggressive(chosenMission:GetOrigin())
				 ----print(chosenMission:GetOrigin())
			end
		)
	else
		creature =
			CreateUnitByName("daralect_vessle", casterUnit:GetOrigin(), true, casterUnit:GetOwner(), nil, DOTA_TEAM_BADGUYS)
		local chosenMission
		while chosenMission == nil do
			local i = RandomInt(1, #missionPool)
			if not string.match(missionPool[i]:GetUnitName(), "ship") then
				chosenMission = missionPool[i]
			end
		end
		daralectOwnerArray[creature] = casterUnit
		daralectArray[casterUnit] = creature
		Timers:CreateTimer(
			0.03,
			function()
				creature:MoveToPositionAggressive(chosenMission:GetOrigin())
				 ----print(chosenMission:GetOrigin())
			end
		)
	end
end

function killDaralect(args)
	 ----print(daralectArray[casterUnit])
	if daralectArray[casterUnit] ~= nil then
		daralectArray[casterUnit]:RemoveSelf()
	end
end

function pullToCaster(keys)
	if not IsPhysicsUnit(keys.target) then
		Physics:Unit(keys.target)
	end
	local targetPos = keys.target:GetAbsOrigin()
	local targetUnit = keys.target
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	local casterPos = keys.caster:GetAbsOrigin()
	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local direction = casterPos - targetPos
	if direction:Length() > 150 then
		targetUnit:SetPhysicsVelocity(direction:Normalized() * 400.0)
	end
end

function FirstAid(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	casterUnit:SetHealth(casterUnit:GetHealth() + (casterUnit:GetMaxHealth() * .2))
end

modle_scales = {}
function grow(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	modle_scales[casterUnit] = casterUnit:GetModelScale()
	casterUnit:SetModelScale(1.5)
end

function shrink(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	if modle_scales[casterUnit] ~= nil then
		casterUnit:SetModelScale(modle_scales[casterUnit])
	else
		casterUnit:SetModelScale(1)
	end
end

function ApplyDD(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	local hero = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	for itemSlot = 0, 5, 1 do
		if hero ~= nil then
			local Item = hero:GetItemInSlot(itemSlot)
			if Item ~= nil and string.match(Item:GetName(), "doubled") then -- makes sure that the item exists and making sure it is the correct item
				local doubledstring = string.gsub(Item:GetName(), "_doubled", "_doubled_shooting")
				Item:ApplyDataDrivenModifier(hero, hero, doubledstring, nil)
			elseif Item ~= nil and string.match(Item:GetName(), "bow") then -- makes sure that the item exists and making sure it is the correct item
				Item:ApplyDataDrivenModifier(hero, hero, Item:GetName() .. "_shooting", nil)
				 ----print("bow found.")
			end
		end
	end
end

function ApplyRandomDD(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	local hero = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	local done = 0
	while done == 0 do
		for itemSlot = 0, 5, 1 do
			if hero ~= nil then
				local Item = hero:GetItemInSlot(itemSlot)
				if Item ~= nil and string.match(Item:GetName(), "doubled") and RandomInt(0, 4) == 2 then -- makes sure that the item exists and making sure it is the correct item
					local doubledstring = string.gsub(Item:GetName(), "_doubled", "_doubled_shooting")
					Item:ApplyDataDrivenModifier(hero, hero, doubledstring, nil)
					done = 1
				elseif Item ~= nil and string.match(Item:GetName(), "bow") and RandomInt(0, 4) == 2 then -- makes sure that the item exists and making sure it is the correct item
					Item:ApplyDataDrivenModifier(hero, hero, Item:GetName() .. "_shooting", nil)
					 ----print("bow found.")
					done = 1
				end
			end
		end
	end
end

function RemoveDD(args) -- keys is the information sent by the ability
	local hero = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	for itemSlot = 0, 5, 1 do
		if hero ~= nil then
			local Item = hero:GetItemInSlot(itemSlot)
			if Item ~= nil and string.match(Item:GetName(), "doubled") then -- makes sure that the item exists and making sure it is the correct item
				local doubledstring = string.gsub(Item:GetName(), "_doubled", "_doubled_shooting")
				while hero:HasModifier(doubledstring) do
					hero:RemoveModifierByName(doubledstring)
				end
			elseif Item ~= nil and string.match(Item:GetName(), "bow") then -- makes sure that the item exists and making sure it is the correct item
				while hero:HasModifier(Item:GetName() .. "_shooting") do
					hero:RemoveModifierByName(Item:GetName() .. "_shooting")
				end
				 ----print("bow found.")
			end
		end
	end
	for itemSlot = 0, 5, 1 do
		if hero ~= nil then
			local Item = hero:GetItemInSlot(itemSlot)
			if Item ~= nil and string.match(Item:GetName(), "doubled") then -- makes sure that the item exists and making sure it is the correct item
				local doubledstring = string.gsub(Item:GetName(), "_doubled", "_doubled_shooting")
				Item:ApplyDataDrivenModifier(hero, hero, doubledstring, nil)
			elseif Item ~= nil and string.match(Item:GetName(), "bow") then -- makes sure that the item exists and making sure it is the correct item
				Item:ApplyDataDrivenModifier(hero, hero, Item:GetName() .. "_shooting", nil)
				 ----print("bow found.")
			end
		end
	end
end
function RemoveWeps(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	local hero = args.caster
	 ----print("[ItemFunctions] CallPuckDive removing weps! ")
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	for itemSlot = 0, 5, 1 do
		if hero ~= nil then
			local Item = hero:GetItemInSlot(itemSlot)
			if Item ~= nil and string.match(Item:GetName(), "doubled") then -- makes sure that the item exists and making sure it is the correct item
				local doubledstring = string.gsub(Item:GetName(), "_doubled", "_doubled_shooting")
				while hero:HasModifier(doubledstring) do
					hero:RemoveModifierByName(doubledstring)
				end
			elseif Item ~= nil and string.match(Item:GetName(), "bow") then -- makes sure that the item exists and making sure it is the correct item
				while hero:HasModifier(Item:GetName() .. "_shooting") do
					hero:RemoveModifierByName(Item:GetName() .. "_shooting")
				end
				 ----print("bow found.")
			end
		end
	end
end

function removeAllBows(hero)
	for itemSlot = 0, 5, 1 do
		if hero ~= nil then
			local Item = hero:GetItemInSlot(itemSlot)
			if Item ~= nil and string.match(Item:GetName(), "doubled") then -- makes sure that the item exists and making sure it is the correct item
				local doubledstring = string.gsub(Item:GetName(), "_doubled", "_doubled_shooting")
				while hero:HasModifier(doubledstring) do
					hero:RemoveModifierByName(doubledstring)
				end
			elseif Item ~= nil and string.match(Item:GetName(), "bow") then -- makes sure that the item exists and making sure it is the correct item
				while hero:HasModifier(Item:GetName() .. "_shooting") do
					hero:RemoveModifierByName(Item:GetName() .. "_shooting")
				end
				 ----print("bow found.")
			end
		end
	end
end

function reapplyAllBowsIfRemoved(hero)
	for itemSlot = 0, 5, 1 do
		if hero ~= nil then
			local Item = hero:GetItemInSlot(itemSlot)
			if Item ~= nil and string.match(Item:GetName(), "doubled") then -- makes sure that the item exists and making sure it is the correct item
				local doubledstring = string.gsub(Item:GetName(), "_doubled", "_doubled_shooting")
				if hero:HasModifier(doubledstring) then
					return
				end
			elseif Item ~= nil and string.match(Item:GetName(), "bow") then -- makes sure that the item exists and making sure it is the correct item
				if hero:HasModifier(Item:GetName() .. "_shooting") then
					return
				end
				 ----print("bow found.")
			end
		end
	end

	for itemSlot = 0, 5, 1 do
		if hero ~= nil then
			local Item = hero:GetItemInSlot(itemSlot)
			if Item ~= nil and string.match(Item:GetName(), "doubled") then -- makes sure that the item exists and making sure it is the correct item
				local doubledstring = string.gsub(Item:GetName(), "_doubled", "_doubled_shooting")
				Item:ApplyDataDrivenModifier(hero, hero, doubledstring, nil)
			elseif Item ~= nil and string.match(Item:GetName(), "bow") then -- makes sure that the item exists and making sure it is the correct item
				Item:ApplyDataDrivenModifier(hero, hero, Item:GetName() .. "_shooting", nil)
				 ----print("bow found.")
			end
		end
	end
end

function ApplyStun(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	local targetUnit = args.target
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	local item = CreateItem("item_oneshot_brew", casterUnit, casterUnit)

	item:ApplyDataDrivenModifier(targetUnit, targetUnit, "sick", nil)

	casterUnit:RemoveItem(item)
end

function ApplyLuck(args) -- keys is the information sent by the ability
	local weps = {}
	local hero = args.caster
	-- ----print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	for itemSlot = 0, 5, 1 do
		if hero ~= nil then
			local Item = hero:GetItemInSlot(itemSlot)
			if Item ~= nil and string.match(Item:GetName(), "doubled") then -- makes sure that the item exists and making sure it is the correct item
				local doubledstring = string.gsub(Item:GetName(), "_doubled", "_doubled_shooting")
				weps[#weps + 1] = doubledstring
			elseif Item ~= nil and string.match(Item:GetName(), "bow") then -- makes sure that the item exists and making sure it is the correct item
				weps[#weps + 1] = Item:GetName() .. "_shooting"
			end
		end
	end
	PrintTable(weps)
	hero:RemoveModifierByName(weps[RandomInt(1, #weps)])
	Timers:CreateTimer(
		4,
		function()
			RemoveDD(args)
		end
	)
end

function visionGrant(args)
	local casterUnit = args.caster

	-- THIS CRASHES THE GAME
	-- local creature
	-- creature1 = CreateUnitByName("dummy_vision800", casterUnit:GetOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	-- creature1:AddNewModifier(creature, nil, "modifier_kill", {duration = .1})
	-- creature2 = CreateUnitByName("dummy_vision800", casterUnit:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	-- creature2:AddNewModifier(creature, nil, "modifier_kill", {duration = .1})

	local allUnits =
		FindUnitsInRadius(
		DOTA_TEAM_BADGUYS,
		casterUnit:GetOrigin(),
		nil,
		600,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		0,
		0,
		false
	)
	local allUnits2 =
		FindUnitsInRadius(
		DOTA_TEAM_GOODGUYS,
		casterUnit:GetOrigin(),
		nil,
		600,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		0,
		0,
		false
	)

	-- Why is this in the vision providing function??
	for k, v in pairs(allUnits2) do
		allUnits[k] = v
	end

	for _, hero in pairs(allUnits) do
		for itemSlot = 0, 5, 1 do
			if hero ~= nil then
				local Item = hero:GetItemInSlot(itemSlot)
				if Item ~= nil and string.match(Item:GetName(), "contract") then
					EMP_GOLD_NUMBER = math.floor(GameRules:GetGameTime() / 500 + 0.5) + 1

					hero:RemoveItem(Item)
					Notifications:Top(
						hero:GetPlayerID(),
						{
							text = "#mission_taken",
							duration = 4.0,
							style = {color = " #A060D6;", fontSize = "45px;", textShadow = "2px 2px 2px #662222;"}
						}
					)
					Notifications:Top(
						hero:GetPlayerID(),
						{
							text = "#mission_taken_2",
							duration = 4.0,
							style = {color = " #A060D6;", fontSize = "45px;", textShadow = "2px 2px 2px #662222;"}
						}
					)
					Notifications:Top(
						hero:GetPlayerID(),
						{
							text = 100 * EMP_GOLD_NUMBER / 2,
							duration = 4.0,
							style = {color = "#FFD700", fontSize = "45px;"},
							continue = true
						}
					)

					hero:SetGold(hero:GetGold() + 100 * EMP_GOLD_NUMBER / 2, true)
				end
			end
		end
	end
end

function DropEmptyOnDeath(keys) -- keys is the information sent by the ability
	 ----print("[ItemFunctions] DropItemOnDeath Called")
	local killedUnit = EntIndexToHScript(keys.caster_entindex) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
	if killedUnit:IsHero() or killedUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 5, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
			if killedUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
				local Item = killedUnit:GetItemInSlot(itemSlot) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
				if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
					local newItem = CreateItem("item_contract_empty", nil, nil) -- creates a new variable which recreates the item we want to drop and then sets it to have no owner
					CreateItemOnPositionSync(killedUnit:GetOrigin(), newItem) -- takes the newItem variable and creates the physical item at the killed unit's location
					killedUnit:RemoveItem(Item) -- finally, the item is removed from the original units inventory.
				elseif Item ~= nil and string.match(Item:GetName(), "temp") then
					killedUnit:RemoveItem(Item)
				end
			end
		end
	end
	local allyid = 0
	for _, hero in pairs(Entities:FindAllByClassname("npc_dota_hero*")) do
		if
			hero ~= nil and hero:IsOwnedByAnyPlayer() and hero ~= killedUnit and
				hero:GetTeamNumber() == killedUnit:GetTeamNumber()
		 then
			ally = hero
		end
	end
	local data = {
		Player_ID = killedUnit:GetPlayerID(),
		Ally_ID = allyid
	}
	CustomGameEventManager:Send_ServerToAllClients("Team_Can_Buy", data)
end

function CreateNoFireZone(keys)
	local casterUnit = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	local rand = RandomInt(1, 40)
	 ----print(rand)
	local by = 40

	for i = 0, 330, by do
		local creature2 =
			CreateUnitByName(
			"npc_dota_booey",
			point,
			true,
			casterUnit:GetOwner(),
			casterUnit:GetOwner(),
			casterUnit:GetTeamNumber()
		)

		creature2:SetOrigin(point + Vector(math.cos(math.rad(i + rand)) * radius, math.sin(math.rad(i + rand)) * radius, -30))
		creature2:AddNewModifier(creature, nil, "modifier_kill", {duration = 6})
	end
	Timers:CreateTimer(
		.05,
		function()
			maintainNoFireZone(keys)
		end
	)
	Timers:CreateTimer(
		ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1)),
		function()
			killNoFireZone(keys)
		end
	)
end

gotNoBows = {}
function maintainNoFireZone(keys)
	local casterUnit = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))

	local allUnits2 = Entities:FindAllInSphere(point, 1000)
	if #allUnits2 > 0 then
		for _, boo in pairs(allUnits2) do
			if boo:HasModifier("dummy_modifier") then
				if boo:GetOwner() ~= nil and boo:GetOwner():GetPlayerID() ~= nil then
					 ----print(tostring(boo:GetUnitName()) .. tostring(boo:GetOwner():GetPlayerID()))
					if string.match(boo:GetUnitName(), "booey") and boo:GetOwner():GetPlayerID() == casterUnit:GetOwner():GetPlayerID() then
						for _, hero in pairs(Entities:FindAllByClassname("npc_dota_hero*")) do
							local heroDist = hero:GetAbsOrigin() - point

							if gotNoBows[hero] ~= nil and heroDist:Length() > radius then
								reapplyAllBowsIfRemoved(hero)
								gotNoBows[hero] = 0
								hero:RemoveModifierByName("modifier_disarmed")
							elseif heroDist:Length() <= radius and (gotNoBows[hero] == nil or gotNoBows[hero] == 0) then
								removeAllBows(hero)
								hero:AddNewModifier(casterUnit, nil, "modifier_disarmed", {duration = 1})
								gotNoBows[hero] = 1
							end
						end
						Timers:CreateTimer(
							.05,
							function()
								maintainNoFireZone(keys)
							end
						)
						return
					end
				end
			end
		end
	end
end
function AntiBackdoor(keys)
	local casterUnit = keys.caster
	if casterUnit.hasBuff == nil then
		casterUnit.hasBuff=false
	end
	allys =
			FindUnitsInRadius(
				casterUnit:GetTeam(),
			casterUnit:GetOrigin(),
			nil,
			100000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_BASIC,
			0,
			0,
			false
		)
	local comp="right"
	if casterUnit:GetOrigin().x < 0 then
		comp="left"
	end
	local ShouldBeBoosted=false
	for _, creep in pairs(allys) do
		if creep.side~=nil and string.match(creep.side,comp) then
			ShouldBeBoosted=true
			break 
		end
	end

		if  ShouldBeBoosted == true and casterUnit.hasBuff==false then
			local curArmor = casterUnit:GetPhysicalArmorBaseValue()
			casterUnit:SetPhysicalArmorBaseValue(curArmor+30.0)
			casterUnit.hasBuff=true
		elseif ShouldBeBoosted == false and casterUnit.hasBuff==true then
			local curArmor = casterUnit:GetPhysicalArmorBaseValue()
			casterUnit:SetPhysicalArmorBaseValue(curArmor-30.0)
			casterUnit.hasBuff=false
	end	

	

end

function killNoFireZone(keys)
	local casterUnit = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))

	for _, hero in pairs(Entities:FindAllByClassname("npc_dota_hero*")) do
		Timers:CreateTimer(
			.2,
			function()
				 ----print("gimme my bows wqhore!!!")
				reapplyAllBowsIfRemoved(hero)
				gotNoBows[hero] = 0
			end
		)
	end

	local allUnits2 = Entities:FindAllInSphere(point, 1000)
	if #allUnits2 > 0 then
		for _, boo in pairs(allUnits2) do
			 ----print("kill me!")
			if boo:HasModifier("dummy_modifier") then
				if boo:GetOwner() ~= nil and boo:GetOwner():GetPlayerID() ~= nil then
					 ----print(tostring(boo:GetUnitName()) .. tostring(boo:GetOwner():GetPlayerID()))
					if string.match(boo:GetUnitName(), "booey") and boo:GetOwner():GetPlayerID() == casterUnit:GetOwner():GetPlayerID() then
						 ----print("killed me!")
						RemoveSelf(boo)
						boo:RemoveSelf()
					end
				end
			end
		end
	end
end

function RealityRiftPosition( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin() 
	local target_location = target:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local range = ability:GetLevelSpecialValueFor("range", ability_level) 
	local reality_rift_particle = keys.reality_rift_particle

	-- Position calculation
	local distance = (target_location - caster_location):Length2D() 
	local direction = (target_location - caster_location):Normalized()
	local target_point =  range * distance
	local target_point_vector = caster_location + direction * target_point

	-- Particle
	local particle = ParticleManager:CreateParticle(reality_rift_particle, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster_location, true)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
	ParticleManager:SetParticleControl(particle, 2, target_point_vector)
	ParticleManager:SetParticleControlOrientation(particle, 2, direction, Vector(0,1,0), Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(particle) 

	-- Save the location
	ability.reality_rift_location = target_point_vector
	ability.reality_rift_direction = direction

	Timers:CreateTimer(0.1, function() RealityRift(keys)	end)
end

--[[Author: Pizzalol
	Date: 09.04.2015.
	Relocates the target, caster and any illusions under the casters control]]
function RealityRift( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()
	local player = caster:GetPlayerOwnerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	EmitSoundOn("Hero_ChaosKnight.RealityRift.Target", target)
	-- Ability variables
	local damage = ability:GetSpecialValueFor("bonus_damage")

	-- Set the positions to be one on each side of the rift
	FindClearSpaceForUnit(target, ability.reality_rift_location + ability.reality_rift_direction * 50, true)
	FindClearSpaceForUnit(caster, ability.reality_rift_location - ability.reality_rift_direction * 50, true)

	-- Set the targets to face eachother
	target:SetForwardVector(ability.reality_rift_direction * -1)
	caster:Stop() 
	caster:SetForwardVector(ability.reality_rift_direction)

	-- Add the phased modifier to prevent getting stuck
	target:AddNewModifier(caster, nil, "modifier_phased", {duration = 0.03})
	caster:AddNewModifier(caster, nil, "modifier_phased", {duration = 0.03})

	-- Deal damage
	local damage = ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL
	})
end

function WhaleBait(args)
	local targetPos = args.target:GetAbsOrigin()
	local targetUnit = args.target
	-- --print('[WhaleBait]')
	local casterPos = args.caster:GetAbsOrigin()
	-- ----print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local direction = casterPos - targetPos
	local vec = direction:Normalized()

	targetUnit:SetAbsOrigin(targetUnit:GetAbsOrigin() + vec*2)
end

function CherryLaunch(args)
	--print("IN CherryLaunch")
	local targetPos = args.target_points[1]
	local caster = args.caster
	
	dummy = CreateUnitByName("dummy_vision10", targetPos, true, nil, nil, caster:GetTeam())
  
   for i=1, RandomInt(1,2) do
		Timers:CreateTimer(.1*i,function()
		
		local info = {
			Ability = args.ability,
			Source = caster,
			Target = dummy,
			vSourceLoc = caster:GetAbsOrigin(),
			EffectName = "particles/basic_projectile/cherry_proj.vpcf",
			bProvidesVision = false,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber(),
			bDeleteOnHit = false,
			iMoveSpeed = 1300,
			vVelocity = 700
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
		end)
	end
end

function CherryExplode(args)
	--print("IN CherryExplode")
	local targetUnit = args.target
	local newTarget
	local caster = args.caster
	local abil = args.ability
	local enemies =
		FindUnitsInRadius(
			caster:GetTeamNumber(),
			targetUnit:GetOrigin(),
		nil,
		abil:GetLevelSpecialValueFor("radius", abil:GetLevel() - 1),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)
	local particle = ParticleManager:CreateParticle("particles/basic_projectile/cherry_explode.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle, 0, targetUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", targetUnit:GetOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle) 
	
	local dmg = abil:GetLevelSpecialValueFor("dmg", abil:GetLevel() - 1)
	for _, fucker in pairs(enemies) do
		local damageTable = {
			victim = fucker,
			attacker = caster,
			damage = dmg,
			damage_type = DAMAGE_TYPE_MAGICAL
		}

		ApplyDamage(damageTable)
	end
	Timers:CreateTimer(
			.5,
			function()
				targetUnit:RemoveSelf()
			end
		)
end

function aoeTowerHit(keys)
	local enemies
	local caster = keys.caster
	local targetUnit = keys.target
	if keys.caster == keys.target then
			enemies =
				FindUnitsInRadius(
				caster:GetTeamNumber(),
				caster:GetOrigin(),
				nil,
				1150,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
				FIND_ANY_ORDER, 
				false
			)
		
		if #enemies > 0 then
			local index = RandomInt(1, #enemies)
			newTarget = enemies[index]
			local info2 = {
				Ability = caster:GetAbilityByIndex(0),
				Source = caster,
				Target = newTarget,
				vSourceLoc = caster:GetOrigin(),
				EffectName = "particles/basic_projectile/tower_fire.vpcf",
				bProvidesVision = false,
				iVisionRadius = 1150,
				iVisionTeamNumber = caster:GetTeamNumber(),
				bDeleteOnHit = false,
				iMoveSpeed = 950,
				vVelocity = 950
			}
			projectile = ProjectileManager:CreateTrackingProjectile(info2)
		end
		return
	end

	if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		enemies =
			FindUnitsInRadius(
			DOTA_TEAM_BADGUYS,
			targetUnit:GetOrigin(),
			nil,
			120,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
			FIND_ANY_ORDER, 
			false
		)
	else
		enemies =
			FindUnitsInRadius(
			DOTA_TEAM_GOODGUYS,
			targetUnit:GetOrigin(),
			nil,
			120,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
			FIND_ANY_ORDER, 
			false
		)
	end
	for _, fucker in pairs(enemies) do
		--print((caster:GetOrigin()-fucker:GetOrigin()):Length())
		if (caster:GetOrigin()-fucker:GetOrigin()):Length()<1180 then
			local dmg = fucker:GetMaxHealth() * 0.08
			
			local damageTable = {
				victim = fucker,
				attacker = caster,
				damage = dmg,
				damage_type = DAMAGE_TYPE_PURE
			}

			ApplyDamage(damageTable)
		end
	end
end

function aoeTowerFire(keys)
	local newTarget
	local caster = keys.caster
	local enemies
	local allies
	
	--hscript CreateUnitByName( string name, vector origin, bool findOpenSpot, hscript, hscript, int team)
	if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		allies =FindUnitsInRadius(
			DOTA_TEAM_GOODGUYS,
			caster:GetOrigin(),
			nil,
			1150,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
			FIND_ANY_ORDER, 
			false
		)
	else
		allies =
			FindUnitsInRadius(
			DOTA_TEAM_BADGUYS,
			caster:GetOrigin(),
			nil,
			1150,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
			FIND_ANY_ORDER, 
			false
		)
	end

	if #allies > 0 then
		
		local index = RandomInt(1, #allies)
			newTarget = allies[index]
		local info = {
			Ability = caster:GetAbilityByIndex(0),
			Source = caster,
			Target = caster,
			vSourceLoc = newTarget:GetOrigin(),
			EffectName = "particles/basic_projectile/tower_load.vpcf",
			bProvidesVision = false,
			iVisionRadius = 1100,
			iVisionTeamNumber = caster:GetTeamNumber(),
			bDeleteOnHit = false,
			iMoveSpeed = 2000,
			vVelocity = 2000
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
	end
end

function creatredwhale(keys)
	--print("made the unit")

end

function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then
		return
	end

	done = done or {}
	done[t] = true
	indent = indent or 0

	local l = {}
	for k, v in pairs(t) do
		table.insert(l, k)
	end

	table.sort(l)
	for k, v in ipairs(l) do
		-- Ignore FDesc
		if v ~= "FDesc" then
			local value = t[v]

			if type(value) == "table" and not done[value] then
				done[value] = true
				 print(string.rep("\t", indent) .. tostring(v) .. ":")
				PrintTable(value, indent + 2, done)
			elseif type(value) == "userdata" and not done[value] then
				done[value] = true
				 print(string.rep("\t", indent) .. tostring(v) .. ": " .. tostring(value))
				PrintTable((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
			else
				if t.FDesc and t.FDesc[v] then
					 print(string.rep("\t", indent) .. tostring(t.FDesc[v]))
				else
					 print(string.rep("\t", indent) .. tostring(v) .. ": " .. tostring(value))
				end
			end
		end
	end
end

function portCannon(args) -- keys is the information sent by the ability
	local caster = args.caster
	local ability = args.ability
   local targetUnit = args.target
   local effect = "particles/basic_projectile/b_ball.vpcf"
   if caster:HasModifier("concus_ammo") then
		effect = "particles/basic_projectile/c_ball_incin.vpcf"
   end 
  
   local range = ability:GetSpecialValueFor("range")
   local pos=3
   local attachname = "p"
   local startradl=math.atan2(caster:GetForwardVector().y,caster:GetForwardVector().x)
   startradl=startradl+.1
	for ind =1,3 do
		local modrad=-.1*(ind-2)
		--print(modrad)
		fireCannon(caster, pos, range, attachname, modrad, ind)
	end
end

function starboardCannon(args) -- keys is the information sent by the ability
	local caster = args.caster
	local ability = args.ability
	local targetUnit = args.target
	local rangebuff = caster:FindAbilityByName("cannon_range")
	local range = ability:GetSpecialValueFor("range")
	local pos=1
	local attachname = "s"
	local startradl=math.atan2(caster:GetForwardVector().y,caster:GetForwardVector().x) + .1

	for ind = 1,3 do
		local modrad=.1*(ind-2)
		fireCannon(caster, pos, range, attachname, modrad, ind)
	end
end

function bowCannon(args) -- keys is the information sent by the ability
	local caster = args.caster
	local ability = args.ability
	local targetUnit = args.target
	local caster = args.caster
	local ability = args.ability
	local rangebuff = caster:FindAbilityByName("cannon_range")
	local range = ability:GetSpecialValueFor("range")
	local num_shots = ability:GetSpecialValueFor("num_shots")
	local pos = 0
	local attachname = "b"
	local secondShotDelay = .5

	-- First Volley
	for i=1,2 do
			local modrad = -.1 + (.1 * i)
			fireCannon(caster, pos, range, attachname, modrad, i)
		end

	-- Second Volley
	Timers:CreateTimer(secondShotDelay, function()
		for i=1,2 do
			local modrad = -.1 + (.1 * i)
			fireCannon(caster, pos, range, attachname, modrad, i)
		end
	end)
	
end

function fireCannon(caster, pos, range, attachname, modrad, ind)
	local startradl = math.atan2(caster:GetForwardVector().y,caster:GetForwardVector().x)
	local effect = "particles/basic_projectile/b_ball.vpcf"

	local pi = 3.1415926
	local dir = Vector(
		math.sin(pos*2*pi/(4)-(startradl+modrad)+pi/4+pi/5+pi/11),
		math.cos(pos*2*pi/(4)-(startradl+modrad)+pi/4+pi/5+pi/11),
		0
	)

	EmitSoundOn("Hero_Gyrocopter.FlackCannon", caster)

	local attachID = caster:ScriptLookupAttachment(attachname .. ind)
  local attachOrigin = caster:GetAttachmentOrigin(attachID)

  local providesVision = false

  if caster:HasModifier("cannon_fire_buff") then
  	providesVision = true
		effect = "particles/basic_projectile/c_ball_incin.vpcf"
	elseif caster:HasModifier("cannon_ice_buff") then
		effect = "particles/basic_projectile/c_ball_ice.vpcf"
	elseif caster:HasModifier("cannon_splash_buff") then
		 effect = "particles/basic_projectile/c_ball_splash.vpcf"
	end

	local info = {
		Ability = caster:GetAbilityByIndex(0),
		EffectName = effect,
		vSpawnOrigin = attachOrigin,
		fDistance = range,
		fStartRadius = 60,
		fEndRadius = 60,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = dir*1600,
		bProvidesVision = providesVision,
		iVisionRadius = 600,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	print("CreateLinearProjectile")
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function fireForwardCannons(args)
	bowCannon(args)
end

function fireSideCannons(args)
	local ability = args.ability
	local casterUnit = args.caster

	starboardCannon(args)
	portCannon(args)

	local abil1 = casterUnit:FindAbilityByName("port_cannons")
	local abil3 = casterUnit:FindAbilityByName("starboard_cannon")

	local cooldown = abil1:GetCooldown(abil1:GetLevel())

	abil1:StartCooldown(cooldown)
	abil3:StartCooldown(cooldown)
end

function FireAllCannons(args)
	print("fireall")
	starboardCannon(args)
	portCannon(args)
	bowCannon(args)
end

function ChangeWeapons(caster, oldWeaponAbility, newWeaponName)
	local level = oldWeaponAbility:GetLevel()
	local index = oldWeaponAbility:GetAbilityIndex()
	local oldWeaponName = oldWeaponAbility:GetAbilityName()

	caster:RemoveAbility(oldWeaponName)

	caster:RemoveModifierByName("cannon_fire_buff")
	caster:RemoveModifierByName("cannon_ice_buff")
	caster:RemoveModifierByName("cannon_splash_buff")

	local newWeaponAbility = caster:AddAbility(newWeaponName)
	newWeaponAbility:SetLevel(level)
	newWeaponAbility:SetAbilityIndex(index)
end

function ChangeWeaponToFire(args)
	local ability = args.ability
	local caster = args.caster

	local newAbility = "ironclad_weapon_fire"

	ChangeWeapons(caster, ability, newAbility)
end

function ChangeWeaponToIce(args)
	local ability = args.ability
	local caster = args.caster

	local newAbility = "ironclad_weapon_ice"

	ChangeWeapons(caster, ability, newAbility)
end

function ChangeWeaponToSplash(args)
	local ability = args.ability
	local caster = args.caster

	local newAbility = "ironclad_weapon_splash"

	ChangeWeapons(caster, ability, newAbility)
end

function cannonHit(args)
	local ability = args.ability
	local casterUnit = args.caster
	local targetUnit = args.target
	local damageType = DAMAGE_TYPE_MAGICAL
	local damage = ability:GetSpecialValueFor("damage_tooltip")

	if casterUnit:HasModifier("cannon_fire_buff") then
		local weaponBuffAbility = casterUnit:FindAbilityByName("ironclad_weapon_fire")
		damage = damage + weaponBuffAbility:GetSpecialValueFor("damage")
		local damageType = DAMAGE_TYPE_PURE
	elseif casterUnit:HasModifier("cannon_ice_buff") then
		local weaponBuffAbility = casterUnit:FindAbilityByName("ironclad_weapon_ice")
		-- Apply the slow modifier
		weaponBuffAbility:ApplyDataDrivenModifier(casterUnit, targetUnit, "cannon_ice_slow", {})
	elseif casterUnit:HasModifier("cannon_splash_buff") then
		local weaponBuffAbility = casterUnit:FindAbilityByName("ironclad_weapon_splash")
		local splash_pct = weaponBuffAbility:GetSpecialValueFor("splash_pct")
		local aoe = weaponBuffAbility:GetSpecialValueFor("aoe")
		-- Splash
		local nearbyUnits = FindUnitsInRadius(
			casterUnit:GetTeam(),
		 	targetUnit:GetAbsOrigin(), 
		 	nil, 
		 	aoe,
		 	DOTA_UNIT_TARGET_TEAM_ENEMY, 
		 	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		 	DOTA_UNIT_TARGET_FLAG_NONE, 
		 	FIND_ANY_ORDER, 
		 	false
		 )

		for _,unit in pairs(nearbyUnits) do
			if unit ~= targetUnit then
				local splashDamage = damage * splash_pct * .01
				local damageTable = {
					victim = unit,
					attacker = casterUnit,
					damage = splashDamage,
					damage_type = DAMAGE_TYPE_MAGICAL
				}

				ApplyDamage(damageTable)
			end
		end
	end
	local damageTable = {
		victim = targetUnit,
		attacker = casterUnit,
		damage = damage,
		damage_type = damageType
	}

	ApplyDamage(damageTable)
end

function levelCannons(args)
	local ability = args.ability
	local casterUnit = args.caster
	local level = ability:GetLevel()

	local abil1 = casterUnit:FindAbilityByName("port_cannons")
	local abil2 = casterUnit:FindAbilityByName("bow_cannon")
	local abil3 = casterUnit:FindAbilityByName("starboard_cannon")

	if abil1:GetLevel()~=level then
		abil1:SetLevel(level)
	end
	
	if abil2:GetLevel()~=level then
		abil2:SetLevel(level)
	end 
	
	if abil3:GetLevel()~=level then
		abil3:SetLevel(level)
	end
end

function sevenCheck(args)
	local ability = args.ability
	local caster = args.caster
	local target = args.target

	local breakDistance = 1500

	if target and target:IsAlive() then
		local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()

		if distance > breakDistance then
			caster:InterruptChannel()
		end
	end
end