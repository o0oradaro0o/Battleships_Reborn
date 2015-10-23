require('notifications')

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


function cluster(keys)
	local dummy = CreateUnitByName( "dummy_unit_cluster", keys.target:GetAbsOrigin(), false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
	dummy:AddNewModifier(creature, nil, "modifier_kill", {duration = 3})
		local abil =dummy:GetAbilityByIndex(1)
		
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
		if #enemies>5 then
			local rand= RandomInt( 1, #enemies )
			table.insert(CapTheseFuckers,enemies[rand])
			table.remove(enemies,rand)
		else
			CapTheseFuckers=enemies
		end
		 for _,fucker in pairs( CapTheseFuckers) do
				local info = 
				{
					Ability = caster:GetAbilityByIndex(1),	
					Source = caster,
					Target = fucker,
					vSourceLoc = caster:GetOrigin(),
					EffectName = "particles/basic_projectile/spin_one_projectile.vpcf",
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
				damage = direction:Length()/1200 * 26,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() < 600 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = 13,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() > 1400 and direction:Length() < 1600 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = (1600-direction:Length())/200*26,
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
		local targetUnit = args.target
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
        local casterPos = args.caster:GetAbsOrigin()
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterPos - targetPos
		if direction:Length() > 600 and direction:Length() < 1200 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = direction:Length()/1200 * 54,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() < 600 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = 27,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() > 1400 and direction:Length() < 1600 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = (1600-direction:Length())/200*54,
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
		local targetUnit = args.target
		--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
        local casterPos = args.caster:GetAbsOrigin()
	--print('[ItemFunctions] wind_ult_buffet start loaction ' .. tostring(casterPos))
        local direction =  casterPos - targetPos
		if direction:Length() > 600 and direction:Length() < 1200 then
				local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = direction:Length()/1200 * 100,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() < 600 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = 50,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		elseif direction:Length() > 1400 and direction:Length() < 1600 then
			local damageTable = {
				victim = targetUnit,
				attacker = casterUnit,
				damage = (1600-direction:Length())/200*100,
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
								if RandomInt(0,4) == 0 then
								Item:ApplyDataDrivenModifier(casterUnit, targetUnit, "aura_speed_wind", nil)
								end

									local damageTable = {
										victim = targetUnit,
										attacker = casterUnit,
										damage = 431,
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
		
		local itemName = tostring(args.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
		if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
			for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
							local Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
							if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
								if RandomInt(0,4) == 0 then
									print('[ItemFunctions] random_hit! ')
									Item:ApplyDataDrivenModifier(casterUnit, targetUnit, "item_coal_ult_bow_stunned", nil)
									print('[ItemFunctions] stunned from coal! ')
								end
								
								do return end
							end
					end
			end
		end
end


-- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
-- makes sure that the item exists and making sure it is the correct item
