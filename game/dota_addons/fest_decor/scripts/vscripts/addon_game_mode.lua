-- Generated from template
require("libraries/timers")
require('libraries/physics')
require('notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
 -- require('libraries/attachments')


if CfrostGameMode == nil then
	CfrostGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheResource( "particle_folder", "particles/basic_projectile", context )
		PrecacheUnitByNameSync("npc_dota_hero_crystal_maiden", context)
			PrecacheUnitByNameSync("npc_dota_vision_granter", context)
				PrecacheUnitByNameSync("npc_dota_present", context)
				PrecacheUnitByNameSync("npc_dota_Orniment1", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CfrostGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CfrostGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CfrostGameMode, 'OnNPCSpawned'), self)
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( CfrostGameMode, "OrderExecutionFilter" ), self )
end

function CfrostGameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)
	if npc:IsRealHero() then
		local abil = npc:GetAbilityByIndex(0)
		abil:SetLevel(1)
	end
end



function CfrostGameMode:OrderExecutionFilter(keys)

 if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		local units = keys["units"]
		 for _,unitIndex in pairs(units) do
		  local hero = EntIndexToHScript(unitIndex)
		  if hero then
			hero.targ_position = Vector(keys.position_x,keys.position_y,0)
		  end
		end
		

        return true
    end

  end

-- Evaluate the state of the game
function CfrostGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )

		local unitCount = 0
	for _,creature in pairs( Entities:FindAllByClassname( "npc_dota_c*")) do
			if creature ~= nil  then
				unitCount=unitCount+1
			end
		end
	
		if unitCount<700 then
		local placment = RandomVector( RandomFloat( 0, 5000 ))
		
		local allUnits = FindUnitsInRadius( DOTA_TEAM_BADGUYS, placment, nil, 700, DOTA_UNIT_TARGET_TEAM_BOTH,  DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,  false)
		print(#allUnits)
		
		if #allUnits==0 then
			 if RandomInt( 0, 9 ) ==1 then
			  local creature = CreateUnitByName( "npc_dota_present2" ,  placment, true, nil, nil, DOTA_TEAM_NEUTRALS )
			  creature:SetForwardVector(RandomVector( RandomFloat( 40, 40 )))
			 else
			 local creature = CreateUnitByName( "npc_dota_present" ,  placment, true, nil, nil, DOTA_TEAM_NEUTRALS )
				creature:SetForwardVector(RandomVector( RandomFloat( 40, 40 )))
			 end
		  end
		end
		 
		 
		 
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
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