-- Generated from template
require("timers")
require('physics')
require('lib.statcollection')
if CBattleship8D == nil then
	CBattleship8D = class({})
end


CREEP_LEVEL = 0
CREEP_NUM_SMALL = 4
CREEP_NUM_BIG = 3
CREEP_NUM_HUGE = 0
EMP_GOLD_NUMBER = 1

BAD_GOLD_TOTAL_MOD = 0
GOOD_GOLD_TOTAL_MOD = 0

LORNE_ITEM_BUYERS = 0
NUM_PLAYERS = 0

THINK_TICKS = 1
BAD_GOLD_PER_TICK = 3
GOOD_GOLD_PER_TICK = 3

DOCK_NORTH_LEFT = 1
DOCK_NORTH_RIGHT = 1
DOCK_SOUTH_LEFT = 1
DOCK_SOUTH_RIGHT = 1
LAST_TIME=0

SPY_ANNOUNCMENT_FLAG = 0
SPYS_NORTH = 0
SPYS_SOUTH = 0

NUM_GOOD_PLAYERS = 0
NUM_BAD_PLAYERS = 0

TIDE_LEVEL = 0

TICKS_SINCE_EMP_GOLD = 0


herokills = {}
herohp = {}
playerIdsToNames = {}

isDisconnected = {}
DisconnectTime = {}
DisconnectKicked = {}
heroids = {}
DISCONNECT_MESSAGE_DESPLAYED = 0

model_lookup = {}
model_lookup["npc_dota_hero_zuus"] = "models/barrel_boat.vmdl"
model_lookup["npc_dota_hero_antimage"] = "models/zodiac_boat.vmdl"
model_lookup["npc_dota_hero_batrider"] = "models/ice_boat.vmdl"
model_lookup["npc_dota_hero_crystal_maiden"] = "models/canoe_boat.vmdl"
model_lookup["npc_dota_hero_doom_bringer"] = "models/air_boat.vmdl"
model_lookup["npc_dota_hero_kunkka"] = "models/cat_boat.vmdl"
model_lookup["npc_dota_hero_jakiro"] = "models/galleon_boat.vmdl"
model_lookup["npc_dota_hero_gyrocopter"] = "models/plane_boat.vmdl"
model_lookup["npc_dota_hero_meepo"] = "models/house_boat.vmdl"
model_lookup["npc_dota_hero_mirana"] = "models/coast_boat.vmdl"
model_lookup["npc_dota_hero_morphling"] = "models/speed_boat.vmdl"
model_lookup["npc_dota_hero_puck"] = "models/junk_boat.vmdl"
model_lookup["npc_dota_hero_pudge"] = "models/yacht_boat.vmdl"
model_lookup["npc_dota_hero_riki"] = "models/tug_boat.vmdl"
model_lookup["npc_dota_hero_shadow_shaman"] = "models/viking_boat.vmdl"
model_lookup["npc_dota_hero_sniper"] = "models/sub_boat.vmdl"
model_lookup["npc_dota_hero_spirit_breaker"] = "models/noah_boat.vmdl"
model_lookup["npc_dota_hero_terrorblade"] = "models/Aircraft_boat.vmdl"
model_lookup["npc_dota_hero_tidehunter"] = "models/pontoon_boat.vmdl"
model_lookup["npc_dota_hero_windrunner"] = "models/const_boat.vmdl"
model_lookup["npc_dota_hero_tusk"] = "models/battleship_boat0.vmdl"





      
function Precache( context )
		for ind = 0, 11, 1 do 
			isDisconnected[ind] = 0 
			DisconnectTime[ind] = 0 
			DisconnectKicked[ind] = 0
			 herokills[ind] = 0
				  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
		end
	for ind = 0, 20, 1 do 
		playerIdsToNames[ind]=0;
	end

	for k, v in pairs( model_lookup ) do
    PrecacheResource( "model", v, context )
  end
	PrecacheResource( "particle_folder", "particles/basic_projectile", context )
	PrecacheResource( "model", "models/battleship_boat0.vmdl", context )
	PrecacheResource( "model", "models/battleship_boat1.vmdl", context )
	PrecacheResource( "model", "models/battleship_boat2.vmdl", context )
	PrecacheResource( "model", "models/battleship_boat3.vmdl", context )
	PrecacheResource( "model", "models/battleship_boat4.vmdl", context )
	PrecacheResource( "model", "models/Aircraft_boat_e.vmdl", context )
	PrecacheResource( "model", "models/Aircraft_boat2.vmdl", context )
	PrecacheResource( "model", "models/sub_boat_down", context )
	PrecacheResource( "model", "models/rng_ind", context )
		PrecacheResource( "model", "models/bad_ancient_ambient_blast", context )
		PrecacheResource( "model", "models/heroes/tidehunter/tidehunter.vmdl", context )
	
	
	PrecacheResource( "model", "models/jet.vmdl", context )
	PrecacheResource( "model", "models/iceberg.vmdl", context )
	PrecacheResource( "model", "models/building_north_tower.vmdl", context )
	PrecacheResource( "model", "models/building_south_tower.vmdl", context )
	
	PrecacheResource( "materials", "materials/", context )
	PrecacheUnitByNameSync("npc_dota_hero_abaddon", context)
PrecacheUnitByNameSync("npc_dota_hero_zuus", context)
PrecacheUnitByNameSync("npc_dota_hero_antimage", context)
PrecacheUnitByNameSync("npc_dota_hero_batrider", context)
PrecacheUnitByNameSync("npc_dota_hero_crystal_maiden", context)
PrecacheUnitByNameSync("npc_dota_hero_doom_bringer", context)
PrecacheUnitByNameSync("npc_dota_hero_gyrocopter", context)
PrecacheUnitByNameSync("npc_dota_hero_jakiro", context)
PrecacheUnitByNameSync("npc_dota_hero_kunkka", context)
PrecacheUnitByNameSync("npc_dota_hero_meepo", context)
PrecacheUnitByNameSync("npc_dota_hero_mirana", context)
PrecacheUnitByNameSync("npc_dota_hero_morphling", context)
PrecacheUnitByNameSync("npc_dota_hero_puck", context)
PrecacheUnitByNameSync("npc_dota_hero_pudge", context)
PrecacheUnitByNameSync("npc_dota_hero_riki", context)
PrecacheUnitByNameSync("npc_dota_hero_shadow_shaman", context)
PrecacheUnitByNameSync("npc_dota_hero_sniper", context)
PrecacheUnitByNameSync("npc_dota_hero_spirit_breaker", context)
PrecacheUnitByNameSync("npc_dota_hero_terrorblade", context)
PrecacheUnitByNameSync("npc_dota_hero_tidehunter", context)
PrecacheUnitByNameSync("npc_dota_hero_windrunner", context)
PrecacheUnitByNameSync("npc_dota_hero_tusk", context)


PrecacheUnitByNameSync("npc_dota_vision_granter", context)
		 
	PrecacheUnitByNameSync( "npc_dota_boat_south_one", context )
	PrecacheUnitByNameSync( "npc_dota_boat_south_two", context )
	PrecacheUnitByNameSync( "npc_dota_boat_south_four", context )
	PrecacheUnitByNameSync( "npc_dota_boat_north_one", context )
	PrecacheUnitByNameSync( "npc_dota_boat_north_two", context )
	PrecacheUnitByNameSync( "npc_dota_air_craft", context )
	PrecacheUnitByNameSync( "npc_dota_air_craft_bomber", context )
	PrecacheUnitByNameSync( "npc_dota_boat_pleasure_craft", context )
	
	
end
				


-- Create the game mode when we activate
function Activate()
	GameRules.battleship = CBattleship8D()
	GameRules.battleship:InitGameMode()
end

function CBattleship8D:InitGameMode()
	print( "Template addon is loaded." )
	
	--register the 'UnstickMe' command in our console
	Convars:RegisterCommand( "UnstickMe", function(name, p)
		--get the player that sent the command
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			--if the player is valid, execute PlayerBuyAbilityPoint
			return self:UnstickPlayer( cmdPlayer, p ) 
		end
	end, "A player buys an ability point", 0 )
	
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled(true)
	GameRules:GetGameModeEntity():SetBuybackEnabled(false)

	GameRules:SetSameHeroSelectionEnabled(true)

	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(CBattleship8D, 'OnItemPurchased'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(CBattleship8D, 'OnEntityKilled'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CBattleship8D, 'OnNPCSpawned'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(CBattleship8D, 'OnConnectFull'), self)
  ListenToGameEvent('player_disconnect', Dynamic_Wrap(CBattleship8D, 'OnDisconnect'), self)
  
  mode = GameRules:GetGameModeEntity()
mode:SetHUDVisible(12, false)
  
end

function CBattleship8D:OnNPCSpawned(keys)
  local npc = EntIndexToHScript(keys.entindex)
  if THINK_TICKS > 20 then
  if npc:IsIllusion() then
			npc:SetModel( "models/noah_boat.vmdl" )
			npc:SetOriginalModel( "models/noah_boat.vmdl" )
		end
	if npc:IsRealHero() then
		npc:SetBaseStrength(1)
		print("hero level is" .. npc:GetLevel())
		local item = CreateItem( "item_spawn_stunner", npc, npc)
			if npc:GetLevel() >= 22 then
				item:ApplyDataDrivenModifier(npc, npc, "pergatory_12", nil)
			elseif npc:GetLevel() >= 19 then
				item:ApplyDataDrivenModifier(npc, npc, "pergatory_9", nil)
			elseif npc:GetLevel() >= 16 then
				item:ApplyDataDrivenModifier(npc, npc, "pergatory_6", nil)
			elseif npc:GetLevel() >= 13 then
				item:ApplyDataDrivenModifier(npc, npc, "pergatory_3", nil)
			end
		npc:RemoveItem(item)
		Timers:CreateTimer( 0.1, function()
			if npc:IsHero() or npc:HasInventory() then 
						for itemSlot = 6, 11, 1 do 
							if npc ~= nil then
								local Item = npc:GetItemInSlot( itemSlot )
									if Item ~= nil and string.match(Item:GetName(),"hull") then -- makes sure that the item exists and making sure it is the correct item
									npc:RemoveModifierByName("modifier_item_hull_one")
									print( "hull found." )
								elseif Item ~= nil and string.match(Item:GetName(),"doubled") then -- makes sure that the item exists and making sure it is the correct item
									local doubledstring = string.gsub(Item:GetName(),"_bow", "_bow_shooting")
									npc:RemoveModifierByName(doubledstring)
									print( "doubled found." )
								elseif Item ~= nil and string.match(Item:GetName(),"bow") then -- makes sure that the item exists and making sure it is the correct item
									npc:RemoveModifierByName(Item:GetName() .. "_shooting")
									print( "bow found." )
								elseif Item ~= nil and string.match(Item:GetName(),"sail") then -- makes sure that the item exists and making sure it is the correct item
									npc:RemoveModifierByName("modifier_item_sail_one")
									print( "sail found." )
								elseif Item ~= nil and string.match(Item:GetName(),"repair") then -- makes sure that the item exists and making sure it is the correct item
									npc:RemoveModifierByName("modifier_item_repair_one")
									print( "sail found." )
								end
							end
						end
					end
    
    end
  )
		
		
	  end
  end
end


function CBattleship8D:handleEmpGold()
			GameRules:SetTimeOfDay(0.25)
			TICKS_SINCE_EMP_GOLD = 0
			local goodGold = 0
			local badGold = 0
			NUM_GOOD_PLAYERS = 0
			NUM_BAD_PLAYERS = 0
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 then
					print("modifying team gold for" .. hero:GetTeamNumber())
					local herogold = hero:GetGold()
					if herogold>0 and not hero:HasModifier("pergatory_perm") then
						if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							NUM_GOOD_PLAYERS = NUM_GOOD_PLAYERS + 1
						elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							NUM_BAD_PLAYERS = NUM_BAD_PLAYERS + 1
						end
					end
				end
			end
			
			

			print("bad gold for this interval was" .. BAD_GOLD_TOTAL_MOD)
			print("good gold for this interval was" .. GOOD_GOLD_TOTAL_MOD)

			 
			local goodGoldEach = 500 * EMP_GOLD_NUMBER
			local badGoldEach = 500 * EMP_GOLD_NUMBER
			local GoldDif = 0
			if GOOD_GOLD_TOTAL_MOD > BAD_GOLD_TOTAL_MOD then
				GoldDif = GOOD_GOLD_TOTAL_MOD - BAD_GOLD_TOTAL_MOD
				badGoldEach = badGoldEach + GoldDif * (DOCK_SOUTH_LEFT + DOCK_SOUTH_RIGHT)/2 * (0.2 + 0.8 * (1/EMP_GOLD_NUMBER))
				BAD_GOLD_TOTAL_MOD = 0
				GOOD_GOLD_TOTAL_MOD = GoldDif
			elseif BAD_GOLD_TOTAL_MOD > GOOD_GOLD_TOTAL_MOD then
				GoldDif = BAD_GOLD_TOTAL_MOD - GOOD_GOLD_TOTAL_MOD
				goodGoldEach = goodGoldEach + GoldDif * (DOCK_NORTH_LEFT + DOCK_NORTH_RIGHT)/2 * (0.2 + 0.8 * (1/EMP_GOLD_NUMBER))
				BAD_GOLD_TOTAL_MOD = GoldDif
				GOOD_GOLD_TOTAL_MOD = 0
			end
			if NUM_GOOD_PLAYERS ~= 0 and NUM_BAD_PLAYERS ~= 0 then
				goodGoldEach = goodGoldEach / NUM_GOOD_PLAYERS
				badGoldEach = badGoldEach / NUM_BAD_PLAYERS
			end
			--trying out full game igold team comparison stuff crap shit
			--BAD_GOLD_TOTAL_MOD = 0
			--GOOD_GOLD_TOTAL_MOD = 0
			GameRules:SendCustomMessage("<font color='#B2B2B2'> Empire gold received, North gets</font><font color='#FFD700'> ".. math.floor(badGoldEach+0.5) 	.."<font color='#B2B2B2'> each.</font> ", DOTA_TEAM_BADGUYS, 0)
			GameRules:SendCustomMessage("<font color='#B2B2B2'> Empire gold received, South gets</font><font color='#FFD700'> ".. math.floor(goodGoldEach+0.5) .."<font color='#B2B2B2'> each.</font> ", DOTA_TEAM_GOODGUYS, 0)
			
			
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 and not hero:HasModifier("pergatory_perm") then
					local herogold = hero:GetGold()
					if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
						hero:SetGold(herogold + goodGoldEach, true)   
						GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + goodGoldEach
						print("hero's is good guy (south) had " .. herogold .. " got " .. goodGoldEach .. "new gold is: " .. herogold + goodGoldEach)
						hero:SetGold(0, false)
					elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
						hero:SetGold(herogold + badGoldEach, true)
						BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + badGoldEach
						print("hero's is bad guy (north) had " .. herogold .. " got " .. badGoldEach .. "new gold is: " .. herogold + badGoldEach)
						hero:SetGold(0, false)
					end
				end
			end
			
end 

function CBattleship8D:quickSpawn(team, lane, tier, level, number)
        
	local spawnLocation = Entities:FindByName( nil, team .. "_spawn_" .. lane)
        local waypointlocation = Entities:FindByName ( nil,  team .. "_wp_" .. lane .. "_2")
        local i = 0
        while number>i do
				local creature
				--print ("team is: " .. team .. "     spawn is: " .. team .. "_spawn_" .. lane .. "     comparison yields" .. tostring(team == "north"))
                --hscript CreateUnitByName( string name, vector origin, bool findOpenSpot, hscript, hscript, int team)
				if team == "north" then
					 creature = CreateUnitByName( "npc_dota_boat_" .. team .. "_" .. tier , spawnLocation:GetAbsOrigin() + Vector(-300 + i * 100,0,0), true, nil, nil, DOTA_TEAM_BADGUYS )
				else
					 creature = CreateUnitByName( "npc_dota_boat_" .. team .. "_" .. tier , spawnLocation:GetAbsOrigin() + Vector(-300 + i * 100,0,0), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end
                --Sets the waypath to follow. path_wp1 in this example
				if creature~=nil then
				
						creature:SetInitialGoalEntity( waypointlocation )
				end
				--creature:CreatureLevelUp(level)
                i = i + 1
        end

end
-- Evaluate the state of the game

function sellBoat(casterUnit)
  local herogold = casterUnit:GetGold()
	if string.match(casterUnit:GetName(),"mirana") then
					casterUnit:SetGold(herogold + 2250, true)
					casterUnit:SetGold(0, false)
					 print ( '[BAREBONES] player was mirana and got 2250')
				elseif string.match(casterUnit:GetName(),"terrorblade") then
					casterUnit:SetGold(herogold + 6000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was terrorblade and got 6000')
				elseif string.match(casterUnit:GetName(),"meepo") then
					casterUnit:SetGold(herogold + 4500, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was meepo and got 4500')
				elseif string.match(casterUnit:GetName(),"tidehunter") then
					casterUnit:SetGold(herogold + 750, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was tidehunter and got 750')
				elseif string.match(casterUnit:GetName(),"antimage") then
					casterUnit:SetGold(herogold + 750, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was apparition and got 750')
				elseif string.match(casterUnit:GetName(),"kunkka") then
					casterUnit:SetGold(herogold + 750, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was kunkka and got 750')
				elseif string.match(casterUnit:GetName(),"morphling") then
					casterUnit:SetGold(herogold + 2250, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was morphling and got 2250')
				elseif string.match(casterUnit:GetName(),"puck") then
					casterUnit:SetGold(herogold + 2250, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was puck and got 2250')
				elseif string.match(casterUnit:GetName(),"riki") then
					casterUnit:SetGold(herogold + 4500, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was riki and got 6000')
				elseif string.match(casterUnit:GetName(),"shadow_shaman") then
					casterUnit:SetGold(herogold + 4500, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was shadow_shaman and got 4500')
				elseif string.match(casterUnit:GetName(),"jakiro") then
					casterUnit:SetGold(herogold + 4500, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was jakiro and got 4500')
				elseif string.match(casterUnit:GetName(),"pudge") then
					casterUnit:SetGold(herogold + 2250, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was pudge and got 2250')
				elseif string.match(casterUnit:GetName(),"tusk") then
					casterUnit:SetGold(herogold + 6000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was tusk and got 6000')
				elseif string.match(casterUnit:GetName(),"spirit_breaker") then
					casterUnit:SetGold(herogold + 6000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was spirit_breaker and got 4500')
				elseif string.match(casterUnit:GetName(),"gyrocopter") then
					casterUnit:SetGold(herogold + 2250, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was gyrocopter and got 2250')
				elseif string.match(casterUnit:GetName(),"sniper") then
					casterUnit:SetGold(herogold + 4500, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was sniper and got 2250')
				elseif string.match(casterUnit:GetName(),"wind") then
					casterUnit:SetGold(herogold + 6000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was lone_druid and got 6000')
				elseif string.match(casterUnit:GetName(),"crystal") then
					casterUnit:SetGold(herogold + 750, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was lone_druid and got 6000')
				elseif string.match(casterUnit:GetName(),"doom") then
					casterUnit:SetGold(herogold + 750, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was doom_lancer and got 750')
				end
end

function CBattleship8D:OnThink()
		if THINK_TICKS < 160 then
			if NUM_PLAYERS == 0 then
				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
						NUM_PLAYERS=NUM_PLAYERS+1
					end
				end
			end
		end
			 
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		
		if GameRules:GetGameTime() ~= LAST_TIME then
			if THINK_TICKS == 5 then
		-- Load Stat collection (statcollection should be available from any script scope)
		
		Timers:CreateTimer( 300, function()
			spawnTide()
		end)
			for _,tower in pairs( Entities:FindAllByClassname( "npc_dota_tow*")) do
			      print( "tower name! " .. tower:GetName())
					if tower ~= nil and string.match(tower:GetName(),"tower") then
						 print( "tower name! was a tower that needed range." .. tower:GetName())
						if tower:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							creature = CreateUnitByName( "npc_dota_rng_ind" , tower:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
						
						elseif  tower:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							creature = CreateUnitByName( "npc_dota_rng_ind" , tower:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
						
						end
						
				end
			end
		
		
		statcollection.addStats({
			modID = '28ed93c9d232295e180a3628e60a492e' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
		})

    print( "Example stat collection game mode loaded." )
		GameRules:SendCustomMessage("<font color='#58ACFA'>Welcome to Battleships, </font><font color='#B03060'>Armor Speed and Regen </font><font color='#58ACFA'>are in the </font><font color='#B03060'>Upgrades</font><font color='#58ACFA'> tab of the main shop in base. </font>", DOTA_TEAM_GOODGUYS, 0)
			
		end
		if THINK_TICKS == 7 then	
		
		GameRules:SendCustomMessage("<font color='#07C300'>Boats </font><font color='#58ACFA'>can be found in the </font><font color='#07C300'>Second Shop</font><font color='#58ACFA'> which is on the right side of the base. </font> ", DOTA_TEAM_GOODGUYS, 0)
			NUM_GOOD_PLAYERS = 0
			NUM_BAD_PLAYERS = 0
				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
						print("modifying team gold for" .. hero:GetTeamNumber())
						if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							NUM_GOOD_PLAYERS = NUM_GOOD_PLAYERS + 1
						elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							NUM_BAD_PLAYERS = NUM_BAD_PLAYERS + 1
						end
						isDisconnected[hero] = 0
					end
				end
		
		end
		if THINK_TICKS == 20 then	
		GameRules:SendCustomMessage("<font color='#58ACFA'>Battleships ends when either team loses their </font><font color='#BFA300'>Main Base</font><font color='#58ACFA'> or loses </font><font color='#BFA300'>Both Side Harbours</font><font color='#58ACFA'> where the empire builds ships. </font> ", DOTA_TEAM_GOODGUYS, 0)
		end
		
		
		--iterates through heroes every 2 seconds
		if THINK_TICKS % 2 == 0 then
			if THINK_TICKS % 4 == 0 and SPY_ANNOUNCMENT_FLAG == 1 then
				SPY_ANNOUNCMENT_FLAG = 0
				GameRules:SendCustomMessage("<font color='#58ACFA'> Spies have been purchased; structures have been sabotaged! </font>" , DOTA_TEAM_GOODGUYS, 0)
				GameRules:SendCustomMessage("<font color='#CC33FF'> North Empire buildings are now reduced by </font><font color='#CC3300'>" .. SPYS_SOUTH .. "</font><font color='#CC33FF'> armor</font>" , DOTA_TEAM_GOODGUYS, 0)
				GameRules:SendCustomMessage("<font color='#CC33FF'> South Empire buildings are now reduced by </font><font color='#CC3300'>" .. SPYS_NORTH .. "</font><font color='#CC33FF'> armor</font>", DOTA_TEAM_BADGUYS, 0)

			end
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 then
					if hero:IsIllusion() then
						hero:SetModel( "models/noah_boat.vmdl" )
						hero:SetOriginalModel( "models/noah_boat.vmdl" )
					end
					if string.match(hero:GetName(),"tusk") then
							local casterUnit = hero
							--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
							--print('[AbilityFunctions] battleshipHealth started!')
							if casterUnit:IsAlive() and hero:IsOwnedByAnyPlayer() and herohp[casterUnit:GetOwner():GetPlayerID()] == nil then
								herohp[casterUnit:GetOwner():GetPlayerID()] = casterUnit:GetHealthPercent() 
								casterUnit:SetModel("models/battleship_boat0")
								casterUnit:SetOriginalModel("models/battleship_boat0")
							end
							if casterUnit:IsAlive() and hero:IsOwnedByAnyPlayer() then
								if casterUnit:GetHealthPercent() < 7  and herohp[casterUnit:GetOwner():GetPlayerID()] > 6 then
									casterUnit:SetModel("models/battleship_boat4")
									casterUnit:SetOriginalModel("models/battleship_boat4")
								--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() < 25 and herohp[casterUnit:GetOwner():GetPlayerID()] > 24 then
									casterUnit:SetModel("models/battleship_boat3")
									casterUnit:SetOriginalModel("models/battleship_boat3")
									--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() < 50 and herohp[casterUnit:GetOwner():GetPlayerID()] > 49 then
									casterUnit:SetModel("models/battleship_boat2")
									casterUnit:SetOriginalModel("models/battleship_boat2")
									--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() < 75 and herohp[casterUnit:GetOwner():GetPlayerID()] > 74 then
									casterUnit:SetModel("models/battleship_boat1")
									casterUnit:SetOriginalModel("models/battleship_boat1")
									--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() > 74 and herohp[casterUnit:GetOwner():GetPlayerID()] < 75 then
									casterUnit:SetModel("models/battleship_boat0")
									casterUnit:SetOriginalModel("models/battleship_boat0")
									--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								end
									herohp[casterUnit:GetOwner():GetPlayerID()] = casterUnit:GetHealthPercent() 
							end
						end
						
						if PlayerResource:GetConnectionState( hero:GetPlayerID() ) ~= 2 or hero:HasOwnerAbandoned() or hero:HasModifier("pergatory_perm") then
								print('inside disconnect')
										if DisconnectTime[hero]~= nil then
											DisconnectTime[hero]=DisconnectTime[hero]+2
											print('disconnect time: ' .. DisconnectTime[hero])
											else
											DisconnectTime[hero]=1
										end
											if DisconnectTime[hero]==180 or DisconnectTime[hero]==181 then
												GameRules:SendCustomMessage("<font color='#800000'> A player is now eligible to be kicked due to disconnect so their team can receive gold. </font> ", DOTA_TEAM_GOODGUYS, 0)
												GameRules:SendCustomMessage("<font color='#800000'> once kicked they will NEVER RECIEVE GOLD EVEN IF THEY RECONNECT </font> ", DOTA_TEAM_GOODGUYS, 0)
												GameRules:SendCustomMessage("<font color='#800000'> To kick this player move their ship onto the 'KICK DISCONNECTED' text  </font> ", DOTA_TEAM_GOODGUYS, 0)
												GameRules:SendCustomMessage("<font color='#800000'> if a player ABANDONS the game they will be kicked.  </font> ", DOTA_TEAM_GOODGUYS, 0)
											
											end
											if DisconnectTime[hero]>180 or hero:HasOwnerAbandoned() then
											print('bigger than 180')
												local casterPos = hero:GetAbsOrigin()
												local targetUnitOne = Entities:FindByName( nil, "south_kicker")
												local targetUnitTwo = Entities:FindByName( nil, "north_kicker")
												local directionOne =  casterPos - targetUnitOne:GetAbsOrigin()
												local directionTwo =  casterPos - targetUnitTwo:GetAbsOrigin()
											
											
												if directionOne:Length() < 600 or directionTwo:Length() < 600 or hero:HasOwnerAbandoned() then
													DisconnectKicked[hero] =1
												end
											end

											
											local herogold = hero:GetGold()
										if (DisconnectKicked[hero] == 1 or hero:HasOwnerAbandoned()) and herogold > 30 and false == hero:HasModifier("pergatory_perm") then
											GameRules:SendCustomMessage("<font color='#800000'> A player is being removed from the game. Their gold and 75 percent of their items and boat value will be distributed with the empire gold </font> ", DOTA_TEAM_GOODGUYS, 0)
											
											--not sure if syntax in following line is right
											sellBoat(hero)
											for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
													if hero ~= nil then --checks to make sure the killed unit is not nonexistent.
															local Item = hero:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
															if Item ~= nil then -- makes sure that the item exists and making sure it is the correct item
																hero:SetGold(herogold + Item:GetGoldCost(0), true)
																hero:SetGold(0, false)
																hero:RemoveItem(Item)
															end
													end
											end
											local herogoldaftersell = hero:GetGold()
											if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
												BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + herogoldaftersell
											elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
												GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + herogoldaftersell
											end
											hero:SetGold(0, false)
											hero:SetGold(0, true)
											DisconnectKicked[hero] = 2
											local vecorig = Vector(-8000,384,0)
											hero:SetOrigin(vecorig)
											local item = CreateItem( "item_spawn_stunner", npc, npc)
							
											item:ApplyDataDrivenModifier(hero, hero, "pergatory_perm", nil)
										end
										
										if DisconnectKicked[hero] == 2 or hero:HasOwnerAbandoned() or hero:HasModifier("pergatory_perm") then
												if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
													hero:SetGold(0, true)
													BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + BAD_GOLD_PER_TICK * 2
												elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
													hero:SetGold(0, true)
													GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + GOOD_GOLD_PER_TICK * 2
											end
										end
								end
						
						
				
							for itemSlot = 0, 5, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
									if hero ~= nil then --checks to make sure the killed unit is not nonexistent.
											local Item = hero:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
											if Item ~= nil and string.match(Item:GetName(),"hull") then -- makes sure that the item exists and making sure it is the correct item
												Item:ApplyDataDrivenModifier(hero, hero, "modifier_item_hull_one", nil)
												
											end
									end
							end
					
					--handles people stuck on cliffs
						local height = hero:GetOrigin() * Vector(0,0,1)
						if height:Length() > 110 and false == hero:HasModifier("fly_bat") and false == hero:HasModifier("fly") and false == hero:HasModifier("modifier_spirit_breaker_charge_of_darkness") and false == hero:HasModifier("modifier_kunkka_torrent") and false == hero:HasModifier("modifier_batrider_flaming_lasso") and false == hero:IsStunned() and  hero:IsAlive() then 
							
							local abil1 = hero:GetAbilityByIndex(1)
							
							print( 'player found at z of: ' .. tostring(height:Length()) .. "and cd check is " .. tostring(abil1:GetCooldownTimeRemaining() > abil1:GetCooldown(abil1:GetLevel())-2) .. " and name of hero is " .. hero:GetName() .. " so name check is " .. tostring(string.match(hero:GetName(),"morphling")))
						
							if abil1:GetCooldownTimeRemaining() >= abil1:GetCooldown(abil1:GetLevel())-2 and (string.match(hero:GetName(),"morphling") or string.match(hero:GetName(),"kunkka")) then
							
							else
								hero:SetOrigin(hero:GetOrigin() * Vector(1,1,0.9) +RandomVector( RandomFloat( 300, 400 ) 	))						
								local dmg=hero:GetMaxHealth() * 0.5
								local damageTable = {
									victim = hero,
									attacker = hero,
									damage = dmg,
									damage_type = DAMAGE_TYPE_PURE,
								}
								GameRules:SendCustomMessage("<font color='#800000'> Stay off the walls if you cannot fly! </font> ", DOTA_TEAM_GOODGUYS, 0)
				
								ApplyDamage(damageTable)
							end
						
						end
					--gives gold per tick
					local herogold = hero:GetGold()
					if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
						hero:SetGold(herogold + GOOD_GOLD_PER_TICK * 2, true)
						hero:SetGold(0, false)
						GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + GOOD_GOLD_PER_TICK * 2
					elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
						hero:SetGold(herogold + BAD_GOLD_PER_TICK * 2, true)
						hero:SetGold(0, false)
						BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + BAD_GOLD_PER_TICK * 2
					end
					
					--Old code that got deleted then pasted back in
									

				end
			end
		end
		
		

		
		
		if THINK_TICKS % 240 == 0 or TICKS_SINCE_EMP_GOLD > 240 then
			CBattleship8D:handleEmpGold()
			EMP_GOLD_NUMBER = EMP_GOLD_NUMBER + 1
		end
		
		if THINK_TICKS % 45 == 0 or THINK_TICKS == 1 then
			if  DOCK_SOUTH_RIGHT == 1 then
				CBattleship8D:quickSpawn("south","right", "one", CREEP_LEVEL, CREEP_NUM_SMALL)
			else
				CBattleship8D:quickSpawn("south","right", "one", 1, CREEP_NUM_SMALL)
			end
			if  DOCK_NORTH_RIGHT == 1 then
					CBattleship8D:quickSpawn("north","right", "one", CREEP_LEVEL, CREEP_NUM_SMALL)
			else
					CBattleship8D:quickSpawn("north","right", "one", 1, CREEP_NUM_SMALL)
			end
			if  DOCK_SOUTH_LEFT == 1 then
					CBattleship8D:quickSpawn("south","left", "one", CREEP_LEVEL, CREEP_NUM_SMALL)
			else
					CBattleship8D:quickSpawn("south","left", "one", 1, CREEP_NUM_SMALL)
			end
			if  DOCK_NORTH_LEFT == 1 then
				CBattleship8D:quickSpawn("north","left", "one", CREEP_LEVEL, CREEP_NUM_SMALL)
			else
				CBattleship8D:quickSpawn("north","left", "one", 1, CREEP_NUM_SMALL)
			end
		end
		if THINK_TICKS % 90 == 0 then
			if  DOCK_SOUTH_RIGHT == 1 then
				CBattleship8D:quickSpawn("south","right", "two", CREEP_LEVEL, CREEP_NUM_BIG)
			else
				CBattleship8D:quickSpawn("south","right", "two", 1, CREEP_NUM_BIG)
			end
			if  DOCK_NORTH_RIGHT == 1 then
					CBattleship8D:quickSpawn("north","right", "two", CREEP_LEVEL, CREEP_NUM_BIG)
			else
					CBattleship8D:quickSpawn("north","right", "two", 1, CREEP_NUM_BIG)
			end
			if  DOCK_SOUTH_LEFT == 1 then
					CBattleship8D:quickSpawn("south","left", "two", CREEP_LEVEL, CREEP_NUM_BIG)
			else
					CBattleship8D:quickSpawn("south","left", "two", 1, CREEP_NUM_BIG)
			end
			if  DOCK_NORTH_LEFT == 1 then
				CBattleship8D:quickSpawn("north","left", "two", CREEP_LEVEL, CREEP_NUM_BIG)
			else
				CBattleship8D:quickSpawn("north","left", "two", 1, CREEP_NUM_BIG)
			end
			
		end
		if THINK_TICKS % 180 == 0 then	
			if  DOCK_SOUTH_RIGHT == 1 then
				CBattleship8D:quickSpawn("south","right", "three", CREEP_LEVEL, CREEP_NUM_HUGE)
			else
				CBattleship8D:quickSpawn("south","right", "three", 1, CREEP_NUM_HUGE)
			end
			if  DOCK_NORTH_RIGHT == 1 then
					CBattleship8D:quickSpawn("north","right", "three", CREEP_LEVEL, CREEP_NUM_HUGE)
			else
					CBattleship8D:quickSpawn("north","right", "three", 1, CREEP_NUM_HUGE)
			end
			if  DOCK_SOUTH_LEFT == 1 then
					CBattleship8D:quickSpawn("south","left", "three", CREEP_LEVEL, CREEP_NUM_HUGE)
			else
					CBattleship8D:quickSpawn("south","left", "three", 1, CREEP_NUM_HUGE)
			end
			if  DOCK_NORTH_LEFT == 1 then
				CBattleship8D:quickSpawn("north","left", "three", CREEP_LEVEL, CREEP_NUM_HUGE)
			else
				CBattleship8D:quickSpawn("north","left", "three", 1, CREEP_NUM_HUGE)
			end
			
		end
		local nCreepval = 45-THINK_TICKS%45;
		if THINK_TICKS % 180 == 0 and CREEP_NUM_SMALL < 6 then
			CREEP_NUM_SMALL = CREEP_NUM_SMALL + 1
		end
		if THINK_TICKS % 300 == 0 and CREEP_NUM_BIG < 6 then
			CREEP_NUM_BIG = CREEP_NUM_BIG + 1
		end
		if THINK_TICKS % 500 == 0 and CREEP_NUM_HUGE < 10 then
			CREEP_NUM_HUGE = CREEP_NUM_HUGE + 2
		end
		if THINK_TICKS > 1500 then
			CREEP_NUM_SMALL = 2
		end
		if THINK_TICKS > 2000 then
			nCreepval = 90-THINK_TICKS%90;
			CREEP_NUM_SMALL = 0
			CREEP_NUM_BIG = 4
		end
		if THINK_TICKS > 2500 then
			nCreepval = 180-THINK_TICKS%180;
			CREEP_NUM_SMALL = 0
			CREEP_NUM_BIG = 0
		end
		
		local bsuiTimerData = {
			nEmpire = 240-THINK_TICKS % 240;
			nCreep = nCreepval;
		}
		FireGameEvent( "bsui_timer_data", bsuiTimerData ); 
			THINK_TICKS = THINK_TICKS + 1
			TICKS_SINCE_EMP_GOLD=TICKS_SINCE_EMP_GOLD+1
			LAST_TIME=GameRules:GetGameTime()		
		end
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end


function CBattleship8D:OnDisconnect(keys)
  print('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
    PrintTable(keys)
		local plyID
		for ind = 0, 20, 1 do 
			if string.match(keys.name,playerIdsToNames[ind]) then
				plyID=ind
			end		
		end

		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			if hero ~= nil then
				local id = hero:GetPlayerOwnerID()
				print("this hero's id" .. tostring(hero:GetPlayerOwnerID()))
				if id == plyID then
					print("this is the DCd hero")
					isDisconnected[hero] = 1
				end
			end
	 	end	
 GameRules:SendCustomMessage("<font color='#800000'> " .. tostring(keys.name) .. " has disconnected they will have 3 minutes of gametime (not pauses) before their gold is distributed </font> ", DOTA_TEAM_GOODGUYS, 0)
		
end
function CBattleship8D:OnConnectFull(keys)
  print ( '[BAREBONES] OnConnectFull' )
  PrintTable(keys)

		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			if hero ~= nil then
				local id = hero:GetPlayerOwnerID()
				print("this hero's id" .. tostring(hero:GetPlayerOwnerID()))
				if id == keys.index then
					print("this is the DCd hero reconnecting")
					isDisconnected[hero] = 0
					DisconnectTime[hero] = 0
				end
			end
		end
  
  if DisconnectKicked[keys.index] ~=0 then
	GameRules:SendCustomMessage("<font color='#800000'>A player has reconnected who has been kicked by their team. rough... </font> ", DOTA_TEAM_GOODGUYS, 0)
							
  end
  
end


function CBattleship8D:OnEntityKilled( keys )
	
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	
	--handle tower gold
	if killedUnit:IsTower() then
			print( "Tower Killed" )
			if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS then
				GOOD_GOLD_PER_TICK = GOOD_GOLD_PER_TICK + 2
				print( "Bad Tower, Good guys gold per tick is now: " .. GOOD_GOLD_PER_TICK )
				GameRules:SendCustomMessage("<font color='#FF6600'> Northern tower has fallen! South Empire's gold income permanently increased and each southern captain got </font><font color='#FFD700'>100</font><font color='#FF6600'>!</font> ", DOTA_TEAM_GOODGUYS, 0)
			
				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
						local herogold = hero:GetGold()
						if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS  then
							hero:SetGold(herogold + 100, true)
							hero:SetGold(0, false)
							GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + 100
						end
					end
				end
			elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS then
				BAD_GOLD_PER_TICK = BAD_GOLD_PER_TICK + 2
				print( "Good Tower, Bad guys gold per tick is now: " .. BAD_GOLD_PER_TICK )
				GameRules:SendCustomMessage("<font color='#FF6600'> Southern tower has fallen! North Empire's gold income permanently increased and each northern captain got </font><font color='#FFD700'>100</font><font color='#FF6600'>!</font> ", DOTA_TEAM_GOODGUYS, 0)
				
				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
						local herogold = hero:GetGold()
						if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS  then
							hero:SetGold(herogold + 100, true)
							hero:SetGold(0, false)
							BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + 100
						end
					end
				end
			end	
			
		--handle docks dieing and changing the empire gold redistribution
		if string.match(killedUnit:GetUnitName(), "dock") then
		print( "base killed" )
			
			if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS then
				
				if DOCK_NORTH_LEFT+DOCK_NORTH_RIGHT==1 then
					GameRules:SendCustomMessage("<font color='#58ACFA'> Questions? Comments? Bugs? tell us in </font><font color='#BFA300'>/r/dota2bships</font><font color='#58ACFA'> or email us at</font><font color='#BFA300'> dota2bships@gmail.com </font> ", DOTA_TEAM_GOODGUYS, 0)
					GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
					GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
					GameRules:SetSafeToLeave( true )
				elseif string.match(killedUnit:GetUnitName(), "left") then
					DOCK_NORTH_LEFT = 0
					GameRules:SendCustomMessage("<font color='#B2B2B2'> North Harbor has fallen! North Empire will no longer produce boats for the left lane and if the right lane falls they will be defeated!</font> ", DOTA_TEAM_GOODGUYS, 0)
					
				elseif string.match(killedUnit:GetUnitName(), "right") then
					DOCK_NORTH_RIGHT = 0
					GameRules:SendCustomMessage("<font color='#B2B2B2'> North Harbor has fallen! North Empire will no longer produce boats for the right lane and if the left lane falls they will be defeated!</font> ", DOTA_TEAM_GOODGUYS, 0)
			
				end
				
				
			elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS then
				if DOCK_SOUTH_LEFT+DOCK_SOUTH_RIGHT==1 then
					GameRules:SendCustomMessage("<font color='#58ACFA'> Questions? Comments? Bugs? tell us in </font><font color='#BFA300'>/r/dota2bships</font><font color='#58ACFA'> or email us at</font><font color='#BFA300'> dota2bships@gmail.com </font> ", DOTA_TEAM_GOODGUYS, 0)
					GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					GameRules:SetSafeToLeave( true )
				elseif string.match(killedUnit:GetUnitName(), "left") then
					DOCK_SOUTH_LEFT = 0
					GameRules:SendCustomMessage("<font color='#B2B2B2'> South Harbor has fallen! South Empire will no longer produce boats for the right lane and if the left lane falls they will be defeated!</font> ", DOTA_TEAM_GOODGUYS, 0)
			
				elseif string.match(killedUnit:GetUnitName(), "right") then
					DOCK_SOUTH_RIGHT = 0
					GameRules:SendCustomMessage("<font color='#B2B2B2'> South Harbor has fallen! South Empire will no longer produce boats for the right lane and if the left left falls they will be defeated!</font> ", DOTA_TEAM_GOODGUYS, 0)
			
				end
				
			end
			print( "North docks:" .. DOCK_NORTH_LEFT .. DOCK_NORTH_RIGHT )
			print( "South docks:" .. DOCK_SOUTH_LEFT .. DOCK_SOUTH_RIGHT )
		end
		
		--handle ending game
		if string.match(killedUnit:GetUnitName(), "base") then
			print( "MATCHED BASE IS TRUE" )
			if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS then
				GameRules:SendCustomMessage("<font color='#58ACFA'> Questions? Comments? Bugs? tell us in </font><font color='#BFA300'>/r/dota2bships</font><font color='#58ACFA'> or email us at</font><font color='#BFA300'> dota2bships@gmail.com </font> ", DOTA_TEAM_GOODGUYS, 0)
				GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				GameRules:SetSafeToLeave( true )
			elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS then
				GameRules:SendCustomMessage("<font color='#58ACFA'> Questions? Comments? Bugs? tell us in </font><font color='#BFA300'>/r/dota2bships</font><font color='#58ACFA'> or email us at</font><font color='#BFA300'> dota2bships@gmail.com </font> ", DOTA_TEAM_GOODGUYS, 0)
				GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				GameRules:SetSafeToLeave( true )
			end
		end
		
	end
	
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end
 
  if string.match(killedUnit:GetUnitName(), "creature_tidehunter") then
	if killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			CBattleship8D:quickSpawn("north","right", "four", 1, CREEP_NUM_HUGE+1)
			CBattleship8D:quickSpawn("north","left", "four", 1, CREEP_NUM_HUGE+1)
			GameRules:SendCustomMessage("<font color='#003300'> Privateers have seen the NORTH slay a monster and have decided to join their cause.</font> ", DOTA_TEAM_GOODGUYS, 0)
						
	end
	if  killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		CBattleship8D:quickSpawn("south","right", "four", 1, CREEP_NUM_HUGE+1)
		CBattleship8D:quickSpawn("south","left", "four", 1, CREEP_NUM_HUGE+1)
		GameRules:SendCustomMessage("<font color='#003300'> Privateers have seen the SOUTH slay a monster and have decided to join their cause.</font> ", DOTA_TEAM_GOODGUYS, 0)
	end
		Timers:CreateTimer( 300, function()
		TIDE_LEVEL = TIDE_LEVEL+1
			spawnTide()
		end)
		
		
		
  end

   if string.match(killedUnit:GetUnitName(), "_three") or string.match(killedUnit:GetUnitName(), "_four") then
		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			if hero ~= nil and hero:IsOwnedByAnyPlayer() then
				local herogold = hero:GetGold()
				if hero:GetTeamNumber() == killerEntity:GetTeamNumber() and killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					hero:SetGold(herogold + 50, true)
					hero:SetGold(0, false)
					GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + 50
				elseif hero:GetTeamNumber() == killerEntity:GetTeamNumber() and killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
					hero:SetGold(herogold + 50, true)
					hero:SetGold(0, false)
					BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + 50

				end
			end
		end
  end
  

  --handle killing a streaker
	if killerEntity:IsRealHero() then
	  
	  if killedUnit:IsRealHero() then 
	  if herokills[killedUnit:GetOwner():GetPlayerID()] > 2 then
		if killerEntity ~= nil and killerEntity:IsOwnedByAnyPlayer() then
			local herogold = killerEntity:GetGold()
			if killerEntity:GetTeamNumber() ~= killedUnit:GetTeam()  then
				killerEntity:SetGold(herogold + herokills[killedUnit:GetOwner():GetPlayerID()] * 100, true)
				killerEntity:SetGold(0, false)
				if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + herokills[killedUnit:GetOwner():GetPlayerID()] * 100
				elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
					BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + herokills[killedUnit:GetOwner():GetPlayerID()] * 100
				end
			end
		end
		GameRules:SendCustomMessage("<font color='#A70606'> Kill Streak ended!</font><font color='#FFD700'> ".. killerEntity:GetStreak() * 100 .."</font><font color='#A70606'>  gold awarded to each player.</font> ", DOTA_TEAM_GOODGUYS, 0)
		herokills[killedUnit:GetOwner():GetPlayerID()] = 0
	   end
-- handle awarding kill streak gold
	herokills[killerEntity:GetOwner():GetPlayerID()] = herokills[killerEntity:GetOwner():GetPlayerID()] + 1
		print ("KILLEDKILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
		if killerEntity:GetStreak() > 2 and killerEntity:GetTeamNumber() ~= killedUnit:GetTeamNumber()  then
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() then
					local herogold = hero:GetGold()
					if hero:GetTeamNumber() == killerEntity:GetTeam()  then
						hero:SetGold(herogold + killerEntity:GetStreak() * 30, true)
						hero:SetGold(0, false)
						if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + killerEntity:GetStreak() * 30
						elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + killerEntity:GetStreak() * 30
						end
					end
				end
			end
			local killergold = killerEntity:GetGold()
			killerEntity:SetGold(killergold - killerEntity:GetStreak() * 30, true)
			killerEntity:SetGold(0, false)
			GameRules:SendCustomMessage("<font color='#A70606'> Kill Streak bonus grants allied players ".. killerEntity:GetStreak() * 30 .." each.</font> ", DOTA_TEAM_GOODGUYS, 0)
			if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD - killerEntity:GetStreak() * 30
			elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD - killerEntity:GetStreak() * 30
			end
		end
		if  killerEntity == killedUnit then
				GameRules:SendCustomMessage("<font color='#800000'> Do not kill yourself! other team awarded </font><font color='#FFD700'>".. killerEntity:GetGoldBounty() .."</font><font color='#800000'> gold. (will be awarded with empire gold)</font> ", DOTA_TEAM_GOODGUYS, 0)
				if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + killerEntity:GetGoldBounty()
				elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
					BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + killerEntity:GetGoldBounty()
				end
		end
		--handle vengance
		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() then
					if false == hero:IsAlive() and false == hero:IsIllusion() and hero:GetTeamNumber() == killerEntity:GetTeam() and killerEntity ~= hero and killerEntity:GetTeam() ~= killedUnit:GetTeam() and hero:GetPlayerOwnerID() ~= -1 then
						local bounty=hero:GetGoldBounty()
						
						killerEntity:SetGold(killerEntity:GetGold() + bounty/4, true)
						hero:SetGold(hero:GetGold() + bounty/2, true)
						GameRules:SendCustomMessage("<font color='#FF9900'>  ".. PlayerResource:GetPlayerName( killerEntity:GetPlayerID()) .. " has avenged " .. PlayerResource:GetPlayerName( hero:GetPlayerID()) .. " and earned </font><font color='#FFD700'>" .. math.floor(bounty/4+0.5) .. "</font><font color='#FF9900'> gold for himself and </font><font color='#FFD700'>" .. math.floor(bounty/2+0.5) .. "</font><font color='#FF9900'>  for his fallen Ally.</font> ", DOTA_TEAM_GOODGUYS, 0)
						if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + EMP_GOLD_NUMBER * bounty*3/4
						elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + EMP_GOLD_NUMBER * bounty*3/4
						end
					end
				end
		end
		
		--genocyde counter
		local goodDead=0
		local badDead=0
		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 then
					if false == hero:IsAlive() and false == hero:IsIllusion() then
						if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							goodDead = goodDead + 1
						elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							badDead = badDead + 1
						end
					end
				end
			end

		print ("NUM_GOOD_PLAYERS: " .. NUM_GOOD_PLAYERS .. " -- good dead: " .. goodDead)
		print ("NUM_BAD_PLAYERS: " .. NUM_BAD_PLAYERS .. " -- bad dead: " .. badDead)
		if goodDead == NUM_GOOD_PLAYERS and killedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS and NUM_GOOD_PLAYERS>1 then
			CBattleship8D:quickSpawn("north","right", "four", 1, CREEP_NUM_HUGE+1)
			CBattleship8D:quickSpawn("north","left", "four", 1, CREEP_NUM_HUGE+1)
			GameRules:SendCustomMessage("<font color='#003300'> Privateers have seen all SOUTHERN capital ships fall and are seizing the opportunity to safely assist the NORTH.</font> ", DOTA_TEAM_GOODGUYS, 0)
						
		end
		if badDead == NUM_BAD_PLAYERS and killedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS and NUM_BAD_PLAYERS>1 then
			CBattleship8D:quickSpawn("south","right", "four", 1, CREEP_NUM_HUGE+1)
			CBattleship8D:quickSpawn("south","left", "four", 1, CREEP_NUM_HUGE+1)
			GameRules:SendCustomMessage("<font color='#003300'> Privateers have seen all NORTHERN capital ships fall and are seizing the opportunity to safely assist the SOUTH.</font> ", DOTA_TEAM_GOODGUYS, 0)
		end
		
		
	  end
	end
end

-- An item was purchased by a player
function CBattleship8D:OnItemPurchased( keys )
  print ( '[BAREBONES] OnItemPurchased')

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local casterUnit
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil then
            local id = hero:GetPlayerOwnerID()
            if id == plyID then
                print("Reconnecting hero for player ")
				casterUnit = hero
            end
		end
    end

	    local itemName = keys.itemname 
	  
  	if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 5, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
			if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
				local Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
				if Item ~= nil and Item:GetName() == itemName and not string.match(Item:GetName(), "wood") and not string.match(Item:GetName(), "boat") and not string.match(Item:GetName(), "bow") then -- makes sure that the item exists and making sure it is the correct item
					if Item:GetToggleState() ~= true then
						local boat=false
						
						Item:ToggleAbility()
						if boat then
							break
						end
					end
				end
			end
		end
	end

	
  
  -- The name of the item purchased
  
  print ( '[BAREBONES] Item Purchased was ' .. itemName)
  local herogold = casterUnit:GetGold()
		if string.match(itemName, "boat") then
			local casterPos = casterUnit:GetAbsOrigin()
			
			local targetUnitOne = Entities:FindByName( nil, "south_boat_shop")
			local targetUnitTwo = Entities:FindByName( nil, "north_boat_shop")
			local directionOne =  casterPos - targetUnitOne:GetAbsOrigin()
			local directionTwo =  casterPos - targetUnitTwo:GetAbsOrigin()
			
			
			if directionOne:Length() < 600 or directionTwo:Length() < 600 then
				boat=true
				sellBoat(casterUnit)
					
					if string.match(itemName,"kunkka") then
						become_boat(casterUnit, "npc_dota_hero_mirana")
					elseif string.match(itemName,"gyrocopter") then
						become_boat(casterUnit, "npc_dota_hero_terrorblade")
					elseif string.match(itemName,"brewmaster") then
						become_boat(casterUnit, "npc_dota_hero_meepo")
					elseif string.match(itemName,"tidehunter") then
						become_boat(casterUnit, "npc_dota_hero_tidehunter")
					elseif string.match(itemName,"puck") then
						become_boat(casterUnit, "npc_dota_hero_antimage")
					elseif string.match(itemName,"morphling") then
						become_boat(casterUnit, "npc_dota_hero_morphling")
					elseif string.match(itemName,"storm_spirit") then
						become_boat(casterUnit, "npc_dota_hero_puck")
					elseif string.match(itemName,"zuus") then
						become_boat(casterUnit, "npc_dota_hero_riki")
					elseif string.match(itemName,"magnus") then
						become_boat(casterUnit, "npc_dota_hero_shadow_shaman")
					elseif string.match(itemName,"jakiro") then
						become_boat(casterUnit, "npc_dota_hero_jakiro")
					elseif string.match(itemName,"lion") then
						become_boat(casterUnit, "npc_dota_hero_pudge")
					elseif string.match(itemName,"spectre") then
						become_boat(casterUnit, "npc_dota_hero_tusk")
					elseif string.match(itemName,"visage") then
						become_boat(casterUnit, "npc_dota_hero_spirit_breaker")
					elseif string.match(itemName,"nevermore") then
						become_boat(casterUnit, "npc_dota_hero_gyrocopter")
					elseif string.match(itemName,"rubick") then
						become_boat(casterUnit, "npc_dota_hero_kunkka")
					elseif string.match(itemName,"shredder") then
						become_boat(casterUnit, "npc_dota_hero_sniper")
					elseif string.match(itemName,"treant") then
						become_boat(casterUnit, "npc_dota_hero_windrunner")
					elseif string.match(itemName,"crystal") then
						become_boat(casterUnit, "npc_dota_hero_crystal_maiden")
					elseif string.match(itemName,"phantom") then
						become_boat(casterUnit, "npc_dota_hero_doom_bringer")
					elseif string.match(itemName,"wisp") then
						become_boat(casterUnit, "npc_dota_hero_batrider")
				end
		else
			GameRules:SendCustomMessage("<font color='#800000'> You need to go back to base to buy a boat. You have been refunded what you spent. </font> ", DOTA_TEAM_GOODGUYS, 0)
				
			if string.match(itemName,"kunkka") then
					casterUnit:SetGold(herogold + 3000, true)
					casterUnit:SetGold(0, false)
					 print ( '[BAREBONES] player was disruptor and got 3000')
				elseif string.match(itemName,"gyrocopter") then
					casterUnit:SetGold(herogold + 10000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was terrorblade and got 10000')
				elseif string.match(itemName,"brewmaster") then
					casterUnit:SetGold(herogold + 6000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was meepo and got 6000')
				elseif string.match(itemName,"tidehunter") then
					casterUnit:SetGold(herogold + 1000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was tidehunter and got 1000')
				elseif string.match(itemName,"puck") then
					casterUnit:SetGold(herogold + 1000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was apparition and got 1000')
				elseif string.match(itemName,"rubick") then
					casterUnit:SetGold(herogold + 1000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was rattletrap and got 1000')
				elseif string.match(itemName,"morphling") then
					casterUnit:SetGold(herogold + 3000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was morphling and got 3000')
				elseif string.match(itemName,"storm_spirit") then
					casterUnit:SetGold(herogold + 3000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was storm_spirit and got 3000')
				elseif string.match(itemName,"zuus") then
					casterUnit:SetGold(herogold + 6000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was zuus and got 10000')
				elseif string.match(itemName,"magnus") then
					casterUnit:SetGold(herogold + 6000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was shadow_shaman and got 6000')
				elseif string.match(itemName,"jakiro") then
					casterUnit:SetGold(herogold + 6000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was jakiro and got 6000')
				elseif string.match(itemName,"lion") then
					casterUnit:SetGold(herogold + 3000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was lion and got 3000')
				elseif string.match(itemName,"spectre") then
					casterUnit:SetGold(herogold + 10000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was tusk and got 10000')
				elseif string.match(itemName,"visage") then
					casterUnit:SetGold(herogold + 10000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was spirit_breaker and got 6000')
				elseif string.match(itemName,"nevermore") then
					casterUnit:SetGold(herogold + 3000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was nevermore and got 3000')
				elseif string.match(itemName,"shredder") then
					casterUnit:SetGold(herogold + 6000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was sniper and got 3000')
				elseif string.match(itemName,"treant") then
					casterUnit:SetGold(herogold + 10000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was windrunner and got 10000')
				elseif string.match(itemName,"wisp") then
					casterUnit:SetGold(herogold + 10000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was windrunner and got 10000')
				elseif string.match(itemName,"crystal") then
					casterUnit:SetGold(herogold + 1000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was windrunner and got 10000')
				elseif string.match(itemName,"phantom") then
					casterUnit:SetGold(herogold + 1000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was phantom_lancer and got 1000')
				end
				if casterUnit:IsHero() or casterUnit:HasInventory() then 
					for itemSlot = 0, 11, 1 do 
						if casterUnit ~= nil then
							local Item = casterUnit:GetItemInSlot( itemSlot )
							if Item ~= nil and string.match(Item:GetName(), "boat") then
								casterUnit:RemoveItem(Item)
							end
						end
					end
				end
		end
	end
		

	if string.match(itemName, "tower_debuff") then
		debuffTowers(casterUnit, itemName)
	end
	if string.match(itemName, "tower_healer") then
		healTowers(casterUnit, itemName)
	end
	if string.match(itemName, "nut_spawner") then
		spawnNuts(casterUnit, itemName)
	end
	
	if GameRules:GetGameTime() < 300 and  string.match(itemName, "lorne") then
		LORNE_ITEM_BUYERS = LORNE_ITEM_BUYERS + 1
		
	end
	if LORNE_ITEM_BUYERS == NUM_PLAYERS and NUM_PLAYERS ~= 0 then
		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			if hero ~= nil and hero:IsOwnedByAnyPlayer() then
				hero:SetGold(80000, true)
				hero:AddExperience(80000, true,false)
				
			end
		end
	end
	


	
 
end


function become_boat(casterUnit, heroname)
    print('[ItemFunctions] become_bristleback started!')
    local a = 0
    local plyID = casterUnit:GetPlayerOwnerID()
    local itemlist = {}
    if casterUnit:IsHero() or casterUnit:HasInventory() then 
    	for itemSlot = 0, 11, 1 do 
            if casterUnit ~= nil then
                local Item = casterUnit:GetItemInSlot( itemSlot )
				
				if Item ~= nil and not string.match(Item:GetName(), "boat") then
					print("Item in slot is: " .. Item:GetName())
					itemlist[itemSlot] = Item:GetName()
					
				elseif Item ~= nil and string.match(Item:GetName(), "boat") then
					print("Item in slot is: filler")
					itemlist[itemSlot] = "item_fluff"
				
				else
					print("Item in slot is: filler")
					itemlist[itemSlot] = "item_fluff"
					
				end
				if itemSlot>5 and Item ~= nil then
					casterUnit:EjectItemFromStash(Item)
					GameRules:SendCustomMessage("<font color='#800000'> This is a workaround for items in the stash dissaparing. I have ejected the item and it should be on the ground. sorry. </font> ", DOTA_TEAM_GOODGUYS, 0)
				
				end
				
				
				
            end
		end
    end
	if heroname ~= casterUnit:GetName() then
			local gold = casterUnit:GetGold()
			local xp = casterUnit:GetCurrentXP()
			PlayerResource:ReplaceHeroWith( casterUnit:GetPlayerID(), heroname , 0, 0 )
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil then
					local id = hero:GetPlayerOwnerID()
					RemoveWearables( hero )
					if id == plyID then
						print("this is the new hero, put items in " .. hero:GetName())
						hero:SetGold(gold, true)
						hero:SetGold(0, false)
						hero:AddExperience(xp, false, false)
						for b = 0, 5, 1 do 
							local newItem = CreateItem(itemlist[b], hero, hero)
							if newItem ~= nil then                   -- makes sure that the item exists and making sure it is the correct item
								print("Item Is: " .. newItem:GetName() )
								hero:AddItem(newItem)
							end
						end
						if hero:IsHero() or hero:HasInventory() then 
							for itemSlot = 0, 11, 1 do 
								if hero ~= nil then
									local activateItem = hero:GetItemInSlot( itemSlot )
									if activateItem ~= nil and string.match(activateItem:GetName(), "bow") then
										print("activating " .. activateItem:GetName())
										activateItem:ToggleAbility()
										
									elseif activateItem ~= nil and string.match(activateItem:GetName(), "fluff") then
										print("Item in slot is: filler")
										activateItem:ToggleAbility()
									end
								end
							end
						end
					end
				end
			end
		
		else
			 if casterUnit:IsHero() or casterUnit:HasInventory() then 
			for itemSlot = 0, 11, 1 do 
				if casterUnit ~= nil then
					local Item = casterUnit:GetItemInSlot( itemSlot )
					
					if Item ~= nil and  string.match(Item:GetName(), "boat") then
						casterUnit:RemoveItem(Item)
					end
				end
			end
		end
		
	end
	
end



function debuffTowers(casterUnit, itemName)
print('[ItemFunctions] dubuffTower started!')
	if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		SPYS_SOUTH = SPYS_SOUTH + 1
	elseif  casterUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		SPYS_NORTH = SPYS_NORTH + 1
	end
	SPY_ANNOUNCMENT_FLAG = 1
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
				 print('[ItemFunctions] dubuffTower found a tower!')
				local curArmor = curTower:GetPhysicalArmorBaseValue()
				if curTower ~= nil and curTower:IsTower() then
				print('[ItemFunctions] dubuffTower really found a tower! cur armor is' .. curArmor)
					if curTower:GetTeamNumber() ~=  casterUnit:GetTeamNumber()  then
						curTower:SetPhysicalArmorBaseValue(curArmor-1.0)
						print('[ItemFunctions] dubuffTower found an enamy tower.  new armor is' .. curArmor-1.0)
					end
				end
			
	end
end
function healTowers(casterUnit, itemName)
print('[ItemFunctions] healTowers started!')
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
function spawnNuts(casterUnit, itemName)
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
	local spawnLocation = Entities:FindByName( nil, "nut_spawn_south_left")
        local waypointlocation = Entities:FindByName ( nil,  "nut_wp_left_1")
        local i = 0
        while  2>i do
					creature = CreateUnitByName( "npc_dota_boat_south_four" , spawnLocation:GetAbsOrigin() + Vector(-300 + i * 100,0,0), true, nil, nil, 4 )
                creature:SetInitialGoalEntity( waypointlocation )
				--creature:CreatureLevelUp(level)
                i = i + 1
        end
		 spawnLocation = Entities:FindByName( nil, "nut_spawn_north_left")
         waypointlocation = Entities:FindByName ( nil,  "nut_wp_left_1")
         i = 0
        while  2>i do
					creature = CreateUnitByName( "npc_dota_boat_south_four" , spawnLocation:GetAbsOrigin() + Vector(-300 + i * 100,0,0), true, nil, nil, 4 )
                creature:SetInitialGoalEntity( waypointlocation )
				--creature:CreatureLevelUp(level)
                i = i + 1
        end
		local spawnLocation = Entities:FindByName( nil, "nut_spawn_south_right")
        local waypointlocation = Entities:FindByName ( nil,  "nut_wp_right_1")
		while  2>i do
					creature = CreateUnitByName( "npc_dota_boat_south_four" , spawnLocation:GetAbsOrigin() + Vector(-300 + i * 100,0,0), true, nil, nil, 4 )
                creature:SetInitialGoalEntity( waypointlocation )
				--creature:CreatureLevelUp(level)
                i = i + 1
        end
		 spawnLocation = Entities:FindByName( nil, "nut_spawn_north_right")
         waypointlocation = Entities:FindByName ( nil,  "nut_wp_right_1")
         i = 0
        while  2>i do
					creature = CreateUnitByName( "npc_dota_boat_south_four" , spawnLocation:GetAbsOrigin() + Vector(-300 + i * 100,0,0), true, nil, nil, 4 )
                creature:SetInitialGoalEntity( waypointlocation )
				--creature:CreatureLevelUp(level)
                i = i + 1
        end

end



function spawnTide()
 spawnLocation = Entities:FindByName( nil, "tide_spawn")
         i = 0
        while  1>i do
					creature = CreateUnitByName( "npc_dota_creature_tidehunter" , spawnLocation:GetAbsOrigin() + Vector(-300 + i * 100,0,0), true, nil, nil, 4 )
				creature:CreatureLevelUp(TIDE_LEVEL)
                i = i + 1
        end
		GameRules:SendCustomMessage("<font color='#800000'> TIDEHUNTER ROAMS THE SEAS! </font> ", DOTA_TEAM_GOODGUYS, 0)
			
end



function RemoveWearables( hero )
      -- Setup variables
	  Timers:CreateTimer( 0.1, function()
      local model_name = ""

      -- Check if npc is hero
      if not hero:IsHero() then return end

      -- Getting model name
      if model_lookup[ hero:GetName() ] ~= nil and hero:GetModelName() ~= model_lookup[ hero:GetName() ] then
        model_name = model_lookup[ hero:GetName() ]
      else
        return nil
      end

      -- Never got changed before
      local toRemove = {}
      local wearable = hero:FirstMoveChild()
      while wearable ~= nil do
        if wearable:GetClassname() == "dota_item_wearable" then
          table.insert( toRemove, wearable )
        end
        wearable = wearable:NextMovePeer()
      end

      -- Remove wearables
      for k, v in pairs( toRemove ) do
        --v:SetModel( "models/development/invisiblebox.vmdl" )
        v:RemoveSelf()
      end
	
      -- Set model
      hero:SetModel( model_name )
      hero:SetOriginalModel( model_name )
      hero:MoveToPosition( hero:GetAbsOrigin() )
	  end
	  )
end




function CBattleship8D:UnstickPlayer( player, p)
    --NOTE: p contains our parameter (the '1') now (as a string not a number), we just don't use it
    
    
    --get the player's ID
    local pID = player:GetPlayerID()
    for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			print("unsticking" .. hero:GetName())
			local herogold = hero:GetGold()
			if herogold>0 then
				if hero:GetOwner():GetPlayerID() == pID then
					if false == hero:HasModifier("pergatory_3") then
						local direction =  hero:GetForwardVector()
						local vec = direction:Normalized() * 31.0
						local vecorig = hero:GetOrigin()
						hero:SetOrigin(vecorig+vec)
					end
					local item = CreateItem( "item_spawn_stunner", hero, hero)
					item:ApplyDataDrivenModifier(hero, hero, "pergatory_3", nil)
					hero:RemoveItem(item)
				end
			end
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


function stopPhysics(casterUnit) -- keys is the information sent by the ability

        local direction =  casterUnit:GetForwardVector()
        local vec = direction:Normalized() * 0.0
		
		Physics:Unit(casterUnit)
		
		casterUnit:SetPhysicsAcceleration(vec)

end


