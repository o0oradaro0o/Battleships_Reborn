require('notifications')
require('item_sound_functions')

if itemFunctions == nil then
	print ( '[ItemFunctions] creating itemFunctions' )
	itemFunctions = {} -- Creates an array to let us beable to index itemFunctions when creating new functions
	itemFunctions.__index = itemFunctions
end
 
function itemFunctions:new() -- Creates the new class
	print ( '[ItemFunctions] itemFunctions:new' )
	o = o or {}
	setmetatable( o, itemFunctions )
	return o
end
 
function itemFunctions:start() -- Runs whenever the itemFunctions.lua is ran
	print('[ItemFunctions] itemFunctions started!')
end
 
function toggle_item(keys) -- keys is the information sent by the ability
	print( '[ItemFunctions] toggle_item  Called' )

	local casterUnit = EntIndexToHScript( keys.caster_entindex ) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
	if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 5, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
			if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
				-- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
				if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
					tem:ToggleAbility()
				end
			end
		end
	end
end
function sendMission(keys) 
local casterUnit = keys.caster
 Notifications:Top(casterUnit:GetPlayerID(), {text="#mission_empty", duration=5.0, style={ color=" #60A0D6;", fontSize= "45px;", textShadow= "2px 2px 2px #662222;"}})
						
end

function del_fluff(keys) -- keys is the information sent by the ability
	print( '[ItemFunctions] itemfluff  Called' )
	local casterUnit = EntIndexToHScript( keys.caster_entindex ) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
	if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
	        	if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
                		local Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
                		if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
                			casterUnit:RemoveItem(Item)
                		end
	        	end
		end
	end
end

function give_gold(keys) -- keys is the information sent by the ability
	print( '[ItemFunctions] give_gold  Called' )
	
	local casterUnit = EntIndexToHScript( keys.caster_entindex ) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	--casterUnit:SetGold(80000, true)
	--casterUnit:AddExperience(80000, true)
	local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
	if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
	        	if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
                		local Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
                		if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
                			casterUnit:RemoveItem(Item)
                		end
	        	end
		end
	end
end

function use_wood(keys) -- keys is the information sent by the ability
	print( '[ItemFunctions] use_wood  Called' )
	local casterUnit = EntIndexToHScript( keys.caster_entindex ) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
	if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
	        	if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
                		local Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
                		if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
							local hp = casterUnit:GetHealth()
							local boost = 0
							if not string.match(Item:GetName(), "combo") then
								if string.match(Item:GetName(), "one") then
									boost = 400
								elseif string.match(Item:GetName(), "two") then
									boost = 1000
								elseif string.match(Item:GetName(), "three") then
									boost = 3500
								elseif string.match(Item:GetName(), "four") then
									boost = 8000
								end
							else
								if string.match(Item:GetName(), "one") then
									boost = 400
								elseif string.match(Item:GetName(), "two") then
									boost = 1000
								elseif string.match(Item:GetName(), "three") then
									boost = 3500
								elseif string.match(Item:GetName(), "four") then
									boost = 8000
								end
							end
							casterUnit:SetHealth(hp+boost)
                		end
	        	end
		end
	end
end


function wind_ult_buffet(args)
--print('[ItemFunctions] wind_ult_buffet started! redux!')
        local targetPos = args.target:GetAbsOrigin()
		local targetUnit = args.target
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
        local casterPos = args.caster:GetAbsOrigin()
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterPos - targetPos
        local vec = direction:Normalized() * -25.0
		if direction:Length() > 500 then
			Physics:Unit(targetUnit)
			targetUnit:AddPhysicsVelocity(vec)
		end
end



function become_kunkka(keys)

become_boat(keys, "npc_dota_hero_disruptor")

end

function become_gyrocopter(keys)
become_boat(keys, "npc_dota_hero_ursa")

end

function become_brewmaster(keys)

become_boat(keys, "npc_dota_hero_meepo")

end


function become_bristleback(keys)

become_boat(keys, "npc_dota_hero_bristleback")

end

function become_tidehunter(keys)

become_boat(keys, "npc_dota_hero_tidehunter")

end

function become_puck(keys)

become_boat(keys, "npc_dota_hero_ancient_apparition")

end

function become_jakiro(keys)

become_boat(keys, "npc_dota_hero_jakiro")

end

function become_morphling(keys)

become_boat(keys, "npc_dota_hero_morphling")

end
function become_zuus(keys)

become_boat(keys, "npc_dota_hero_tiny")

end

function become_magnus(keys)

become_boat(keys, "npc_dota_hero_slark")

end

function become_lion(keys)

become_boat(keys, "npc_dota_hero_lion")

end

function become_lycan(keys)

become_boat(keys, "npc_dota_hero_tusk")

end

function become_visage(keys)

become_boat(keys, "npc_dota_hero_visage")

end

function become_nevermore(keys)

become_boat(keys, "npc_dota_hero_nevermore")

end

function become_rubick(keys)

become_boat(keys, "npc_dota_hero_enigma")

end

function become_boat(keys, heroname)

	
	
	
end

function debuffTowers(keys)
print('[ItemFunctions] dubuffTower started!')

end

function healTowers(keys)
print('[ItemFunctions] healTowers started!')
	local casterUnit = EntIndexToHScript( keys.caster_entindex ) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
	if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
	        	if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
                		local Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
                		if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
                			casterUnit:RemoveItem(Item)
                		end
	        	end
		end
	end
		for _,curTower in pairs( Entities:FindAllByClassname( "npc_dota_tow*")) do
				 print('[ItemFunctions] healTowers found a tower!')
				local curArmor = curTower:GetPhysicalArmorBaseValue()
				if curTower ~= nil and curTower:IsTower() then
				print('[ItemFunctions] healTowers really found a tower!')
					if curTower:GetTeamNumber() ==  casterUnit:GetTeamNumber()  then
						local hp1 = (curTower:GetMaxHealth()-curTower:GetHealth())*.1
						curTower:SetHealth(curTower:GetHealth()+hp1)
						print('[ItemFunctions] healTowers found an ally tower.')
					end
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

function FireDmgAura(keys)
	local casterUnit = keys.caster
	local item = keys.ability:GetAbilityName() --ability is how item name is passed in
	local range = 700	 
	local handles = {}
	handles.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	handles.types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_HERO
	handles.flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
		local dmg=0;
	if #getEnemies(casterUnit,range,handles) > 0 then
		if string.match(item, "two") then--level-2 fire-type
					dmg	=4
		elseif string.match(item, "three") then--level-3 fire-type
					dmg = 6
		elseif string.match(item, "ult") then--ultimate fire-type
					dmg = 20
		else --level-1 fire-type
			dmg = 2
		end		
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

function cluster(keys)
	local dummy = CreateUnitByName( "dummy_unit_cluster", keys.target:GetAbsOrigin(), false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
	dummy:AddNewModifier(creature, nil, "modifier_kill", {duration = 3})
		local abil =dummy:GetAbilityByIndex(1)
		abil:SetLevel(2)
		dummy.lvl=4
		abil:CastAbility()

end

function cluster3(keys)
	local dummy = CreateUnitByName( "dummy_unit_cluster", keys.target:GetAbsOrigin(), false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
	dummy:AddNewModifier(creature, nil, "modifier_kill", {duration = 3})
		local abil =dummy:GetAbilityByIndex(1)
		abil:SetLevel(3)
		dummy.lvl=3
		abil:CastAbility()

end

function cluster2(keys)
	local dummy = CreateUnitByName( "dummy_unit_cluster", keys.target:GetAbsOrigin(), false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
	dummy:AddNewModifier(creature, nil, "modifier_kill", {duration = 3})
		local abil =dummy:GetAbilityByIndex(1)
		abil:SetLevel(2)
		dummy.lvl=2
		abil:CastAbility()

end

function cluster1(keys)
	local dummy = CreateUnitByName( "dummy_unit_cluster", keys.target:GetAbsOrigin(), false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
	dummy:AddNewModifier(creature, nil, "modifier_kill", {duration = 3})
		local abil =dummy:GetAbilityByIndex(1)
		abil:SetLevel(1)
		dummy.lvl=1
		abil:CastAbility()

end




function clusterBoom(args)

		local caster = args.caster
		local enemies
		
			--hscript CreateUnitByName( string name, vector origin, bool findOpenSpot, hscript, hscript, int team)
		if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, caster:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		else
			enemies = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, caster:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		end
		local CapTheseFuckers = {}
		if #enemies>caster.lvl then
			while #CapTheseFuckers<caster.lvl do
				local rand= RandomInt( 1, #enemies )
				table.insert(CapTheseFuckers,enemies[rand])
				table.remove(enemies,rand)
			end
		else
			CapTheseFuckers=enemies
		end
		 for _,fucker in pairs( CapTheseFuckers) do
			local tracking_projectile = 
        {
            EffectName = "particles/basic_projectile/spin_one_projectile.vpcf",
            Ability = caster:GetAbilityByIndex(1),
            vSpawnOrigin = caster:GetAbsOrigin(),
            Target = fucker,
            Source = args.source or caster,
            bHasFrontalCone = false,
            iMoveSpeed = 750,
            bReplaceExisting = false,
            bProvidesVision = false,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
        }
			

				ProjectileManager:CreateTrackingProjectile(tracking_projectile)
			end
	

end

function dearmorUlt(args)
Timers:CreateTimer( .05, function()


	local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local targetUnit = args.target
		local Item
		local plasmaItem
		local stunmult=0
		local itemName = tostring(args.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
		if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
			for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
							 Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
							if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
								stunmult=stunmult+1
								plasmaItem=Item
							end
					end
			end
		end
		if plasmaItem ~= nil then
			if targetUnit:HasModifier("item_plasma_ult_bow_dearmored") then

				local t=targetUnit:FindAllModifiersByName("item_plasma_ult_bow_dearmored")
				 for _,fucker in pairs( t) do
					fucker:SetDuration(fucker:GetRemainingTime()+2,true)
				end
			else
				plasmaItem:ApplyDataDrivenModifier(casterUnit, targetUnit, "item_plasma_ult_bow_dearmored", nil)
			end
		end
			end)
end

function dearmor3(args)
Timers:CreateTimer( .05, function()
	local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local targetUnit = args.target
		local Item
		local plasmaItem
		local stunmult=0
		local itemName = tostring(args.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
		if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
			for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
							 Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
							if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
								stunmult=stunmult+1
								plasmaItem=Item
							end
					end
			end
		end
		if plasmaItem ~= nil then
			if targetUnit:HasModifier("item_plasma_three_bow_dearmored") then
				local t=targetUnit:FindAllModifiersByName("item_plasma_three_bow_dearmored")
				 for _,fucker in pairs( t) do
					fucker:SetDuration(fucker:GetRemainingTime()+2,true)
				end
			else
				plasmaItem:ApplyDataDrivenModifier(casterUnit, targetUnit, "item_plasma_three_bow_dearmored", nil)
			end
		end
		end)
end

function dearmor2(args)
Timers:CreateTimer( .05, function()
	local casterUnit = args.caster
		print('plasma dearmor start' )
		local targetUnit = args.target
		local Item
		local plasmaItem
		local stunmult=0
		local itemName = tostring(args.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
		if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
			for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
							 Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
							if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
								stunmult=stunmult+1
								plasmaItem=Item
							end
					end
			end
		end
		if plasmaItem ~= nil then
			if targetUnit:HasModifier("item_plasma_two_bow_dearmored") then
				local t=targetUnit:FindAllModifiersByName("item_plasma_two_bow_dearmored")
				 for _,fucker in pairs( t) do
					fucker:SetDuration(fucker:GetRemainingTime()+2,true)
				end
			else
				print('didnt exist, added' )
				plasmaItem:ApplyDataDrivenModifier(casterUnit, targetUnit, "item_plasma_two_bow_dearmored", nil)
			end
		end
		end)
end

function dearmor1(args)
Timers:CreateTimer( .05, function()
	local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local targetUnit = args.target
		local Item
		local plasmaItem
		local stunmult=0
		local itemName = tostring(args.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
		if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
			for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
							 Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
							if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
								stunmult=stunmult+1
								plasmaItem=Item
							end
					end
			end
		end
		if plasmaItem ~= nil then
			if targetUnit:HasModifier("item_plasma_bow_dearmored") then
				local t=targetUnit:FindAllModifiersByName("item_plasma_bow_dearmored")
				 for _,fucker in pairs( t) do
					fucker:SetDuration(fucker:GetRemainingTime()+2,true)
				end
			else
				plasmaItem:ApplyDataDrivenModifier(casterUnit, targetUnit, "item_plasma_bow_dearmored", nil)
			end
		end
		end)
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


function WindOneDmg(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local abil = casterUnit:GetAbilityByIndex(0)
		local level = abil:GetLevel()
		local targetUnit = args.target
		local targetPos = args.target:GetAbsOrigin()
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
        local casterPos = args.caster:GetAbsOrigin()
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterPos - targetPos
		
		if direction:Length() > 600 and direction:Length() < 1200 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = direction:Length()/1200 * 16,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() < 600 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = 8,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() > 1199 and direction:Length() < 1900 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage =16,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		end
		local item = args.ability:GetAbilityName() --ability is how 
		if string.match(item, "doubled") then--l
		
			local HPPercentageTaken = (targetUnit:GetHealth()/targetUnit:GetMaxHealth()) -- Calculate the target HP percentage
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = 16*HPPercentageTaken,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
			
			
		end
		
		
end

function WindTwoDmg(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local abil = casterUnit:GetAbilityByIndex(0)
		local level = abil:GetLevel()
		local targetUnit = args.target
		local targetPos = args.target:GetAbsOrigin()
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
        local casterPos = args.caster:GetAbsOrigin()
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterPos - targetPos
		if direction:Length() > 600 and direction:Length() < 1200 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = direction:Length()/1200 * 35,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() < 600 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = 17,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() > 1199 and direction:Length() < 1900 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = 35,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		end
		local item = args.ability:GetAbilityName() --ability is how 
		if string.match(item, "doubled") then--l
		
			local HPPercentageTaken = (targetUnit:GetHealth()/targetUnit:GetMaxHealth()) -- Calculate the target HP percentage
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = 35*HPPercentageTaken,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
			
			
		end
end

function WindThreeDmg(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local abil = casterUnit:GetAbilityByIndex(0)
		local level = abil:GetLevel()
		local targetUnit = args.target
		local targetPos = args.target:GetAbsOrigin()
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
        local casterPos = args.caster:GetAbsOrigin()
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterPos - targetPos
		if direction:Length() > 600 and direction:Length() < 1200 then
				local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = direction:Length()/1200 * 66,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() < 600 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = 33,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() > 1199 and direction:Length() < 1900 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = 66,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		end
		local item = args.ability:GetAbilityName() --ability is how 
		if string.match(item, "doubled") then--l
		
			local HPPercentageTaken = (targetUnit:GetHealth()/targetUnit:GetMaxHealth()) -- Calculate the target HP percentage
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = 66*HPPercentageTaken,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
			
			
		end
end

function WindUltDmg(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local targetUnit = args.target
		local targetPos = args.target:GetAbsOrigin()
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
        local casterPos = args.caster:GetAbsOrigin()
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterPos - targetPos
		
		local itemName = tostring(args.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
		if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
			for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
							local Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
							if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
							

									local damageTable = {
										victim = targetUnit,
										attacker = casterUnit,
										damage = 273,
										damage_type = DAMAGE_TYPE_PHYSICAL,
									}
									ApplyDamage(damageTable)
									
									local HPPercentageTaken = (targetUnit:GetHealth()/targetUnit:GetMaxHealth()) -- Calculate the target HP percentage
									local damageTable = {
										victim = targetUnit,
										attacker = casterUnit,
										damage = 273*HPPercentageTaken,
										damage_type = DAMAGE_TYPE_PHYSICAL,
									}
									ApplyDamage(damageTable)
								do return end
							end
					end
			end
		end
end

function coalUltStun(args) -- keys is the information sent by the ability
	print('[ItemFunctions] coal started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local targetUnit = args.target
		local Item
		local coalitem
		local stunmult=0
		local itemName = tostring(args.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
		if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
			for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
							 Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
							if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
								stunmult=stunmult+1
								coalitem=Item
							end
					end
			end
		end
		print('[ItemFunctions] stunmult! ' .. stunmult)
		if coalitem ~= nil and RandomInt(0,10) == 0 then
			print('[ItemFunctions] random_hit! ')
			coalitem:ApplyDataDrivenModifier(casterUnit, targetUnit, "item_coal_ult_bow_stunned", nil)
			coalSoundStun(args)
			print('[ItemFunctions] stunned from coal! ')
		end
end

function coalThreeStun(args) -- keys is the information sent by the ability
	print('[ItemFunctions] coal started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local targetUnit = args.target
		local Item
		local coalitem
		local stunmult=0
		local itemName = tostring(args.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
		if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
			for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
							 Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
							if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
								stunmult=stunmult+1
								coalitem=Item
							end
					end
			end
		end
		print('[ItemFunctions] stunmult! ' .. stunmult)
		if coalitem ~= nil and RandomInt(0,15) == 0 then
			print('[ItemFunctions] random_hit! ')
			coalitem:ApplyDataDrivenModifier(casterUnit, targetUnit, "item_coal_three_bow_stunned", nil)
			coalSoundStun(args)
			print('[ItemFunctions] stunned from coal! ')
		end
end

function coalTwoStun(args) -- keys is the information sent by the ability
	print('[ItemFunctions] coal started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local targetUnit = args.target
		local Item
		local coalitem
		local stunmult=0
		local itemName = tostring(args.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
		if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
			for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
							 Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
							if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
								stunmult=stunmult+1
								coalitem=Item
							end
					end
			end
		end
		print('[ItemFunctions] stunmult! ' .. stunmult)
		if coalitem ~= nil and RandomInt(0,15) == 0 then
			print('[ItemFunctions] random_hit! ')
			coalitem:ApplyDataDrivenModifier(casterUnit, targetUnit, "item_coal_three_bow_stunned", nil)
			coalSoundStun(args)
			print('[ItemFunctions] stunned from coal! ')
		end
end

function coalStun(args) -- keys is the information sent by the ability
	print('[ItemFunctions] coal started! ')
		local casterUnit = args.caster
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
		local targetUnit = args.target
		local Item
		local coalitem
		local stunmult=0
		local itemName = tostring(args.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
		if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
			for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
							 Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
							if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
								stunmult=stunmult+1
								coalitem=Item
							end
					end
			end
		end
		print('[ItemFunctions] stunmult! ' .. stunmult)
		if coalitem ~= nil and RandomInt(0,15) == 0 then
			print('[ItemFunctions] random_hit! ')
			coalitem:ApplyDataDrivenModifier(casterUnit, targetUnit, "item_coal_bow_stunned", nil)
			coalSoundStun(args)
			print('[ItemFunctions] stunned from coal! ')
		end
end


function fireCaulkWeapon(args) 

	local itemName = tostring(args.ability:GetAbilityName())
	local casterUnit = args.caster

	friends = FindUnitsInRadius( casterUnit:GetTeamNumber(), casterUnit:GetOrigin(), nil, 650, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	TargetFriend=friends[RandomInt( 1, #friends )]
	
	if #friends>1 then

		while casterUnit==TargetFriend do
			TargetFriend= friends[RandomInt( 1, #friends )]
		end


		if string.match(itemName, "ult") then
			local tracking_projectile = 
			{
				EffectName = "particles/basic_projectile/caulk_ult_projectile.vpcf",
				Ability = args.ability,
				vSpawnOrigin = casterUnit:GetAbsOrigin(),
				Target = TargetFriend,
				Source = args.source or casterUnit,
				bHasFrontalCone = false,
				iMoveSpeed = 950,
				bReplaceExisting = false,
				bProvidesVision = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			ProjectileManager:CreateTrackingProjectile(tracking_projectile)

		elseif string.match(itemName, "two") then
			local tracking_projectile = 
			{
				EffectName = "particles/basic_projectile/caulk_two_projectile.vpcf",
				Ability = args.ability,
				vSpawnOrigin = casterUnit:GetAbsOrigin(),
				Target = TargetFriend,
				Source = args.source or casterUnit,
				bHasFrontalCone = false,
				iMoveSpeed = 950,
				bReplaceExisting = false,
				bProvidesVision = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			ProjectileManager:CreateTrackingProjectile(tracking_projectile)

		elseif string.match(itemName, "three") then
			local tracking_projectile = 
			{
				EffectName = "particles/basic_projectile/caulk_three_projectile.vpcf",
				Ability = args.ability,
				vSpawnOrigin = casterUnit:GetAbsOrigin(),
				Target = TargetFriend,
				Source = args.source or casterUnit,
				bHasFrontalCone = false,
				iMoveSpeed = 950,
				bReplaceExisting = false,
				bProvidesVision = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			ProjectileManager:CreateTrackingProjectile(tracking_projectile)

		else
			local tracking_projectile = 
			{
				EffectName = "particles/basic_projectile/caulk_one_projectile.vpcf",
				Ability = args.ability,
				vSpawnOrigin = casterUnit:GetAbsOrigin(),
				Target = TargetFriend,
				Source = args.source or casterUnit,
				bHasFrontalCone = false,
				iMoveSpeed = 950,
				bReplaceExisting = false,
				bProvidesVision = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			ProjectileManager:CreateTrackingProjectile(tracking_projectile)

		end
	end

end

-- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
-- makes sure that the item exists and making sure it is the correct item
