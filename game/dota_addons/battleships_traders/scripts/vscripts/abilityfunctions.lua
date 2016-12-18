if abilityFunctions == nil then
	print ( '[AbilityFunctions] creating abilityFunctions' )
	abilityFunctions = {} -- Creates an array to let us beable to index abilityFunctions when creating new functions
	abilityFunctions.__index = abilityFunctions
end
 
function abilityFunctions:new() -- Creates the new class
	print ( '[AbilityFunctions] abilityFunctions:new' )
	o = o or {}
	setmetatable( o, abilityFunctions )
	return o
end
 
function abilityFunctions:start() -- Runs whenever the abilityFunctions.lua is ran
	print('[AbilityFunctions] abilityFunctions started!')
end

function battleshipHealth(args)

		
end

function route(args)

			args.caster:MoveToPositionAggressive(args.target_points[1] )
end



function removeAircrafts(keys)
	local casterUnit = keys.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	casterUnit:SetModel("models/Aircraft_boat_e.vmdl")
	casterUnit:SetOriginalModel("models/Aircraft_boat_e.vmdl")
end

function restoreAircrafts(keys)
	local casterUnit = keys.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	casterUnit:SetModel("models/Aircraft_boat2.vmdl")
	casterUnit:SetOriginalModel("models/Aircraft_boat2.vmdl")
end


function startDisco(keys) -- keys is the information sent by the ability

	local casterUnit = EntIndexToHScript( keys.caster_entindex ) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	casterUnit:MakeVisibleDueToAttack(1)
	casterUnit:MakeVisibleDueToAttack(2)
	casterUnit:MakeVisibleDueToAttack(3)
	casterUnit:MakeVisibleDueToAttack(4)
end

function peak(keys) -- keys is the information sent by the ability
	print( '[AbilityFunctions] peak  Called' )
	local casterUnit = EntIndexToHScript( keys.caster_entindex )
	
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		 print('[ItemFunctions] peak found a hero!')
		if hero ~= nil and hero:IsRealHero() then
			if hero:GetTeamNumber() ~=  casterUnit:GetTeamNumber()  then
				hero:MakeVisibleDueToAttack(1)
				hero:MakeVisibleDueToAttack(2)
				hero:MakeVisibleDueToAttack(3)
				hero:MakeVisibleDueToAttack(4)
			end
		end
	end
		
end


function startGunningIt(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
local casterUnit = args.caster
		GunTicks[casterUnit:GetOwner():GetPlayerID()]=1
end



function rammingIt(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		if not IsPhysicsUnit(casterUnit) then
			Physics:Unit(casterUnit)
		end
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterUnit:GetForwardVector()
		local abil = casterUnit:GetAbilityByIndex(2)
		local level = abil:GetLevel()
        local vec = direction:Normalized() * (30 * level +80)
		casterUnit:AddPhysicsVelocity(vec)
		
end

function startRammingIt(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

		local abil = casterUnit:GetAbilityByIndex(2)
		local level = abil:GetLevel()
       StartAnimation(casterUnit, {duration=2.2, activity=ACT_SCRIPT_CUSTOM_1,rate=(level+2)/4})
		
end

function DrumbAnimate(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

		local abil = casterUnit:GetAbilityByIndex(2)
		local level = abil:GetLevel()
       StartAnimation(casterUnit, {duration=2.2+.3*level, activity=ACT_DOTA_RUN,rate=1.5})
		
end



dumpingItDir={}
function dumpingIt(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')

		local casterUnit = args.caster
		if dumpingItDir[casterUnit]==nil or dumpingItDir[casterUnit]==0 then
			dumpingItDir[casterUnit]=casterUnit:GetForwardVector()
		
		end
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		if not IsPhysicsUnit(casterUnit) then
			Physics:Unit(casterUnit)
		end
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterUnit:GetForwardVector()
		local abil = casterUnit:GetAbilityByIndex(3)
		local level = abil:GetLevel()
        local vec = direction:Normalized() * (100 * level +300)
		casterUnit:SetPhysicsVelocity(vec)
end
function clearDir(args)
local casterUnit = args.caster
 dumpingItDir[casterUnit]=0
end

oneshots={
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
	local a=RandomInt( 1, 3 )
	if a==1 then
		local newItem = CreateItem( "item_bag_of_gold_battleships", nil, nil )
		local drop = CreateItemOnPositionForLaunch( casterUnit:GetOrigin(), newItem )
		local direction=casterUnit:GetForwardVector()
		 local vec = direction:Normalized() * -200
		newItem:LaunchLootInitialHeight( false, 0, 300, 0.75, casterUnit:GetOrigin() + vec )

	elseif a==2 then
		
		local newItem = CreateItem( oneshots[RandomInt( 1, #oneshots )], nil, nil )
		local drop = CreateItemOnPositionForLaunch( casterUnit:GetOrigin(), newItem )
		local direction=casterUnit:GetForwardVector()
		 local vec = direction:Normalized() * -200
		newItem:LaunchLootInitialHeight( false, 0, 300, 0.75, casterUnit:GetOrigin() + vec )

	else
	
	end
end
function giveGold(args)
local casterUnit = args.caster
local herogold = casterUnit:GetGold()
casterUnit:SetGold(herogold+100,true)
casterUnit:SetGold(0,false)
end

GunTicks = {}
function gunningIt(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		if not IsPhysicsUnit(casterUnit) then
			Physics:Unit(casterUnit)
		end
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterUnit:GetForwardVector()
		local abil = casterUnit:GetAbilityByIndex(2)
		local level = abil:GetLevel()
        local vec = direction:Normalized() * (20 * level +40)
		casterUnit:AddPhysicsVelocity(vec)
	if GunTicks[casterUnit:GetOwner():GetPlayerID()] ~= nil  then
		GunTicks[casterUnit:GetOwner():GetPlayerID()] = GunTicks[casterUnit:GetOwner():GetPlayerID()]+1
		casterUnit:RemoveModifierByName("remove_wreaking_it")	
		abil:ApplyDataDrivenModifier(casterUnit, casterUnit, "wreaking_it", nil)
			
	else
		GunTicks[casterUnit:GetOwner():GetPlayerID()]=1
		casterUnit:RemoveModifierByName("remove_wreaking_it")	
		abil:ApplyDataDrivenModifier(casterUnit, casterUnit, "wreaking_it", nil)
			
	end
end

	
function gunningItDamage(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
	
	local casterUnit = args.caster
if GunTicks[casterUnit:GetOwner():GetPlayerID()]~=nil and GunTicks[casterUnit:GetOwner():GetPlayerID()]>0 then
	
		
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local abil = casterUnit:GetAbilityByIndex(2)
		local level = abil:GetLevel()
		local dmg=casterUnit:GetMaxHealth()*0.0005*GunTicks[casterUnit:GetOwner():GetPlayerID()]
		
		local damageTable = {
			victim = casterUnit,
			attacker = casterUnit,
			damage = dmg,
			damage_type = DAMAGE_TYPE_PURE,
		}
 
		ApplyDamage(damageTable)
		else
			casterUnit:RemoveModifierByName("wreaking_it")
			casterUnit:RemoveModifierByName("remove_wreaking_it")			
		end
		
end
function gunningItDamageRemove(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	if GunTicks[casterUnit:GetOwner():GetPlayerID()]~=nil and GunTicks[casterUnit:GetOwner():GetPlayerID()]>0 then
		GunTicks[casterUnit:GetOwner():GetPlayerID()]=GunTicks[casterUnit:GetOwner():GetPlayerID()]-1
	end

	
end


function PistolDamage(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local abil = casterUnit:GetAbilityByIndex(0)
		local level = abil:GetLevel()
		local targetUnit = args.target
		local dmg=casterUnit:GetMaxHealth()*0.0005*level+(1.7*level)
		local damageTable = {
			victim = targetUnit,
			attacker = casterUnit,
			damage = dmg,
			damage_type = DAMAGE_TYPE_PURE,
		}
 
		ApplyDamage(damageTable)
end

function unstick(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local hero = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local direction =  hero:GetForwardVector()
					local vec = direction:Normalized() * 5.0
					local vecorig = hero:GetOrigin()
					hero:SetOrigin(vecorig+vec)
end
				

function fly(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterUnit:GetForwardVector()
        local vec = direction:Normalized() * 21.0
		local vecorig = casterUnit:GetOrigin() * Vector(1,1,0) + Vector(0,0,300)
		
		
		casterUnit:SetOrigin(vecorig+vec)
		
end

function fly2(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterUnit:GetForwardVector()
        local vec = direction:Normalized() * 21.0
		local vecorig = casterUnit:GetOrigin() * Vector(1,1,1)
		
		
		casterUnit:SetOrigin(vecorig+vec)
		
end



BurstTicks = {}
cooloffCalls = {}
function burstingIt(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	
	casterUnit:AddNewModifier(casterUnit, nil, "modifier_bloodseeker_thirst", {}) 
	
end
function burstingItDamage(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local abil = casterUnit:GetAbilityByIndex(2)
		local level = abil:GetLevel()
	if casterUnit:HasModifier("bursting_it") then
		if BurstTicks[casterUnit:GetOwner():GetPlayerID()] ~= nil  then
			BurstTicks[casterUnit:GetOwner():GetPlayerID()] = BurstTicks[casterUnit:GetOwner():GetPlayerID()]+1
		else
			BurstTicks[casterUnit:GetOwner():GetPlayerID()]=1
		end

		local dmg=casterUnit:GetMaxHealth()*0.003*BurstTicks[casterUnit:GetOwner():GetPlayerID()]/10
		


	
		local damageTable = {
			victim = casterUnit,
			attacker = casterUnit,
			damage = dmg,
			damage_type = DAMAGE_TYPE_PURE,
		}
		ApplyDamage(damageTable)
	end
		if not casterUnit:HasModifier("remove_wreaking_it") then
			cooloffCalls[casterUnit:GetOwner():GetPlayerID()]=0
		end
		
		
end


function burstingItDamageRemove(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
	local casterUnit = args.caster
	
	if BurstTicks[casterUnit:GetOwner():GetPlayerID()]~=nil and BurstTicks[casterUnit:GetOwner():GetPlayerID()]>0 then
		local totalburst = BurstTicks[casterUnit:GetOwner():GetPlayerID()] * 6/(6-cooloffCalls[casterUnit:GetOwner():GetPlayerID()])
		BurstTicks[casterUnit:GetOwner():GetPlayerID()]= totalburst*(5-cooloffCalls[casterUnit:GetOwner():GetPlayerID()])/6
	end
	if cooloffCalls[casterUnit:GetOwner():GetPlayerID()] ~= nil then
		cooloffCalls[casterUnit:GetOwner():GetPlayerID()]=cooloffCalls[casterUnit:GetOwner():GetPlayerID()]+1
	end
	
end






function panic(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		local abil = casterUnit:GetAbilityByIndex(2)
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	local level = abil:GetLevel()
	moveBonus=casterUnit:GetHealthPercent() 
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	local i = 0
	  abil:ApplyDataDrivenModifier(casterUnit, casterUnit, "panic_time", nil)
	while i < 100 - moveBonus do
        abil:ApplyDataDrivenModifier(casterUnit, casterUnit, "panic_time", nil)
		i=i+10
	end
 
		
end
function SwapMission(args)

local heroBuying=args.caster
local olditem=""
local diff=0
	
		for itemSlot = 0, 5, 1 do 
				if heroBuying ~= nil then
					local Item = heroBuying:GetItemInSlot( itemSlot )
					if Item ~= nil then
						olditem=Item:GetName()
						if  string.match(olditem,"item_contract_easy") then
							diff=1
							heroBuying:RemoveItem(Item)
						end
						if  string.match(olditem,"item_contract_medium") then
							diff=2
							heroBuying:RemoveItem(Item)
						end
						if  string.match(olditem,"item_contract_hard") then
							diff=3
							heroBuying:RemoveItem(Item)
						end
					end
				end
			end
	
	if diff~=0 then
			print("inrange")
			local missionPool=Entities:FindAllByName("npc_dota_buil*")
			local chosenMission
			local missionDist
			while chosenMission==nil do
				local i = RandomInt( 1, #missionPool )
				if not string.match(missionPool[i]:GetUnitName(),olditem)  and not string.match(missionPool[i]:GetUnitName(),"ship") and (heroBuying:GetOrigin()-missionPool[i]:GetOrigin()):Length()>2500 then
					chosenMission=missionPool[i]
				end
			end

			local newItem

				if diff==1  then
					 newItem = CreateItem(string.gsub(chosenMission:GetUnitName(),"npc_dota_shop", "item_contract_easy"), hero, hero)
				elseif  diff==2 then
					 newItem = CreateItem(string.gsub(chosenMission:GetUnitName(),"npc_dota_shop", "item_contract_medium"), hero, hero)
				else
					 newItem = CreateItem(string.gsub(chosenMission:GetUnitName(),"npc_dota_shop", "item_contract_hard"), hero, hero)
				end

			if newItem ~= nil then                   -- makes sure that the item exists and making sure it is the correct item
				print("Item Is: " .. newItem:GetName() )
				heroBuying:AddItem(newItem)
				
				EmitSoundOnClient("ui.npe_objective_given",PlayerResource:GetPlayer(heroBuying:GetPlayerID()))
										
				local data =
				{
					Player_ID = heroBuying:GetPlayerID();
					Ally_ID = 0;
					x =  chosenMission:GetAbsOrigin().x;
					y =  chosenMission:GetAbsOrigin().y;
					z =  chosenMission:GetAbsOrigin().z;
				}
				FireGameEvent("Team_Cannot_Buy",data)
				
				end
		end
end





function CallBatFly(args) -- keys is the information sent by the ability
		print('[ItemFunctions] CallPuckDive started! ')

		local casterUnit = args.caster
		local ability = "batrider_firefly_battleship"
		
		local abil = casterUnit:GetAbilityByIndex(1)
		local level = abil:GetLevel()
		
		local abil1 = casterUnit:GetAbilityByIndex(3)
			local level2 = abil1:GetLevel()
		casterUnit:RemoveAbility(abil1:GetAbilityName())
		casterUnit:AddAbility(ability)
		
		local abil2 = casterUnit:GetAbilityByIndex(3)
		abil2:SetLevel(level)
		abil2:CastAbility()
		casterUnit:RemoveAbility(abil2:GetAbilityName())
		casterUnit:AddAbility("mayday_battleship")
		local abil3 = casterUnit:GetAbilityByIndex(3)
		abil3:SetLevel(level2)
end


function CallSlarkInvis(args) -- keys is the information sent by the ability
		print('[ItemFunctions] CallPuckDive started! ')

		local casterUnit = args.caster
		local ability = "slark_shadow_dance_battleship"
		
		local abil = casterUnit:GetAbilityByIndex(2)
		local level = abil:GetLevel()
		
		local abil1 = casterUnit:GetAbilityByIndex(3)
			local level2 = abil1:GetLevel()
		casterUnit:RemoveAbility(abil1:GetAbilityName())
		casterUnit:AddAbility(ability)
		
		local abil2 = casterUnit:GetAbilityByIndex(3)
		abil2:SetLevel(level)
		abil2:CastAbility()
		casterUnit:RemoveAbility(abil2:GetAbilityName())
		casterUnit:AddAbility("batten_hatches")
		local abil3 = casterUnit:GetAbilityByIndex(3)
		abil3:SetLevel(level2)
		
		Timers:CreateTimer( 4, function()
		 RemoveDD(args)
	end)
end


function checkCliff(args) -- keys is the information sent by the ability


		local casterUnit = args.caster
		local height = casterUnit:GetOrigin() * Vector(0,0,1)

			local allUnits = FindUnitsInRadius( DOTA_TEAM_BADGUYS, casterUnit:GetOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
			local allUnits2 = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, casterUnit:GetOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
			for k,v in pairs(allUnits2) do allUnits[k] = v end
			
			
		print('[check cliff] found ' .. tostring(#allUnits))
		if  height:Length() > 110 and #allUnits == 1 then		
			local damageTable = {
				victim = casterUnit,
				attacker = casterUnit,
				damage = 10000,
				damage_type = DAMAGE_TYPE_PURE,
			}
			
			ApplyDamage(damageTable)
		end
		
	
end

function CheckForRing(args) -- keys is the information sent by the ability

	local casterUnit = args.caster
	local allUnits = FindUnitsInRadius( DOTA_TEAM_BADGUYS, casterUnit:GetOrigin(), nil, 80, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	local allUnits2 = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, casterUnit:GetOrigin(), nil, 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #allUnits == 1 then
			local creature = CreateUnitByName( "npc_dota_rng_ind" , casterUnit:GetOrigin() , true, nil, nil, casterUnit:GetTeamNumber() )
	end
	
end



function CallPuckDive(args) -- keys is the information sent by the ability
		print('[ItemFunctions] CallPuckDive started! ')

		local casterUnit = args.caster
		local ability = "dive_battleship_puck"
		
		local abil = casterUnit:GetAbilityByIndex(1)
		local level = abil:GetLevel()
		 StartAnimation(casterUnit, {duration=.4+.2*level, activity=ACT_SCRIPT_CUSTOM_0, rate=2/(.4+.2*level)})
	
		
end


function stopGunningIt(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
local casterUnit = args.caster
	local direction =  casterUnit:GetForwardVector()
        local vec = direction:Normalized() * 0.0
		
		Physics:Unit(casterUnit)
		
		casterUnit:SetPhysicsAcceleration(vec)

end

function stopGunningItAbility(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
local casterUnit = args.caster
	local direction =  casterUnit:GetForwardVector()
        local vec = direction:Normalized() * 0.0
		local abil = casterUnit:GetAbilityByIndex(2)
		print(GunTicks[casterUnit:GetOwner():GetPlayerID()])
		if abil:GetLevel()~=0 and not casterUnit:HasModifier("remove_wreaking_it") and GunTicks[casterUnit:GetOwner():GetPlayerID()]~=nil  and GunTicks[casterUnit:GetOwner():GetPlayerID()]>2 then
			abil:ToggleAbility()
		end
		Physics:Unit(casterUnit)
		
		casterUnit:SetPhysicsAcceleration(vec)
		 
	
end



function RainbowDied(args)
	print('[ability] rainbow died started! ')
	local casterUnit = args.caster
		local abil = casterUnit:GetAbilityByIndex(2)
		local level = abil:GetLevel()
		local i = 0
		
		while level+4>i do
			local creature = CreateUnitByName( "npc_dota_rainbow_unit" , casterUnit:GetOrigin() * Vector(1,1,0) + Vector(0,0,200) , true, nil, nil, casterUnit:GetTeamNumber() )
			 creature:AddNewModifier(creature, nil, "modifier_kill", {duration = 5})
			i = i + 1
		end
	
end
 
-- uses a variable which gets the actual ability in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
-- makes sure that the ability exists and making sure it is the correct ability
function toggle_item(keys) -- keys is the information sent by the ability
	print( '[AbilityFunctions] toggle_item  Called' )

	local casterUnit = EntIndexToHScript( keys.caster_entindex ) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as earthshaker_blade_dance.
	if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 5, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
	        	if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
                		local Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
                		if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
                			Item:ToggleAbility()
                		end
	        	end
		end
	end
end
function TeleHome(keys) -- keys is the information sent by the ability
Timers:CreateTimer( 0.1, function()
	
	print( '[AbilityFunctions] toggle_item  Called' )
	local casterUnit = EntIndexToHScript( keys.caster_entindex )
	local vecorig = Vector(0,0,0)
	if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		 vecorig = Vector(-30,-7104,0)+RandomVector( RandomFloat( 0, 100 ))
	elseif  casterUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		 vecorig = Vector(0,7040,0)+RandomVector( RandomFloat( 0, 100 ))
	end	
	casterUnit:SetOrigin(vecorig)
	 end
	 )
end
	
	function keepUp(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local targetUnit = args.target
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
		local hp1 = casterUnit:GetHealth()/casterUnit:GetMaxHealth()
		local hp2 = targetUnit:GetHealth()/targetUnit:GetMaxHealth()
		local newhp = (hp1+hp2)/2
		if hp1<newhp -.007 then
			casterUnit:SetHealth(casterUnit:GetHealth()+.007 * casterUnit:GetMaxHealth())
		elseif hp1>newhp + .007 then
			casterUnit:SetHealth(casterUnit:GetHealth()-.007 * casterUnit:GetMaxHealth())
		else
			casterUnit:SetHealth(newhp*casterUnit:GetMaxHealth())
		end
		
		if hp2<newhp -.007 then
			targetUnit:SetHealth(targetUnit:GetHealth()+.007 * targetUnit:GetMaxHealth())
		elseif hp2>newhp + .007 then
			targetUnit:SetHealth(targetUnit:GetHealth()-.007 * targetUnit:GetMaxHealth())
		else
			targetUnit:SetHealth(newhp*targetUnit:GetMaxHealth())
		end
		
end
function swapToGiraffe(args) -- keys is the information sent by the ability
		print('[ItemFunctions] swaptogiraffe started! ')

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
		print('[ItemFunctions] drag started! ')
		local targetUnit = args.target
		local newTarget
		local caster = args.caster
		
		local enemies = FindUnitsInRadius( targetUnit:GetTeamNumber(), targetUnit:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #enemies > 0 then
		local index = RandomInt( 1, #enemies )
		newTarget = enemies[index]
		local info = 
		{
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
			vVelocity = 522,
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
	end
		
		
        
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))


		

end



function getDown(args) 
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterUnit:GetForwardVector()
        local vec = direction:Normalized() * 50.0
		local vecorig = casterUnit:GetOrigin()
		
	casterUnit:MoveToPosition(vecorig+vec)
end
	
function giraffeGrab(args) -- keys is the information sent by the ability
		print('[ItemFunctions] drag started! ')

		local targetPos = args.target:GetAbsOrigin()
		local targetUnit = args.target
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
        local casterPos = args.caster:GetAbsOrigin()
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterPos - targetPos
        local vec = direction:Normalized() * 22.0
		if direction:Length() > 200 and not string.match(targetUnit:GetUnitName(),"rng") then
			local vecorig = targetUnit:GetOrigin()
			targetUnit:SetOrigin(vecorig+vec)
		end
		

end

function moceCarrierIn(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterUnit:GetForwardVector()
        local vec = direction:Normalized() * 50.0
		local vecorig = casterUnit:GetOrigin()
		
		
		casterUnit:SetOrigin((vecorig+vec)* Vector(1,1,0)+Vector(0,0,300))
		
end
function moceCarrierOut(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterUnit:GetForwardVector()
        local vec = direction:Normalized() * -50.0
		local vecorig = casterUnit:GetOrigin()
		
		
		casterUnit:SetOrigin(vecorig+vec)
		
end


function killMe(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		local damageTable = {
			victim = casterUnit,
			attacker = casterUnit,
			damage = 10000,
			damage_type = DAMAGE_TYPE_PURE,
		}
		
		ApplyDamage(damageTable)
		
		
end
	
function submerge(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		print('[ItemFunctions]  sub down ' .. tostring(casterUnit:GetMana()))
		casterUnit:SetModel("models/sub_boat_down")
		casterUnit:SetOriginalModel("models/sub_boat_down")
		if casterUnit:GetMana()<10 then
			local damageTable = {
				victim = casterUnit,
				attacker = casterUnit,
				damage = 10,
				damage_type = DAMAGE_TYPE_PURE,
			}
			
			ApplyDamage(damageTable)
		end
		
end

function submergedmg(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		if casterUnit:GetMana()<10 then
			local damageTable = {
				victim = casterUnit,
				attacker = casterUnit,
				damage = 35,
				damage_type = DAMAGE_TYPE_PURE,
			}
			
			ApplyDamage(damageTable)
		end
		
end

function rise(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		casterUnit:SetModel("models/sub_boat")
		casterUnit:SetOriginalModel("models/sub_boat")
		
end

function inTheHold(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		local targetUnit = args.target
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

		
		local direction =  casterUnit:GetForwardVector()
        local vec = direction:Normalized() * -30
		local vecorig = casterUnit:GetOrigin() * Vector(1,1,0) + Vector(0,0,80) + vec
		targetUnit:SetOrigin(vecorig)
end

function salvagePercent(args) -- keys is the information sent by the ability
		local casterUnit = args.caster
		local targetUnit = args.unit
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

		local abil = casterUnit:GetAbilityByIndex(2)
		local level = abil:GetLevel()
		if targetUnit:IsRealHero() then
			casterUnit:SetHealth(casterUnit:GetHealth()+(targetUnit:GetMaxHealth()*(level/100+.05)))
		else
			casterUnit:SetHealth(casterUnit:GetHealth()+(targetUnit:GetMaxHealth()*(.3)))
		end


end
function bilgeMana(args) -- keys is the information sent by the ability
		local casterUnit = args.caster
		local abil = casterUnit:GetAbilityByIndex(1)
		local level = abil:GetLevel()
		casterUnit:SetMana(casterUnit:GetMana()+level*50)

end

function bomberSpawn(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
        
		local creature
		creature = CreateUnitByName( "npc_dota_air_craft_bomber" , casterUnit:GetOrigin() , true, nil, nil, casterUnit:GetTeam() )

		creature.vOwner = casterUnit:GetOwner()
		creature:SetControllableByPlayer(casterUnit:GetOwner():GetPlayerID(), true )
		--Sets the waypath to follow. path_wp1 in this example
		local direction =  casterUnit:GetForwardVector()
		creature:SetForwardVector(direction)
		creature:SetInitialGoalEntity( waypointlocation )
		
end

function turnAround(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		local direction =  casterUnit:GetForwardVector()*Vector(-1,-1,1)
		casterUnit:SetForwardVector(direction)
		
		
end



function inTheHoldSpawn(args) -- keys is the information sent by the ability
		local casterUnit = args.caster
        
		local creature
		--print ("team is: " .. team .. "     spawn is: " .. team .. "_spawn_" .. lane .. "     comparison yields" .. tostring(team == "north"))
		--hscript CreateUnitByName( string name, vector origin, bool findOpenSpot, hscript, hscript, int team)
		if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			local waypointlocation = Entities:FindByName ( nil,  "south_wp_right3")
			 creature = CreateUnitByName( "npc_dota_boat_south_two" , casterUnit:GetOrigin() , true, nil, nil, DOTA_TEAM_GOODGUYS )
		else
			local waypointlocation = Entities:FindByName ( nil,  "north_wp_right3")
			 creature = CreateUnitByName( "npc_dota_boat_north_two" , casterUnit:GetOrigin() , true, nil, nil, DOTA_TEAM_BADGUYS )
		end
		--Sets the waypath to follow. path_wp1 in this example
		creature.vOwner = casterUnit:GetOwner()
		creature:SetControllableByPlayer(casterUnit:GetOwner():GetPlayerID(), true )
		creature:SetInitialGoalEntity( waypointlocation )
		creature:CreatureLevelUp(20)
end

function pushBack(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local targetPos = args.target:GetAbsOrigin()
		local targetUnit = args.target
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
        local casterPos = args.caster:GetAbsOrigin()
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterPos - targetPos
        local vec = direction:Normalized() * - 90.0
			if not IsPhysicsUnit(targetUnit) then
			Physics:Unit(targetUnit)
		end
			targetUnit:AddPhysicsVelocity(vec)
	
end
function pushBackRefund(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
	if args.target ~= args.caster then --not self target
		
	else --disable self target, refund spell. callback event.ability:OnChannelFinish(true) not needed
		args.ability:RefundManaCost()
		args.ability:EndCooldown()
	end
end

herohp = {}
function reflectGetStartHp(args) -- keys is the information sent by the ability
	local casterUnit = args.caster

	herohp[casterUnit:GetOwner():GetPlayerID()] = casterUnit:GetHealth()
end

function reflect(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	print('[ItemFunctions] REFLECT finished! HP was:' .. herohp[casterUnit:GetOwner():GetPlayerID()])
	local ruseDmg = herohp[casterUnit:GetOwner():GetPlayerID()] - casterUnit:GetHealth() * (0.2+0.1*abil:GetLevel())
	casterUnit:SetHealth(casterUnit:GetHealth()+ruseDmg)
	
end

function takeReflected(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	print('[ItemFunctions] REFLECT finished! HP was:' .. herohp[casterUnit:GetOwner():GetPlayerID()])
	local ruseDmg = herohp[casterUnit:GetOwner():GetPlayerID()] - casterUnit:GetHealth()
	print('[ItemFunctions] REFLECT STARTED started! HP IS:' .. casterUnit:GetHealth() .. ' deal ' .. ruseDmg .. 'to target')
	
	
	local abil = casterUnit:GetAbilityByIndex(2)
	local level = abil:GetLevel()
	ruseDmg = ruseDmg *(0.2+0.1*abil:GetLevel())
	
	local targetUnit = args.target
	local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = ruseDmg,
				damage_type = DAMAGE_TYPE_PURE,
			}
			if casterUnit:IsAlive() then
				ApplyDamage(damageTable)
			end
	print('[ItemFunctions] damage done')
	
end

function mightStart(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	local numunits=0
	
	
	local enemies
		
			--hscript CreateUnitByName( string name, vector origin, bool findOpenSpot, hscript, hscript, int team)
		if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, casterUnit:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		else
			enemies = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, casterUnit:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		end

		 for _,fucker in pairs( enemies) do
		 if casterUnit.strbonus then
			local dmg=  (casterUnit.strbonus*20)/#enemies
			print(dmg)
				local damageTable = {
				victim = fucker,
				attacker = casterUnit,
				damage =dmg,
				damage_type = DAMAGE_TYPE_PURE,
			}
			local tracking_projectile = 
			{
				EffectName = "particles/basic_projectile/might.vpcf",
				Ability = casterUnit:GetAbilityByIndex(1),
				vSpawnOrigin = casterUnit:GetAbsOrigin(),
				Target = fucker,
				Source = args.source or casterUnit,
				bHasFrontalCone = false,
				iMoveSpeed = 750,
				bReplaceExisting = false,
				bProvidesVision = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}
			

				ProjectileManager:CreateTrackingProjectile(tracking_projectile)
				ApplyDamage(damageTable)
				end
		end
	
	
	numunits = FindUnitsInRadius( casterUnit:GetTeamNumber(), casterUnit:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	print('[ItemFunctions] RmightStart started! units is:' .. #numunits)
	local hpPer =  casterUnit:GetHealthPercent()
	print('[ItemFunctions] RmightStart started! hpPer is:' .. hpPer)
	print('[ItemFunctions] new max health should be' .. casterUnit:GetMaxHealth()+35*#numunits)
	casterUnit:ModifyStrength(3*#numunits)
	casterUnit.strbonus=#numunits
	 for _,friend in pairs( numunits) do

			local tracking_projectile = 
			{
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
				ApplyDamage(damageTable)
				end

	

end


function mightStop(args) -- keys is the information sent by the ability
	local casterUnit = args.caster
	print('[ItemFunctions] Rmightstop started')
	casterUnit:SetBaseStrength(1)
end


 function airBlast(args) -- keys is the information sent by the ability
		print('[ItemFunctions] drag started! ')
		local targetUnit = args.target
		local newTarget
		local caster = args.caster
		
		local info = 
	{
		Ability = caster:GetAbilityByIndex(2),
        	EffectName = "particles/basic_projectile/blast_effect.vpcf",
        	vSpawnOrigin = caster:GetAbsOrigin(),
        	fDistance = 1000,
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
		vVelocity = caster:GetForwardVector() * -1200,
		bProvidesVision = true,
		iVisionRadius = 600,
		iVisionTeamNumber = caster:GetTeamNumber()
	}

		projectile = ProjectileManager:CreateLinearProjectile(info)
		

		

end

 function dragonBlast(args) -- keys is the information sent by the ability
		print('[ItemFunctions] dragonBlast started! ')

		local targetUnit = args.target
		local newTarget
		local caster = args.caster
		local enemies
			--hscript CreateUnitByName( string name, vector origin, bool findOpenSpot, hscript, hscript, int team)
		if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, targetUnit:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		else
			enemies = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, targetUnit:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		end
	
		
			if #enemies > 0 then
		local index = RandomInt( 1, #enemies )
		newTarget = enemies[index]
		local info = 
		{
			Ability = caster:GetAbilityByIndex(1),	
			Source = targetUnit,
			Target = newTarget,
			vSourceLoc = targetUnit:GetOrigin(),
			EffectName = "particles/basic_projectile/dragon_proj.vpcf",
			bProvidesVision = false,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber(),
			bDeleteOnHit = false,
			iMoveSpeed = 750,
			vVelocity = 750,
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
	end

end

 function fireGas(args) -- keys is the information sent by the ability
		print('[ItemFunctions] dragonBlast started! ')

		local targetUnit = args.target
		local caster = args.caster

		local info = 
		{
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
		print('[ItemFunctions] dragonBlast started! ')

		local targetPos = args.target:GetAbsOrigin()
		local targetUnit = args.target
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
        local casterPos = args.caster:GetAbsOrigin()
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterPos - targetPos
        local vec = direction:Normalized() * -1.0
		if math.abs((targetUnit:GetForwardVector()+vec):Length())<1.85 then
			targetUnit:SetForwardVector(targetUnit:GetForwardVector()+vec)
		end

end
function unstickPush(args)
local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
print('unstick push is going wooo! ')
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
	if not IsPhysicsUnit(casterUnit) then
			Physics:Unit(casterUnit)
		end
        local direction =  casterUnit:GetPhysicsVelocity()
		
        local vec = direction:Normalized() * -1.0
		
		casterUnit:SetPhysicsAcceleration(vec * 0)
		
		local vecorig = casterUnit:GetOrigin();
		
		
		casterUnit:SetOrigin(vecorig+vec)
end

function faceRan(args)
	local casterUnit = args.caster
		print('[faceRan]  called  ' )
		local vec = RandomVector( RandomFloat( 0, 100 ))
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
       casterUnit:SetForwardVector(vec)
	   casterUnit:SetOrigin(casterUnit:GetOrigin() * Vector(1,1,0))
end

function Rise(args)
	local casterUnit = args.caster
	print('[rise]  called  ' )
		local height = casterUnit:GetOrigin() * Vector(0,0,1)
		if height:Length() < 190 then
			casterUnit:SetOrigin(casterUnit:GetOrigin() + Vector(0,0,2))
		end
end

function aircraftDied(args)
	local casterUnit = args.caster
	if casterUnit ~= nil  and casterUnit:IsOwnedByAnyPlayer() and casterUnit:GetPlayerOwnerID() ~= -1 then
		local id = casterUnit:GetOwner():GetPlayerID()
		for _,plane in pairs( Entities:FindAllByClassname( "npc_dota_creat*")) do
		print('[aircraftDied]  found a plane  ' )
			 if plane ~= nil and string.match(plane:GetUnitName(),"air") and id == plane:GetOwner():GetPlayerID() then
			 print('[aircraftDied]  killed a plane  ' )
					plane:ForceKill(true)
			 end
		
		end
	end
end


function RemoveSelf(args)

	Timers:CreateTimer( 0.03, function()
	
      local casterUnit = args.caster
		casterUnit:ForceKill(true)
	 return nil
    end
  )
	
end


function PingDest(args)
print('[ItemFunctions] PingDest ')
	local itemName = args.ability:GetName()
	print(itemName)
	local itemStrippedEasy=string.gsub(itemName,"item_contract_easy","")
	local itemStrippedMedium=string.gsub(itemName,"item_contract_medium","")
	local itemStrippedHard=string.gsub(itemName,"item_contract_hard","")
	local chosenMission
		for _,mission in pairs(  Entities:FindAllByName( "npc_dota_buil*")) do
				if  string.match(mission:GetUnitName(),itemStrippedEasy) or string.match(mission:GetUnitName(),itemStrippedMedium) or string.match(mission:GetUnitName(),itemStrippedHard)then
					chosenMission=mission
				end
		end
		
	print(chosenMission:GetUnitName())
	if chosenMission ~= nil then
	local data =
	{
		Player_ID = args.caster:GetOwner():GetPlayerID();
		x =  chosenMission:GetAbsOrigin().x;
		y =  chosenMission:GetAbsOrigin().y;
		z =  chosenMission:GetAbsOrigin().z;
	}
	FireGameEvent("ping_loc",data)
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
	local cdleft=caster:GetAbilityByIndex(0):GetCooldownTimeRemaining()
	if cdleft>0 then
		print(cdleft)
		caster:GetAbilityByIndex(0):EndCooldown()
		caster:GetAbilityByIndex(0):StartCooldown(cdleft/2)
	end
	cdleft=caster:GetAbilityByIndex(1):GetCooldownTimeRemaining()
	if cdleft>0 then
	print(cdleft)
		caster:GetAbilityByIndex(1):EndCooldown()
		caster:GetAbilityByIndex(1):StartCooldown(cdleft/2)
	end
	cdleft=caster:GetAbilityByIndex(2):GetCooldownTimeRemaining()
	if cdleft>0 then
	print(cdleft)
		caster:GetAbilityByIndex(2):EndCooldown()
		caster:GetAbilityByIndex(2):StartCooldown(cdleft/2)
	end
	cdleft=caster:GetAbilityByIndex(3):GetCooldownTimeRemaining()
	if cdleft>0 then
	print(cdleft)
		caster:GetAbilityByIndex(3):EndCooldown()
		caster:GetAbilityByIndex(3):StartCooldown(cdleft/2)
	end
end



function latchOn(args)

	local casterUnit = args.caster
	local target
	for _,unit in pairs( Entities:FindAllByNameWithin("npc_dota*",casterUnit:GetOrigin(),300)) do
		if target==nil and unit~= casterUnit then
			target=unit
		end
		if unit~= casterUnit and (target:GetOrigin()-casterUnit:GetOrigin()):Length()>(unit:GetOrigin()-casterUnit:GetOrigin()):Length() then
			target=unit
		end
	end
	
	
	direction=target:GetForwardVector()
	casterUnit:SetForwardVector(direction)
		local vec = direction:Normalized() * -15
	local vecorig = target:GetOrigin() + vec
	local vecorig = target:GetOrigin()
	casterUnit:SetOrigin(vecorig)
end



function throwJav(args) -- keys is the information sent by the ability
		print('[ItemFunctions] drag started! ')
		local targetUnit = args.target
		local newTarget
		local caster = args.caster
		
		local info = 
	{
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
		local dmg=targetUnit:GetMaxHealth()*0.2
		
		local damageTable = {
			victim = targetUnit,
			attacker = casterUnit,
			damage = dmg,
			damage_type = DAMAGE_TYPE_PURE,
		}
 
		ApplyDamage(damageTable)
end

function OilDmg(args)
	local casterUnit = args.caster
		local targetUnit = args.target
		local dmg=targetUnit:GetMaxHealth()*0.05
		
		local damageTable = {
			victim = targetUnit,
			attacker = casterUnit,
			damage = dmg,
			damage_type = DAMAGE_TYPE_PURE,
		}
 
		ApplyDamage(damageTable)
end

function moveToRandom(args)
	local targetUnit = args.target
	local vec = RandomVector( RandomFloat( 100, 200 ))
	targetUnit:MoveToPosition(targetUnit:GetOrigin()+vec )
end

function moveToRandomTradePost(args)
	local casterUnit = args.caster
	local missionPool=Entities:FindAllByName("npc_dota_buil*")
	local chosenMission
	
		while chosenMission==nil do
				local i = RandomInt( 1, #missionPool )
				if  not string.match(missionPool[i]:GetUnitName(),"ship") then
					chosenMission=missionPool[i]
						print(chosenMission:GetOrigin())
				end
			end
	casterUnit:MoveToPosition(chosenMission:GetOrigin() )
	if daralectOwnerArray[creature]==nil or not daralectOwnerArray[creature]:IsAlive() then
		casterUnit:RemoveSelf()
	end
end

function Blur( keys )
	local caster = keys.caster
	local ability = keys.ability
	local casterLocation = caster:GetAbsOrigin()
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	local enemyHeroes = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)

	if #enemyHeroes>0 then
		ability:ApplyDataDrivenModifier(caster, caster, "unghost_ship", {})
		caster:RemoveModifierByName("ghost_ship")
	else
		if caster:HasModifier("unghost_ship") then
		Timers:CreateTimer( 0.1, function()
		caster:RemoveModifierByName("unghost_ship")
		  end)
	
			Timers:CreateTimer( 0.2, function()
		ability:ApplyDataDrivenModifier(caster, caster, "ghost_ship", {})
		 end )
			
		end
		
	end
end

daralectOwnerArray={}
daralectArray={}
function DropOrGo(args)
	local casterUnit = args.caster
	local hasDaralect=false
	if daralectArray[casterUnit]~=nil and not daralectArray[casterUnit]:IsNull() then
	
			creepDirection=daralectArray[casterUnit]:GetForwardVector()
			creepOri=daralectArray[casterUnit]:GetOrigin()
			
			casterUnitDirection=casterUnit:GetForwardVector()
			casterOri=casterUnit:GetOrigin()
			
			casterUnit:SetForwardVector(creepDirection)
			casterUnit:SetOrigin(creepOri)
			daralectArray[casterUnit]:SetForwardVector(casterUnitDirection)
			daralectArray[casterUnit]:SetOrigin(casterOri)
			return
	end
	
	local missionPool=Entities:FindAllByName("npc_dota_buil*")

	

		if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				creature = CreateUnitByName( "daralect_vessle" , casterUnit:GetOrigin() , true, casterUnit:GetOwner(), nil, DOTA_TEAM_GOODGUYS )
				local chosenMission
				while chosenMission==nil do
						local i = RandomInt( 1, #missionPool )
						if  not string.match(missionPool[i]:GetUnitName(),"ship") then
							chosenMission=missionPool[i]
						end
					end
					daralectOwnerArray[creature]=casterUnit
					daralectArray[casterUnit]=creature
					Timers:CreateTimer( 0.03, function()
	
			creature:MoveToPositionAggressive(chosenMission:GetOrigin() )
			print(chosenMission:GetOrigin())
			end)
		else
			 creature = CreateUnitByName( "daralect_vessle" , casterUnit:GetOrigin() , true, casterUnit:GetOwner(), nil, DOTA_TEAM_BADGUYS )
				local chosenMission
				while chosenMission==nil do
						local i = RandomInt( 1, #missionPool )
						if  not string.match(missionPool[i]:GetUnitName(),"ship") then
							chosenMission=missionPool[i]
						end
					end
					daralectOwnerArray[creature]=casterUnit
					daralectArray[casterUnit]=creature
						Timers:CreateTimer( 0.03, function()
			creature:MoveToPositionAggressive(chosenMission:GetOrigin() )
			print(chosenMission:GetOrigin())
				end)
		end
end

function killDaralect(args)
print(daralectArray[casterUnit])
	if daralectArray[casterUnit]~=nil then
		daralectArray[casterUnit]:RemoveSelf()
	end
end

function pullToCaster(keys)
if not IsPhysicsUnit(keys.target) then
			Physics:Unit(keys.target)
		end
		local targetPos = keys.target:GetAbsOrigin()
		local targetUnit = keys.target
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
        local casterPos = keys.caster:GetAbsOrigin()
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterPos - targetPos
		if direction:Length()>150 then
			targetUnit:SetPhysicsVelocity(direction:Normalized() * 400.0)
		end
end


function FirstAid(args) -- keys is the information sent by the ability
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))

			casterUnit:SetHealth(casterUnit:GetHealth()+(casterUnit:GetMaxHealth()*.2))

end

modle_scales={}
function grow(args) -- keys is the information sent by the ability
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		modle_scales[casterUnit]=casterUnit:GetModelScale()
casterUnit:SetModelScale(1.5)
			
end
function reapplyAllBows( hero )
	
end
function shrink(args) -- keys is the information sent by the ability
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		if modle_scales[casterUnit]~=nil then
casterUnit:SetModelScale(modle_scales[casterUnit])
else
casterUnit:SetModelScale(1)
end
			
end



function ApplyDD(args) -- keys is the information sent by the ability
		local casterUnit = args.caster
	local hero = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
for itemSlot = 0, 5, 1 do 
	if hero ~= nil then
		local Item = hero:GetItemInSlot( itemSlot )
		if Item ~= nil and string.match(Item:GetName(),"doubled") then -- makes sure that the item exists and making sure it is the correct item
			local doubledstring = string.gsub(Item:GetName(),"_bow", "_bow_shooting")
			Item:ApplyDataDrivenModifier(hero, hero, doubledstring, nil)
		elseif Item ~= nil and string.match(Item:GetName(),"bow") then -- makes sure that the item exists and making sure it is the correct item
			Item:ApplyDataDrivenModifier(hero, hero, Item:GetName() .. "_shooting", nil)
			print( "bow found." )
		end
	end
end
			
end


function ApplyRandomDD(args) -- keys is the information sent by the ability
		local casterUnit = args.caster
	local hero = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local done=0
		while done==0 do
			for itemSlot = 0, 5, 1 do 
				if hero ~= nil then
					local Item = hero:GetItemInSlot( itemSlot )
					if Item ~= nil and string.match(Item:GetName(),"doubled") and RandomInt(0,4)==2 then -- makes sure that the item exists and making sure it is the correct item
						local doubledstring = string.gsub(Item:GetName(),"_bow", "_bow_shooting")
						Item:ApplyDataDrivenModifier(hero, hero, doubledstring, nil)
						done=1
					elseif Item ~= nil and string.match(Item:GetName(),"bow") and RandomInt(0,4)==2 then -- makes sure that the item exists and making sure it is the correct item
						Item:ApplyDataDrivenModifier(hero, hero, Item:GetName() .. "_shooting", nil)
						print( "bow found." )
						done=1
					end
				end
			end
		end
			
end

function RemoveDD(args) -- keys is the information sent by the ability
		local hero = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
for itemSlot = 0, 5, 1 do 
	if hero ~= nil then
		local Item = hero:GetItemInSlot( itemSlot )
		if Item ~= nil and string.match(Item:GetName(),"doubled") then -- makes sure that the item exists and making sure it is the correct item
			local doubledstring = string.gsub(Item:GetName(),"_bow", "_bow_shooting")
			while  hero:HasModifier(doubledstring) do
				hero:RemoveModifierByName(doubledstring)
			end
		elseif Item ~= nil and string.match(Item:GetName(),"bow") then -- makes sure that the item exists and making sure it is the correct item
			while  hero:HasModifier(Item:GetName() .. "_shooting") do
				hero:RemoveModifierByName(Item:GetName() .. "_shooting")
			end
			print( "bow found." )
		end
	end
end
for itemSlot = 0, 5, 1 do 
	if hero ~= nil then
		local Item = hero:GetItemInSlot( itemSlot )
		if Item ~= nil and string.match(Item:GetName(),"doubled") then -- makes sure that the item exists and making sure it is the correct item
			local doubledstring = string.gsub(Item:GetName(),"_bow", "_bow_shooting")
			Item:ApplyDataDrivenModifier(hero, hero, doubledstring, nil)
		elseif Item ~= nil and string.match(Item:GetName(),"bow") then -- makes sure that the item exists and making sure it is the correct item
			Item:ApplyDataDrivenModifier(hero, hero, Item:GetName() .. "_shooting", nil)
			print( "bow found." )
		end
	end
end
			
end
function RemoveWeps(args) -- keys is the information sent by the ability
		local casterUnit = args.caster
	local hero = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
for itemSlot = 0, 5, 1 do 
	if hero ~= nil then
		local Item = hero:GetItemInSlot( itemSlot )
		if Item ~= nil and string.match(Item:GetName(),"doubled") then -- makes sure that the item exists and making sure it is the correct item
			local doubledstring = string.gsub(Item:GetName(),"_bow", "_bow_shooting")
			while  hero:HasModifier(doubledstring) do
				hero:RemoveModifierByName(doubledstring)
			end
		elseif Item ~= nil and string.match(Item:GetName(),"bow") then -- makes sure that the item exists and making sure it is the correct item
			while  hero:HasModifier(Item:GetName() .. "_shooting") do
				hero:RemoveModifierByName(Item:GetName() .. "_shooting")
			end
			print( "bow found." )
		end
	end
end
			
end





function ApplyStun(args) -- keys is the information sent by the ability
		local casterUnit = args.caster
		local targetUnit = args.target
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local item = CreateItem( "item_oneshot_brew", casterUnit, casterUnit)
			
		item:ApplyDataDrivenModifier(targetUnit, targetUnit, "sick", nil)
		
		casterUnit:RemoveItem(item)
end

function ApplyLuck(args) -- keys is the information sent by the ability
		local weps={}
				local hero = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
	for itemSlot = 0, 5, 1 do 
		if hero ~= nil then
			local Item = hero:GetItemInSlot( itemSlot )
			if Item ~= nil and string.match(Item:GetName(),"doubled") then -- makes sure that the item exists and making sure it is the correct item
				local doubledstring = string.gsub(Item:GetName(),"_bow", "_bow_shooting")
					weps[#weps+1]=doubledstring
			elseif Item ~= nil and string.match(Item:GetName(),"bow") then -- makes sure that the item exists and making sure it is the correct item
					weps[#weps+1]=Item:GetName() .. "_shooting"
			end
		end
	end
PrintTable(weps)
	hero:RemoveModifierByName(weps[RandomInt( 1, #weps )])
	Timers:CreateTimer( 4, function()
		 RemoveDD(args)
	end)
		
end


function visionGrant(args) 

local casterUnit = args.caster
        
		local creature
		creature1 = CreateUnitByName( "dummy_vision800" , casterUnit:GetOrigin() , true, nil, nil,  DOTA_TEAM_GOODGUYS)
		creature1:AddNewModifier(creature, nil, "modifier_kill", {duration = .1})
		creature2 = CreateUnitByName( "dummy_vision800" , casterUnit:GetOrigin() , true, nil, nil,  DOTA_TEAM_BADGUYS)
		creature2:AddNewModifier(creature, nil, "modifier_kill", {duration = .1})
		
		
		local allUnits = FindUnitsInRadius( DOTA_TEAM_BADGUYS, casterUnit:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO, 0, 0, false )
			local allUnits2 = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, casterUnit:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
			for k,v in pairs(allUnits2) do allUnits[k] = v end
		
		for _,hero in pairs( allUnits) do
	
			for itemSlot = 0, 5, 1 do 
					if hero ~= nil then
						local Item = hero:GetItemInSlot( itemSlot )
							if Item ~= nil and string.match(Item:GetName(),"contract") then
							
							EMP_GOLD_NUMBER = math.floor(GameRules:GetGameTime()/500+0.5)+1
							
								hero:RemoveItem(Item)
								Notifications:Top(hero:GetPlayerID(), {text="#mission_taken", duration=4.0, style={ color=" #A060D6;", fontSize= "45px;", textShadow= "2px 2px 2px #662222;"}})
								Notifications:Top(hero:GetPlayerID(), {text="#mission_taken_2", duration=4.0, style={ color=" #A060D6;", fontSize= "45px;", textShadow= "2px 2px 2px #662222;"}})
								Notifications:Top(hero:GetPlayerID(),{text=100*EMP_GOLD_NUMBER/2, duration=4.0, style={color="#FFD700",  fontSize="45px;"}, continue=true})
								
								hero:SetGold(hero:GetGold()+100*EMP_GOLD_NUMBER/2,true)
								
								end
					end
			end
		end
		
		
		
end



function DropEmptyOnDeath(keys) -- keys is the information sent by the ability
	print( '[ItemFunctions] DropItemOnDeath Called' )
	local killedUnit = EntIndexToHScript( keys.caster_entindex ) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
	if killedUnit:IsHero() or killedUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 5, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
	        	if killedUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
                		local Item = killedUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
                		if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
                			local newItem = CreateItem("item_contract_empty", nil, nil) -- creates a new variable which recreates the item we want to drop and then sets it to have no owner
                    			CreateItemOnPositionSync(killedUnit:GetOrigin(), newItem) -- takes the newItem variable and creates the physical item at the killed unit's location
                    			killedUnit:RemoveItem(Item) -- finally, the item is removed from the original units inventory.
						elseif Item ~= nil and  string.match(Item:GetName(),"temp") then
								killedUnit:RemoveItem(Item)
                		end
	        	end
		end
	end
	local allyid=0
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero~=killedUnit and hero:GetTeamNumber() == killedUnit:GetTeamNumber()   then
			ally=hero
		end
	end
	local data =
	{
		Player_ID = killedUnit:GetPlayerID();
		Ally_ID =allyid;
	}
	FireGameEvent("Team_Can_Buy",data)
end




function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
    if type(t) ~= "table" then return end

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
        if v ~= 'FDesc' then
            local value = t[v]

            if type(value) == "table" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..":")
                PrintTable (value, indent + 2, done)
            elseif type(value) == "userdata" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
            else
                if t.FDesc and t.FDesc[v] then
                    print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
                else
                    print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                end
            end
        end
    end
end

