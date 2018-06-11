-- Generated from template

require("libraries/timers")
require('libraries/physics')
require('notifications')
require('storage')
require('StatCollection/init')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')



if CBattleship8D == nil then
	CBattleship8D = class({})
end

-- global variable fun!!!

--tracksif a hero needs a shop to auto open or close
g_WasNearShop={}
g_XpToLevel={
200,
300,
400,
400,
500,
600,
600,
600,
1200,
600,
1000,
2200,
800,
1400,
1500,
1600,
1700,
1800,
1900,
2000,
2100,
2200,
2300,
2400,
2500,
100000
}

-- creep spawn and level counters
g_CreepLevel = 0
g_NumSmallCreeps = 6
g_NumBigCreeps = 3
g_NumHugeCreeps = 2
g_NumPrivCreeps = 1
g_EmpireGoldCount = 1


-- coopertive mode varialves
g_CoOpMode=0
g_CoOpHeroCount = 0
g_CoOpDiffLevel=1
g_CoOpDiffSetting=0
g_CoOpItemPool={}
g_CoOpUnitPool={}

-- battle mode variables
g_BattleMode=0
g_BattleModeNumberNorth=1
g_BattleModeNumberSouth=1
g_BattleModeNorthScore=0
g_BattleModeSouthScore=0
g_BattleModeTimer=120
g_BattleModeRemaining=0
g_BattleModeLocation=0

g_TugMode=0

-- trade mode variables
g_TradeMode=0

-- set to 1 if you are testing and want to make jimmydorry happy
g_StatCollectionEnabled=0

-- a running tally of the total gold collected by each team
g_TotalGoldCollectedByNorth = 0
g_TotalGoldCollectedBySouth = 0

-- flag to nout put newly purchased boats into pergitory
g_BoatJustBaught=0

-- ceat item counter
g_LorneItemBuyers = 0

--	player counter
g_PlayerCount = 0

-- this is like red hot, i put this shit on everything it tracks how farinto the game we are
g_MainTimerTickCount = 1

-- current constant gold income for each player on the named team
g_GoldPerTickNorth = 3
g_GoldPerTickSouth = 3

-- used for empire gold change and to end the game
g_DockAliveNorthLeft = 1
g_DockAliveNorthRight = 1
g_DockAliveSouthLeft = 1
g_DockAliveSouthRight = 1

-- this was to fix some bugs with pausing or some shit, iot like resets the tick counter if stuff goes weird i think
g_PreviousTickCount=0

-- spy vairables (keeps track of team dearmors)
g_SpyAnnouncmentFlag = 0
g_SpyCountNorth = 0
g_SpyCountSouth = 0

-- player coutns for each team
g_PlayerCountSouth = 0
g_PlayerCountNorth = 0

g_TidehunterLevel = 0

g_TicksSinceEmpireGold = 0


g_EmpGoldArray={}

g_tideKillerArray={}

g_HeroKills = {}
g_HeroHP = {}
g_PlayerIdsToNames = {}

-- when a creep cant find where to go it gets put in this array and sent to attack the enamy spawn point
g_ConfusedCreeps={}

-- handle disconnects
g_IsHeroDisconnected = {}
g_DisconnectTime = {}
g_DisconnectKicked = {}

-- these make the unstick button work most of the time
g_OldHeroLocations = {}
g_OlderHeroLocations ={}

-- this replaces dotas default gold tracking.
g_HeroGoldArray={}



-- this shit is all for stat tracking.  we can look at recent games to check item builds and see what items are most popular
g_ItemCodeLookUp={}
g_ItemCodeLookUp["item_hull_sail_one_combo_bow"] = "XX"
g_ItemCodeLookUp["item_coal_bow"] = "CO"
g_ItemCodeLookUp["item_fire_bow"] = "FO"
g_ItemCodeLookUp["item_plasma_bow"] = "PO"
g_ItemCodeLookUp["item_poison_bow"] = "OO"
g_ItemCodeLookUp["item_light_bow"] = "LO"
g_ItemCodeLookUp["item_ice_bow"] = "IO"
g_ItemCodeLookUp["item_wind_bow"] = "WO"
g_ItemCodeLookUp["item_caulk_bow"] = "LO"
g_ItemCodeLookUp["item_spin_bow"] = "SO"
g_ItemCodeLookUp["item_chaos_bow"] = "KO"
g_ItemCodeLookUp["item_breach_bow"] = "BO"

g_ItemCodeLookUp["item_coal_two_bow"] = "CT"
g_ItemCodeLookUp["item_fire_two_bow"] = "FT"
g_ItemCodeLookUp["item_plasma_two_bow"] = "PT"
g_ItemCodeLookUp["item_poison_two_bow"] = "OT"
g_ItemCodeLookUp["item_light_two_bow"] = "LT"
g_ItemCodeLookUp["item_ice_two_bow"] = "IT"
g_ItemCodeLookUp["item_wind_two_bow"] = "WT"
g_ItemCodeLookUp["item_caulk_two_bow"] = "LT"
g_ItemCodeLookUp["item_spin_two_bow"] = "ST"
g_ItemCodeLookUp["item_chaos_two_bow"] = "KT"
g_ItemCodeLookUp["item_breach_two_bow"] = "BT"

g_ItemCodeLookUp["item_coal_three_bow"] = "CH"
g_ItemCodeLookUp["item_fire_three_bow"] = "FH"
g_ItemCodeLookUp["item_plasma_three_bow"] = "PH"
g_ItemCodeLookUp["item_poison_three_bow"] = "OH"
g_ItemCodeLookUp["item_light_three_bow"] = "LH"
g_ItemCodeLookUp["item_ice_three_bow"] = "IH"
g_ItemCodeLookUp["item_wind_three_bow"] = "WH"
g_ItemCodeLookUp["item_caulk_three_bow"] = "LH"
g_ItemCodeLookUp["item_spin_three_bow"] = "SH"
g_ItemCodeLookUp["item_chaos_three_bow"] = "KH"
g_ItemCodeLookUp["item_breac_threeh_bow"] = "BH"

g_ItemCodeLookUp["item_recipe_coal_ult_bow"] = "CU"

g_ItemCodeLookUp["item_recipe_fire_ult_bow"] = "FU"
g_ItemCodeLookUp["item_recipe_plasma_ult_bow"] = "PU"
g_ItemCodeLookUp["item_recipe_poison_ult_bow"] = "OU"
g_ItemCodeLookUp["item_recipe_light_ult_bow"] = "LU"
g_ItemCodeLookUp["item_recipe_ice_ult_bow"] = "IU"
g_ItemCodeLookUp["item_recipe_wind_ult_bow"] = "WU"
g_ItemCodeLookUp["item_recipe_caulk_ult_bow"] = "LU"
g_ItemCodeLookUp["item_recipe_spin_ult_bow"] = "SU"
g_ItemCodeLookUp["item_recipe_chaos_ult_bow"] = "KU"
g_ItemCodeLookUp["item_recipe_breach_ult_bow"] = "BU"

g_ItemCodeLookUp["item_fire_ult_bow"] = "FU"
g_ItemCodeLookUp["item_plasma_ult_bow"] = "PU"
g_ItemCodeLookUp["item_poison_ult_bow"] = "OU"
g_ItemCodeLookUp["item_light_ult_bow"] = "LU"
g_ItemCodeLookUp["item_ice_ult_bow"] = "IU"
g_ItemCodeLookUp["item_wind_ult_bow"] = "WU"
g_ItemCodeLookUp["item_caulk_ult_bow"] = "LU"
g_ItemCodeLookUp["item_spin_ult_bow"] = "SU"
g_ItemCodeLookUp["item_chaos_ult_bow"] = "KU"
g_ItemCodeLookUp["item_breach_ult_bow"] = "BU"

g_ItemCodeLookUp["item_hull_one"] = "HO"
g_ItemCodeLookUp["item_hull_two"] = "HT"
g_ItemCodeLookUp["item_hull_three"] = "HH"
g_ItemCodeLookUp["item_hull_four"] = "HF"
g_ItemCodeLookUp["item_sail_one"] = "SU"
g_ItemCodeLookUp["item_sail_two"] = "SO"
g_ItemCodeLookUp["item_sail_three"] = "ST"
g_ItemCodeLookUp["item_sail_four"] = "SH"
g_ItemCodeLookUp["item_repair_one"] = "RF"
g_ItemCodeLookUp["item_repair_two"] = "RU"
g_ItemCodeLookUp["item_repair_three"] = "RO"
g_ItemCodeLookUp["item_repair_four"] = "RT"
g_ItemCodeLookUp["item_wood_one"] = "DH"
g_ItemCodeLookUp["item_wood_two"] = "DF"
g_ItemCodeLookUp["item_wood_three"] = "DU"
g_ItemCodeLookUp["item_wood_four"] = "DO"

g_ItemCodeLookUp["item_tower_debuff"] = "EG"
g_ItemCodeLookUp["item_tower_healer"] = "EB"
g_ItemCodeLookUp["item_nut_spawner"] = "EN"



g_ItemCodeLookUp["item_puck_replacement_boat"] = "BZ"
--Zodiac
g_ItemCodeLookUp["item_rubick_replacement_boat"] = "BC"
--Catamaran
g_ItemCodeLookUp["item_tidehunter_replacement_boat"] = "BP"
--Pontoon
g_ItemCodeLookUp["item_phantom_lancer_replacement_boat"] = "BA"
--Airboat
g_ItemCodeLookUp["item_morphling_replacement_boat"] = "BS"
--Speedboat
g_ItemCodeLookUp["item_nevermore_replacement_boat"] = "BL"
--Plane
g_ItemCodeLookUp["item_kunkka_replacement_boat"] = "BH"
--Shore Guard
g_ItemCodeLookUp["item_zuus_replacement_boat"] = "BT"
--Tug Boat
g_ItemCodeLookUp["item_brewmaster_replacement_boat"] = "BH"
--Houseboat
g_ItemCodeLookUp["item_magnus_replacement_boat"] = "BV"
--Viking
g_ItemCodeLookUp["item_jakiro_replacement_boat"] = "BG"
--Galleon
g_ItemCodeLookUp["item_shredder_replacement_boat"] = "BU"
--Submarine
g_ItemCodeLookUp["item_treant_replacement_boat"] = "BO"
--Construction
g_ItemCodeLookUp["item_spectre_replacement_boat"] = "BB"
--Battleship
g_ItemCodeLookUp["item_visage_replacement_boat"] = "BN"
--Noah's Ark
g_ItemCodeLookUp["item_wisp_replacement_boat"] = "BI"
--Icebreaker
g_ItemCodeLookUp["item_gyrocopter_replacement_boat"] = "BR"
--Aircraft Carrier
g_ItemCodeLookUp["item_lion_replacement_boat"] = "BY"
--Yacht
g_ItemCodeLookUp["item_crystal_maiden_replacement_boat"] = "BN"
--Canoe
g_ItemCodeLookUp["item_storm_spirit_replacement_boat"] = "BJ"
--Junk
g_ItemCodeLookUp["npc_dota_hero_brewmaster"] = "BK"
--riveer
g_heroCache = {}

-- this is for if we need to swap a unit model 
g_ModelLookUp = {}
g_ModelLookUp["npc_dota_hero_zuus"] = "models/barrel_boat.vmdl"
g_ModelLookUp["npc_dota_hero_ancient_apparition"] = "models/zodiac/sm_zodiac.vmdl"
g_ModelLookUp["npc_dota_hero_tidehunter"] = "models/pontoon_boat.vmdl"
g_ModelLookUp["npc_dota_hero_crystal_maiden"] = "models/canoe_boat.vmdl"
g_ModelLookUp["npc_dota_hero_phantom_lancer"] = "models/air_boat.vmdl"
g_ModelLookUp["npc_dota_hero_rattletrap"] = "models/cat_boat.vmdl"
g_ModelLookUp["npc_dota_hero_batrider"] = "models/dinghy_boat.vmdl"
g_ModelLookUp["npc_dota_hero_jakiro"] = "models/galleon_boat.vmdl"
g_ModelLookUp["npc_dota_hero_nevermore"] = "models/plane_boat.vmdl"
g_ModelLookUp["npc_dota_hero_meepo"] = "models/house_boat.vmdl"
g_ModelLookUp["npc_dota_hero_disruptor"] = "models/coast_boat.vmdl"
g_ModelLookUp["npc_dota_hero_morphling"] = "models/speed_boat.vmdl"
g_ModelLookUp["npc_dota_hero_storm_spirit"] = "models/junk_boat.vmdl"
g_ModelLookUp["npc_dota_hero_brewmaster"] = "models/river_boat.vmdl"
g_ModelLookUp["npc_dota_hero_lion"] = "models/yacht_boat.vmdl"
g_ModelLookUp["npc_dota_hero_ember_spirit"] = "models/tug_boat.vmdl"
g_ModelLookUp["npc_dota_hero_slark"] = "models/viking_boat.vmdl"
g_ModelLookUp["npc_dota_hero_sniper"] = "models/sub_boat.vmdl"
g_ModelLookUp["npc_dota_hero_visage"] = "models/noah_boat.vmdl"
g_ModelLookUp["npc_dota_hero_ursa"] = "models/Aircraft_boat.vmdl"
g_ModelLookUp["npc_dota_hero_pugna"] = "models/ice_boat.vmdl"
g_ModelLookUp["npc_dota_hero_razor"] = "models/stormchaser_boat.vmdl"

g_ModelLookUp["npc_dota_hero_windrunner"] = "models/const_boat.vmdl"
g_ModelLookUp["npc_dota_hero_tusk"] = "models/battleship_boat0.vmdl"
g_ModelLookUp["npc_dota_hero_vengefulspirit"] = "models/trade_one_boat.vmdl"
g_ModelLookUp["npc_dota_hero_bane"] = "models/trade_boat_two.vmdl"
g_ModelLookUp["npc_dota_hero_enigma"] = "models/trade_three_boat.vmdl"



g_EasyMissionsNorth={}
g_HardMissionsNorth={}
g_EasyMissionsSouth={}
g_HardMissionsSouth={}

function Precache( context )
		for ind = 0, 11, 1 do 
			g_IsHeroDisconnected[ind] = 0 
			g_DisconnectTime[ind] = 0 
			g_DisconnectKicked[ind] = 0
			 g_HeroKills[ind] = 0
				  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
		end
	for ind = 0, 20, 1 do 
		g_PlayerIdsToNames[ind]=0;
	end

-- 	for k, v in pairs( g_ModelLookUp ) do
--     PrecacheResource( "model", v, context )
--   end
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
	PrecacheResource( "model", "models/battle_ind.vmdl", context )
	PrecacheResource( "model", "models/battle_ind", context )
	PrecacheResource( "model", "models/bad_ancient_ambient_blast", context )
	PrecacheResource( "model", "models/heroes/tidehunter/tidehunter.vmdl", context )
	
	
	PrecacheResource( "model", "models/spin_one", context )
	PrecacheResource( "model", "models/spin_two", context )
		
	PrecacheResource( "model", "models/spin_three", context )
	
	PrecacheResource( "model", "models/no_model", context )
	PrecacheResource( "model", "models/monkey", context )
	

	
	PrecacheResource( "model", "models/jet.vmdl", context )
	PrecacheResource( "model", "models/iceberg.vmdl", context )
	PrecacheResource( "model", "models/building_north_tower.vmdl", context )
	PrecacheResource( "model", "models/building_south_tower.vmdl", context )
	
	PrecacheResource( "materials", "materials/", context )
	-- PrecacheUnitByNameSync("npc_dota_hero_abaddon", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_zuus", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_tiny", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_kunkka", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_bane", context)
	
	-- PrecacheUnitByNameSync("npc_dota_hero_vengefulspirit", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_brewmaster", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_puck", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_tidehunter", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_jakiro", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_sniper", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_meepo", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_pudge", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_morphling", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_spirit_breaker", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_batrider", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_pugna", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_gyrocopter", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_magnataur", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_ursa", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_meepo", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_disruptor", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_winter_wyvern", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_lion", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_alchemist", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_invoker", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_doom_bringer", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_lycan", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_visage", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_nevermore", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_slark", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_naga_siren", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_chen", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_rubick", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_mirana", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_windrunner", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_rattletrap", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_batrider", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_antimage", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_riki", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_shredder", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_silencer", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_treant", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_bane", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_lone_druid", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_shadow_shaman", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_crystal_maiden", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_phantom_lancer", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_storm_spirit", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_ember_spirit", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_wisp", context)


	PrecacheUnitByNameSync("npc_dota_vision_granter", context)
		 
	PrecacheUnitByNameSync( "npc_dota_boat_south_one", context )
	PrecacheUnitByNameSync( "npc_dota_boat_south_two", context )
	PrecacheUnitByNameSync( "npc_dota_boat_south_three", context )
	PrecacheUnitByNameSync( "npc_dota_boat_north_three", context )
	
	PrecacheUnitByNameSync( "npc_dota_battle_ind", context )
	
	PrecacheUnitByNameSync( "npc_dota_boat_south_four", context )
	PrecacheUnitByNameSync( "npc_dota_boat_north_one", context )
	PrecacheUnitByNameSync( "npc_dota_boat_north_two", context )
	PrecacheUnitByNameSync( "npc_dota_air_craft", context )
	PrecacheUnitByNameSync( "npc_dota_air_craft_bomber", context )
	PrecacheUnitByNameSync( "npc_dota_boat_pleasure_craft", context )
	PrecacheResource( "model", "models/courier/donkey_unicorn/donkey_unicorn.vmdl", context )
	PrecacheResource( "model", "models/courier/donkey_unicorn/donkey_unicorn.vmdyl", context )
	
	PrecacheResource( "model", "models/courier/sw_donkey/sw_donkey.vmdl", context )
	PrecacheResource( "model", "models/items/courier/jumo/jumo.vmdl", context )
	PrecacheResource( "model", "models/heroes/shopkeeper/shopkeeper.vmdl", context )

	PrecacheResource( "model", "models/items/courier/blotto_and_stick/blotto.vmdl", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_puck.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_viper.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_bane.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_vengefulspirit.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_disruptor.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context )

	
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_techies.vsndevts", context )

	PrecacheResource( "soundfile","soundevents/game_sounds_items.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_tusk.vsndevts", context )
	
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_bastion.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_axe.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_lina.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_bristleback.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_stormspirit.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_workshop_pirate.vsndevts", context )
	
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_morphling.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts", context )
PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_drowranger.vsndevts", context )
	
PrecacheResource( "soundfile","soundevents/music/dsadowski_01/soundevents_music.vsndevts", context )
	PrecacheUnitByNameSync("npc_dota_shop_right_mid", context)
	PrecacheUnitByNameSync("npc_dota_shop_right_top", context)
	PrecacheUnitByNameSync("npc_dota_shop_right_bot", context)
	PrecacheUnitByNameSync("npc_dota_shop_left_mid", context)
	PrecacheUnitByNameSync("npc_dota_shop_left_top", context)
	PrecacheUnitByNameSync("npc_dota_shop_left_bot", context)
	PrecacheUnitByNameSync("npc_dota_shop_mid_mid", context)
	PrecacheUnitByNameSync("npc_dota_shop_mid_top", context)
	PrecacheUnitByNameSync("npc_dota_shop_mid_bot", context)
	PrecacheUnitByNameSync("npc_dota_trap", context)
	PrecacheUnitByNameSync("npc_dota_chain", context)
	PrecacheUnitByNameSync("npc_dota_booey", context)
	
	PrecacheResource( "soundfile","soundevents/custom_sounds.vsndevts", context )
	
end
				


-- Create the game mode when we activate
function Activate()
	GameRules.battleship = CBattleship8D()
	GameRules.battleship:InitGameMode()
end



function CBattleship8D:InitGameMode()
	self.vUserIds = {}
	 --print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(CBattleship8D, "FilterModifyGold"), self)
	
	--register the 'UnstickMe' command in our console
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( CBattleship8D, "OrderExecutionFilter" ), self )
	
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( CBattleship8D, "BountyRuneFilter" ), self )
	
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled(true)
	GameRules:SetUseBaseGoldBountyOnHeroes(true)
	GameRules:SetSameHeroSelectionEnabled(true)
	
	SendToServerConsole( "dota_combine_models 0" ) 
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(CBattleship8D, 'OnItemPurchased'), self)

	GameRules:GetGameModeEntity():SetRuneSpawnFilter( Dynamic_Wrap( CBattleship8D, "FilterRuneSpawn" ), self )
	
	ListenToGameEvent('entity_killed', Dynamic_Wrap(CBattleship8D, 'OnEntityKilled'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CBattleship8D, 'OnNPCSpawned'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(CBattleship8D, 'OnConnectFull'), self)
 	ListenToGameEvent('player_disconnect', Dynamic_Wrap(CBattleship8D, 'OnDisconnect'), self)
	 ListenToGameEvent('player_chat', Dynamic_Wrap(CBattleship8D, 'OnPlayerChat'), self)
  
	CustomGameEventManager:RegisterListener("GiveEasy", GiveEasy);
	CustomGameEventManager:RegisterListener("GiveMedium", GiveMedium);
	CustomGameEventManager:RegisterListener("buyItem", buyItem);
	CustomGameEventManager:RegisterListener("DiffSelection", ChooseDiff);
	CustomGameEventManager:RegisterListener("buyBoat", buyBoat);
	
	CustomGameEventManager:RegisterListener("BattleMode", battleMode);
	CustomGameEventManager:RegisterListener("TugMode", tugmode);
	CustomGameEventManager:RegisterListener("TradeMode", tradeMode);
	CustomGameEventManager:RegisterListener("Activate_Co_Op", ActivateCoOp);
	
	CustomGameEventManager:RegisterListener("Unstick", UnstickPlayer);
	
  mode = GameRules:GetGameModeEntity()
mode:SetHUDVisible(12, false)
  
  
  
  
g_EasyMissionsNorth["npc_dota_shop_left_bot"]={}
g_EasyMissionsNorth["npc_dota_shop_right_bot"]={}
g_EasyMissionsNorth["npc_dota_shop_right_mid"]={}
g_EasyMissionsNorth["npc_dota_shop_left_mid"]={}
g_EasyMissionsNorth["npc_dota_shop_left_top"]={}
g_EasyMissionsNorth["npc_dota_shop_mid_bot"]={}
g_EasyMissionsNorth["npc_dota_shop_mid_mid"]={}
g_EasyMissionsNorth["npc_dota_shop_mid_top"]={}
g_EasyMissionsNorth["npc_dota_shop_right_top"]={}
g_HardMissionsNorth["npc_dota_shop_left_bot"]={}
g_HardMissionsNorth["npc_dota_shop_right_bot"]={}
g_HardMissionsNorth["npc_dota_shop_right_mid"]={}
g_HardMissionsNorth["npc_dota_shop_left_mid"]={}
g_HardMissionsNorth["npc_dota_shop_left_top"]={}
g_HardMissionsNorth["npc_dota_shop_mid_bot"]={}
g_HardMissionsNorth["npc_dota_shop_mid_mid"]={}
g_HardMissionsNorth["npc_dota_shop_mid_top"]={}
g_HardMissionsNorth["npc_dota_shop_right_top"]={}
g_EasyMissionsSouth["npc_dota_shop_left_bot"]={}
g_EasyMissionsSouth["npc_dota_shop_right_bot"]={}
g_EasyMissionsSouth["npc_dota_shop_right_mid"]={}
g_EasyMissionsSouth["npc_dota_shop_left_mid"]={}
g_EasyMissionsSouth["npc_dota_shop_left_top"]={}
g_EasyMissionsSouth["npc_dota_shop_mid_bot"]={}
g_EasyMissionsSouth["npc_dota_shop_mid_mid"]={}
g_EasyMissionsSouth["npc_dota_shop_mid_top"]={}
g_EasyMissionsSouth["npc_dota_shop_right_top"]={}
g_HardMissionsSouth["npc_dota_shop_left_bot"]={}
g_HardMissionsSouth["npc_dota_shop_right_bot"]={}
g_HardMissionsSouth["npc_dota_shop_right_mid"]={}
g_HardMissionsSouth["npc_dota_shop_left_mid"]={}
g_HardMissionsSouth["npc_dota_shop_left_top"]={}
g_HardMissionsSouth["npc_dota_shop_mid_bot"]={}
g_HardMissionsSouth["npc_dota_shop_mid_mid"]={}
g_HardMissionsSouth["npc_dota_shop_mid_top"]={}
g_HardMissionsSouth["npc_dota_shop_right_top"]={}

table.insert(g_EasyMissionsNorth["npc_dota_shop_left_top"], "item_contract_easy_left_mid")
table.insert(g_EasyMissionsNorth["npc_dota_shop_left_top"], "item_contract_easy_mid_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_left_top"], "item_contract_easy_right_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_easy_mid_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_left_mid"], "item_contract_easy_left_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_mid_top"], "item_contract_easy_left_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_mid_top"], "item_contract_easy_left_mid")
table.insert(g_EasyMissionsNorth["npc_dota_shop_mid_top"], "item_contract_easy_right_mid")
table.insert(g_EasyMissionsNorth["npc_dota_shop_mid_top"], "item_contract_easy_right_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_right_mid"], "item_contract_easy_right_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_right_top"], "item_contract_easy_left_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_right_top"], "item_contract_easy_mid_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_right_top"], "item_contract_easy_right_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_top"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_top"], "item_contract_hard_right_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_top"], "item_contract_hard_right_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_top"], "item_contract_hard_mid_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_hard_left_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_hard_right_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_hard_mid_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_mid"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_mid"], "item_contract_hard_right_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_mid"], "item_contract_hard_right_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_mid"], "item_contract_hard_mid_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_mid"], "item_contract_hard_right_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_bot"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_bot"], "item_contract_hard_right_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_bot"], "item_contract_hard_right_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_bot"], "item_contract_hard_mid_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_bot"], "item_contract_hard_right_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_top"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_top"], "item_contract_hard_left_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_top"], "item_contract_hard_right_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_top"], "item_contract_hard_mid_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_mid"], "item_contract_hard_left_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_mid"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_mid"], "item_contract_hard_left_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_mid"], "item_contract_hard_left_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_mid"], "item_contract_hard_mid_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_bot"], "item_contract_hard_left_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_bot"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_bot"], "item_contract_hard_left_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_bot"], "item_contract_hard_left_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_bot"], "item_contract_hard_mid_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_bot"], "item_contract_hard_left_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_bot"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_bot"], "item_contract_hard_left_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_bot"], "item_contract_hard_mid_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_bot"], "item_contract_hard_right_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_bot"], "item_contract_hard_right_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_top"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_top"], "item_contract_hard_left_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_top"], "item_contract_hard_left_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_top"], "item_contract_hard_mid_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_top"], "item_contract_medium_left_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_medium_left_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_medium_left_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_medium_right_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_medium_right_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_mid"], "item_contract_medium_left_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_mid"], "item_contract_medium_mid_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_bot"], "item_contract_medium_left_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_bot"], "item_contract_medium_left_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_left_bot"], "item_contract_medium_mid_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_mid"], "item_contract_medium_mid_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_mid"], "item_contract_medium_right_bot")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_bot"], "item_contract_medium_mid_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_bot"], "item_contract_medium_right_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_bot"], "item_contract_medium_right_top")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_bot"], "item_contract_medium_left_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_mid_bot"], "item_contract_medium_right_mid")
table.insert(g_HardMissionsNorth["npc_dota_shop_right_top"], "item_contract_medium_right_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_easy_mid_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_left_mid"], "item_contract_easy_left_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_left_bot"], "item_contract_easy_left_mid")
table.insert(g_EasyMissionsSouth["npc_dota_shop_left_bot"], "item_contract_easy_right_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_left_bot"], "item_contract_easy_mid_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_right_mid"], "item_contract_easy_right_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_right_bot"], "item_contract_easy_left_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_right_bot"], "item_contract_easy_right_mid")
table.insert(g_EasyMissionsSouth["npc_dota_shop_right_bot"], "item_contract_easy_mid_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_mid_bot"], "item_contract_easy_left_mid")
table.insert(g_EasyMissionsSouth["npc_dota_shop_mid_bot"], "item_contract_easy_left_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_mid_bot"], "item_contract_easy_right_mid")
table.insert(g_EasyMissionsSouth["npc_dota_shop_mid_bot"], "item_contract_easy_right_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_top"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_top"], "item_contract_hard_mid_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_top"], "item_contract_hard_right_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_top"], "item_contract_hard_right_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_top"], "item_contract_hard_right_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_hard_left_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_hard_mid_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_hard_right_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_mid"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_mid"], "item_contract_hard_mid_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_mid"], "item_contract_hard_right_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_mid"], "item_contract_hard_right_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_mid"], "item_contract_hard_right_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_bot"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_bot"], "item_contract_hard_mid_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_bot"], "item_contract_hard_right_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_bot"], "item_contract_hard_right_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_top"], "item_contract_hard_left_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_top"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_top"], "item_contract_hard_left_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_top"], "item_contract_hard_right_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_top"], "item_contract_hard_mid_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_top"], "item_contract_hard_right_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_mid"], "item_contract_hard_left_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_mid"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_mid"], "item_contract_hard_left_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_mid"], "item_contract_hard_left_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_mid"], "item_contract_hard_mid_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_bot"], "item_contract_hard_left_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_bot"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_bot"], "item_contract_hard_left_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_bot"], "item_contract_hard_mid_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_bot"], "item_contract_hard_left_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_bot"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_bot"], "item_contract_hard_mid_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_bot"], "item_contract_hard_right_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_top"], "item_contract_hard_left_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_top"], "item_contract_hard_mid_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_top"], "item_contract_hard_left_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_top"], "item_contract_hard_left_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_top"], "item_contract_hard_mid_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_top"], "item_contract_medium_left_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_top"], "item_contract_medium_left_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_top"], "item_contract_medium_mid_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_medium_left_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_medium_left_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_medium_right_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_medium_right_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_mid"], "item_contract_medium_left_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_mid"], "item_contract_medium_mid_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_left_bot"], "item_contract_medium_left_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_top"], "item_contract_medium_left_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_mid_top"], "item_contract_medium_right_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_mid"], "item_contract_medium_mid_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_mid"], "item_contract_medium_right_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_bot"], "item_contract_medium_right_top")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_top"], "item_contract_medium_right_mid")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_top"], "item_contract_medium_right_bot")
table.insert(g_HardMissionsSouth["npc_dota_shop_right_top"], "item_contract_medium_mid_bot")
table.insert(g_EasyMissionsNorth["npc_dota_shop_left_top"], "item_contract_medium_left_bot")
table.insert(g_EasyMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_medium_left_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_medium_left_mid")
table.insert(g_EasyMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_medium_right_mid")
table.insert(g_EasyMissionsNorth["npc_dota_shop_mid_mid"], "item_contract_medium_right_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_left_mid"], "item_contract_medium_left_bot")
table.insert(g_EasyMissionsNorth["npc_dota_shop_left_mid"], "item_contract_medium_mid_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_left_bot"], "item_contract_medium_left_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_left_bot"], "item_contract_medium_left_mid")
table.insert(g_EasyMissionsNorth["npc_dota_shop_left_bot"], "item_contract_medium_mid_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_right_mid"], "item_contract_medium_mid_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_right_mid"], "item_contract_medium_right_bot")
table.insert(g_EasyMissionsNorth["npc_dota_shop_right_bot"], "item_contract_medium_mid_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_right_bot"], "item_contract_medium_right_mid")
table.insert(g_EasyMissionsNorth["npc_dota_shop_right_bot"], "item_contract_medium_right_top")
table.insert(g_EasyMissionsNorth["npc_dota_shop_mid_bot"], "item_contract_medium_left_mid")
table.insert(g_EasyMissionsNorth["npc_dota_shop_mid_bot"], "item_contract_medium_right_mid")
table.insert(g_EasyMissionsNorth["npc_dota_shop_right_top"], "item_contract_medium_right_bot")


table.insert(g_EasyMissionsSouth["npc_dota_shop_left_top"], "item_contract_medium_left_mid")
table.insert(g_EasyMissionsSouth["npc_dota_shop_left_top"], "item_contract_medium_left_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_left_top"], "item_contract_medium_mid_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_medium_left_mid")
table.insert(g_EasyMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_medium_left_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_medium_right_mid")
table.insert(g_EasyMissionsSouth["npc_dota_shop_mid_mid"], "item_contract_medium_right_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_left_mid"], "item_contract_medium_left_top")
table.insert(g_EasyMissionsSouth["npc_dota_shop_left_mid"], "item_contract_medium_mid_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_left_bot"], "item_contract_medium_left_top")
table.insert(g_EasyMissionsSouth["npc_dota_shop_mid_top"], "item_contract_medium_left_mid")
table.insert(g_EasyMissionsSouth["npc_dota_shop_mid_top"], "item_contract_medium_right_mid")
table.insert(g_EasyMissionsSouth["npc_dota_shop_right_mid"], "item_contract_medium_mid_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_right_mid"], "item_contract_medium_right_top")
table.insert(g_EasyMissionsSouth["npc_dota_shop_right_bot"], "item_contract_medium_right_top")
table.insert(g_EasyMissionsSouth["npc_dota_shop_right_top"], "item_contract_medium_right_mid")
table.insert(g_EasyMissionsSouth["npc_dota_shop_right_top"], "item_contract_medium_right_bot")
table.insert(g_EasyMissionsSouth["npc_dota_shop_right_top"], "item_contract_medium_mid_bot")

	table.insert(g_CoOpItemPool,"item_coal_bow")
	table.insert(g_CoOpItemPool,"item_fire_bow")
	table.insert(g_CoOpItemPool,"item_plasma_bow")
	table.insert(g_CoOpItemPool,"item_poison_bow")
	table.insert(g_CoOpItemPool,"item_light_bow")
	table.insert(g_CoOpItemPool,"item_spin_bow")
	table.insert(g_CoOpItemPool,"item_ice_bow")
	table.insert(g_CoOpItemPool,"item_breach_bow")
	table.insert(g_CoOpItemPool,"item_chaos_bow")
	table.insert(g_CoOpItemPool,"item_caulk_bow")
	table.insert(g_CoOpItemPool,"item_hull_one")
	table.insert(g_CoOpItemPool,"item_sail_one")
	table.insert(g_CoOpItemPool,"item_repair_one")
	table.insert(g_CoOpUnitPool,"npc_dota_hero_zuus")

end

function CBattleship8D:FilterModifyGold(event)
    --Check if the order is the glyph type
	 --print("i'm in ModifyGoldFilter!!!!!!!!!!!!!!!!!!!")
	
    event["gold"] = 0

    --Return true by default to keep all other orders the same
    return true
end

function CBattleship8D:OnPlayerChat(keys)
	local teamonly = keys.teamonly
	print(teamonly)
	local userID = keys.userid
	local playerID = self.vUserIds[userID] and self.vUserIds[userID]:GetPlayerID()
	print("playerID" .. playerID)
	if playerID~=nil then
		steamID32 = PlayerResource:GetSteamAccountID(playerID)
		print("userID" .. steamID32)
		local text = keys.text
		if (steamID32 == 35695824 or steamID32 == 6883638 or steamID32 == 5879425 or steamID32 == 93116118) and string.match(text,"TUG MODE ACTIVATE!") and  GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			g_TugMode=1
			print("tug mode!!")
		end
		if steamID32 == 6883638 and teamonly==0 and string.match(text,"to zoom") and GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			Notifications:TopToAll({text="Thank you David!", duration=5.0, style={color="#888888",  fontSize="70px;"}})
		
		end
	end
  end

function CBattleship8D:BountyRuneFilter(filterTable)
    --Check if the order is the glyph type
	 --print("i'm in BountyRuneFilter!!!!!!!!!!!!!!!!!!!")
	
   for k, v in pairs( filterTable ) do
		 --print("rune spawn: " .. k .. " " .. tostring(v) )
	end
	 --print(g_EmpireGoldCount)
	 --print(filterTable["gold_bounty"])
	filterTable["gold_bounty"]=filterTable["gold_bounty"]*.5*g_EmpireGoldCount
	if PlayerResource:GetTeam(filterTable["player_id_const"]) == DOTA_TEAM_GOODGUYS then
		g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + filterTable["gold_bounty"]
	else
		g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + filterTable["gold_bounty"]
	end
	g_HeroGoldArray[filterTable["player_id_const"]] =g_HeroGoldArray[filterTable["player_id_const"]]  + filterTable["gold_bounty"]
    --Return true by default to keep all other orders the same
    return true
end




function CBattleship8D:FilterRuneSpawn( filterTable )
	for k, v in pairs( filterTable ) do
		 --print("rune spawn: " .. k .. " " .. tostring(v) )
	end
	return true
end


function CBattleship8D:OrderExecutionFilter(keys)


  local playerID = keys.issuer_player_id_const
  local ability = EntIndexToHScript(keys.entindex_ability)
  local target = EntIndexToHScript(keys.entindex_target)
  local orderType = keys.order_type
  local queuePos = keys.queue
  local player = PlayerResource:GetPlayer(playerID)
  if orderType == DOTA_UNIT_ORDER_SELL_ITEM or (orderType == DOTA_UNIT_ORDER_GIVE_ITEM and target~=nil and not target:IsOwnedByAnyPlayer()) then
  DeepPrintTable( keys )
	 --print("i'm in DOTA_UNIT_ORDER_SELL_ITEM")
	 --print(ability:GetName())
	 --print(ability:GetCaster():GetName())
	if ability:GetCaster() ~= nil and ability:GetCaster():IsOwnedByAnyPlayer() and ability:GetCaster():IsRealHero() then
	
		local sellGold = GetItemCost(ability:GetName())*.5
		if  ability:GetPurchaseTime()+10>GameRules:GetGameTime() then
			sellGold=sellGold*2
		end
		 --print(sellGold)
		 --print(GetItemCost(ability:GetName()))
		 --print(ability:GetGoldCost(1))
		g_HeroGoldArray[ability:GetCaster():GetPlayerOwnerID()]=g_HeroGoldArray[ability:GetCaster():GetPlayerOwnerID()]+sellGold
		if g_ItemCodeLookUp[ability:GetName()]~=nil then
			storage:AddToPlayerSaleHist(playerID,{item=g_ItemCodeLookUp[ability:GetName()] , time=math.floor(GameRules:GetGameTime()/60+0.5)})--math.floor(GameRules:GetGameTime()/60+0.5) .. g_ItemCodeLookUp[itemName])
		else
			storage:AddToPlayerSaleHist(playerID,{item=ability:GetName() , time=math.floor(GameRules:GetGameTime()/60+0.5)})--math.floor(GameRules:GetGameTime()/60+0.5) .. g_ItemCodeLookUp[itemName])
		end
	end
  end
  

  -- emits a sound every time a player issues any sort of command
  --EmitSoundOnClient("announcer_dlc_glados_ann_glados_battle_begin_01", player)
  -- 1/20 is about okay for the frequency of playing movement sounds. It depends on length of the clip.
  -- this clip is about 9 seconds long
  local rand = math.random(1, 10000)
  if rand > 9500 then
    EmitSoundOnClient("battleships_traders.wooden_ship_creaking_waterslosh", player) --PlayerResource:GetPlayer(playerID))
  end

  return true
end


function CBattleship8D:OnThink()
		if g_MainTimerTickCount < 500 then
				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_abad*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() and string.match(hero:GetName(),"abaddon") and hero.changed==nil then
						hero.changed=1
					
						g_PlayerCount=g_PlayerCount+1
						if g_TugMode==0 then
							become_boat(hero, "npc_dota_hero_zuus")
						else
							become_boat(hero,"npc_dota_hero_ember_spirit")
						end
						
						
						RemoveWearables( hero )
				end
			end
		end
			 
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if GameRules:GetGameTime() ~= g_PreviousTickCount then
			
					if g_MainTimerTickCount == 5 then
						storage:SetGameSettings({battle=g_BattleMode ,coOp = g_CoOpMode , trading = g_TradeMode})
					if g_BattleMode==1 then
						local battleTimerData = {
							TimeTillBattle = g_BattleModeTimer;
						}
						FireGameEvent( "Battle_Over", battleTimerData ); 
					end
					
					if g_BattleMode==1 then
						local battleTimerData = {
							TimeTillBattle = g_BattleModeTimer;
						}
						FireGameEvent( "Battle_Over", battleTimerData ); 
					end
					 --print("g_TradeMode is" .. g_TradeMode)
					if g_TradeMode==1 then
						local empty = {}
							FireGameEvent( "Trade_Mode_Enabled", empty ); 
					end
					
					
		Timers:CreateTimer( 300, function()
			spawnTide()
		end)
		spawnCop()
			for _,tower in pairs( Entities:FindAllByClassname( "npc_dota_tow*")) do
					if tower ~= nil and string.match(tower:GetName(),"tower") then
						if tower:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							creature = CreateUnitByName( "npc_dota_rng_ind" , tower:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
							creature:SetOrigin( tower:GetAbsOrigin()* Vector(1,1,0))
						elseif  tower:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							creature = CreateUnitByName( "npc_dota_rng_ind" , tower:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
							creature:SetOrigin(creature:GetOrigin() * Vector(1,1,0))
						end
						
				end
			end
		 Notifications:TopToAll({text="#Welcome", duration=6.0, style={color="#58ACFA",  fontSize="40px;"}})
		 Notifications:TopToAll({text="#inst_one", duration=6.0, style={color="#B03060",  fontSize="18px;"}})
		 Notifications:TopToAll({text="#inst_two", duration=6.0, style={color="#58ACFA",  fontSize="18px;"}, continue=true})
		 Notifications:TopToAll({text="#inst_three", duration=6.0, style={color="#B03060",  fontSize="18px;"}, continue=true})
		 Notifications:TopToAll({text="#inst_four", duration=6.0, style={color="#58ACFA",  fontSize="18px;"}, continue=true})
		
		
		end
		if g_MainTimerTickCount == 7 then	
		 Notifications:TopToAll({text="#inst_five", duration=6.0, style={color="#07C300",  fontSize="18px;"}})
		 Notifications:TopToAll({text="#inst_six", duration=6.0, style={color="#58ACFA",  fontSize="18px;"}, continue=true})
		 Notifications:TopToAll({text="#inst_seven", duration=6.0, style={color="#07C300",  fontSize="18px;"}, continue=true})
		 Notifications:TopToAll({text="#inst_eight", duration=6.0, style={color="#58ACFA",  fontSize="18px;"}, continue=true})
			g_PlayerCountSouth = 0
			g_PlayerCountNorth = 0
				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
						if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							g_PlayerCountSouth = g_PlayerCountSouth + 1
						elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							g_PlayerCountNorth = g_PlayerCountNorth + 1
						end
						g_IsHeroDisconnected[hero] = 0
					end
				end
			if g_CoOpMode==1 then
				g_PlayerCountNorth=1
				local co_op_pid
				for playerID = 0, DOTA_MAX_PLAYERS do
					if PlayerResource:IsValidPlayerID(playerID) then
						local player = PlayerResource:GetPlayer(playerID)
						if GameRules:PlayerHasCustomGameHostPrivileges(player) then 
							co_op_pid = playerID
						end
					end
				end  
				
				local data =
				{
					Player_ID = co_op_pid;
				}
				FireGameEvent("co_op_mode",data)
			end
			
		end

		if g_MainTimerTickCount ==18 and g_TugMode==1 then	
			Notifications:TopToAll({text="tug_one", duration=6.0, style={color="#07C300",  fontSize="80px;"}})

		   
		   end

		if g_MainTimerTickCount ==13 and g_CoOpMode==1 then	
		 Notifications:TopToAll({text="#co_op_one", duration=6.0, style={color="#07C300",  fontSize="30px;"}})
		 Notifications:TopToAll({text="#co_op_two", duration=6.0, style={color="#07C300",  fontSize="30px;"}})
		
		end
		
		if g_MainTimerTickCount ==13 and g_BattleMode==1 then	
			Notifications:TopToAll({text="#BattleMode", duration=5.0, style={color="#F2B2B2",  fontSize="40px;"}})
			Notifications:TopToAll({text="#BattleMode_1", duration=5.0, style={color="#F2B2B2",  fontSize="20px;"}})
			
			
			
		end
		
		
		
		if g_MainTimerTickCount == 30 then	
		 Notifications:TopToAll({text="#bs_HowToWin", duration=10.0, style={color="#58ACFA",  fontSize="25px;"}})

		end
		
			if g_MainTimerTickCount == 1224 then	
				Notifications:TopToAll({text="#spys_reminder", duration=8.0, style={color="#CC33FF",  fontSize="25px;"}})
				  for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
						if hero:IsRealHero() then

					
						local Data = {
							player_id =hero:GetPlayerOwnerID(),
							x 	= -3328,
							y  = 320,
							z  = -68
						}
						FireGameEvent( "ping_loc", Data ); 
						
						local Data = {
							player_id =hero:GetPlayerOwnerID(),
							x 	= 3008,
							y  = -320,
							z  = -68
						}
						FireGameEvent( "ping_loc", Data ); 
						end
					end
				end
				
			end
			if g_MainTimerTickCount == 1228 then	
				Notifications:TopToAll({text="#spys_reminder", duration=8.0, style={color="#CC33FF",  fontSize="25px;"}})
				  for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
						if hero:IsRealHero() then
						local Data = {
							player_id =hero:GetPlayerOwnerID(),
							x 	= -3328,
							y  = 320,
							z  = -68
						}
						FireGameEvent( "ping_loc", Data ); 
						
						local Data = {
							player_id =hero:GetPlayerOwnerID(),
							x 	= 3008,
							y  = -320,
							z  = -68
						}
						FireGameEvent( "ping_loc", Data ); 
						end
					end
				end
				
			end
		if g_MainTimerTickCount == 20 then	
			local i=0
			while i < 5-g_PlayerCountSouth do
			g_GoldPerTickSouth = g_GoldPerTickSouth + 1
			i=i+1
			end
			i=0
			while i < 5-g_PlayerCountNorth do
			g_GoldPerTickNorth = g_GoldPerTickNorth + 1
			i=i+1
			end
		end
		
		
		--iterates through heroes every 2 seconds
		if g_MainTimerTickCount % 2 == 0 then
			if g_MainTimerTickCount % 4 == 0 and g_SpyAnnouncmentFlag == 1 then
				g_SpyAnnouncmentFlag = 0
				 Notifications:TopToAll({text="#buy_spy_header", duration=4.0, style={color="#58ACFA",  fontSize="30px;"}})
				 Notifications:TopToAll({text="#spys_south_start", duration=4.0, style={color="#CC33FF",  fontSize="30px;"}})
				 Notifications:TopToAll({text=tostring(g_SpyCountSouth) .. " ", duration=4.0, style={color="#CC3300",  fontSize="30px;"}, continue=true})
				 Notifications:TopToAll({text="#spys_end", duration=4.0, style={color="#CC33FF",  fontSize="30px;"}, continue=true})
				 Notifications:TopToAll({text="#spys_north_start", duration=4.0, style={color="#CC33FF",  fontSize="30px;"}})
				 Notifications:TopToAll({text=tostring(g_SpyCountNorth) .. " ", duration=4.0, style={color="#CC3300",  fontSize="30px;"}, continue=true})
				 Notifications:TopToAll({text="#spys_end", duration=4.0, style={color="#CC33FF",  fontSize="30px;"}, continue=true})
				
				
			end
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 then
				
				AttachCosmetics(hero)
					HandleShopChecks(hero)
					if hero:IsIllusion() then
						hero:SetModel( "models/noah_boat.vmdl" )
						hero:SetOriginalModel( "models/noah_boat.vmdl" )
					end
					
					if string.match(hero:GetName(),"crystal_maiden") then
						hero:SetMana((hero:GetStrength()-1)/3)
					end
					if string.match(hero:GetName(),"tusk") then
							local casterUnit = hero
							-- --print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
							-- --print('[AbilityFunctions] battleshipHealth started!')
							if casterUnit:IsAlive() and hero:IsOwnedByAnyPlayer() and g_HeroHP[casterUnit:GetPlayerID()] == nil then
								g_HeroHP[casterUnit:GetPlayerID()] = casterUnit:GetHealthPercent() 
								casterUnit:SetModel("models/battleship_boat0")
								casterUnit:SetOriginalModel("models/battleship_boat0")
							end
							if casterUnit:IsAlive() and hero:IsOwnedByAnyPlayer() then
								if casterUnit:GetHealthPercent() < 7  and g_HeroHP[casterUnit:GetPlayerID()] > 6 then
									casterUnit:SetModel("models/battleship_boat4")
									casterUnit:SetOriginalModel("models/battleship_boat4")
								-- --print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() < 25 and g_HeroHP[casterUnit:GetPlayerID()] > 24 then
									casterUnit:SetModel("models/battleship_boat3")
									casterUnit:SetOriginalModel("models/battleship_boat3")
									-- --print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() < 50 and g_HeroHP[casterUnit:GetPlayerID()] > 49 then
									casterUnit:SetModel("models/battleship_boat2")
									casterUnit:SetOriginalModel("models/battleship_boat2")
									-- --print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() < 75 and g_HeroHP[casterUnit:GetPlayerID()] > 74 then
									casterUnit:SetModel("models/battleship_boat1")
									casterUnit:SetOriginalModel("models/battleship_boat1")
									-- --print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() > 74 and g_HeroHP[casterUnit:GetPlayerID()] < 75 then
									casterUnit:SetModel("models/battleship_boat0")
									casterUnit:SetOriginalModel("models/battleship_boat0")
									-- --print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								-- --print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								end
									g_HeroHP[casterUnit:GetPlayerID()] = casterUnit:GetHealthPercent() 
							end
						end
						
					
							local casterPos = hero:GetAbsOrigin()
							local targetUnitOne = Entities:FindByName( nil, "south_kicker")
							local targetUnitTwo = Entities:FindByName( nil, "north_kicker")
							local directionOne =  casterPos - targetUnitOne:GetAbsOrigin()
							local directionTwo =  casterPos - targetUnitTwo:GetAbsOrigin()
						
						
						
						if PlayerResource:GetConnectionState( hero:GetPlayerID() ) ~= 2 or hero:HasOwnerAbandoned() or hero:HasModifier("pergatory_perm") then
								 --print('inside disconnect')
										if g_DisconnectTime[hero]~= nil then
											g_DisconnectTime[hero]=g_DisconnectTime[hero]+2
											 --print('disconnect time: ' .. g_DisconnectTime[hero])
											else
											g_DisconnectTime[hero]=1
										end
											if g_DisconnectTime[hero]==180 or g_DisconnectTime[hero]==181 then
											Notifications:TopToAll({text="#player_kickable", duration=6.0, style={color="#800000",  fontSize="30px;"}})
				
											 					
											end
											if g_DisconnectTime[hero]>180 or hero:HasOwnerAbandoned() then
											 --print('bigger than 180')
												local casterPos = hero:GetAbsOrigin()
												local targetUnitOne = Entities:FindByName( nil, "south_kicker")
												local targetUnitTwo = Entities:FindByName( nil, "north_kicker")
												local directionOne =  casterPos - targetUnitOne:GetAbsOrigin()
												local directionTwo =  casterPos - targetUnitTwo:GetAbsOrigin()
											
											
												if directionOne:Length() < 600 or directionTwo:Length() < 600 or hero:HasOwnerAbandoned() then
													g_DisconnectKicked[hero] =1
												end
											end
										local herogold=0
											if hero:IsOwnedByAnyPlayer() then
											 herogold = g_HeroGoldArray[hero:GetPlayerOwnerID()]
											end
										if (g_DisconnectKicked[hero] == 1 and g_PlayerCount>1 or hero:HasOwnerAbandoned()) and herogold > 30 and false == hero:HasModifier("pergatory_perm") and g_PlayerCount>1 then
											GameRules:SendCustomMessage("#remove_player", DOTA_TEAM_GOODGUYS, 0)
											storage:SetDisconnectState(g_DisconnectKicked)
											--not sure if syntax in following line is right
											sellBoat(hero)
											for itemSlot = 0, 14, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
													if hero ~= nil then --checks to make sure the killed unit is not nonexistent.
															local Item = hero:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
															if Item ~= nil then -- makes sure that the item exists and making sure it is the correct item
																hero:SetGold(herogold + Item:GetGoldCost(0), true)
																hero:SetGold(0, false)
																RemoveAndDeleteItem(hero,Item)
															end
													end
											end
											local herogoldaftersell = hero:GetGold()
											if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
												g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + herogoldaftersell
											elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
												g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + herogoldaftersell
											end
											hero:SetGold(0, false)
											hero:SetGold(0, true)
											g_DisconnectKicked[hero] = 2
											local vecorig = Vector(-8000,384,0)
											hero:SetOrigin(vecorig)
											local item = CreateItem( "item_spawn_stunner", npc, npc)
							
											item:ApplyDataDrivenModifier(hero, hero, "pergatory_perm", nil)
										end
										
										if g_DisconnectKicked[hero] == 2 or hero:HasOwnerAbandoned() or hero:HasModifier("pergatory_perm") then
												if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
													hero:SetGold(0, true)
													g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + g_GoldPerTickNorth * 2
												elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
													hero:SetGold(0, true)
													g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + g_GoldPerTickSouth * 2
											end
										end
								end
						
						
				local hulls=0
							for itemSlot = 0, 5, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
									if hero ~= nil then --checks to make sure the killed unit is not nonexistent.
											local Item = hero:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
											if Item ~= nil and string.match(Item:GetName(),"hull") then -- makes sure that the item exists and making sure it is the correct item
												Item:ApplyDataDrivenModifier(hero, hero, "modifier_item_hull_one", nil)
												hulls=hulls+1
											end
									end
							end
					
					if hulls>1 and hero.hullmsg==nil then
						hero.hullmsg=1
						Notifications:Top(hero:GetPlayerID(), {text="#too_many_hulls", duration=5.0, style={color="#800000",  fontSize="50px;"}})
					end
					
						if hulls>1 and g_MainTimerTickCount % 15 == 0 then
							hero.hullmsg=nil
						end
					
					--handles people stuck on cliffs
						local height = hero:GetOrigin() * Vector(0,0,1)
						if height:Length() > 110 and false == hero:HasModifier("line_mod") and false == hero:HasModifier("modifier_ball_lightning")  and false == hero:HasModifier("fly_bat") and false == hero:HasModifier("fly") and false == hero:HasModifier("modifier_spirit_breaker_charge_of_darkness") and false == hero:HasModifier("modifier_kunkka_torrent") and false == hero:HasModifier("move_carrier_in")  and false == hero:HasModifier("giraffe_grabed")  and false == hero:HasModifier("modifier_batrider_flaming_lasso") and false == hero:HasModifier("modifier_mirana_leap")  and false == hero:IsStunned() and  hero:IsAlive()  then 
							
							local abil1 = hero:GetAbilityByIndex(1)
							
							 --print( 'player found at z of: ' .. tostring(height:Length()) .. "and cd check is " .. tostring(abil1:GetCooldownTimeRemaining() > abil1:GetCooldown(abil1:GetLevel())-2) .. " and name of hero is " .. hero:GetName() .. " so name check is " .. tostring(string.match(hero:GetName(),"winter_wyvern")))
						
							if abil1:GetCooldownTimeRemaining() >= abil1:GetCooldown(abil1:GetLevel())-2 and (string.match(hero:GetName(),"winter_wyvern") or string.match(hero:GetName(),"kunkka")) then
							
							else
									lasth=g_OldHeroLocations[hero]*Vector(0,0,1)
									if	lasth:Length() <110 then
										hero:SetOrigin(g_OldHeroLocations[hero])		
										else
										hero:SetOrigin(g_OlderHeroLocations[hero])		
									end
									
									local dmg=hero:GetHealth() * 0.7
									local damageTable = {
										victim = hero,
										attacker = hero,
										damage = dmg,
										damage_type = DAMAGE_TYPE_PURE,
									}
									
									 Notifications:Top(hero:GetPlayerID(), {text="#off_wall", duration=3.0, style={color="#800000",  fontSize="50px;"}})
					
									ApplyDamage(damageTable)
							end
						else
							if g_OldHeroLocations[hero]~=nil then
								if g_OlderHeroLocations[hero] ~=nil and (g_OldHeroLocations[hero] - hero:GetOrigin()):Length() >100 then
									g_OlderHeroLocations[hero] = g_OldHeroLocations[hero]
									-- --print("update ll2")
								elseif g_OlderHeroLocations[hero]==nil then
									g_OlderHeroLocations[hero] = g_OldHeroLocations[hero]
								--	 --print("irst time ll2")
								else
								--	 --print("no update ll2")
								end
							end
							if  g_OldHeroLocations[hero]~=nil and (g_OldHeroLocations[hero] - hero:GetOrigin()):Length() >100 then
								-- --print((g_OldHeroLocations[hero] - hero:GetOrigin()):Length())
								g_OldHeroLocations[hero] = hero:GetOrigin()
							elseif g_OldHeroLocations[hero]==nil then
							--	 --print("first time")
								g_OldHeroLocations[hero] = hero:GetOrigin()
								-- --print((g_OldHeroLocations[hero] - hero:GetOrigin()):Length())
								else
							--	 --print("no update ll")
							end
							
							
							end
					--gives gold per tick
					
					if hero:IsOwnedByAnyPlayer() then
						local herogold = g_HeroGoldArray[hero:GetPlayerOwnerID()]
						if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + g_GoldPerTickSouth * 2, true)
							hero:SetGold(0, false)
							g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + g_GoldPerTickSouth * 2
							g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + g_GoldPerTickSouth * 2
						elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + g_GoldPerTickNorth * 2, true)
							hero:SetGold(0, false)
							g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + g_GoldPerTickNorth * 2
							g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + g_GoldPerTickNorth * 2
						end
						if hero.earnedbonusgold ~= nil and hero.earnedbonusgold >0 then
							print(g_HeroGoldArray[hero:GetPlayerOwnerID()] .. "before bonus")
							hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + hero.earnedbonusgold, true)
							hero:SetGold(0, false)
							g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + hero.earnedbonusgold
							print(g_HeroGoldArray[hero:GetPlayerOwnerID()] .. "after bonus")
							hero.earnedbonusgold=0
						end
					end

				end
			end
		end
		HandleTideAbil()
		
		if g_MainTimerTickCount % 2 == 0 then
			reapplyWP()
			
		end
	
		if g_MainTimerTickCount % 3 == 0 and g_CoOpMode==1 then
			HandleCoOp()
		end
		
		if g_MainTimerTickCount % 240 == 0 or g_TicksSinceEmpireGold > 240 then
			CBattleship8D:HandleEmpGold()
			g_EmpireGoldCount = g_EmpireGoldCount + 1
			g_CreepLevel=g_CreepLevel+1
			g_NumPrivCreeps=g_NumPrivCreeps+1
		end
		
		if g_MainTimerTickCount % 45 == 0 or g_MainTimerTickCount == 1 then
			 --print("g_TradeMode is" .. g_TradeMode)
			if g_TradeMode==1 then
				local empty = {}
					FireGameEvent( "Trade_Mode_Enabled", empty ); 
			end
			
			if  g_DockAliveSouthRight == 1 then
				CBattleship8D:QuickSpawn("south","right", "one", g_CreepLevel, g_NumSmallCreeps)
			else
				CBattleship8D:QuickSpawn("south","right", "one", 1, g_NumSmallCreeps)
			end
			if  g_DockAliveNorthRight == 1 then
					CBattleship8D:QuickSpawn("north","right", "one", g_CreepLevel, g_NumSmallCreeps)
			else
					CBattleship8D:QuickSpawn("north","right", "one", 1, g_NumSmallCreeps)
			end
			if  g_DockAliveSouthLeft == 1 then
					CBattleship8D:QuickSpawn("south","left", "one", g_CreepLevel, g_NumSmallCreeps)
			else
					CBattleship8D:QuickSpawn("south","left", "one", 1, g_NumSmallCreeps)
			end
			if  g_DockAliveNorthLeft == 1 then
				CBattleship8D:QuickSpawn("north","left", "one", g_CreepLevel, g_NumSmallCreeps)
			else
				CBattleship8D:QuickSpawn("north","left", "one", 1, g_NumSmallCreeps)
			end
		end
		if g_MainTimerTickCount % 90 == 0 then
			if  g_DockAliveSouthRight == 1 then
				CBattleship8D:QuickSpawn("south","right", "two", g_CreepLevel, g_NumBigCreeps)
			else
				CBattleship8D:QuickSpawn("south","right", "two", 1, g_NumBigCreeps)
			end
			if  g_DockAliveNorthRight == 1 then
					CBattleship8D:QuickSpawn("north","right", "two", g_CreepLevel, g_NumBigCreeps)
			else
					CBattleship8D:QuickSpawn("north","right", "two", 1, g_NumBigCreeps)
			end
			if  g_DockAliveSouthLeft == 1 then
					CBattleship8D:QuickSpawn("south","left", "two", g_CreepLevel, g_NumBigCreeps)
			else
					CBattleship8D:QuickSpawn("south","left", "two", 1, g_NumBigCreeps)
			end
			if  g_DockAliveNorthLeft == 1 then
				CBattleship8D:QuickSpawn("north","left", "two", g_CreepLevel, g_NumBigCreeps)
			else
				CBattleship8D:QuickSpawn("north","left", "two", 1, g_NumBigCreeps)
			end
			
		end
		if g_MainTimerTickCount % 180 == 0 then	
			if  g_DockAliveSouthRight == 1 then
				CBattleship8D:QuickSpawn("south","right", "three", g_CreepLevel, g_NumHugeCreeps)
			else
				CBattleship8D:QuickSpawn("south","right", "three", 1, g_NumHugeCreeps)
			end
			if  g_DockAliveNorthRight == 1 then
					CBattleship8D:QuickSpawn("north","right", "three", g_CreepLevel, g_NumHugeCreeps)
			else
					CBattleship8D:QuickSpawn("north","right", "three", 1, g_NumHugeCreeps)
			end
			if  g_DockAliveSouthLeft == 1 then
					CBattleship8D:QuickSpawn("south","left", "three", g_CreepLevel, g_NumHugeCreeps)
			else
					CBattleship8D:QuickSpawn("south","left", "three", 1, g_NumHugeCreeps)
			end
			if  g_DockAliveNorthLeft == 1 then
				CBattleship8D:QuickSpawn("north","left", "three", g_CreepLevel, g_NumHugeCreeps)
			else
				CBattleship8D:QuickSpawn("north","left", "three", 1, g_NumHugeCreeps)
			end
			
		end
		local nCreepval = 45-g_MainTimerTickCount%45;
		
		if g_BattleMode==1 then
			g_BattleModeTimer=g_BattleModeTimer-1
			
			if g_BattleModeTimer<1 and g_BattleModeRemaining==0 then
				startBattle()
				g_BattleModeTimer=5000
			elseif g_BattleModeRemaining==0 then
					local battleTimerData = {
						TimeTillBattle = g_BattleModeTimer;
					}
					FireGameEvent( "Battle_Timer", battleTimerData ); 
			end
		end
		
		
		local bsuiTimerData = {
			nEmpire = 240-g_MainTimerTickCount % 240;
			nCreep = nCreepval;
			nNorthGold = GetEmpGoldForTeam(DOTA_TEAM_BADGUYS);
			nSouthGold = GetEmpGoldForTeam(DOTA_TEAM_GOODGUYS);
			
		}
		FireGameEvent( "bsui_timer_data", bsuiTimerData ); 
			g_MainTimerTickCount = g_MainTimerTickCount + 1
			g_TicksSinceEmpireGold=g_TicksSinceEmpireGold+1
			g_PreviousTickCount=GameRules:GetGameTime()		
		end
		-- --print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CBattleship8D:OnNPCSpawned(keys)
if g_BoatJustBaught ==0 then
	local npc = EntIndexToHScript(keys.entindex)

	-- VicFrank
	local npcName = npc:GetUnitName()

	if not g_heroCache[npcName] then
		g_heroCache[npcName] = true
		PrecacheUnitByNameAsync(npcName, function(...) end)
	end

  if g_MainTimerTickCount > 20 then
  if npc:IsIllusion() then
			npc:SetModel( "models/noah_boat.vmdl" )
			npc:SetOriginalModel( "models/noah_boat.vmdl" )
		end
	if npc:IsRealHero() then
		RemoveWearables( npc )
		AttachCosmetics(npc)
		stopPhysics(npc)
		
		
		npc:SetBaseStrength(1)
		 --print("hero level is" .. npc:GetLevel())
		Timers:CreateTimer( 0.1, function()
			if npc:IsHero() or npc:HasInventory() then 
						for itemSlot = 6, 11, 1 do 
							if npc ~= nil then
								local Item = npc:GetItemInSlot( itemSlot )
									if Item ~= nil and string.match(Item:GetName(),"hull") then -- makes sure that the item exists and making sure it is the correct item
									npc:RemoveModifierByName("modifier_item_hull_one")
									 --print( "hull found." )
								elseif Item ~= nil and string.match(Item:GetName(),"doubled") then -- makes sure that the item exists and making sure it is the correct item
									local doubledstring = string.gsub(Item:GetName(),"_bow", "_bow_shooting")
									npc:RemoveModifierByName(doubledstring)
									 --print( "doubled found." )
								elseif Item ~= nil and string.match(Item:GetName(),"bow") then -- makes sure that the item exists and making sure it is the correct item
									npc:RemoveModifierByName(Item:GetName() .. "_shooting")
									 --print( "bow found." )
								elseif Item ~= nil and string.match(Item:GetName(),"sail") then -- makes sure that the item exists and making sure it is the correct item
									npc:RemoveModifierByName("modifier_item_sail_one")
									 --print( "sail found." )
								elseif Item ~= nil and string.match(Item:GetName(),"repair") then -- makes sure that the item exists and making sure it is the correct item
									npc:RemoveModifierByName("modifier_item_repair_one")
									 --print( "sail found." )
								end
							end
						end
					end
    end
  )
	  end
  end
  else
  g_BoatJustBaught=0
  end
end

function AttachCosmetics(hero)
		if string.match(hero:GetName(),"apparition") then
			if hero.particleR==nil then
			 hero.particleR = ParticleManager:CreateParticle( "particles/basic_projectile/smoke_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
				ParticleManager:SetParticleControlEnt(hero.particleR, 0, hero, PATTACH_POINT_FOLLOW, "R_chim3", hero:GetAbsOrigin(), true)
			 hero.particleL = ParticleManager:CreateParticle( "particles/basic_projectile/smoke_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
				ParticleManager:SetParticleControlEnt(hero.particleL, 0, hero, PATTACH_POINT_FOLLOW, "L_chim3", hero:GetAbsOrigin(), true)
			 hero.particleM = ParticleManager:CreateParticle( "particles/basic_projectile/smoke_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
				ParticleManager:SetParticleControlEnt(hero.particleM, 0, hero, PATTACH_POINT_FOLLOW, "M_chim3", hero:GetAbsOrigin(), true)
			end
		elseif string.match(hero:GetName(),"brewmaster") then
				if hero.particleR==nil then
				 hero.particleR = ParticleManager:CreateParticle( "particles/basic_projectile/smoke_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
					ParticleManager:SetParticleControlEnt(hero.particleR, 0, hero, PATTACH_POINT_FOLLOW, "attach_smoke_1", hero:GetAbsOrigin(), true)
				 hero.particleL = ParticleManager:CreateParticle( "particles/basic_projectile/smoke_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
					ParticleManager:SetParticleControlEnt(hero.particleL, 0, hero, PATTACH_POINT_FOLLOW, "attach_smoke_2", hero:GetAbsOrigin(), true)
				end
		elseif string.match(hero:GetName(),"phantom") then
			if hero.particleM==nil then
				 hero.particleM = ParticleManager:CreateParticle( "particles/basic_projectile/smoke_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
					ParticleManager:SetParticleControlEnt(hero.particleM, 0, hero, PATTACH_POINT_FOLLOW, "Pipe_emitter", hero:GetAbsOrigin(), true)
				end
		elseif string.match(hero:GetName(),"batrider") then
			if hero.particleM==nil then
				print("placing particle")
					hero.particleM = ParticleManager:CreateParticle( "particles/basic_projectile/lamp_flame.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
					ParticleManager:SetParticleControlEnt(hero.particleM, 0, hero, PATTACH_POINT_FOLLOW, "flame_effect", hero:GetAbsOrigin(), true)
				end
		end

end

function CBattleship8D:HandleEmpGold()
		GameRules:SetTimeOfDay(0.25)
		if g_CoOpMode==0 then
			g_TicksSinceEmpireGold = 0
			local goodGold = 0
			local badGold = 0
			g_PlayerCountSouth = 0
			g_PlayerCountNorth = 0
			local goodGoldEach = 500 * g_EmpireGoldCount
			local badGoldEach = 500 * g_EmpireGoldCount
			local GoldDif = 0
			
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 and hero:IsRealHero() then
					if g_HeroGoldArray[hero:GetPlayerOwnerID()]>0 and not hero:HasModifier("pergatory_perm") then
						if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							g_PlayerCountSouth = g_PlayerCountSouth + 1
						elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							g_PlayerCountNorth = g_PlayerCountNorth + 1
						end
					end
				end
			end
			
			goodGoldEach = GetEmpGoldForTeam(DOTA_TEAM_GOODGUYS)
			badGoldEach = GetEmpGoldForTeam(DOTA_TEAM_BADGUYS)

			Notifications:TopToAll({text="#emp_gold", duration=5.0, style={color="#B2B2B2",  fontSize="50px;"}})
			Notifications:TopToAll({text="#north_gets", duration=5.0, style={color="#B2B2B2",  fontSize="30px;"}})
			Notifications:TopToAll({text=tostring(math.floor(badGoldEach+0.5)) .. " ", duration=5.0, style={color="#FFD700",  fontSize="30px;"}, continue=true})
			Notifications:TopToAll({text="#for_each_player", duration=5.0, style={color="#B2B2B2",  fontSize="30px;"}, continue=true})
			Notifications:TopToAll({text="#south_gets", duration=5.0, style={color="#B2B2B2",  fontSize="30px;"}})
			Notifications:TopToAll({text=tostring(math.floor(goodGoldEach+0.5)) .. " ", duration=5.0, style={color="#FFD700",  fontSize="30px;"}, continue=true})
			Notifications:TopToAll({text="#for_each_player", duration=5.0, style={color="#B2B2B2",  fontSize="30px;"}, continue=true})
			 table.insert(g_EmpGoldArray,{
			 EmpireGoldCount=g_EmpireGoldCount,
			 South_Gold=goodGoldEach,
			 North_gold=badGoldEach,
			 })
			 
			
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 and not hero:HasModifier("pergatory_perm") and hero:IsRealHero()  then
					if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
						hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + goodGoldEach, true)   
						g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + goodGoldEach
						 --print("hero's is good guy (south) had " .. g_HeroGoldArray[hero:GetPlayerOwnerID()] .. " got " .. goodGoldEach .. "new gold is: " .. g_HeroGoldArray[hero:GetPlayerOwnerID()] + goodGoldEach)
						hero:SetGold(0, false)
						g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + goodGoldEach
					elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
						hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + badGoldEach, true)
						g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + badGoldEach
						 --print("hero's is bad guy (north) had " .. g_HeroGoldArray[hero:GetPlayerOwnerID()] .. " got " .. badGoldEach .. "new gold is: " .. g_HeroGoldArray[hero:GetPlayerOwnerID()] + badGoldEach)
						hero:SetGold(0, false)
						g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + badGoldEach
					end
				end
			end
			
			else
				g_TicksSinceEmpireGold = 0
				local goodGoldEach = 500 * g_EmpireGoldCount
				local badGoldEach = 500 * g_EmpireGoldCount
				if g_PlayerCountSouth ~= 0 and g_PlayerCountNorth ~= 0 then
					goodGoldEach = goodGoldEach / g_PlayerCountSouth
					badGoldEach = badGoldEach / g_PlayerCountNorth
				end
				Notifications:TopToAll({text="#emp_gold", duration=5.0, style={color="#B2B2B2",  fontSize="50px;"}})
				Notifications:TopToAll({text="#south_gets", duration=5.0, style={color="#B2B2B2",  fontSize="30px;"}})
				Notifications:TopToAll({text=tostring(math.floor(goodGoldEach+0.5)) .. " ", duration=5.0, style={color="#FFD700",  fontSize="30px;"}, continue=true})
				Notifications:TopToAll({text="#for_each_player", duration=5.0, style={color="#B2B2B2",  fontSize="30px;"}, continue=true})
				
			
				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 and not hero:HasModifier("pergatory_perm") then
					local herogold = hero:GetGold()
					if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
						hero:SetGold(herogold + goodGoldEach, true)   
						g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + goodGoldEach
						 --print("hero's is good guy (south) had " .. herogold .. " got " .. goodGoldEach .. "new gold is: " .. herogold + goodGoldEach)
						hero:SetGold(0, false)
						g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + goodGoldEach
					elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
						hero:SetGold(herogold + badGoldEach, true)
						g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + badGoldEach
						 --print("hero's is bad guy (north) had " .. herogold .. " got " .. badGoldEach .. "new gold is: " .. herogold + badGoldEach)
						hero:SetGold(0, false)
						g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + badGoldEach
					end
				end
			end
			end
end 


function GetEmpGoldForTeam(team)
if g_CoOpMode==0 then

			local gold = 0
			local team_players = 0
			local team_gold = 0
			local other_team_gold = 0
			
			
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 and hero:IsRealHero() then
					if g_HeroGoldArray[hero:GetPlayerOwnerID()]>0 and not hero:HasModifier("pergatory_perm") then
						if hero:GetTeamNumber() == team then
								team_players = team_players + 1
								team_gold=team_gold + GetNetWorth(hero)
							else
								other_team_gold = other_team_gold + GetNetWorth(hero)
						end
					end
				end
			end

			if team == DOTA_TEAM_GOODGUYS then
				team_gold=team_gold+g_SpyCountSouth*500
				other_team_gold=other_team_gold+g_SpyCountNorth*500
			else
				team_gold=team_gold+g_SpyCountNorth*500
				other_team_gold=other_team_gold+g_SpyCountSouth*500
			end

			if team_players==0 then
				team_players=1
			end
			 local minGold = 500 * g_EmpireGoldCount
			local goldEach = 500 * g_EmpireGoldCount
			local GoldDif = 0
			
			if team_gold < other_team_gold then
				local balanceAmount  =  (other_team_gold-team_gold)
					goldEach = goldEach + balanceAmount * (g_DockAliveNorthLeft + g_DockAliveNorthRight)/2 * (0.1 + 0.8 * (1/g_EmpireGoldCount))
			end
		return goldEach / team_players
	end
end

function GetNetWorth(hero)

	local TotalGold = 0
	if g_HeroGoldArray[hero:GetPlayerOwnerID()] ~= nil then
		TotalGold=TotalGold + g_HeroGoldArray[hero:GetPlayerOwnerID()]
		TotalGold=TotalGold+GetBoatValue(hero)
		TotalGold=TotalGold+GetItemValue(hero)
	end
	return TotalGold
end

function GetItemValue(hero)
	local totalGold = 0
	
	for _,item in pairs( Entities:FindAllByName("item_*")) do
				if item~=nil and item:GetName()~=nil and item:GetName()~=""then
					if item:GetPurchaser() == hero  and item:IsPermanent() then
					
						if string.match(item:GetName(),"hull")  or
						string.match(item:GetName(),"bow")   or
						string.match(item:GetName(),"wood") or  
						string.match(item:GetName(),"sail") or
						string.match(item:GetName(),"repair") then
							if not string.match(item:GetName(),"sail_one_combo_bow") then
								totalGold=totalGold+GetItemCost(item:GetName())
							end
						end
					end
				end
	end
		for _,herocopy in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if herocopy ~= nil and herocopy:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 and not herocopy:IsRealHero() and herocopy:GetPlayerOwnerID() == hero:GetPlayerOwnerID() then
					for itemSlot = 0, 14, 1 do 
						if herocopy ~= nil then
							local Item = herocopy:GetItemInSlot( itemSlot )
							if Item ~= nil and (
							string.match(Item:GetName(),"hull")  or
							string.match(Item:GetName(),"bow")   or
							string.match(Item:GetName(),"wood") or  
							string.match(Item:GetName(),"sail") or
							string.match(Item:GetName(),"repair")) then
								if not string.match(Item:GetName(),"sail_one_combo_bow") then
									totalGold=totalGold-GetItemCost(Item:GetName())
								end
							end
						end
				end
			end
		end

	
	return totalGold
end

function GetBoatValue(hero)
	if string.match(hero:GetName(),"disruptor") then
		return 3000
	elseif string.match(hero:GetName(),"ursa") then
		 return 12000
	elseif string.match(hero:GetName(),"meepo") then
		 return 6000
	elseif string.match(hero:GetName(),"tidehunter") then
		return 1000
	elseif string.match(hero:GetName(),"apparition") then
		return 1000
	elseif string.match(hero:GetName(),"rattletrap") then
		return 1000
	elseif string.match(hero:GetName(),"batrider") then
		return 1000
	elseif string.match(hero:GetName(),"winter_wyvern") then
		return 3000
	elseif string.match(hero:GetName(),"storm_spirit") then
		 return 3000
	elseif string.match(hero:GetName(),"brewmaster") then
		return 3000
	elseif string.match(hero:GetName(),"ember_spirit") then
		 return 6000
	elseif string.match(hero:GetName(),"slark") then
		return 6000
	elseif string.match(hero:GetName(),"jakiro") then
		return 6000
	elseif string.match(hero:GetName(),"lion") then
		return 3000
	elseif string.match(hero:GetName(),"tusk") then
		 return 12000
	elseif string.match(hero:GetName(),"visage") then
		 return 12000
	elseif string.match(hero:GetName(),"nevermore") then
		return 3000
	elseif string.match(hero:GetName(),"sniper") then
		return 6000
	elseif string.match(hero:GetName(),"wind") then
		return 12000
	elseif string.match(hero:GetName(),"crystal") then
		return 1000
	elseif string.match(hero:GetName(),"phantom") then
		return 1000
	elseif string.match(hero:GetName(),"vengefulspirit") then
		 return 750
	elseif string.match(hero:GetName(),"enigma") then
		 return 8000
	elseif string.match(hero:GetName(),"bane") then
		 return 4000
	elseif string.match(hero:GetName(),"pugna") then
		 return 12000
	elseif string.match(hero:GetName(),"razor") then
		return 12000
	 else
		 return 0
end


end
function CBattleship8D:QuickSpawn(team, lane, tier, level, number)
        
	local spawnLocation = Entities:FindByName( nil, team .. "_spawn_" .. lane)
        local waypointlocation = Entities:FindByName ( nil,  team .. "_wp_" .. lane .. "_2")
        local i = 0
        while number>i do
				local creature
				--print ("team is: " .. team .. "     spawn is: " .. team .. "_spawn_" .. lane .. "     comparison yields" .. tostring(team == "north"))
                --hscript CreateUnitByName( string name, vector origin, bool findOpenSpot, hscript, hscript, int team)
				if team == "north" then
					 creature = CreateUnitByName( "npc_dota_boat_" .. team .. "_" .. tier , spawnLocation:GetAbsOrigin() + Vector(-350 + i * 150,0,0), true, nil, nil, DOTA_TEAM_BADGUYS )
				else
					 creature = CreateUnitByName( "npc_dota_boat_" .. team .. "_" .. tier , spawnLocation:GetAbsOrigin() + Vector(-350 + i * 150,0,0), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end
                --Sets the waypath to follow. path_wp1 in this example
				if creature~=nil then
						creature:CreatureLevelUp(level)
						creature.side = lane
				end
				
                i = i + 1
        end
	reapplyWP()
end


function UpdateCoOpTables()

if g_CoOpDiffLevel==5-g_CoOpDiffSetting then
		table.insert(g_CoOpUnitPool,"npc_dota_hero_ancient_apparition")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_crystal_maiden")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_phantom_lancer")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_tidehunter")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_rattletrap")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_batrider")
	end

	if g_CoOpDiffLevel==10-g_CoOpDiffSetting*2 then
		table.insert(g_CoOpItemPool,"item_coal_bow_doubled")
		table.insert(g_CoOpItemPool,"item_fire_bow_doubled")
		table.insert(g_CoOpItemPool,"item_plasma_bow_doubled")
		table.insert(g_CoOpItemPool,"item_poison_bow_doubled")
		table.insert(g_CoOpItemPool,"item_light_bow_doubled")
		table.insert(g_CoOpItemPool,"item_spin_bow_doubled")
		table.insert(g_CoOpItemPool,"item_ice_bow_doubled")
		table.insert(g_CoOpItemPool,"item_breach_bow_doubled")
		table.insert(g_CoOpItemPool,"item_chaos_bow_doubled")
		table.insert(g_CoOpItemPool,"item_caulk_bow_doubled")
	end

	if g_CoOpDiffLevel==20-g_CoOpDiffSetting*3 then
		
		table.insert(g_CoOpUnitPool,"npc_dota_hero_disruptor")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_winter_wyvern")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_storm_spirit")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_brewmaster")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_nevermore")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_lion")
		
		table.insert(g_CoOpItemPool,"item_coal_two_bow")
		table.insert(g_CoOpItemPool,"item_fire_two_bow")
		table.insert(g_CoOpItemPool,"item_plasma_two_bow")
		table.insert(g_CoOpItemPool,"item_poison_two_bow")
		table.insert(g_CoOpItemPool,"item_light_two_bow")
		table.insert(g_CoOpItemPool,"item_spin_two_bow")
		table.insert(g_CoOpItemPool,"item_ice_two_bow")
		table.insert(g_CoOpItemPool,"item_breach_two_bow")
		table.insert(g_CoOpItemPool,"item_chaos_two_bow")
		table.insert(g_CoOpItemPool,"item_caulk_two_bow")
		table.insert(g_CoOpItemPool,"item_hull_two")
		table.insert(g_CoOpItemPool,"item_sail_two")
		table.insert(g_CoOpItemPool,"item_repair_two")

	end

	if g_CoOpDiffLevel==30-g_CoOpDiffSetting*4 then
		g_CoOpUnitPool={}
		table.insert(g_CoOpUnitPool,"npc_dota_hero_disruptor")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_winter_wyvern")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_storm_spirit")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_nevermore")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_lion")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_brewmaster")
		
		
		table.insert(g_CoOpItemPool,"item_coal_two_bow_doubled")
		table.insert(g_CoOpItemPool,"item_fire_two_bow_doubled")
		table.insert(g_CoOpItemPool,"item_plasma_two_bow_doubled")
		table.insert(g_CoOpItemPool,"item_poison_two_bow_doubled")
		table.insert(g_CoOpItemPool,"item_light_two_bow_doubled")
		table.insert(g_CoOpItemPool,"item_spin_two_bow_doubled")
		table.insert(g_CoOpItemPool,"item_ice_two_bow_doubled")
		table.insert(g_CoOpItemPool,"item_breach_two_bow_doubled")
		table.insert(g_CoOpItemPool,"item_chaos_two_bow_doubled")
		table.insert(g_CoOpItemPool,"item_caulk_two_bow_doubled")
		table.insert(g_CoOpItemPool,"item_hull_two")
		table.insert(g_CoOpItemPool,"item_sail_two")
		table.insert(g_CoOpItemPool,"item_repair_two")

	end

	if g_CoOpDiffLevel==40-g_CoOpDiffSetting*5 then
		table.insert(g_CoOpUnitPool,"npc_dota_hero_meepo")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_jakiro")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_ember_spirit")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_slark")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_sniper")
		
		table.insert(g_CoOpItemPool,"item_coal_three_bow")
		table.insert(g_CoOpItemPool,"item_fire_three_bow")
		table.insert(g_CoOpItemPool,"item_plasma_three_bow")
		table.insert(g_CoOpItemPool,"item_poison_three_bow")
		table.insert(g_CoOpItemPool,"item_light_three_bow")
		table.insert(g_CoOpItemPool,"item_spin_three_bow")
		table.insert(g_CoOpItemPool,"item_ice_three_bow")
		table.insert(g_CoOpItemPool,"item_hull_three")
		table.insert(g_CoOpItemPool,"item_sail_three")
		table.insert(g_CoOpItemPool,"item_repair_three")

	end

	if g_CoOpDiffLevel==50-g_CoOpDiffSetting*6 then
		g_CoOpUnitPool={}
		table.insert(g_CoOpUnitPool,"npc_dota_hero_meepo")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_jakiro")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_ember_spirit")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_slark")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_sniper")
		
		
		
		table.insert(g_CoOpItemPool,"item_coal_three_bow")
		table.insert(g_CoOpItemPool,"item_fire_three_bow")
		table.insert(g_CoOpItemPool,"item_plasma_three_bow")
		table.insert(g_CoOpItemPool,"item_poison_three_bow")
		table.insert(g_CoOpItemPool,"item_light_three_bow")
		table.insert(g_CoOpItemPool,"item_spin_three_bow")
		table.insert(g_CoOpItemPool,"item_ice_three_bow")
				table.insert(g_CoOpItemPool,"item_breach_three_bow")
		table.insert(g_CoOpItemPool,"item_chaos_three_bow")
		table.insert(g_CoOpItemPool,"item_caulk_three_bow")
		table.insert(g_CoOpItemPool,"item_hull_three")
		table.insert(g_CoOpItemPool,"item_sail_three")
		table.insert(g_CoOpItemPool,"item_repair_three")

	end

	if g_CoOpDiffLevel==60-g_CoOpDiffSetting*7 then
		
		
		table.insert(g_CoOpItemPool,"item_coal_three_bow_doubled")
		table.insert(g_CoOpItemPool,"item_fire_three_bow_doubled")
		table.insert(g_CoOpItemPool,"item_plasma_three_bow_doubled")
		table.insert(g_CoOpItemPool,"item_poison_three_bow_doubled")
		table.insert(g_CoOpItemPool,"item_light_three_bow_doubled")
		table.insert(g_CoOpItemPool,"item_spin_three_bow_doubled")
		table.insert(g_CoOpItemPool,"item_ice_three_bow_doubled")
		table.insert(g_CoOpItemPool,"item_breach_three_bow_doubled")
		table.insert(g_CoOpItemPool,"item_chaos_three_bow_doubled")
		table.insert(g_CoOpItemPool,"item_caulk_three_bow_doubled")
		table.insert(g_CoOpItemPool,"item_hull_four")
		table.insert(g_CoOpItemPool,"item_sail_four")
		table.insert(g_CoOpItemPool,"item_repair_four")
		if g_CoOpDiffSetting==3 then
			table.insert(g_CoOpUnitPool,"npc_dota_hero_spirit_breaker")
		end

	end

	if g_CoOpDiffLevel==70-g_CoOpDiffSetting*7 then
		g_CoOpUnitPool={}
		table.insert(g_CoOpUnitPool,"npc_dota_hero_meepo")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_jakiro")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_ember_spirit")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_slark")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_sniper")
		
		
		table.insert(g_CoOpItemPool,"item_coal_ult_bow")
		table.insert(g_CoOpItemPool,"item_fire_ult_bow")
		table.insert(g_CoOpItemPool,"item_plasma_ult_bow")
		table.insert(g_CoOpItemPool,"item_poison_ult_bow")
		table.insert(g_CoOpItemPool,"item_light_ult_bow")
		table.insert(g_CoOpItemPool,"item_spin_ult_bow")
		table.insert(g_CoOpItemPool,"item_ice_ult_bow")
		table.insert(g_CoOpItemPool,"item_breach_ult_bow")
		table.insert(g_CoOpItemPool,"item_chaos_ult_bow")
		table.insert(g_CoOpItemPool,"item_caulk_ult_bow")
		table.insert(g_CoOpItemPool,"item_hull_four")
		table.insert(g_CoOpItemPool,"item_sail_four")
		table.insert(g_CoOpItemPool,"item_repair_four")
		if g_CoOpDiffSetting==3 or g_CoOpDiffSetting==2 then
			table.insert(g_CoOpUnitPool,"npc_dota_hero_spirit_breaker")
		end

	end

	if g_CoOpDiffLevel>75-g_CoOpDiffSetting*7 then
		table.insert(g_CoOpUnitPool,"npc_dota_hero_visage")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_ursa")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_tusk")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_windrunner")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_pugna")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_razor")
		table.insert(g_CoOpUnitPool,"npc_dota_hero_spirit_breaker")
		
		if g_CoOpDiffSetting==3 or g_CoOpDiffSetting==2 then
			table.insert(g_CoOpUnitPool,"npc_dota_hero_spirit_breaker")
		end
		if g_CoOpDiffSetting==3 then
			table.insert(g_CoOpUnitPool,"npc_dota_hero_spirit_breaker")
		end
		table.insert(g_CoOpItemPool,"item_coal_ult_bow")
		table.insert(g_CoOpItemPool,"item_fire_ult_bow")
		table.insert(g_CoOpItemPool,"item_plasma_ult_bow")
		table.insert(g_CoOpItemPool,"item_poison_ult_bow")
		table.insert(g_CoOpItemPool,"item_light_ult_bow")
		table.insert(g_CoOpItemPool,"item_spin_ult_bow")
		table.insert(g_CoOpItemPool,"item_ice_ult_bow")
		table.insert(g_CoOpItemPool,"item_hull_four")
		table.insert(g_CoOpItemPool,"item_sail_four")
		table.insert(g_CoOpItemPool,"item_repair_four")

	end
	
end



function HandleTideAbil()

	local otherTeam=DOTA_TEAM_BADGUYS
	local team="north"

			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_spirit_brea*")) do
					if hero ~= nil then
						
						if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							otherTeam=DOTA_TEAM_GOODGUYS
						end
						 --print("haveTide!!")
							local nearby=FindUnitsInRadius(  hero:GetTeamNumber(), hero:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, 0, false )
							if #nearby==0 then
							if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
								team="south"
							end
								
									 local waypoint = Entities:FindByNameNearest( team .. "_wp_*", hero:GetOrigin(), 0 )
										if waypoint and g_ConfusedCreeps[hero]~=1 then
													local wpNextNum=tonumber(string.sub(waypoint:GetName(),string.len(waypoint:GetName())))
													local waypoint2 =nil
													local wpName=string.gsub(waypoint:GetName(),tostring(wpNextNum),tostring(wpNextNum+1))
													waypoint2 = Entities:FindByName(nil, wpName)
													if waypoint2 then
														 --print(waypoint2:GetName())
														hero:MoveToPosition( waypoint2:GetOrigin())
													 end
													 else
													   hero:MoveToPosition( Vector(60,-5568,0))
													    --print("othermove")
										end
										if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and (hero:GetOrigin()* Vector(0,1,0)- Vector(0,6100,0)):Length()<200 or g_ConfusedCreeps[hero]==1 then
											 hero:MoveToPositionAggressive( Vector(-58,5390,0))
											 g_ConfusedCreeps[hero]=1
										elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS and (hero:GetOrigin()* Vector(0,1,0)+ Vector(0,6100,0)):Length()<200 or g_ConfusedCreeps[hero]==1 then
											  hero:MoveToPositionAggressive( Vector(60,-5568,0))
											  g_ConfusedCreeps[hero]=1
										end
									else
									local nearbyHero=FindUnitsInRadius( hero:GetTeamNumber(), hero:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
								
										if #nearbyHero~=0 then
											local abil = hero:GetAbilityByIndex(0)
												
											local abil2 = hero:GetAbilityByIndex(1)
							
											local abil3 = hero:GetAbilityByIndex(2)

											local abil4 = hero:GetAbilityByIndex(3)
											
											if abil:IsFullyCastable() then
												if g_MainTimerTickCount%2==0 then
													hero:CastAbilityOnPosition(nearbyHero[RandomInt(1,#nearbyHero)]:GetOrigin(), abil, -1)	
												else
													hero:CastAbilityOnTarget(nearbyHero[RandomInt(1,#nearbyHero)], abil, -1)
												end
												--abil:CastAbility()
											elseif abil2:IsFullyCastable() then
												if g_MainTimerTickCount%2==0 then
													hero:CastAbilityOnPosition(nearbyHero[RandomInt(1,#nearbyHero)]:GetOrigin(), abil2, -1)	
												else
													hero:CastAbilityOnTarget(nearbyHero[RandomInt(1,#nearbyHero)], abil2, -1)
												end
												--abil2:CastAbility()
											elseif abil3:IsFullyCastable() then
												if g_MainTimerTickCount%2==0 then
													hero:CastAbilityOnPosition(nearbyHero[RandomInt(1,#nearbyHero)]:GetOrigin(), abil3, -1)	
												else
													hero:CastAbilityOnTarget(nearbyHero[RandomInt(1,#nearbyHero)], abil3, -1)
												end
												--abil3:CastAbility()
											elseif abil4 ~= nil and abil4:IsFullyCastable() then
												if g_MainTimerTickCount%2==0 then
													hero:CastAbilityOnPosition(nearbyHero[RandomInt(1,#nearbyHero)]:GetOrigin(), abil4, -1)	
												else
													hero:CastAbilityOnTarget(nearbyHero[RandomInt(1,#nearbyHero)], abil4, -1)
												end
												--abil4:CastAbility()
											else
												hero:MoveToPosition(nearby[RandomInt(1,#nearby)]:GetOrigin())
											end
										else
											hero:MoveToPosition(nearby[RandomInt(1,#nearby)]:GetOrigin())
										end
								if hero:IsNull()==false and hero:IsAlive() == false then
									Timers:CreateTimer( 10, function()
											 --print("Removing Tide!!!!")
											hero:RemoveSelf()
									end)
									
								end
							end
							
						end
					end
					
		end



function HandleCoOp()
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() and not string.match(hero:GetName(),"spirit_brea") then
						
						if  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							local height = hero:GetOrigin() * Vector(0,0,1)
							if height:Length() > 80 then
								 --print("moving wall stuck")
								hero:SetOrigin(hero:GetOrigin() * Vector(.9,.9,.9))
								if hero:GetOrigin():Length() < 1000 then
										hero:SetOrigin( Vector(0,4300,0)+RandomVector( RandomFloat( 200, 300 )))
								end
								
								
							end
							
							local ycord = hero:GetOrigin() * Vector(0,1,0)
							if ycord:Length() > 4300 then
								 --print("moving to base, too far back")
								hero:SetOrigin( Vector(0,4300,0)+RandomVector( RandomFloat( 200, 300 )))
								
							end
							local nearby=FindUnitsInRadius( DOTA_TEAM_BADGUYS, hero:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, 0, false )
							if #nearby==0 then
									 local waypoint = Entities:FindByNameNearest( "north_wp_*", hero:GetOrigin(), 0 )
										if waypoint and g_ConfusedCreeps[hero]~=1 then
													local wpNextNum=tonumber(string.sub(waypoint:GetName(),string.len(waypoint:GetName())))
													local waypoint2 =nil
													local wpName=string.gsub(waypoint:GetName(),tostring(wpNextNum),tostring(wpNextNum+1))
													waypoint2 = Entities:FindByName(nil, wpName)
													if waypoint2 then
														hero:MoveToPosition( waypoint2:GetOrigin())
													 end
													 else
													   hero:MoveToPosition( Vector(60,-5568,0))
										end
											if  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS and (hero:GetOrigin()* Vector(0,1,0)+ Vector(0,6100,0)):Length()<100 or g_ConfusedCreeps[hero]==1 then
												  hero:MoveToPosition( Vector(60,-5568,0))
												  g_ConfusedCreeps[hero]=1
											end
									else
										local nearbyHero=FindUnitsInRadius( DOTA_TEAM_BADGUYS, hero:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
								
										if #nearbyHero~=0 then
											local abil = hero:GetAbilityByIndex(0)
												
											local abil2 = hero:GetAbilityByIndex(1)
							
											local abil3 = hero:GetAbilityByIndex(2)

											local abil4 = hero:GetAbilityByIndex(3)
											
											if abil:IsFullyCastable() then
												if g_MainTimerTickCount%2==0 then
													hero:CastAbilityOnPosition(nearbyHero[RandomInt(1,#nearbyHero)]:GetOrigin(), abil, -1)	
												else
													hero:CastAbilityOnTarget(nearbyHero[RandomInt(1,#nearbyHero)], abil, -1)
												end
												--abil:CastAbility()
											elseif abil2:IsFullyCastable() then
												if g_MainTimerTickCount%2==0 then
													hero:CastAbilityOnPosition(nearbyHero[RandomInt(1,#nearbyHero)]:GetOrigin(), abil2, -1)	
												else
													hero:CastAbilityOnTarget(nearbyHero[RandomInt(1,#nearbyHero)], abil2, -1)
												end
												--abil2:CastAbility()
											elseif abil3:IsFullyCastable() then
												if g_MainTimerTickCount%2==0 then
													hero:CastAbilityOnPosition(nearbyHero[RandomInt(1,#nearbyHero)]:GetOrigin(), abil3, -1)	
												else
													hero:CastAbilityOnTarget(nearbyHero[RandomInt(1,#nearbyHero)], abil3, -1)
												end
												--abil3:CastAbility()
											elseif abil4 ~= nil and abil4:IsFullyCastable() then
												if g_MainTimerTickCount%2==0 then
													hero:CastAbilityOnPosition(nearbyHero[RandomInt(1,#nearbyHero)]:GetOrigin(), abil4, -1)	
												else
													hero:CastAbilityOnTarget(nearbyHero[RandomInt(1,#nearbyHero)], abil4, -1)
												end
												--abil4:CastAbility()
											else
												hero:MoveToPosition(nearby[RandomInt(1,#nearby)]:GetOrigin())
											end
										else
											hero:MoveToPosition(nearby[RandomInt(1,#nearby)]:GetOrigin())
										end
								end
								if hero:IsNull()==false and hero:IsAlive() == false then
									Timers:CreateTimer( 10, function()
											hero:RemoveSelf()
											
									end)
									
								end
							end
							
						end
					end


if (g_CoOpHeroCount<math.sqrt(g_CoOpDiffLevel)*.2*g_PlayerCountSouth*(g_CoOpDiffSetting+1)+1 or g_CoOpHeroCount==0) and g_CoOpHeroCount<25 and g_MainTimerTickCount%2==0 then
		 --print(g_CoOpHeroCount .. "   out of a possable " .. math.sqrt(g_CoOpDiffLevel)*.5*g_PlayerCountSouth+1)
		 --print("current diff level is" .. g_CoOpDiffLevel)
		local spawnPicked=0
		local spawnPos=Vector(0,0,0)
		local tries=0
			while spawnPicked == 0 and tries<10 do
				 tries=tries+1
				spawnPos=Vector(RandomFloat( -6000, 6000 ),RandomFloat( 0, 6000 ),0)
				 --print(spawnPos)
				local allUnits = FindUnitsInRadius( DOTA_TEAM_BADGUYS, spawnPos, nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
				if #allUnits == 0 then
					 --print(#allUnits)
					spawnPicked=1
				end
			end
			
			local unitSpawned=RandomInt( 1, #g_CoOpUnitPool )
			
		 creature = CreateUnitByName( g_CoOpUnitPool[unitSpawned] ,spawnPos , true, nil, nil, DOTA_TEAM_BADGUYS )
		 
				
		if creature:HasInventory() then
			g_CoOpHeroCount=g_CoOpHeroCount+1
			local num_items=RandomInt(1,6)
			local added=0
			while added < num_items do
							
				local newItem2 = CreateItem(g_CoOpItemPool[RandomInt( 1, #g_CoOpItemPool )], creature, creature)
				creature:AddItem(newItem2)
				added=added+1
				
				local abil = creature:GetAbilityByIndex(0)
			
				local abil2 = creature:GetAbilityByIndex(1)

				local abil3 = creature:GetAbilityByIndex(2)

				local abil4 = creature:GetAbilityByIndex(3)
				if abil~= nil then
					abil:SetLevel(4)
				end
				if abil2~= nil then
					abil2:SetLevel(4)
				end
				if abil3~= nil then
					abil3:SetLevel(4)
				end
				if abil4~= nil then
					abil4:SetLevel(4)
				end
				
			end
			RemoveWearables( creature )
			creature:SetRespawnsDisabled(true)
			creature:MoveToPosition( Vector(60,-5568,0))
			else
			creature:MoveToPositionAggressive( Vector(60,-5568,0))
		end
		   
	 end
	 
	 

end

function reapplyWP()
	for _,creep in pairs( Entities:FindAllByClassname( "npc_dota_cre*" )) do
		if creep:HasGroundMovementCapability() and not creep:IsAncient() and not creep:HasModifier("ghost_ship_creep") then
			local waypoint =nil
				if creep~=nil then
					local height = creep:GetOrigin() * Vector(0,0,1)
					if creep:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
						 waypoint = Entities:FindByNameNearest( "south_wp_*", creep:GetOrigin(), 0 )
					elseif  creep:GetTeamNumber() == DOTA_TEAM_BADGUYS then
						 waypoint = Entities:FindByNameNearest( "north_wp_*", creep:GetOrigin(), 0 )
					end
					if waypoint and g_ConfusedCreeps[creep]==nil then
							if not creep:IsAttacking() then
								local wpNextNum=tonumber(string.sub(waypoint:GetName(),string.len(waypoint:GetName())))
								local waypoint2 =nil
								local wpName=string.gsub(waypoint:GetName(),tostring(wpNextNum),tostring(wpNextNum+1))
								waypoint2 = Entities:FindByName(nil, wpName)
								if waypoint2 then
								
									local wpShift=(waypoint:GetOrigin()-creep:GetOrigin())*Vector(1,0,0)
									
									creep:MoveToPositionAggressive( waypoint2:GetOrigin()-wpShift)
								 end
							 end
					end
				
					if not creep:IsAttacking() then
						if creep:GetTeamNumber() == DOTA_TEAM_GOODGUYS and (creep:GetOrigin()* Vector(0,1,0)- Vector(0,4200,0)):Length()<400 and g_ConfusedCreeps[creep]==nil then
						
							  g_ConfusedCreeps[creep]=creep:GetOrigin()* Vector(-1,1,1)
						elseif  creep:GetTeamNumber() == DOTA_TEAM_BADGUYS and (creep:GetOrigin()* Vector(0,1,0)- Vector(0,-4200,0)):Length()<400 and g_ConfusedCreeps[creep]==nil then
						
							   g_ConfusedCreeps[creep]=creep:GetOrigin()* Vector(-1,1,1)
						elseif  g_ConfusedCreeps[creep] ~=nil then
							 print (g_ConfusedCreeps[creep])
							  creep:MoveToPositionAggressive(  g_ConfusedCreeps[creep])
							  
						end
					end
					
					
					if height:Length() > 110 and false == creep:HasModifier("modifier_kunkka_torrent") then
						creep:ForceKill(true)
					end
				end
		end
	end
end
-- Evaluate the state of the game

function sellBoat(hero)
	  local herogold = hero:GetGold()
	  local goldVal=GetBoatValue(hero)
	  heroname = hero:GetName()
	  	if not string.match(heroname,"vengefulspirit") and not string.match(heroname,"enigma") and not string.match(heroname,"bane") then
			goldVal=goldVal*.75
		end

		hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + goldVal, true)
							hero:SetGold(0, false)
							g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + goldVal
end


function CBattleship8D:OnDisconnect(keys)
   --print('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
    PrintTable(keys)
		local plyID
		for ind = 0, 20, 1 do 
			if string.match(keys.name,g_PlayerIdsToNames[ind]) then
				plyID=ind
			end		
		end

		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			if hero ~= nil then
				local id = hero:GetPlayerOwnerID()
				 --print("this hero's id" .. tostring(hero:GetPlayerOwnerID()))
				if id == plyID then
					 --print("this is the DCd hero")
					g_IsHeroDisconnected[hero] = 1
				end
			end
	 	end	
		Notifications:TopToAll({text=keys.name, duration=5.0, style={color="#800000",  fontSize="18px;"}})
		Notifications:TopToAll({text="#dc_drop", duration=5.0, style={color="#800000",  fontSize="18px;"}, continue=true})
		
end
function CBattleship8D:OnConnectFull(keys)
  print ( '[BAREBONES] OnConnectFull' )
  PrintTable(keys)
  local entIndex = keys.index+1
  local ply = EntIndexToHScript(entIndex)
  local playerID = ply:GetPlayerID()
  self.vUserIds[keys.userid] = ply
  Timers:CreateTimer( 5, function()
		local data ={}
	FireGameEvent("Boat_Spawned",data)
	end)

		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			
			
			
			
				local id = hero:GetPlayerOwnerID()
				 --print("this hero's id" .. tostring(hero:GetPlayerOwnerID()))
				if id == keys.index then
					 --print("this is the DCd hero reconnecting")
					if hero ~= nil then
						for itemSlot = 0, 5, 1 do 
							if hero ~= nil then
								local Item = hero:GetItemInSlot( itemSlot )
								if Item ~= nil then
									if string.match(Item:GetName(),"contract") then
										RemoveAndDeleteItem(hero,Item)
										local allyteamnumber=hero:GetPlayerID()
										local data =
										{
											Player_ID = hero:GetPlayerID();
											Ally_ID = allyteamnumber;
										}
										FireGameEvent("Team_Can_Buy",data)
										EmitSoundOnClient("ui.npe_objective_complete",PlayerResource:GetPlayer(hero:GetPlayerID()))
									end
								end
							end
						end
					end
					
					g_IsHeroDisconnected[hero] = 0
					g_DisconnectTime[hero] = 0
				end
		end
end


function CBattleship8D:OnEntityKilled( keys )
	
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		
		if hero:GetPlayerOwnerID() ==nil then
			 --print("nobody owns me! and nobody will")
		else
			if g_HeroGoldArray[hero:GetPlayerOwnerID()] == nil then
				g_HeroGoldArray[hero:GetPlayerOwnerID()]=0
				 --print("owned but no array! got one now")
			end
		end
	end
	
	--handle tower gold
	if killedUnit:IsTower()  then
			 --print( "Tower Killed" )
			if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS and not string.match(killedUnit:GetUnitName(), "dock") then
				g_GoldPerTickSouth = g_GoldPerTickSouth + 2
				 --print( "Bad Tower, Good guys gold per tick is now: " .. g_GoldPerTickSouth )
				Notifications:TopToAll({text="#north_tower_died", duration=5.0, style={color="#FF6600",  fontSize="18px;"}})
				Notifications:TopToAll({text=tostring(100), duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})

		
				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
						if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS  then
							hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + 100, true)
							hero:SetGold(0, false)
							g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + 100
							g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + 100
						end
					end
				end
			elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS and not string.match(killedUnit:GetUnitName(), "dock") then
				g_GoldPerTickNorth = g_GoldPerTickNorth + 2
				 --print( "Good Tower, Bad guys gold per tick is now: " .. g_GoldPerTickNorth )
				Notifications:TopToAll({text="#south_tower_died", duration=5.0, style={color="#FF6600",  fontSize="18px;"}})
				Notifications:TopToAll({text=tostring(100), duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})

				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
						if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS  then
							hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + 100, true)
							hero:SetGold(0, false)
							g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + 100
							g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + 100
						end
					end
				end
			end	
			
		--handle docks dieing and changing the empire gold redistribution
		if string.match(killedUnit:GetUnitName(), "dock") then
		 --print( "base killed" )
			
			if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS then
				
				if g_DockAliveNorthLeft+g_DockAliveNorthRight==1 then

					storage:SetEmpGoldHist(g_EmpGoldArray)
					
					GameRules:SendCustomMessage("#wrap_up", DOTA_TEAM_GOODGUYS, 0)
					storage:SetWinner("South")
					GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
					GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
					
					GameRules:SetSafeToLeave( true )
				elseif string.match(killedUnit:GetUnitName(), "left") then
					g_DockAliveNorthLeft = 0
					Notifications:TopToAll({text="#left_north_harbor_died", duration=5.0, style={color="#FF6600",  fontSize="50px;"}})
				elseif string.match(killedUnit:GetUnitName(), "right") then
					g_DockAliveNorthRight = 0
					Notifications:TopToAll({text="#right_north_harbor_died", duration=5.0, style={color="#FF6600",  fontSize="50px;"}})
				
				end
				
				
			elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS then
				if g_DockAliveSouthLeft+g_DockAliveSouthRight==1 then
					storage:SetEmpGoldHist(g_EmpGoldArray)
					GameRules:SendCustomMessage("#wrap_up", DOTA_TEAM_GOODGUYS, 0)
					storage:SetWinner("North")
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
					
					GameRules:SetSafeToLeave( true )
				elseif string.match(killedUnit:GetUnitName(), "left") then
					g_DockAliveSouthLeft = 0
					Notifications:TopToAll({text="#left_south_harbor_died", duration=5.0, style={color="#FF6600",  fontSize="50px;"}})
			
				elseif string.match(killedUnit:GetUnitName(), "right") then
					g_DockAliveSouthRight = 0
					Notifications:TopToAll({text="#right_south_harbor_died", duration=5.0, style={color="#FF6600",  fontSize="50px;"}})
			
				end
				
			end
			 --print( "North docks:" .. g_DockAliveNorthLeft .. g_DockAliveNorthRight )
			 --print( "South docks:" .. g_DockAliveSouthLeft .. g_DockAliveSouthRight )
		end
		
		--handle ending game
		if string.match(killedUnit:GetUnitName(), "base") then
			 --print( "MATCHED BASE IS TRUE" )
			if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS then
				storage:SetWinner("South")
				GameRules:SendCustomMessage("#wrap_up", DOTA_TEAM_GOODGUYS, 0)
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
				
				GameRules:SetSafeToLeave( true )
			elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS then

				storage:SetWinner("North")
				GameRules:SendCustomMessage("#wrap_up", DOTA_TEAM_GOODGUYS, 0)
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
				
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
	
		local spawnLocation = Entities:FindByName( nil, "north_spawn_left")
        local waypointlocation = Entities:FindByName ( nil, "north_wp_left_2")
     local creature
	
		creature = CreateUnitByName( "npc_dota_hero_spirit_breaker" ,spawnLocation:GetAbsOrigin() , true, nil, nil, DOTA_TEAM_BADGUYS )
			
			if creature~=nil then
			
			
			local abil = creature:GetAbilityByIndex(0)
			
				local abil2 = creature:GetAbilityByIndex(1)

				local abil3 = creature:GetAbilityByIndex(2)

				local abil4 = creature:GetAbilityByIndex(3)
				if abil~= nil then
					abil:SetLevel(2)
				end
				if abil2~= nil then
					abil2:SetLevel(2)
				end
				if abil3~= nil then
					abil3:SetLevel(2)
				end
				if abil4~= nil then
					abil4:SetLevel(2)
				end
				
			RemoveWearables( creature )
			creature:SetRespawnsDisabled(true)
	end
		GameRules:SendCustomMessage("#north_tide", DOTA_TEAM_GOODGUYS, 0)
		Notifications:TopToAll({hero="npc_dota_hero_tidehunter", imagestyle="portrait", continue=true})
		Notifications:TopToAll({text="#north_tide", duration=5.0, style={color="#44BB44",  fontSize="50px;"}, continue=true})
		
	
			 table.insert(g_tideKillerArray,{
			 Killer_Team="North",
			 Game_time=GameRules:GetGameTime()/60+0.5,
			 })
			 tideKiller=tideKiller .. "N" .. math.floor(GameRules:GetGameTime()/60+0.5)
			 storage:SetTideKillers(tideKiller)
	end
	if  killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
	
		local spawnLocation = Entities:FindByName( nil, "south_spawn_left")
		local waypointlocation = Entities:FindByName ( nil, "south_wp_left_2")
		local creature
		creature = CreateUnitByName( "npc_dota_hero_spirit_breaker" ,spawnLocation:GetAbsOrigin() , true, nil, nil, DOTA_TEAM_GOODGUYS )
		if creature~=nil then
		
				local abil = creature:GetAbilityByIndex(0)
			
				local abil2 = creature:GetAbilityByIndex(1)

				local abil3 = creature:GetAbilityByIndex(2)

				local abil4 = creature:GetAbilityByIndex(3)
				if abil~= nil then
					abil:SetLevel(2)
				end
				if abil2~= nil then
					abil2:SetLevel(2)
				end
				if abil3~= nil then
					abil3:SetLevel(2)
				end
				if abil4~= nil then
					abil4:SetLevel(2)
				end
				
		
			RemoveWearables( creature )
			creature:SetRespawnsDisabled(true)
		end
		Notifications:TopToAll({hero="npc_dota_hero_tidehunter", imagestyle="portrait", continue=true})
		Notifications:TopToAll({text="#south_tide", duration=5.0, style={color="#44BB44",  fontSize="50px;"}, continue=true})
		 table.insert(g_tideKillerArray,{
			 Killer_Team="South",
			 Game_time=GameRules:GetGameTime()/60+0.5,
			 })
			  tideKiller=tideKiller .. "S" .. math.floor(GameRules:GetGameTime()/60+0.5)
			  storage:SetTideKillers(tideKiller)
	end
	
	
		Timers:CreateTimer( 300, function()
		g_TidehunterLevel = g_TidehunterLevel+1
			spawnTide()
		end)
		
		
		
  end

		
  
  
  
		if g_CoOpMode and killedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS and killedUnit:IsRealHero() then
			if RandomInt(1,g_PlayerCountSouth*2+5)<5 then
				g_CoOpDiffLevel=g_CoOpDiffLevel+1
				 --print( "g_CoOpDiffLevel: " .. g_CoOpDiffLevel )
			end
			g_CoOpHeroCount=g_CoOpHeroCount-1
			UpdateCoOpTables()
		end
		--distribute the gold to the team, add it to the empire gold and remove the origional bounty gold from the killer
		
	if killedUnit:IsRealHero() then



	
	local killerName="Unknown"
	local KilledName="Unknown"
	if killedUnit:GetPlayerID()~=nil then
		killedName=PlayerResource:GetPlayerName( killedUnit:GetPlayerID())
	end

		if killerEntity:IsRealHero() and killerEntity:GetTeamNumber()~=killedUnit:GetTeamNumber() then
			if killerEntity:GetPlayerID()~=nil then
				killerName=PlayerResource:GetPlayerName( killerEntity:GetPlayerID())
			end
			
			if killedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {hero=killerEntity:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0})
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text=killerName .. " ", duration=10.0, style={color="#AA3333",  fontSize="18px;"}, continue=true})
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="#got_kill_one", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {hero=killedUnit:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0, continue=true})
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text=killedName .. " ", duration=10.0, style={color="#66FF66",  fontSize="18px;"}, continue=true})
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="#got_kill_two", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text=tostring(math.floor(killedUnit:GetGoldBounty()/2+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="#got_kill_three", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text=tostring(math.floor(killedUnit:GetGoldBounty()/2+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
			
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="#got_kill_four", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				
				
				--badguy messager
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {hero=killerEntity:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0})
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text=killerName .. " ", duration=10.0, style={color="#66FF66",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS,{text="#got_kill_one", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {hero=killedUnit:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0, continue=true})
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text=killedName .. " ", duration=10.0, style={color="#AA3333",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS,{text="#got_kill_two", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS,{text=tostring(math.floor(killedUnit:GetGoldBounty()/2+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS,{text="#got_kill_three", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				
			Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text=tostring(math.floor(killedUnit:GetGoldBounty()/2+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
			
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text="#got_kill_four", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				else
				
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {hero=killerEntity:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0})
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text=killerName .. " ", duration=10.0, style={color="#AA3333",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text="#got_kill_one", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				
					Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {hero=killedUnit:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0, continue=true})
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text=killedName .. " ", duration=10.0, style={color="#66FF66",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text="#got_kill_two", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text=tostring(math.floor(killedUnit:GetGoldBounty()/2+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text="#got_kill_three", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				
			Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text=tostring(math.floor(killedUnit:GetGoldBounty()/2+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
			
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text="#got_kill_four", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})

			Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {hero=killerEntity:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0})
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text=killerName .. " ", duration=10.0, style={color="#66FF66",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS,{text="#got_kill_one", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				
	Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {hero=killedUnit:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0, continue=true})
	
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text=killedName .. " ", duration=10.0, style={color="#AA3333",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS,{text="#got_kill_two", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS,{text=tostring(math.floor(killedUnit:GetGoldBounty()/2+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
				
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS,{text="#got_kill_three", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				
			Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text=tostring(math.floor(killedUnit:GetGoldBounty()/2+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
			
				Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="#got_kill_four", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
				end
		else
				
				if killedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {hero=killedUnit:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0})
					Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text=killedName .. " ", duration=10.0, style={color="#AA3333",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="#died_one", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text=tostring(math.floor(killedUnit:GetGoldBounty()+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="#died_two", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
			
				Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {hero=killedUnit:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0})
					Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text=killedName .. " ", duration=10.0, style={color="#66FF66",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text="#died_one", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text=tostring(math.floor(killedUnit:GetGoldBounty()+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text="#died_two", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})

				else
					Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {hero=killedUnit:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0})
					Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text=killedName .. " ", duration=10.0, style={color="#AA3333",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text="#died_one", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text=tostring(math.floor(killedUnit:GetGoldBounty()+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_BADGUYS, {text="#died_two", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})

					Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {hero=killedUnit:GetName(), style={height="15px", width="20px",  marginRight="3px"}, imagestyle="landscape", duration=10.0})
					Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text=killedName .. " ", duration=10.0, style={color="#66FF66",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="#died_one", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text=tostring(math.floor(killedUnit:GetGoldBounty()+0.5)) .. " ", duration=10.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
					Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="#died_two", duration=10.0, style={color="#8888FF",  fontSize="18px;"}, continue=true})

				
				end
				
		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			if hero ~= nil and hero:IsOwnedByAnyPlayer() then
				if hero:GetTeamNumber() == killerEntity:GetTeamNumber() and killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + killedUnit:GetGoldBounty()/g_PlayerCountSouth, true)
					hero:SetGold(0, false)
					g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + (killedUnit:GetGoldBounty()/g_PlayerCountSouth)
				elseif hero:GetTeamNumber() == killerEntity:GetTeamNumber() and killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
					hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + killedUnit:GetGoldBounty()/g_PlayerCountNorth, true)
					hero:SetGold(0, false)
					g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + (killedUnit:GetGoldBounty()/g_PlayerCountNorth)
				end
			end
		end
		if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + killedUnit:GetGoldBounty()
		elseif killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + killedUnit:GetGoldBounty()
		end
				
	end	
		
  end


		  if killedUnit:IsRealHero() and killedUnit:GetPlayerID()~=nil then
				Timers:CreateTimer(.1, function() 
					killedUnit:SetTimeUntilRespawn(12+killedUnit:GetLevel()/2-1)
				end)
		end
		
		
  if killedUnit:GetGoldBounty() and killerEntity:IsRealHero() and killerEntity:IsOwnedByAnyPlayer() then
	
	local deathEffect = ParticleManager:CreateParticleForPlayer( "particles/basic_projectile/last_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, killedUnit,PlayerResource:GetPlayer(killerEntity:GetPlayerID()))
	Timers:CreateTimer(1, function() 
		ParticleManager:DestroyParticle(deathEffect,false)
	end)
	SendOverheadEventMessage(PlayerResource:GetPlayer(killerEntity:GetPlayerID()), OVERHEAD_ALERT_GOLD, killedUnit,  killedUnit:GetGoldBounty()/2, PlayerResource:GetPlayer(killerEntity:GetPlayerID()))
	 
		
		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			 --print(hero:GetName())
				if hero:GetTeamNumber() == killerEntity:GetTeamNumber() and killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS and killedUnit ~= nil and g_HeroGoldArray[hero:GetPlayerOwnerID()] ~= nil then
					hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + (killedUnit:GetGoldBounty()/g_PlayerCountSouth)/2, true)
					hero:SetGold(0, false)
					g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + (killedUnit:GetGoldBounty()/g_PlayerCountSouth)/2
				elseif hero:GetTeamNumber() == killerEntity:GetTeamNumber() and killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS and killedUnit ~= nil then
					hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + killedUnit:GetGoldBounty()/g_PlayerCountNorth/2, true)
					hero:SetGold(0, false)
					g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + (killedUnit:GetGoldBounty()/g_PlayerCountNorth)/2
				end
			end
		end
  
		if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + killedUnit:GetGoldBounty()
		elseif killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + killedUnit:GetGoldBounty()
		end
		killerEntity:SetGold(g_HeroGoldArray[killerEntity:GetPlayerOwnerID()] + killedUnit:GetGoldBounty()/2, true)
		killerEntity:SetGold(0, false)
		g_HeroGoldArray[killerEntity:GetPlayerOwnerID()]=g_HeroGoldArray[killerEntity:GetPlayerOwnerID()] + killedUnit:GetGoldBounty()/2

		if killedUnit:IsRealHero() then
		g_HeroGoldArray[killerEntity:GetPlayerOwnerID()]=g_HeroGoldArray[killerEntity:GetPlayerOwnerID()] + killedUnit:GetGoldBounty()/2
		else
			g_HeroGoldArray[killerEntity:GetPlayerOwnerID()]=g_HeroGoldArray[killerEntity:GetPlayerOwnerID()] - killedUnit:GetGoldBounty()/2
		end
		
		 --print("gold bounty for hero was " .. killedUnit:GetGoldBounty())
  end
  
  if killedUnit:IsRealHero() then
		  if killedUnit ~= nil then
				local continue=0
				for itemSlot = 0, 5, 1 do 
					local Item = killedUnit:GetItemInSlot( itemSlot )
					if Item ~= nil and  string.match(Item:GetName(), "trade_manifest") then
							continue=1
					end		
				end
				if continue==0 then
						local data =
							{
								Player_ID = killedUnit:GetPlayerID();
								Ally_ID = -1;
								x = 99999999;
								y =  99999999;
								z =  99999999;
							}
							FireGameEvent("Team_Cannot_Buy",data)
						else
							local data =
							{
								Player_ID = killedUnit:GetPlayerID();
								Ally_ID = allyteamnumber;
							}
							FireGameEvent("Team_Can_Buy",data)
						end
		end

  									
  ProjectileManager:ProjectileDodge(killedUnit)
  end

  --handle killing a streaker
	if killerEntity:IsRealHero() and killedUnit:IsOwnedByAnyPlayer() and g_CoOpMode==0 then
	  
	  if killedUnit:IsRealHero() then 
	  
	  if g_BattleModeRemaining>0 and  killerEntity:GetTeamNumber() ~= killedUnit:GetTeam() then

			if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				g_BattleModeSouthScore=g_BattleModeSouthScore+5
			elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				g_BattleModeNorthScore=g_BattleModeNorthScore+5
			end
		 
	  end
	  
	  
	  if g_HeroKills[killedUnit:GetPlayerID()] ~= nil and g_HeroKills[killedUnit:GetPlayerID()] > 2 then
		if killerEntity ~= nil and killerEntity:IsOwnedByAnyPlayer() then
			if killerEntity:GetTeamNumber() ~= killedUnit:GetTeam()  then
				killerEntity:SetGold(g_HeroGoldArray[killerEntity:GetPlayerOwnerID()] + g_HeroKills[killedUnit:GetPlayerID()] * 100, true)
				killerEntity:SetGold(0, false)
				g_HeroGoldArray[killerEntity:GetPlayerOwnerID()]=g_HeroGoldArray[killerEntity:GetPlayerOwnerID()] + g_HeroKills[killedUnit:GetPlayerID()] * 100
				if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + g_HeroKills[killedUnit:GetPlayerID()] * 100
					Notifications:BottomToAll({text="#streak_end_one_s", duration=5.0, style={color="#A70606",  fontSize="30px;"}})
					Notifications:BottomToAll({text=tostring(killerEntity:GetStreak() * 100) .. " ", duration=5.0, style={color="#FFD700",  fontSize="30px;"}, continue=true})
					Notifications:BottomToAll({text="#streak_end_two_s", duration=5.0, style={color="#A70606",  fontSize="30px;"}, continue=true})
				
				elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
					g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + g_HeroKills[killedUnit:GetPlayerID()] * 100
					Notifications:BottomToAll({text="#streak_end_one_n", duration=5.0, style={color="#A70606",  fontSize="30px;"}})
					Notifications:BottomToAll({text=tostring(killerEntity:GetStreak() * 100) .. " ", duration=5.0, style={color="#FFD700",  fontSize="30px;"}, continue=true})
					Notifications:BottomToAll({text="#streak_end_two_n", duration=5.0, style={color="#A70606",  fontSize="30px;"}, continue=true})
				
				end
			end
		end
			g_HeroKills[killedUnit:GetPlayerID()] = 0
	   end
-- handle awarding kill streak gold
if g_HeroKills[killerEntity:GetPlayerID()] ~=nil then
		g_HeroKills[killerEntity:GetPlayerID()] = g_HeroKills[killerEntity:GetPlayerID()] + 1
			print ("KILLEDKILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
			if killerEntity:GetStreak() > 2 and killerEntity:GetTeamNumber() ~= killedUnit:GetTeamNumber() and killerEntity:IsOwnedByAnyPlayer() then
				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
						if hero:GetTeamNumber() == killerEntity:GetTeam()  then
							hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + killerEntity:GetStreak() * 30, true)
							hero:SetGold(0, false)
							g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] + killerEntity:GetStreak() * 30
			
							if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
								g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + killerEntity:GetStreak() * 30
							elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
								g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + killerEntity:GetStreak() * 30
							end
						end
					end
				end
				killerEntity:SetGold(g_HeroGoldArray[killerEntity:GetPlayerOwnerID()] - killerEntity:GetStreak() * 30, true)
				killerEntity:SetGold(0, false)
				g_HeroGoldArray[killerEntity:GetPlayerOwnerID()]=g_HeroGoldArray[killerEntity:GetPlayerOwnerID()] - killerEntity:GetStreak() * 30
			
				if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth - killerEntity:GetStreak() * 30
					Notifications:BottomToAll({text="#streak_reward_one_n", duration=5.0, style={color="#A70606",  fontSize="18px;"}})
					Notifications:BottomToAll({text=tostring(killerEntity:GetStreak() * 30) .. " ", duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
					Notifications:BottomToAll({text="#streak_reward_two_n", duration=5.0, style={color="#A70606",  fontSize="18px;"}, continue=true})
				
				elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
					g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth - killerEntity:GetStreak() * 30
					Notifications:BottomToAll({text="#streak_reward_one_s", duration=5.0, style={color="#A70606",  fontSize="18px;"}})
					Notifications:BottomToAll({text=tostring(killerEntity:GetStreak() * 30) .. " ", duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
					Notifications:BottomToAll({text="#streak_reward_two_s", duration=5.0, style={color="#A70606",  fontSize="18px;"}, continue=true})
				
				end
			end
			if  killerEntity == killedUnit then
				Notifications:BottomToAll({text="#kill_self_one", duration=5.0, style={color="#A70606",  fontSize="18px;"}})
				Notifications:BottomToAll({text=tostring(killerEntity:GetGoldBounty()) .. " ", duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
				Notifications:BottomToAll({text="#kill_self_two", duration=5.0, style={color="#A70606",  fontSize="18px;"}, continue=true})

	
			end
		end
		--handle vengance
		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() then
					if false == hero:IsAlive() and false == hero:IsIllusion() and hero:GetTeamNumber() == killerEntity:GetTeam() and killerEntity ~= hero and killerEntity:GetTeam() ~= killedUnit:GetTeam() and hero:GetPlayerOwnerID() ~= -1 and killerEntity:IsOwnedByAnyPlayer() then
						local bounty=hero:GetGoldBounty()
						
						killerEntity:SetGold(g_HeroGoldArray[killerEntity:GetPlayerOwnerID()] + bounty/4, true)
						hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + bounty/2, true)
						g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()]+ bounty/2
						g_HeroGoldArray[killerEntity:GetPlayerOwnerID()]=g_HeroGoldArray[killerEntity:GetPlayerOwnerID()] + bounty/4
						Notifications:BottomToAll({text=PlayerResource:GetPlayerName( killerEntity:GetPlayerID()) .. " ", duration=5.0, style={color="#FF9955",  fontSize="18px;"}})
						Notifications:BottomToAll({text="#avenge_one", duration=5.0, style={color="#FF9900",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text=PlayerResource:GetPlayerName( hero:GetPlayerID()) .. " ", duration=5.0, style={color="#FF9955",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text="#avenge_two", duration=5.0, style={color="#FF9900",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text=tostring(math.floor(bounty/4+0.5)) .. " ", duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text="#avenge_three", duration=5.0, style={color="#FF9900",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text=tostring(math.floor(bounty/2+0.5)) .. " ", duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text="#avenge_four", duration=5.0, style={color="#FF9900",  fontSize="18px;"}, continue=true})
						if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + g_EmpireGoldCount * bounty*3/4
						elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + g_EmpireGoldCount * bounty*3/4
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

		print ("g_PlayerCountSouth: " .. g_PlayerCountSouth .. " -- good dead: " .. goodDead)
		print ("g_PlayerCountNorth: " .. g_PlayerCountNorth .. " -- bad dead: " .. badDead)
		if goodDead == g_PlayerCountSouth and killedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS and g_PlayerCountSouth>2 then
			Notifications:TopToAll({text="#team_wipe_south", duration=5.0, style={color="#44BB44",  fontSize="50px;"}, continue=true})	
		end
		if badDead == g_PlayerCountNorth and killedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS and g_PlayerCountNorth>2 then
			Notifications:TopToAll({text="#team_wipe_north", duration=5.0, style={color="#44BB44",  fontSize="50px;"}, continue=true})
		end
		
		
	  end
	end
end


	function reapplyAllBows( hero )
	Timers:CreateTimer( .5, function()
		if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 then
					if hero:IsHero() or hero:HasInventory() then 
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
									 --print( "bow found." )
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
									 --print( "bow found." )
								end
							end
						end
						
						end
					end
					end)
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
				casterUnit = hero
            end
		end
    end
	
local itemName = keys.itemname 


 --print(g_ItemCodeLookUp[itemName])
	  storage:AddToPlayerItemHist(casterUnit:GetPlayerID(),{item=itemName, time=math.floor(GameRules:GetGameTime()/60+0.5)})--math.floor(GameRules:GetGameTime()/60+0.5) .. g_ItemCodeLookUp[itemName])
  


  -- The name of the item purchased
  
  print ( '[BAREBONES] Item Purchased was ' .. itemName)
  local herogold = casterUnit:GetGold()
  g_HeroGoldArray[casterUnit:GetPlayerOwnerID()]=herogold
  
  local sellItBack = false
			for itemSlot = 0, 14, 1 do 
				local Item = casterUnit:GetItemInSlot( itemSlot )
				if Item ~= nil and 
				string.match(Item:GetName(), itemName) and
				string.match(Item:GetName(),"doubled") then
					sellItBack=true;
					
				end
			end
			if sellItBack then
				for itemSlot = 0, 14, 1 do 
					local Item = casterUnit:GetItemInSlot( itemSlot )
					if Item ~= nil and string.match( itemName, Item:GetName()) then
						casterUnit:SetGold(herogold + GetItemCost(Item:GetName()), true)
						casterUnit:SetGold(0, false)
						g_HeroGoldArray[casterUnit:GetPlayerOwnerID()] = herogold + GetItemCost(Item:GetName())
						RemoveAndDeleteItem(casterUnit,Item)
							 Notifications:Top(casterUnit:GetPlayerID(), {text="#max_items_1", duration=5.0, style={color="#800000",  fontSize="50px;"}})
							  Notifications:Top(casterUnit:GetPlayerID(), {image="file://{images}/items/".. string.sub (itemName, 6)  ..".png", style={height="65px", width = "150px"} , continue=true})
							  Notifications:Top(casterUnit:GetPlayerID(), {text="#max_items_2", duration=5.0, style={color="#800000",  fontSize="50px;"}})
					end
				end
			end
	
	
	if string.match(itemName, "tower_debuff") then
		debuffTowers(casterUnit, itemName)
		fixBackpack(casterUnit)
	end
	if string.match(itemName, "tower_healer") then
		healTowers(casterUnit, itemName)
		fixBackpack(casterUnit)
	end
	if string.match(itemName, "nut_spawner") then
		spawnNuts(casterUnit, itemName)
		fixBackpack(casterUnit)
	end
	
	if GameRules:GetGameTime() < 300 and  string.match(itemName, "lorne") then
		g_LorneItemBuyers = g_LorneItemBuyers + 1
		if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
			for itemSlot = 0, 14, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
							local Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
							if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
								RemoveAndDeleteItem(casterUnit,Item)
							end
					end
			end
		end	
	end

	if g_LorneItemBuyers == g_PlayerCount and g_PlayerCount ~= 0 then
		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			if hero ~= nil and hero:IsOwnedByAnyPlayer() then
				hero:SetGold(80000, true)
				hero:AddExperience(80000, true,false)
				g_HeroGoldArray[hero:GetPlayerOwnerID()]=80000
			end
		end
	end

 
end


function fixBackpack(casterUnit)

	if (casterUnit:IsHero() or casterUnit:HasInventory()) and heroname ~= casterUnit:GetName() then 
    	for itemSlot = 0, 14, 1 do 
            if casterUnit ~= nil then
                local Item = casterUnit:GetItemInSlot( itemSlot )
				if Item ~= nil and string.match(Item:GetName(), "backpack_stuffer")  then
					RemoveAndDeleteItem(casterUnit,Item)
					local newItem = CreateItem("item_fluff", casterUnit, casterUnit)
					casterUnit:AddItem(newItem)
				
				elseif itemSlot > 5 and itemSlot <9 then
					RemoveAndDeleteItem(casterUnit,Item)
				else
					local newItem = CreateItem("item_fluff", casterUnit, casterUnit)
					casterUnit:AddItem(newItem)
				end
				if itemSlot > 5 and itemSlot <9 then
					local newItem = CreateItem("item_backpack_stuffer", casterUnit, casterUnit)
					casterUnit:AddItem(newItem)
				end
            end
		end
    end
	if casterUnit:IsHero() or casterUnit:HasInventory() then 
		for itemSlot = 0, 14, 1 do 
			if casterUnit ~= nil then
				local activateItem = casterUnit:GetItemInSlot( itemSlot )
				if activateItem ~= nil and string.match(activateItem:GetName(), "fluff") then
					RemoveAndDeleteItem(casterUnit,activateItem)
				end
			end
		end
	end
	
end

function become_boat(casterUnit, heroname)
     --print('[ItemFunctions] become_bristleback started!')
	
    local a = 0
    local plyID = casterUnit:GetPlayerOwnerID()
    local itemlist = {}
	local droppeditemlist = {}
	local itemstacks = {}
	local savedGold = g_HeroGoldArray[casterUnit:GetPlayerOwnerID()]
	
	for itemSlot = 0, 14, 1 do 
		  if casterUnit ~= nil then
                local Item = casterUnit:GetItemInSlot( itemSlot )
				if Item ~= nil and string.match(Item:GetName(), "scroll") then

						RemoveAndDeleteItem(casterUnit,Item)
					end
				end
	end
	
    if (casterUnit:IsHero() or casterUnit:HasInventory()) and heroname ~= casterUnit:GetName() then 
    	for itemSlot = 0, 14, 1 do 
            if casterUnit ~= nil then
                local Item = casterUnit:GetItemInSlot( itemSlot )
				if Item ~= nil and not string.match(Item:GetName(), "boat") and not string.match(Item:GetName(), "scroll") and not string.match(Item:GetName(), "trade_") and not string.match(Item:GetName(), "contract") then

					itemlist[itemSlot] = Item:GetName()
					 itemstacks[itemSlot]  = Item:GetCurrentCharges()
						RemoveAndDeleteItem(casterUnit,Item)
				elseif Item ~= nil and (string.match(Item:GetName(), "boat")  or string.match(Item:GetName(), "scroll") or string.match(Item:GetName(), "trade_") or string.match(Item:GetName(), "contract")) then

					itemlist[itemSlot] = "item_fluff"
					RemoveAndDeleteItem(casterUnit,Item)
				elseif itemSlot > 5 and itemSlot <9 then

					itemlist[itemSlot] = "item_backpack_stuffer"
				else

					itemlist[itemSlot] = "item_fluff"
					if string.match(heroname,"zuus") and itemSlot==0 then
						itemlist[itemSlot]="item_hull_sail_one_combo_bow"
					end
				end
            end
		end
    end
	for _,item in pairs( Entities:FindAllByName("item_*")) do
								 --print("found an item")

				if item~=nil and item:GetName()~=nil and item:GetName()~=""then
				 --print("found an item with a name")
					if item:GetPurchaser() == casterUnit then
						 --print("insertingItem")
						table.insert(droppeditemlist, item)
					end
				end
	end
	if heroname ~= casterUnit:GetName() then
			local gold = casterUnit:GetGold()
			local xp = casterUnit:GetCurrentXP()
			 --print("calling replace hero")
			g_BoatJustBaught=1
			local hero = PlayerResource:ReplaceHeroWith( casterUnit:GetPlayerID(), heroname , 0, 0 )
			SendToServerConsole( "dota_combine_models 0" ) 
			casterUnit:RemoveSelf()
				 --print("called replace hero")
				if hero ~= nil then
					local id = hero:GetPlayerOwnerID()
					
					if id == plyID then
					RemoveWearables( hero )
					AttachCosmetics(hero)
					fixAbilities(hero)
					if string.match(hero:GetName(),"razor") then
						hero:SetMana(0)
					end
						 --print("this is the new hero, put items in " .. hero:GetName())
						hero:SetGold(gold, true)
						hero:SetGold(0, false)
						g_HeroGoldArray[hero:GetPlayerOwnerID()]=gold
						hero:AddExperience(xp, false, false)
						if hero:GetLevel() >= 14 and  g_LorneItemBuyers ~= g_PlayerCount then
							for abilitySlot = 0, 5, 1 do
								local ability = hero:GetAbilityByIndex(abilitySlot)
								if ability then 
									ability:SetLevel(ability:GetMaxLevel())
								end
							end
						end
						for b = 0, 14, 1 do 
							local newItem = CreateItem(itemlist[b], hero, hero)
							if newItem ~= nil then                   -- makes sure that the item exists and making sure it is the correct item
								
								if string.match(heroname,"vengefulspirit") or string.match(heroname,"enigma") or string.match(heroname,"bane") then
									if b==4 then
										

										if hero:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
											local newItem3 = CreateItem("item_contract_easy_mid_bot", hero, hero)
											local MissionLoc
												for _,mission in pairs(  Entities:FindAllByName( "npc_dota_buil*")) do
														if  string.match(mission:GetUnitName(),"mid_bot") then
															MissionLoc=mission
														end
												end
											local data =
															{
																Player_ID = hero:GetPlayerID();
																Ally_ID = 0;
																x =  MissionLoc:GetAbsOrigin().x;
																y =  MissionLoc:GetAbsOrigin().y;
																z =  MissionLoc:GetAbsOrigin().z;
															}
															FireGameEvent("Team_Cannot_Buy",data) 
															hero:AddItem(newItem3)
															local newItem2 = CreateItem("item_trade_manifest", hero, hero)
															local newItem3 = CreateItem("item_backpack_stuffer", hero, hero)
											local newItem4 = CreateItem("item_backpack_stuffer", hero, hero)
											local newItem5 = CreateItem("item_backpack_stuffer", hero, hero)
											
												hero:AddItem(newItem2)
												hero:AddItem(newItem3)
												hero:AddItem(newItem4)
												hero:AddItem(newItem5)
										else
											local newItem3 = CreateItem("item_contract_easy_mid_top", hero, hero)
											local MissionLoc
												for _,mission in pairs(  Entities:FindAllByName( "npc_dota_buil*")) do
														if  string.match(mission:GetUnitName(),"mid_top") then
															MissionLoc=mission
														end
												end
											local data =
											{
												Player_ID = hero:GetPlayerID();
												Ally_ID = 0;
												x =  MissionLoc:GetAbsOrigin().x;
												y =  MissionLoc:GetAbsOrigin().y;
												z =  MissionLoc:GetAbsOrigin().z;
											}
											FireGameEvent("Team_Cannot_Buy",data)
											hero:AddItem(newItem3)
											local newItem2 = CreateItem("item_trade_manifest", hero, hero)
											local newItem3 = CreateItem("item_backpack_stuffer", hero, hero)
											local newItem4 = CreateItem("item_backpack_stuffer", hero, hero)
											local newItem5 = CreateItem("item_backpack_stuffer", hero, hero)
											
												hero:AddItem(newItem2)
												hero:AddItem(newItem3)
												hero:AddItem(newItem4)
												hero:AddItem(newItem5)
										end
									
									
									end
									
									elseif  b==5 then
											local data =
											{
												Player_ID = hero:GetPlayerID();
												Ally_ID = -1;
												x = 99999999;
												y =  99999999;
												z =  99999999;
											}
											FireGameEvent("Team_Cannot_Buy",data)
								end
								
								if (string.match(heroname,"vengefulspirit") or string.match(heroname,"enigma") or string.match(heroname,"bane")) and (b==13 or b==14) and not string.match(itemlist[b],"fluff") then
										CreateItemOnPositionSync(hero:GetOrigin(), newItem)
										 --print("ejecting")
								end
								if (string.match(heroname,"vengefulspirit") or string.match(heroname,"enigma") or string.match(heroname,"bane")) and  string.match(itemlist[b],"backpack") then
									
								elseif string.match(itemlist[b],"fluff") then
									hero:AddItem(newItem)
								elseif not  string.match(itemlist[b],"fluff") then
									hero:AddItem(newItem)
								else
										RemoveAndDeleteItem(hero,newItem)
								end
								
								if itemstacks[b] then
									newItem:SetCurrentCharges(itemstacks[b])
								end
							end
						end
						if hero:IsHero() or hero:HasInventory() then 
							for itemSlot = 0, 14, 1 do 
								if hero ~= nil then
									local activateItem = hero:GetItemInSlot( itemSlot )
									if activateItem ~= nil and string.match(activateItem:GetName(), "bow") then
										 --print("activating " .. activateItem:GetName())
										activateItem:ToggleAbility()
										
									elseif activateItem ~= nil and string.match(activateItem:GetName(), "fluff") then
										RemoveAndDeleteItem(hero,activateItem)
									end
								end
							end
						end
						
						for itemnum= 0, #droppeditemlist, 1 do
							PrintTable(droppeditemlist)
							if droppeditemlist[itemnum] ~= nil then
								local DroppedItem=droppeditemlist[itemnum]
									DroppedItem:SetPurchaser(hero)
							end
						end
						
					end
				end
		
		else
			 if casterUnit:IsHero() or casterUnit:HasInventory() then 
			for itemSlot = 0, 14, 1 do 
				if casterUnit ~= nil then
					local Item = casterUnit:GetItemInSlot( itemSlot )
					
					if Item ~= nil and  string.match(Item:GetName(), "boat") then
						RemoveAndDeleteItem(casterUnit,Item)
					end
				end
			end
		end
		
	end
	Timers:CreateTimer( 1, function()
		local data ={}
		storage:AddToPlayerBoatHist(plyID,{item=storage:GetHeroName(plyID) , time= math.floor(GameRules:GetGameTime()/60+0.5)})
					 --print(storage:GetHeroName(plyID) .. math.floor(GameRules:GetGameTime()/60+0.5))
		
		
	FireGameEvent("Boat_Spawned",data)
	end)
	Timers:CreateTimer( 3, function()
		local data ={}
	FireGameEvent("Boat_Spawned",data)
	end)
	Timers:CreateTimer( 5, function()
		local data ={}
	FireGameEvent("Boat_Spawned",data)
	end)
	Timers:CreateTimer( 7, function()
		local data ={}
	FireGameEvent("Boat_Spawned",data)
	end)
end


function fixAbilities(hero)
local ultimate = ""
local ultslot= 3
	for abilitySlot = 3, 11, 1 do 
		if hero:GetAbilityByIndex(abilitySlot) ~= nil  then
			if hero:GetAbilityByIndex(abilitySlot):GetName()~= nil then
				abil =  hero:GetAbilityByIndex(abilitySlot):GetName()
				 --print(abil)
				 --print(abilitySlot)
				
				 --print("max level")
				 --print(hero:GetAbilityByIndex(abilitySlot):GetMaxLevel())
					if abilitySlot==3  then
						ultimate =abil
					elseif hero:GetAbilityByIndex(abilitySlot):GetMaxLevel()==3  then
						ultslot = abilitySlot
					end
					hero:RemoveAbility(abil)
			end
		end
	end
	
	for abilitySlot = 3, 5, 1 do 
		if abilitySlot==5 then
				 --print(ultimate)
				hero:AddAbility(ultimate)
		else
				hero:AddAbility("generic_hidden")
		end
	end
	
	
		 --print("printing all abilities")
	for abilitySlot = 0, 11, 1 do 
		if hero:GetAbilityByIndex(abilitySlot) ~= nil  then
			abil =  hero:GetAbilityByIndex(abilitySlot):GetName()
			 --print(abilitySlot)
				 --print(abil)
		end
	end
		
	for itemSlot = 0, 14, 1 do 
		  if hero ~= nil then
                local Item = hero:GetItemInSlot( itemSlot )
				if Item ~= nil and string.match(Item:GetName(), "scroll") then
						RemoveAndDeleteItem(hero,Item)
					end
				end
	end
		
end


function debuffTowers(casterUnit)
 --print('[ItemFunctions] dubuffTower started!')
	if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		g_SpyCountSouth = g_SpyCountSouth + 1
	elseif  casterUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		g_SpyCountNorth = g_SpyCountNorth + 1
	end
	g_SpyAnnouncmentFlag = 1
	for _,curTower in pairs( Entities:FindAllByClassname( "npc_dota_tow*")) do
			--	  --print('[ItemFunctions] dubuffTower found a tower!')
				local curArmor = curTower:GetPhysicalArmorBaseValue()
				if curTower ~= nil and curTower:IsTower() then
			--	 --print('[ItemFunctions] dubuffTower really found a tower! cur armor is' .. curArmor)
					if curTower:GetTeamNumber() ~=  casterUnit:GetTeamNumber()  then
						curTower:SetPhysicalArmorBaseValue(curArmor-1.0)
				--		 --print('[ItemFunctions] dubuffTower found an enamy tower.  new armor is' .. curArmor-1.0)
					end
				end
			
	end
end
function healTowers(casterUnit)
 --print('[ItemFunctions] healTowers started!')
	for _,curTower in pairs( Entities:FindAllByClassname( "npc_dota_tow*")) do
				--  --print('[ItemFunctions] healTowers found a tower!')
				local curArmor = curTower:GetPhysicalArmorBaseValue()
				if curTower ~= nil and curTower:IsTower() then
				-- --print('[ItemFunctions] healTowers really found a tower!')
					if curTower:GetTeamNumber() ==  casterUnit:GetTeamNumber()  then
						local hp1 = (curTower:GetMaxHealth()-curTower:GetHealth())*.1
						curTower:SetHealth(curTower:GetHealth()+hp1)
				--		 --print('[ItemFunctions] healTowers found an ally tower.')
					end
				end
			
	end
end
function spawnNuts(casterUnit, itemName)
	if casterUnit:IsHero() or casterUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 14, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
	        	if casterUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
                		local Item = casterUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
                		if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
							RemoveAndDeleteItem(casterUnit,Item)
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
				creature:CreatureLevelUp(g_TidehunterLevel)
                i = i + 1
        end
		Notifications:TopToAll({hero="npc_dota_hero_tidehunter", imagestyle="portrait", continue=true})
		Notifications:TopToAll({text="#spawn_tide", duration=5.0, style={color="#80BB44",  fontSize="50px;"}, continue=true})
		
			
end

function spawnCop()
 spawnLocation = Entities:FindByName( nil, "cop_spawn")
         i = 0
        while  1>i do
					creature = CreateUnitByName( "npc_dota_creature_cop" , spawnLocation:GetAbsOrigin() + Vector(-300 + i * 100,0,0), true, nil, nil, 4 )
				creature:CreatureLevelUp(g_TidehunterLevel)
                i = i + 1
        end
			
end



function RemoveWearables( hero )
      -- Setup variables

end


function UnstickPlayer(eventSourceIndex, args)
 --print("in unstick")
	  local pID = args.PlayerID

    for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			 --print("unsticking" .. hero:GetName())
			local herogold = hero:GetGold()
			if herogold>0 then
				if hero:GetPlayerID() == pID then
					if false == hero:HasModifier("pergatory_3") then
						 if g_OlderHeroLocations[hero]~= nil and ((g_OlderHeroLocations[hero] - hero:GetOrigin()):Length() <600 and (g_OlderHeroLocations[hero] - hero:GetOrigin()):Length()>50) then
							local vecorig = g_OlderHeroLocations[hero]
							hero:SetOrigin(vecorig)
							stopPhysics(hero)
							else
								hero:SetOrigin(hero:GetOrigin()+RandomVector( RandomFloat( 200, 300 )))
						end
					end
					local item = CreateItem( "item_spawn_stunner", hero, hero)
					item:ApplyDataDrivenModifier(hero, hero, "pergatory_3", nil)
					RemoveAndDeleteItem(hero,item)
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
                 --print(string.rep ("\t", indent)..tostring(v)..":")
                PrintTable (value, indent + 2, done)
            elseif type(value) == "userdata" and not done[value] then
                done [value] = true
                 --print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
            else
                if t.FDesc and t.FDesc[v] then
                     --print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
                else
                     --print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
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

--Ported Convoys code!

function CheckInvFull(hero,NumNewItems)
	local numItems=0
	for itemSlot = 0, 5, 1 do 
		if hero ~= nil then
			local Item = hero:GetItemInSlot( itemSlot )
			if Item ~= nil then
				numItems=numItems+1
			end
		end
	end
	return numItems==7-NumNewItems
end

function HasQuest(hero)
	local numItems=0
	for itemSlot = 0, 5, 1 do 
		if hero ~= nil then
			local Item = hero:GetItemInSlot( itemSlot )
			if Item ~= nil and string.match(Item:GetName(),"contract") then
				return true
			end
		end
	end
	return false
end


function buyBoat(eventSourceIndex, args)
	
	
	local pID = args.PlayerID
	
	local teamNum=PlayerResource:GetTeam(pID)
	local casterUnit
	PrintTable(args)
	--get list of heroes on this team
	local i=0
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
				if hero:GetPlayerID() == pID then
					casterUnit= hero
					 --print("assignedHero")
				end
		end
	end
	if g_TugMode==1 then
		Notifications:Top(casterUnit:GetPlayerID(), {text="#tug_buy_boat", duration=3.0, style={color="#800000",  fontSize="70px;"}})

		return
	end

	local itemName=args.text
	if casterUnit~=nil then
	
		local cost=tonumber(args.cost)
		local herogold = casterUnit:GetGold()
		local casterPos = casterUnit:GetAbsOrigin()
		
		local targetUnitOne = Entities:FindByName( nil, "south_boat_shop")
		local targetUnitTwo = Entities:FindByName( nil, "north_boat_shop")
		local directionOne =  casterPos - targetUnitOne:GetAbsOrigin()
		local directionTwo =  casterPos - targetUnitTwo:GetAbsOrigin()
		
		 --print(itemName .. " vs " .. casterUnit:GetName())
		if (directionOne:Length() < 1000 or directionTwo:Length() < 1000) and herogold>cost-1 and not string.match(casterUnit:GetName(),itemName )  and (GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS or  g_LorneItemBuyers == g_PlayerCount) then
			boat=true
			casterUnit:SetGold(herogold-cost,true)
			casterUnit:SetGold(0,false)
			g_HeroGoldArray[casterUnit:GetPlayerOwnerID()]=herogold-cost
			sellBoat(casterUnit)
			EmitSoundOnClient("General.Buy",PlayerResource:GetPlayer(pID))
		Timers:CreateTimer( .15, function()
	
		if string.match(itemName,"disruptor") then
			become_boat(casterUnit, "npc_dota_hero_disruptor")
			elseif string.match(itemName,"ursa") then
				become_boat(casterUnit, "npc_dota_hero_ursa")
			elseif string.match(itemName,"meepo") then
				become_boat(casterUnit, "npc_dota_hero_meepo")
			elseif string.match(itemName,"tidehunter") then
				become_boat(casterUnit, "npc_dota_hero_tidehunter")
			elseif string.match(itemName,"ancient_apparition") then
				become_boat(casterUnit, "npc_dota_hero_ancient_apparition")
			elseif string.match(itemName,"winter_wyvern") then
				become_boat(casterUnit, "npc_dota_hero_winter_wyvern")
			elseif string.match(itemName,"storm_spirit") then
				become_boat(casterUnit, "npc_dota_hero_storm_spirit")
			elseif string.match(itemName,"brewmaster") then
				become_boat(casterUnit, "npc_dota_hero_brewmaster")
			elseif string.match(itemName,"ember_spirit") then
				become_boat(casterUnit, "npc_dota_hero_ember_spirit")
			elseif string.match(itemName,"slark") then
				become_boat(casterUnit, "npc_dota_hero_slark")
			elseif string.match(itemName,"jakiro") then
				become_boat(casterUnit, "npc_dota_hero_jakiro")
			elseif string.match(itemName,"lion") then
				become_boat(casterUnit, "npc_dota_hero_lion")
			elseif string.match(itemName,"tusk") then
				become_boat(casterUnit, "npc_dota_hero_tusk")
			elseif string.match(itemName,"visage") then
				become_boat(casterUnit, "npc_dota_hero_visage")
			elseif string.match(itemName,"nevermore") then
				become_boat(casterUnit, "npc_dota_hero_nevermore")
			elseif string.match(itemName,"rattletrap") then
				become_boat(casterUnit, "npc_dota_hero_rattletrap")
			elseif string.match(itemName,"batrider") then
				become_boat(casterUnit, "npc_dota_hero_batrider")
			elseif string.match(itemName,"sniper") then
				become_boat(casterUnit, "npc_dota_hero_sniper")
			elseif string.match(itemName,"windrunner") then
				become_boat(casterUnit, "npc_dota_hero_windrunner")
			elseif string.match(itemName,"crystal") then
				become_boat(casterUnit, "npc_dota_hero_crystal_maiden")
			elseif string.match(itemName,"phantom") then
				become_boat(casterUnit, "npc_dota_hero_phantom_lancer")
			elseif string.match(itemName,"pugna") then
				become_boat(casterUnit, "npc_dota_hero_pugna")
			elseif string.match(itemName,"razor") then
				become_boat(casterUnit, "npc_dota_hero_razor")
			elseif string.match(itemName,"vengefulspirit") then
				become_boat(casterUnit, "npc_dota_hero_vengefulspirit")
			elseif string.match(itemName,"enigma") then
				become_boat(casterUnit, "npc_dota_hero_enigma")
			elseif string.match(itemName,"bane") then
				become_boat(casterUnit, "npc_dota_hero_bane")
		end
		
	end)
	elseif GameRules:State_Get() ~= 	DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		Notifications:Top(casterUnit:GetPlayerID(), {text="#cant_buy", duration=3.0, style={color="#800000",  fontSize="50px;"}})
		EmitSoundOnClient("ui.contract_fail",PlayerResource:GetPlayer(pID))
	elseif(directionOne:Length() > 599 and directionTwo:Length() > 599) then
		
	Notifications:Top(casterUnit:GetPlayerID(), {text="#to_base", duration=3.0, style={color="#800000",  fontSize="50px;"}})
	EmitSoundOnClient("ui.contract_fail",PlayerResource:GetPlayer(pID))
	
	else
		EmitSoundOnClient("ui.contract_fail",PlayerResource:GetPlayer(pID)) 
		end
	end
end
function ChooseDiff(eventSourceIndex, args)
g_CoOpDiffSetting=args.diff
 --print("diff set to " .. args.diff) 
end

function buyItem(eventSourceIndex, args)
	local pID = args.PlayerID
	local teamNum=PlayerResource:GetTeam(pID)
	local heroBuying
	PrintTable(args)
	--get list of heroes on this team
	local i=0
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			if hero:GetPlayerID() == pID then
				heroBuying= hero
				 --print("assignedHero")
			end
		end
	end
	
	if heroBuying~=nil and heroBuying:IsAlive() then
		local cost=tonumber(args.cost)
		local herogold = heroBuying:GetGold()
		if string.match(args.text,"spy") then
			if herogold>cost-1 then
				debuffTowers(heroBuying)
				heroBuying:SetGold(herogold-cost,true)
				heroBuying:SetGold(0,false)
				g_HeroGoldArray[heroBuying:GetPlayerOwnerID()]=herogold-cost
			else
				EmitSoundOnClient("ui.contract_fail",PlayerResource:GetPlayer(pID))
			end
			return
		elseif string.match(args.text,"heals") then
			if herogold>cost-1 then
				healTowers(heroBuying)
				heroBuying:SetGold(herogold-cost,true)
				heroBuying:SetGold(0,false)
				g_HeroGoldArray[heroBuying:GetPlayerOwnerID()]=herogold-cost
			else
				EmitSoundOnClient("ui.contract_fail",PlayerResource:GetPlayer(pID))
			end
			return
		end

		 local tempItem = CreateItem("item_" .. tostring(args.text), hero, hero)
		 local continue=false
		 if tempItem:IsStackable() then
			 for itemSlot = 0, 5, 1 do 
				local Item = heroBuying:GetItemInSlot( itemSlot )
				if Item ~= nil and Item:GetName()==tempItem:GetName()  then
					continue=true
				end
			end
		end
		if continue or not CheckInvFull(heroBuying,1) then

			if herogold>cost-1 then
				EmitSoundOnClient("General.Buy",PlayerResource:GetPlayer(pID))
				 --print(tempItem:GetName())
				heroBuying:AddItem(tempItem)
				heroBuying:SetGold(herogold-cost,true)
				heroBuying:SetGold(0,false)
				g_HeroGoldArray[heroBuying:GetPlayerOwnerID()]=herogold-cost
			else
				EmitSoundOnClient("ui.contract_fail",PlayerResource:GetPlayer(pID))
			end
		end
	end 
end

function GiveEasy(eventSourceIndex, args)
	 --print("in give easy")
	local pID = args.PlayerID
	local teamNum=PlayerResource:GetTeam(pID)
	local heroBuying
	--get list of heroes on this team
	local i=0
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
				if hero:GetPlayerID() == pID then
					heroBuying= hero
					 --print("assignedHero")
				end
		end
	end
	if heroBuying~=nil and heroBuying:IsAlive() and not CheckInvFull(heroBuying,1) and not HasQuest(heroBuying) then
		local nearestShop= Entities:FindByNameNearest("npc_dota_buil*",heroBuying:GetOrigin(),0)
		local casterPos = heroBuying:GetAbsOrigin()
		local ShopDist =  casterPos - nearestShop:GetAbsOrigin()
		if ShopDist:Length()<600 then
			 --print("inrange")
			local missionPool
			if heroBuying:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
				 --print(nearestShop:GetUnitName())
				PrintTable(g_EasyMissionsSouth[nearestShop:GetUnitName()])
				missionPool=g_EasyMissionsSouth[nearestShop:GetUnitName()]
				else
				missionPool=g_EasyMissionsNorth[nearestShop:GetUnitName()]
			end
			local chosenMission=missionPool[RandomInt( 1, #missionPool )]
			newItem = CreateItem(chosenMission, hero, hero)
			if newItem ~= nil then -- makes sure that the item exists and making sure it is the correct item
				 --print("Item Is: " .. newItem:GetName() )
				
				heroBuying:AddItem(newItem)
				EmitSoundOnClient("ui.npe_objective_given",PlayerResource:GetPlayer(heroBuying:GetPlayerID()))
				
					 --print(newItem)
					local itemStrippedEasy=string.gsub(newItem:GetName(),"item_contract_easy","")
					local itemStrippedMedium=string.gsub(newItem:GetName(),"item_contract_medium","")
					local itemStrippedHard=string.gsub(newItem:GetName(),"item_contract_hard","")
					local MissionLoc
						for _,mission in pairs(  Entities:FindAllByName( "npc_dota_buil*")) do
								if  string.match(mission:GetUnitName(),itemStrippedEasy) or string.match(mission:GetUnitName(),itemStrippedMedium) or string.match(mission:GetUnitName(),itemStrippedHard)then
									MissionLoc=mission
								end
						end
								
				
				
				local data =
				{
					Player_ID = heroBuying:GetPlayerID();
					Ally_ID = 0;
					x =  MissionLoc:GetAbsOrigin().x;
					y =  MissionLoc:GetAbsOrigin().y;
					z =  MissionLoc:GetAbsOrigin().z;
				}
				FireGameEvent("Team_Cannot_Buy",data) 
			end
		end
	end
end

function GiveMedium(eventSourceIndex, args)
		 --print("in give easy")
	local pID = args.PlayerID
	local teamNum=PlayerResource:GetTeam(pID)
	local heroBuying
	--get list of heroes on this team
	local i=0
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
				if hero:GetPlayerID() == pID then
					heroBuying= hero
					 --print("assignedHero")
				end
		end
	end
	if heroBuying~=nil and heroBuying:IsAlive() and not CheckInvFull(heroBuying,1) and not HasQuest(heroBuying) then
		local nearestShop= Entities:FindByNameNearest("npc_dota_buil*",heroBuying:GetOrigin(),0)
		local casterPos = heroBuying:GetAbsOrigin()
		local ShopDist =  casterPos - nearestShop:GetAbsOrigin()
		if ShopDist:Length()<600 then
			 --print("inrange")
			local missionPool
			if heroBuying:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
				missionPool=g_HardMissionsSouth[nearestShop:GetUnitName()]
				else
				missionPool=g_HardMissionsNorth[nearestShop:GetUnitName()]
			end
			local chosenMission=missionPool[RandomInt( 1, #missionPool )]
			newItem = CreateItem(chosenMission, hero, hero)
			if newItem ~= nil then -- makes sure that the item exists and making sure it is the correct item
				 --print("Item Is: " .. newItem:GetName() )
				
				heroBuying:AddItem(newItem)
				EmitSoundOnClient("ui.npe_objective_given",PlayerResource:GetPlayer(heroBuying:GetPlayerID()))
					 --print(newItem)
					local itemStrippedEasy=string.gsub(newItem:GetName(),"item_contract_easy","")
					local itemStrippedMedium=string.gsub(newItem:GetName(),"item_contract_medium","")
					local itemStrippedHard=string.gsub(newItem:GetName(),"item_contract_hard","")
					local MissionLoc
						for _,mission in pairs(  Entities:FindAllByName( "npc_dota_buil*")) do
								if  string.match(mission:GetUnitName(),itemStrippedEasy) or string.match(mission:GetUnitName(),itemStrippedMedium) or string.match(mission:GetUnitName(),itemStrippedHard)then
									MissionLoc=mission
								end
						end
								
				
				
				local data =
				{
					Player_ID = heroBuying:GetPlayerID();
					Ally_ID = 0;
					x =  MissionLoc:GetAbsOrigin().x;
					y =  MissionLoc:GetAbsOrigin().y;
					z =  MissionLoc:GetAbsOrigin().z;
				}
				FireGameEvent("Team_Cannot_Buy",data) 
			end
		end
	end
end

function HandleShopChecks(hero)
	local cotinue=0
	local hasContract=0
	local TradeValueCount = g_EmpireGoldCount
	if TradeValueCount>5 then
		TradeValueCount=5
	end
	if hero ~= nil then

			for itemSlot = 0, 5, 1 do 
				local Item = hero:GetItemInSlot( itemSlot )
				if Item ~= nil and  string.match(Item:GetName(), "trade_manifest") then
					cotinue=1
	
				elseif Item ~= nil then
					if string.match(Item:GetName(), "item_contract_easy") or  string.match(Item:GetName(), "item_contract_medium") or string.match(Item:GetName(), "item_contract_hard") then
					hasContract=1
					end
				end
			end
	end
	if cotinue==1 and hasContract==0 then
		local data =
		{
			Player_ID = hero:GetPlayerID();
			Ally_ID = hero:GetPlayerID();
		}
		FireGameEvent("Team_Can_Buy",data)
	end
					
	if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 then -- and string.match(hero:GetName(),"*trade*") then
		local casterPos = hero:GetAbsOrigin()
		local nearestShop= Entities:FindByNameNearest("npc_dota_buil*",casterPos,0)
		if nearestShop then

			

		local ShopDist =  casterPos - nearestShop:GetAbsOrigin()
		if g_WasNearShop[hero]==nil then
			g_WasNearShop[hero] = true
		end
			local targetUnitOne = Entities:FindByName( nil, "south_boat_shop")
			local targetUnitTwo = Entities:FindByName( nil, "north_boat_shop")
			local directionOne =  casterPos - targetUnitOne:GetAbsOrigin()
			local directionTwo =  casterPos - targetUnitTwo:GetAbsOrigin()
			
			for itemSlot = 0, 5, 1 do 
				local Item = hero:GetItemInSlot( itemSlot )
				if Item ~= nil  and string.match(Item:GetName(),"contract_empty") and ShopDist:Length()<600 then	
							RemoveAndDeleteItem(hero,Item)
							hero:SetGold(hero:GetGold()+300*TradeValueCount/4,true)
							hero:SetGold(0,false)
							g_HeroGoldArray[hero:GetPlayerOwnerID()]=hero:GetGold()+300*TradeValueCount/4
							hero:AddExperience(200,0,false,true)
							Notifications:Top(hero:GetPlayerID(), {text="#mission_done", duration=4.0, style={ color=" #60A0D6;", fontSize= "45px;", textShadow= "2px 2px 2px #662222;"}})
							Notifications:Top(hero:GetPlayerID(),{text=300*TradeValueCount/4, duration=4.0, style={color="#FFD700",  fontSize="45px;"}, continue=true})

				end		
			end
			
		if ShopDist:Length()<500 and (directionOne:Length() > 1000 and directionTwo:Length() > 1000) and (cotinue==1) then
			if g_WasNearShop[hero]==false then
				 --print("sending entershop")
				g_WasNearShop[hero]=true
				local data =
				{
					Player_ID = hero:GetPlayerID()
				}
				FireGameEvent("Hero_Near_Shop",data)
			end
		
		--saves number of peoplke on this traders team
		local numPlayers=1
		
			for itemSlot = 0, 5, 1 do 
				if hero ~= nil then
					local Item = hero:GetItemInSlot( itemSlot )
					if Item ~= nil then
						local itemStrippedEasy=string.gsub(Item:GetName(),"item_contract_easy","")
						local itemStrippedMedium=string.gsub(Item:GetName(),"item_contract_medium","")
						local itemStrippedHard=string.gsub(Item:GetName(),"item_contract_hard","")
						if  string.match(nearestShop:GetUnitName(),itemStrippedEasy) then
							RemoveAndDeleteItem(hero,Item)
							hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()]+100*TradeValueCount/4,true)
							hero:SetGold(0,false)
							g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()]+100*TradeValueCount/4
							hero:AddExperience(g_XpToLevel[hero:GetLevel()]*.25,0,false,true)
							if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
								g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + 100*TradeValueCount/4
							elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
								g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + 100*TradeValueCount/4
							end
						
							local allyteamnumber=hero:GetPlayerID()
							local data =
							{
								Player_ID = hero:GetPlayerID();
								Ally_ID = allyteamnumber;
							}
							FireGameEvent("Team_Can_Buy",data)
							EmitSoundOnClient("ui.npe_objective_complete",PlayerResource:GetPlayer(hero:GetPlayerID()))
							
							for _,otherHero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
								if otherHero ~= nil and otherHero:IsOwnedByAnyPlayer() then
									local herogold = g_HeroGoldArray[otherHero:GetPlayerOwnerID()]
									if otherHero:GetTeamNumber() == hero:GetTeam()  and otherHero~=hero then
										if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
											numPlayers=g_PlayerCountSouth
											otherHero:SetGold(herogold + 50*TradeValueCount/numPlayers, true)
											otherHero:SetGold(0, false)
											g_HeroGoldArray[otherHero:GetPlayerOwnerID()]=herogold + 50*TradeValueCount/numPlayers
											g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + 50*TradeValueCount/numPlayers
										elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
											numPlayers=g_PlayerCountNorth
											otherHero:SetGold(herogold + 50*TradeValueCount/numPlayers, true)
											otherHero:SetGold(0, false)
											g_HeroGoldArray[otherHero:GetPlayerOwnerID()]=herogold + 50*TradeValueCount/numPlayers
											g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + 50*TradeValueCount/numPlayers
										end
									end
								end
							end
						Notifications:Top(hero:GetPlayerID(), {text="#mission_done", duration=3.0, style={color=" #60A0D6;", fontSize= "45px;", textShadow= "2px 2px 2px #662222;"}})
						Notifications:Top(hero:GetPlayerID(), {text=100*TradeValueCount/4, duration=3.0, style={color="#FFD700",  fontSize="45px;"}, continue=true})
						Notifications:Top(hero:GetPlayerID(), {text="#mission_done_team", duration=3.0, style={ color=" #60A0D6;", fontSize= "35px;", textShadow= "2px 2px 2px #662222;"}})
						Notifications:Top(hero:GetPlayerID(), {text=math.floor(50*TradeValueCount/numPlayers), duration=3.0, style={color="#FFD700",  fontSize="35px;"}, continue=true})
						
						elseif string.match(nearestShop:GetUnitName(),itemStrippedMedium) then
							RemoveAndDeleteItem(hero,Item)
							hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()]+300*TradeValueCount/4,true)
							hero:SetGold(0,false)
								g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()]+300*TradeValueCount/4
								 --print("hero level: " .. hero:GetLevel())
								 --print("nect level: " .. g_XpToLevel[hero:GetLevel()])
							if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
								g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + 300*TradeValueCount/4
							elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
								g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + 300*TradeValueCount/4
							end
							
							hero:AddExperience(g_XpToLevel[hero:GetLevel()]*.25,0,false,true)
							for _,otherHero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
								if otherHero ~= nil and otherHero:IsOwnedByAnyPlayer() then
									local herogold = g_HeroGoldArray[otherHero:GetPlayerOwnerID()]
									if otherHero:GetTeamNumber() == hero:GetTeam()  and otherHero~=hero then
										
										if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
											numPlayers=g_PlayerCountSouth
											otherHero:SetGold(herogold + 75*TradeValueCount/numPlayers, true)
											otherHero:SetGold(0, false)
												g_HeroGoldArray[otherHero:GetPlayerOwnerID()]=herogold + 75*TradeValueCount/numPlayers
											g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + 75*TradeValueCount/numPlayers
										elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
											numPlayers=g_PlayerCountNorth
											otherHero:SetGold(herogold + 75*TradeValueCount/numPlayers, true)
											otherHero:SetGold(0, false)
											g_HeroGoldArray[otherHero:GetPlayerOwnerID()]=herogold + 75*TradeValueCount/numPlayers
											
											g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + 75*TradeValueCount/numPlayers
										end
									end
								end
							end
							local allyteamnumber=hero:GetPlayerID()
							
							local data =
							{
								Player_ID = hero:GetPlayerID();
								Player_ID = hero:GetPlayerID();
								Ally_ID = allyteamnumber;
							}
							FireGameEvent("Team_Can_Buy",data)
							EmitSoundOnClient("ui.npe_objective_complete",PlayerResource:GetPlayer(hero:GetPlayerID()))
							Notifications:Top(hero:GetPlayerID(), {text="#mission_done", duration=3.0, style={color=" #60A0D6;", fontSize= "45px;", textShadow= "2px 2px 2px #662222;"}})
						Notifications:Top(hero:GetPlayerID(),{text=300*TradeValueCount/4, duration=3.0, style={color="#FFD700",  fontSize="45px;"}, continue=true})
						Notifications:Top(hero:GetPlayerID(), {text="#mission_done_team", duration=3.0, style={ color=" #60A0D6;", fontSize= "35px;", textShadow= "2px 2px 2px #662222;"}})
						Notifications:Top(hero:GetPlayerID(),{text=math.floor(75*TradeValueCount/numPlayers), duration=3.0, style={color="#FFD700",  fontSize="35px;"}, continue=true})
						
						elseif string.match(nearestShop:GetUnitName(),itemStrippedHard) then
							RemoveAndDeleteItem(hero,Item)
							hero:SetGold(hero:GetGold()+300*TradeValueCount/4,true)
							hero:SetGold(0,false)
							g_HeroGoldArray[hero:GetPlayerOwnerID()]=hero:GetGold()+300*TradeValueCount/4
							hero:AddExperience(g_XpToLevel[hero:GetLevel()]*.33,0,false,true)
							if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
								g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + 300*TradeValueCount/4
							elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
								g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + 300*TradeValueCount/4
							end
						
							local allyteamnumber=hero:GetPlayerID()
							for _,otherHero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
								if otherHero ~= nil and otherHero:IsOwnedByAnyPlayer() then
									local herogold = otherHero:GetGold()
									if otherHero:GetTeamNumber() == hero:GetTeam()  and otherHero~=hero then
										
										if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
											numPlayers=g_PlayerCountSouth
											otherHero:SetGold(herogold + 100*TradeValueCount/g_PlayerCountSouth, true)
											otherHero:SetGold(0, false)
												g_HeroGoldArray[otherHero:GetPlayerOwnerID()]=herogold + 100*TradeValueCount/g_PlayerCountNorth
											g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + 100*TradeValueCount/g_PlayerCountSouth
										elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
											numPlayers=g_PlayerCountNorth
											otherHero:SetGold(herogold + 100*TradeValueCount/g_PlayerCountNorth, true)
											otherHero:SetGold(0, false)
											g_HeroGoldArray[otherHero:GetPlayerOwnerID()]=herogold + 100*TradeValueCount/g_PlayerCountNorth
											
											g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + 100*TradeValueCount/g_PlayerCountNorth
										end
									end
								end
							end
							local data =
							{
								Player_ID = hero:GetPlayerID();
								Ally_ID = allyteamnumber;
							}
							FireGameEvent("Team_Can_Buy",data)
							EmitSoundOnClient("ui.npe_objective_complete",PlayerResource:GetPlayer(hero:GetPlayerID()))
						 Notifications:Top(hero:GetPlayerID(), {text="#mission_done", duration=3.0, style={color=" #60A0D6;", fontSize= "45px;", textShadow= "2px 2px 2px #662222;"}})
						 Notifications:Top(hero:GetPlayerID(),{text=300*TradeValueCount/4, duration=3.0, style={color="#FFD700",  fontSize="45px;"}, continue=true})
						Notifications:Top(hero:GetPlayerID(), {text="#mission_done_team", duration=3.0, style={ color=" #60A0D6;", fontSize= "35px;", textShadow= "2px 2px 2px #662222;"}})
						Notifications:Top(hero:GetPlayerID(),{text=math.floor(100*TradeValueCount/numPlayers), duration=3.0, style={color="#FFD700",  fontSize="35px;"}, continue=true})
						
							end
					end
				end
			end
			elseif g_WasNearShop[hero]==true then
				 --print("sending leftshop")
				g_WasNearShop[hero]=false
				local data =
				{
					Player_ID = hero:GetPlayerID()
				}
				FireGameEvent("Hero_Left_Shop",data)
			end 
		end
	end	 						
end

function GetPlayerHist(playerID)
	if playerItemHist[playerID] ~= nil then
		return playerItemHist[playerID]
	end
	return "none"
end



function GetDisconnectState(playerID)
	 --print("getDisconnect")
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			if hero:GetPlayerID() == playerID then
				if g_DisconnectKicked[hero]~= nil then
					return g_DisconnectKicked[hero]
					else
					return 0
				end
				
			end
		end
	end
	return 0
end

function GetItemInSlot(playerID,itemSlot)
	local casterUnit = nil
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			if hero:GetPlayerID() == playerID then
				casterUnit=hero
			end
		end
	end
	if casterUnit ~= nil then
		if casterUnit:IsRealHero() then 
					local Item = casterUnit:GetItemInSlot( itemSlot )
					if Item ~= nil then
						return Item:GetName()
				end
		end
	end
	return "No_Item"
end

function GetHeroLevel(playerID)
	 --print(playerID)
    for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			if hero:GetPlayerID() == playerID then
				return hero:GetLevel()
			end
		end
	end
	return 0
end





function ActivateCoOp(eventSourceIndex, args)
 --print(args.text)
	if string.match(args.text,"normal") then
		g_CoOpMode=0
		
	else
		g_CoOpMode=1
	end
	 --print(g_CoOpMode)
		
		
end


function tradeMode(eventSourceIndex, args)
 --print(args.text)
	if string.match(args.text,"normal") then
		g_TradeMode=0
		else
		g_TradeMode=1
	end
	 --print(g_TradeMode)
end


---------------------------BATTLE MODE CODE---------------------------


function battleMode(eventSourceIndex, args)
 --print(args.text)
	if string.match(args.text,"normal") then
		g_BattleMode=0
		else
		g_BattleMode=1
	end
	 --print(g_BattleMode)
end

function tugMode(eventSourceIndex, args)
	--print(args.text)
	   if string.match(args.text,"normal") then
		   g_TugMode=0
		   else
			g_TugMode=1
	   end
		--print(g_BattleMode)
   end

function startBattle()
	g_BattleModeLocation=RandomInt(1,3)
	
	
	Notifications:TopToAll({text="#battle_starting_" .. tostring(g_BattleModeLocation), duration=5.0, style={color="#F2B2B2",  fontSize="60px;"}})
	
	local battleTimerData = {
						TimeTillBattle = g_BattleModeTimer;
					}
					FireGameEvent( "Battle_Started", battleTimerData ); 
			
	
	  local waypointlocation = Entities:FindByName ( nil,  "battle_" .. g_BattleModeLocation )
	  
	   for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			if hero:IsRealHero() then
				  
				  local Data = {
								player_id =hero:GetPlayerOwnerID(),
								x =  waypointlocation:GetAbsOrigin().x;
								y =  waypointlocation:GetAbsOrigin().y;
								z =  waypointlocation:GetAbsOrigin().z;
							}
							FireGameEvent( "ping_loc", Data ); 
							
							Timers:CreateTimer( 2, function()
									local Data = {
										player_id =hero:GetPlayerOwnerID(),
										x =  waypointlocation:GetAbsOrigin().x;
										y =  waypointlocation:GetAbsOrigin().y;
										z =  waypointlocation:GetAbsOrigin().z;
									}
									FireGameEvent( "ping_loc", Data ); 
							end)
							
							Timers:CreateTimer( 4, function()
									local Data = {
									player_id =hero:GetPlayerOwnerID(),
										x =  waypointlocation:GetAbsOrigin().x;
										y =  waypointlocation:GetAbsOrigin().y;
										z =  waypointlocation:GetAbsOrigin().z;
									}
									FireGameEvent( "ping_loc", Data ); 
							end)
							Timers:CreateTimer( 8, function()
									local Data = {
									player_id =hero:GetPlayerOwnerID(),
										x =  waypointlocation:GetAbsOrigin().x;
										y =  waypointlocation:GetAbsOrigin().y;
										z =  waypointlocation:GetAbsOrigin().z;
									}
									FireGameEvent( "ping_loc", Data ); 
							end)
							Timers:CreateTimer( 12, function()
									local Data = {
									player_id =hero:GetPlayerOwnerID(),
										x =  waypointlocation:GetAbsOrigin().x;
										y =  waypointlocation:GetAbsOrigin().y;
										z =  waypointlocation:GetAbsOrigin().z;
									}
									FireGameEvent( "ping_loc", Data ); 
							end)
							Timers:CreateTimer( 16, function()
									local Data = {
									player_id =hero:GetPlayerOwnerID(),
										x =  waypointlocation:GetAbsOrigin().x;
										y =  waypointlocation:GetAbsOrigin().y;
										z =  waypointlocation:GetAbsOrigin().z;
									}
									FireGameEvent( "ping_loc", Data ); 
							end)
							Timers:CreateTimer( 20, function()
									local Data = {
									player_id =hero:GetPlayerOwnerID(),
										x =  waypointlocation:GetAbsOrigin().x;
										y =  waypointlocation:GetAbsOrigin().y;
										z =  waypointlocation:GetAbsOrigin().z;
									}
									FireGameEvent( "ping_loc", Data ); 
							end)
							Timers:CreateTimer( 25, function()
									local Data = {
									player_id =hero:GetPlayerOwnerID(),
										x =  waypointlocation:GetAbsOrigin().x;
										y =  waypointlocation:GetAbsOrigin().y;
										z =  waypointlocation:GetAbsOrigin().z;
									}
									FireGameEvent( "ping_loc", Data ); 
							end)
							Timers:CreateTimer( 30, function()
									local Data = {
									player_id =hero:GetPlayerOwnerID(),
										x =  waypointlocation:GetAbsOrigin().x;
										y =  waypointlocation:GetAbsOrigin().y;
										z =  waypointlocation:GetAbsOrigin().z;
									}
									FireGameEvent( "ping_loc", Data ); 
							end)
							Timers:CreateTimer( 40, function()
									local Data = {
									player_id =hero:GetPlayerOwnerID(),
										x =  waypointlocation:GetAbsOrigin().x;
										y =  waypointlocation:GetAbsOrigin().y;
										z =  waypointlocation:GetAbsOrigin().z;
									}
									FireGameEvent( "ping_loc", Data ); 
							end)
				end
			end
			end
				
				
				
	  
	  local dummy = CreateUnitByName( "npc_dota_battle_ind", waypointlocation:GetAbsOrigin(), true, nil, nil, 4 )
	dummy:AddNewModifier(dummy, nil, "modifier_kill", {duration = 60})
	g_BattleModeRemaining=60
	Timers:CreateTimer( 1, function()
			HandleBattle()
	end)
end


function HandleBattle()

  local waypointlocation = Entities:FindByName ( nil,  "battle_" .. g_BattleModeLocation )
  
  	 --print( "battle time remaining" .. g_BattleModeRemaining)
	

 for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			local Dist =  hero:GetAbsOrigin() - waypointlocation:GetAbsOrigin()
			if hero:IsRealHero() and Dist:Length()<1100 and hero:IsAlive() then
				
				if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					g_BattleModeSouthScore=g_BattleModeSouthScore+1
					hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + g_BattleModeNumberSouth*3+2, true)   
					g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] +  (g_BattleModeNumberSouth*3+2)
					g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + g_BattleModeNumberSouth*3+2
					hero:AddExperience(g_BattleModeNumberSouth*3+2, true,false)
					SendOverheadEventMessage(PlayerResource:GetPlayer(hero:GetPlayerID()), OVERHEAD_ALERT_GOLD, hero,  g_BattleModeNumberSouth*3+2, PlayerResource:GetPlayer(hero:GetPlayerID()))
	 
				elseif	hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
					g_BattleModeNorthScore=g_BattleModeNorthScore+1
					hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + g_BattleModeNumberNorth*3+2, true)   
					g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] +  (g_BattleModeNumberNorth*3+2)
					g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + g_BattleModeNumberNorth*3+2
					hero:AddExperience(g_BattleModeNumberNorth*3+2, true,false)
					SendOverheadEventMessage(PlayerResource:GetPlayer(hero:GetPlayerID()), OVERHEAD_ALERT_GOLD, hero,  g_BattleModeNumberNorth*3+2, PlayerResource:GetPlayer(hero:GetPlayerID()))
				end
			end
		end
	end
	g_BattleModeRemaining=g_BattleModeRemaining-1
	if g_BattleModeRemaining>1 then
		local battleTimerData = {
						TimeInBattle = g_BattleModeRemaining;
						NorthScore = g_BattleModeNorthScore;
						SouthScore = g_BattleModeSouthScore;
						gptn = g_BattleModeNumberNorth*3+2;
						gpts = g_BattleModeNumberSouth*3+2;
					}
		FireGameEvent( "Battle_in_Progress", battleTimerData ); 
		
		
		Timers:CreateTimer( 1, function()
					HandleBattle()
		end)
	else
			endBattle()
	end
	

end

function endBattle()

	local battleTimerData = {
						TimeTillBattle = g_BattleModeTimer;
					}
					FireGameEvent( "Battle_Over", battleTimerData );

 for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			if hero:IsRealHero() then
				if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and g_BattleModeNorthScore < g_BattleModeSouthScore then
					g_BattleModeSouthScore=g_BattleModeSouthScore+1
					hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] + (g_BattleModeNumberNorth*3+2)*15, true)  
					g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] +  (g_BattleModeNumberNorth*3+2)*15
					g_TotalGoldCollectedBySouth = g_TotalGoldCollectedBySouth + (g_BattleModeNumberNorth*4+2)*15			
					hero:AddExperience((g_BattleModeNumberNorth*4+2)*15, true,false)					
				elseif hero:GetTeamNumber() == DOTA_TEAM_BADGUYS and g_BattleModeNorthScore > g_BattleModeSouthScore then
					g_BattleModeNorthScore=g_BattleModeNorthScore+1
					hero:SetGold(g_HeroGoldArray[hero:GetPlayerOwnerID()] +  (g_BattleModeNumberSouth*3+2)*15, true)   
					g_HeroGoldArray[hero:GetPlayerOwnerID()]=g_HeroGoldArray[hero:GetPlayerOwnerID()] +  (g_BattleModeNumberSouth*3+2)*15
					g_TotalGoldCollectedByNorth = g_TotalGoldCollectedByNorth + (g_BattleModeNumberSouth*4+2)*15
					hero:AddExperience((g_BattleModeNumberSouth*4+2)*15, true,false)
				end
			end
		end
	end
	if  g_BattleModeNorthScore < g_BattleModeSouthScore then
		Notifications:TopToAll({text="#south_won_battle", duration=5.0, style={color="#F2B2B2",  fontSize="30px;"}})
		g_BattleModeNumberSouth=g_BattleModeNumberNorth+1
		Notifications:TopToAll({text=" " .. tostring((g_BattleModeNumberSouth*4+2)*15) .. " ", duration=5.0, style={color="#FFD700",  fontSize="30px;"}, continue=true})
		Notifications:TopToAll({text="#gold", duration=5.0, style={color="#F2B2B2",  fontSize="30px;"}, continue=true})

	elseif g_BattleModeNorthScore > g_BattleModeSouthScore then
		Notifications:TopToAll({text="#north_won_battle", duration=5.0, style={color="#F2B2B2",  fontSize="30px;"}})
		g_BattleModeNumberNorth=g_BattleModeNumberSouth+1
		Notifications:TopToAll({text=" " .. tostring((g_BattleModeNumberNorth*4+2)*15) .. " ", duration=5.0, style={color="#FFD700",  fontSize="30px;"}, continue=true})
		Notifications:TopToAll({text="#gold", duration=5.0, style={color="#F2B2B2",  fontSize="30px;"}, continue=true})

	else
		Notifications:TopToAll({text="#nobody_won_battle", duration=5.0, style={color="#F2B2B2",  fontSize="30px;"}})
		g_BattleModeNumberSouth=g_BattleModeNumberSouth+1
		g_BattleModeNumberNorth=g_BattleModeNumberNorth+1
	end
	
g_BattleModeNorthScore=0
g_BattleModeSouthScore=0
g_BattleModeTimer=180
g_BattleModeRemaining=0
g_BattleModeLocation=0
end




--======================================= utilities ================================

function RemoveAndDeleteItem(hero,item)
	 --print(item:GetClassname())
	 --print(item:GetName())

		item:RemoveSelf()

	
	
	
end