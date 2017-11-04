-- Generated from template
require("libraries/timers")
require('storage')
require('libraries/physics')
require('notifications')
require('good_base')
require('bad_base')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
 -- require('libraries/attachments')

g_MainTimerTickCount = 0


PlayerColors = {
 {46, 106, 230},

 {92, 230, 173},

 {173, 0, 173},

 {220,217,10},

 {230, 98, 0},

 {230, 122, 176},

 {146, 164, 64},
 
 {92, 197, 224},
 
 {0, 119, 31},
 
 {149, 96, 0}
}


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
				PrecacheUnitByNameSync("npc_dota_present2", context)
				PrecacheUnitByNameSync("npc_dota_present2", context)
				PrecacheUnitByNameSync("npc_dota_Orniment1", context)
				PrecacheUnitByNameSync("npc_dota_Orniment2", context)
				PrecacheUnitByNameSync("npc_dota_Orniment3", context)
				PrecacheUnitByNameSync("npc_dota_Orniment4", context)
				PrecacheResource( "model", "models/particle/snowball.vmdl", context )
				PrecacheResource("custom_sounds", "soundevents/custom_sounds.vsndevts", context)
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
		 local pId = npc:GetPlayerOwnerID()+1
		 if(pId == nil) then
		 pId = 1
		 end
		 npc.PID_Color = pId
		PlayerResource:SetCustomPlayerColor(pId-1,PlayerColors[pId][1],PlayerColors[pId][2],PlayerColors[pId][3] )
	
		local abil = npc:GetAbilityByIndex(0)
		abil:SetLevel(1)
		npc.AbilityName = "Spawn_Invlun"
		Timers:CreateTimer( 0.03, function()
					abil:CastAbility()
				end)
		
		local abil = npc:GetAbilityByIndex(1)
		abil:SetLevel(1)
		
		
		PlayerResource:SetCameraTarget(npc:GetPlayerOwnerID(), npc)
		local emptyData = {
					}
					FireGameEvent( "Player_Spawned", emptyData );
		
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
return true
  end

-- Evaluate the state of the game
function CfrostGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
		g_MainTimerTickCount = g_MainTimerTickCount +1
		if g_MainTimerTickCount == 1 then
			local emptyData = {
					}
					FireGameEvent( "Player_Spawned", emptyData );
		end
		
		
		if g_MainTimerTickCount%180 == 0 then
			GameRules:SetTimeOfDay(0.25)
		end
		

		local unitCount = 0
		for _,creature in pairs( Entities:FindAllByClassname( "npc_dota_c*")) do
				if creature ~= nil  then
					unitCount=unitCount+1
				end
			end
		
			if unitCount<700 then
			for itemSlot = 0, 5, 1 do 
					local placment = RandomVector( RandomFloat( 600, 4300 ))
					
					local x = Entities:FindByClassnameNearest("npc_dota_creature", placment, 400)
					if x==nil then
							spawnOrn(placment)
					
					  end
			  end
		end
		updateScore()
		sendScore()
		 
		 
		 
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function updateScore()

end
function sendScore()
local TotalGoodScore =  storage:GetGoodPoints()
local TotalBadScore =  storage:GetBadPoints()
local TimeLeftInGame = 600-g_MainTimerTickCount
	local emptyData = {
		good_score = TotalGoodScore;
		bad_score = TotalBadScore;
		Game_Time = TimeLeftInGame;
					}
					FireGameEvent( "Score_data", emptyData );
					
			if TimeLeftInGame==60 then
					Notifications:TopToAll({text="#one_minute", duration=1.6, style={color=" #F00000;", fontSize= "65px;", textShadow= "2px 2px 2px #000000;"}})
			end
					
		if TimeLeftInGame<0 then
				if TotalGoodScore>TotalBadScore then
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
					Timers:CreateTimer( 1, function()
					GameRules:SetSafeToLeave( true )
					end)
				else
					GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
					GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
					
					Timers:CreateTimer( 1, function()
					GameRules:SetSafeToLeave( true )
					end)
				end
		end
		
		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			if hero ~= nil and hero:IsOwnedByAnyPlayer() then
				local pName = "radar"
				if PlayerResource:GetPlayerName( hero:GetPlayerID()) ~= nil and PlayerResource:GetPlayerName( hero:GetPlayerID()) ~= "" then
					pName = PlayerResource:GetPlayerName( hero:GetPlayerID())
				end
				local heald_orns = 0
				if hero.presentList ~=nil then
					 heald_orns = #hero.presentList
				 end
				local score_info = {
				player_id = hero:GetPlayerID();
				player_name = pName;
				delivered = hero.pointScored;
				heald = heald_orns;
					}
						FireGameEvent( "score_info", score_info );
				
			end
		end
		
					
end





function spawnOrn(placment)
				--spawn star
				if RandomInt( 0, 10) ==1 then
					  local creature = CreateUnitByName( "npc_dota_present2" ,  placment, true, nil, nil, DOTA_TEAM_NEUTRALS )
					  creature:SetForwardVector(RandomVector( RandomFloat( 40, 40 )))
				elseif RandomInt( 0, 7) ==1 then
					  local creature = CreateUnitByName( "npc_dota_present4" ,  placment, true, nil, nil, DOTA_TEAM_NEUTRALS )
					  creature:SetForwardVector(RandomVector( RandomFloat( 40, 40 )))
				
				elseif RandomInt( 0, 6) ==1 then
					  local creature = CreateUnitByName( "npc_dota_power_up" ,  placment, true, nil, nil, DOTA_TEAM_NEUTRALS )
					  creature:SetForwardVector(RandomVector( RandomFloat( 40, 40 )))
				
				else
				
					if RandomInt ( 0, 1) ==1 then
						local creature = CreateUnitByName( "npc_dota_present" ,  placment, true, nil, nil, DOTA_TEAM_NEUTRALS )
						creature:SetForwardVector(RandomVector( RandomFloat( 40, 40 )))
					else
					
							local creature = CreateUnitByName( "npc_dota_present3" ,  placment, true, nil, nil, DOTA_TEAM_NEUTRALS )
							creature:SetForwardVector(RandomVector( RandomFloat( 40, 40 )))
					end
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