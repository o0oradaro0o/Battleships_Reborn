-- Generated from template

require("timers")
require('physics')
require('notifications')
require('storage')
--require('statcollection/init')


if CBattleship8D == nil then
	CBattleship8D = class({})
end

precashed = false
teamScores={0, 0}
WasNearShop={}
score_to_win=100000
xp_to_level={
200,
300,
400,
500,
600,
600,
600,
1200,
1000,
600,
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

CREEP_LEVEL = 0
CREEP_NUM_SMALL = 4
CREEP_NUM_BIG = 3
CREEP_NUM_HUGE = 2
EMP_GOLD_NUMBER = 1

statCollection=0

BAD_GOLD_TOTAL_MOD = 0
GOOD_GOLD_TOTAL_MOD = 0

BOAT_JUST_BAUGHT=0

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


empGoldArray={}

tideKillerArray={}

herokills = {}
herohp = {}
playerIdsToNames = {}

isDisconnected = {}
DisconnectTime = {}
DisconnectKicked = {}
heroids = {}
DISCONNECT_MESSAGE_DESPLAYED = 0
LastLocs = {}
LastLocs2 ={}
GoodWon=true


item_code_lookup={}
item_code_lookup["item_coal_bow"] = "CO"
item_code_lookup["item_fire_bow"] = "FO"
item_code_lookup["item_plasma_bow"] = "PO"
item_code_lookup["item_poison_bow"] = "OO"
item_code_lookup["item_light_bow"] = "LO"
item_code_lookup["item_ice_bow"] = "IO"
item_code_lookup["item_wind_bow"] = "WO"

item_code_lookup["item_coal_two_bow"] = "CT"
item_code_lookup["item_fire_two_bow"] = "FT"
item_code_lookup["item_plasma_two_bow"] = "PT"
item_code_lookup["item_poison_two_bow"] = "OT"
item_code_lookup["item_light_two_bow"] = "LT"
item_code_lookup["item_ice_two_bow"] = "IT"
item_code_lookup["item_wind_two_bow"] = "WT"

item_code_lookup["item_coal_three_bow"] = "CH"
item_code_lookup["item_fire_three_bow"] = "FH"
item_code_lookup["item_plasma_three_bow"] = "PH"
item_code_lookup["item_poison_three_bow"] = "OH"
item_code_lookup["item_light_three_bow"] = "LH"
item_code_lookup["item_ice_three_bow"] = "IH"
item_code_lookup["item_wind_three_bow"] = "WH"
item_code_lookup["item_recipe_coal_ult_bow"] = "CU"

item_code_lookup["item_recipe_fire_ult_bow"] = "FU"
item_code_lookup["item_recipe_plasma_ult_bow"] = "PU"
item_code_lookup["item_recipe_poison_ult_bow"] = "OU"
item_code_lookup["item_recipe_light_ult_bow"] = "LU"
item_code_lookup["item_recipe_ice_ult_bow"] = "IU"
item_code_lookup["item_recipe_wind_ult_bow"] = "WU"

item_code_lookup["item_hull_one"] = "HO"
item_code_lookup["item_hull_two"] = "HT"
item_code_lookup["item_hull_three"] = "HH"
item_code_lookup["item_hull_four"] = "HF"
item_code_lookup["item_sail_one"] = "SU"
item_code_lookup["item_sail_two"] = "SO"
item_code_lookup["item_sail_three"] = "ST"
item_code_lookup["item_sail_four"] = "SH"
item_code_lookup["item_repair_one"] = "RF"
item_code_lookup["item_repair_two"] = "RU"
item_code_lookup["item_repair_three"] = "RO"
item_code_lookup["item_repair_four"] = "RT"
item_code_lookup["item_wood_one"] = "DH"
item_code_lookup["item_wood_two"] = "DF"
item_code_lookup["item_wood_three"] = "DU"
item_code_lookup["item_wood_four"] = "DO"

item_code_lookup["item_tower_debuff"] = "EG"
item_code_lookup["item_tower_healer"] = "EB"
item_code_lookup["item_nut_spawner"] = "EN"



item_code_lookup["item_puck_replacement_boat"] = "BZ"
--Zodiac
item_code_lookup["item_rubick_replacement_boat"] = "BC"
--Catamaran
item_code_lookup["item_tidehunter_replacement_boat"] = "BP"
--Pontoon
item_code_lookup["item_phantom_lancer_replacement_boat"] = "BA"
--Airboat
item_code_lookup["item_morphling_replacement_boat"] = "BS"
--Speedboat
item_code_lookup["item_nevermore_replacement_boat"] = "BL"
--Plane
item_code_lookup["item_kunkka_replacement_boat"] = "BH"
--Shore Guard
item_code_lookup["item_zuus_replacement_boat"] = "BT"
--Tug Boat
item_code_lookup["item_brewmaster_replacement_boat"] = "BH"
--Houseboat
item_code_lookup["item_magnus_replacement_boat"] = "BV"
--Viking
item_code_lookup["item_jakiro_replacement_boat"] = "BG"
--Galleon
item_code_lookup["item_shredder_replacement_boat"] = "BU"
--Submarine
item_code_lookup["item_treant_replacement_boat"] = "BO"
--Construction
item_code_lookup["item_spectre_replacement_boat"] = "BB"
--Battleship
item_code_lookup["item_visage_replacement_boat"] = "BN"
--Noah's Ark
item_code_lookup["item_wisp_replacement_boat"] = "BI"
--Icebreaker
item_code_lookup["item_gyrocopter_replacement_boat"] = "BR"
--Aircraft Carrier
item_code_lookup["item_lion_replacement_boat"] = "BY"
--Yacht
item_code_lookup["item_crystal_maiden_replacement_boat"] = "BN"
--Canoe
item_code_lookup["item_storm_spirit_replacement_boat"] = "BJ"
--Junk

model_lookup = {}
model_lookup["npc_dota_hero_zuus"] = "models/barrel_boat.vmdl"
model_lookup["npc_dota_hero_ancient_apparition"] = "models/zodiac_boat.vmdl"
model_lookup["npc_dota_hero_tidehunter"] = "models/pontoon_boat.vmdl"
model_lookup["npc_dota_hero_crystal_maiden"] = "models/canoe_boat.vmdl"
model_lookup["npc_dota_hero_phantom_lancer"] = "models/air_boat.vmdl"
model_lookup["npc_dota_hero_rattletrap"] = "models/cat_boat.vmdl"
model_lookup["npc_dota_hero_jakiro"] = "models/galleon_boat.vmdl"
model_lookup["npc_dota_hero_nevermore"] = "models/plane_boat.vmdl"
model_lookup["npc_dota_hero_meepo"] = "models/house_boat.vmdl"
model_lookup["npc_dota_hero_disruptor"] = "models/coast_boat.vmdl"
model_lookup["npc_dota_hero_morphling"] = "models/speed_boat.vmdl"
model_lookup["npc_dota_hero_storm_spirit"] = "models/junk_boat.vmdl"
model_lookup["npc_dota_hero_lion"] = "models/yacht_boat.vmdl"
model_lookup["npc_dota_hero_ember_spirit"] = "models/tug_boat.vmdl"
model_lookup["npc_dota_hero_slark"] = "models/viking_boat.vmdl"
model_lookup["npc_dota_hero_sniper"] = "models/sub_boat.vmdl"
model_lookup["npc_dota_hero_visage"] = "models/noah_boat.vmdl"
model_lookup["npc_dota_hero_ursa"] = "models/Aircraft_boat.vmdl"
model_lookup["npc_dota_hero_pugna"] = "models/ice_boat.vmdl"
model_lookup["npc_dota_hero_windrunner"] = "models/const_boat.vmdl"
model_lookup["npc_dota_hero_tusk"] = "models/battleship_boat0.vmdl"
model_lookup["npc_dota_hero_vengefulspirit"] = "models/trade_one_boat.vmdl"
model_lookup["npc_dota_hero_bane"] = "models/trade_boat_two.vmdl"
model_lookup["npc_dota_hero_enigma"] = "models/trade_three_boat.vmdl"



NorthEasyMissions={}
NorthHardMissions={}
SouthEasyMissions={}
SouthHardMissions={}

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
	PrecacheUnitByNameSync("npc_dota_hero_tiny", context)
	PrecacheUnitByNameSync("npc_dota_hero_kunkka", context)
	PrecacheUnitByNameSync("npc_dota_hero_bane", context)
	
	PrecacheUnitByNameSync("npc_dota_hero_vengefulspirit", context)
	PrecacheUnitByNameSync("npc_dota_hero_brewmaster", context)
	PrecacheUnitByNameSync("npc_dota_hero_puck", context)
	PrecacheUnitByNameSync("npc_dota_hero_tidehunter", context)
	PrecacheUnitByNameSync("npc_dota_hero_jakiro", context)
	PrecacheUnitByNameSync("npc_dota_hero_sniper", context)
	PrecacheUnitByNameSync("npc_dota_hero_meepo", context)
	PrecacheUnitByNameSync("npc_dota_hero_pudge", context)
	PrecacheUnitByNameSync("npc_dota_hero_morphling", context)
	PrecacheUnitByNameSync("npc_dota_hero_spirit_breaker", context)
	PrecacheUnitByNameSync("npc_dota_hero_batrider", context)
	PrecacheUnitByNameSync("npc_dota_hero_pugna", context)
	PrecacheUnitByNameSync("npc_dota_hero_gyrocopter", context)
	PrecacheUnitByNameSync("npc_dota_hero_magnataur", context)
	PrecacheUnitByNameSync("npc_dota_hero_ursa", context)
	PrecacheUnitByNameSync("npc_dota_hero_meepo", context)
	PrecacheUnitByNameSync("npc_dota_hero_disruptor", context)
	PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	PrecacheUnitByNameSync("npc_dota_hero_winter_wyvern", context)
	PrecacheUnitByNameSync("npc_dota_hero_lion", context)
	PrecacheUnitByNameSync("npc_dota_hero_alchemist", context)
	PrecacheUnitByNameSync("npc_dota_hero_invoker", context)
	PrecacheUnitByNameSync("npc_dota_hero_doom_bringer", context)
	PrecacheUnitByNameSync("npc_dota_hero_lycan", context)
	PrecacheUnitByNameSync("npc_dota_hero_visage", context)
	PrecacheUnitByNameSync("npc_dota_hero_nevermore", context)
	PrecacheUnitByNameSync("npc_dota_hero_slark", context)
	PrecacheUnitByNameSync("npc_dota_hero_naga_siren", context)
	PrecacheUnitByNameSync("npc_dota_hero_chen", context)
	PrecacheUnitByNameSync("npc_dota_hero_rubick", context)
	PrecacheUnitByNameSync("npc_dota_hero_mirana", context)
	PrecacheUnitByNameSync("npc_dota_hero_windrunner", context)
	PrecacheUnitByNameSync("npc_dota_hero_rattletrap", context)
	PrecacheUnitByNameSync("npc_dota_hero_antimage", context)
	PrecacheUnitByNameSync("npc_dota_hero_riki", context)
	PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
	PrecacheUnitByNameSync("npc_dota_hero_shredder", context)
	PrecacheUnitByNameSync("npc_dota_hero_silencer", context)
	PrecacheUnitByNameSync("npc_dota_hero_treant", context)
	PrecacheUnitByNameSync("npc_dota_hero_bane", context)
	PrecacheUnitByNameSync("npc_dota_hero_lone_druid", context)
	PrecacheUnitByNameSync("npc_dota_hero_shadow_shaman", context)
	PrecacheUnitByNameSync("npc_dota_hero_crystal_maiden", context)
	PrecacheUnitByNameSync("npc_dota_hero_phantom_lancer", context)
	PrecacheUnitByNameSync("npc_dota_hero_storm_spirit", context)
	PrecacheUnitByNameSync("npc_dota_hero_ember_spirit", context)
	PrecacheUnitByNameSync("npc_dota_hero_wisp", context)


	PrecacheUnitByNameSync("npc_dota_vision_granter", context)
		 
	PrecacheUnitByNameSync( "npc_dota_boat_south_one", context )
	PrecacheUnitByNameSync( "npc_dota_boat_south_two", context )
	PrecacheUnitByNameSync( "npc_dota_boat_south_three", context )
	PrecacheUnitByNameSync( "npc_dota_boat_north_three", context )
	
	PrecacheUnitByNameSync( "npc_dota_boat_south_four", context )
	PrecacheUnitByNameSync( "npc_dota_boat_north_one", context )
	PrecacheUnitByNameSync( "npc_dota_boat_north_two", context )
	PrecacheUnitByNameSync( "npc_dota_air_craft", context )
	PrecacheUnitByNameSync( "npc_dota_air_craft_bomber", context )
	PrecacheUnitByNameSync( "npc_dota_boat_pleasure_craft", context )
	PrecacheResource( "model", "models/courier/donkey_unicorn/donkey_unicorn.vmdl", context )
	PrecacheResource( "model", "models/courier/sw_donkey/sw_donkey.vmdl", context )
	PrecacheResource( "model", "models/items/courier/jumo/jumo.vmdl", context )
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
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_bastion.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_axe.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_lina.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_bristleback.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_stormspirit.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/voscripts/game_sounds_vo_announcer_dlc_workshop_pirate.vsndevts", context )
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
	PrecacheResource( "soundfile","soundevents/custom_sounds.vsndevts", context )
	
end
				


-- Create the game mode when we activate
function Activate()
	GameRules.battleship = CBattleship8D()
	GameRules.battleship:InitGameMode()
end

function CBattleship8D:InitGameMode()
	print( "Template addon is loaded." )
	
	--register the 'UnstickMe' command in our console
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( CBattleship8D, "OrderExecutionFilter" ), self )
	
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled(true)
	GameRules:GetGameModeEntity():SetBuybackEnabled(false)
	GameRules:SetSameHeroSelectionEnabled(true)
	SendToServerConsole( "dota_combine_models 0" ) 
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(CBattleship8D, 'OnItemPurchased'), self)

	
	ListenToGameEvent('entity_killed', Dynamic_Wrap(CBattleship8D, 'OnEntityKilled'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CBattleship8D, 'OnNPCSpawned'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(CBattleship8D, 'OnConnectFull'), self)
  ListenToGameEvent('player_disconnect', Dynamic_Wrap(CBattleship8D, 'OnDisconnect'), self)
  
	CustomGameEventManager:RegisterListener("GiveEasy", GiveEasy);
	CustomGameEventManager:RegisterListener("GiveMedium", GiveMedium);
	CustomGameEventManager:RegisterListener("buyItem", buyItem);
	CustomGameEventManager:RegisterListener("buyBoat", buyBoat);
	
	CustomGameEventManager:RegisterListener("Unstick", UnstickPlayer);
	
  mode = GameRules:GetGameModeEntity()
mode:SetHUDVisible(12, false)
  
  
  
  
NorthEasyMissions["npc_dota_shop_left_bot"]={}
NorthEasyMissions["npc_dota_shop_right_bot"]={}
NorthEasyMissions["npc_dota_shop_right_mid"]={}
NorthEasyMissions["npc_dota_shop_left_mid"]={}
NorthEasyMissions["npc_dota_shop_left_top"]={}
NorthEasyMissions["npc_dota_shop_mid_bot"]={}
NorthEasyMissions["npc_dota_shop_mid_mid"]={}
NorthEasyMissions["npc_dota_shop_mid_top"]={}
NorthEasyMissions["npc_dota_shop_right_top"]={}
NorthHardMissions["npc_dota_shop_left_bot"]={}
NorthHardMissions["npc_dota_shop_right_bot"]={}
NorthHardMissions["npc_dota_shop_right_mid"]={}
NorthHardMissions["npc_dota_shop_left_mid"]={}
NorthHardMissions["npc_dota_shop_left_top"]={}
NorthHardMissions["npc_dota_shop_mid_bot"]={}
NorthHardMissions["npc_dota_shop_mid_mid"]={}
NorthHardMissions["npc_dota_shop_mid_top"]={}
NorthHardMissions["npc_dota_shop_right_top"]={}
SouthEasyMissions["npc_dota_shop_left_bot"]={}
SouthEasyMissions["npc_dota_shop_right_bot"]={}
SouthEasyMissions["npc_dota_shop_right_mid"]={}
SouthEasyMissions["npc_dota_shop_left_mid"]={}
SouthEasyMissions["npc_dota_shop_left_top"]={}
SouthEasyMissions["npc_dota_shop_mid_bot"]={}
SouthEasyMissions["npc_dota_shop_mid_mid"]={}
SouthEasyMissions["npc_dota_shop_mid_top"]={}
SouthEasyMissions["npc_dota_shop_right_top"]={}
SouthHardMissions["npc_dota_shop_left_bot"]={}
SouthHardMissions["npc_dota_shop_right_bot"]={}
SouthHardMissions["npc_dota_shop_right_mid"]={}
SouthHardMissions["npc_dota_shop_left_mid"]={}
SouthHardMissions["npc_dota_shop_left_top"]={}
SouthHardMissions["npc_dota_shop_mid_bot"]={}
SouthHardMissions["npc_dota_shop_mid_mid"]={}
SouthHardMissions["npc_dota_shop_mid_top"]={}
SouthHardMissions["npc_dota_shop_right_top"]={}

table.insert(NorthEasyMissions["npc_dota_shop_left_top"], "item_contract_easy_left_mid")
table.insert(NorthEasyMissions["npc_dota_shop_left_top"], "item_contract_easy_mid_top")
table.insert(NorthEasyMissions["npc_dota_shop_left_top"], "item_contract_easy_right_top")
table.insert(NorthEasyMissions["npc_dota_shop_mid_mid"], "item_contract_easy_mid_top")
table.insert(NorthEasyMissions["npc_dota_shop_left_mid"], "item_contract_easy_left_top")
table.insert(NorthEasyMissions["npc_dota_shop_mid_top"], "item_contract_easy_left_top")
table.insert(NorthEasyMissions["npc_dota_shop_mid_top"], "item_contract_easy_left_mid")
table.insert(NorthEasyMissions["npc_dota_shop_mid_top"], "item_contract_easy_right_mid")
table.insert(NorthEasyMissions["npc_dota_shop_mid_top"], "item_contract_easy_right_top")
table.insert(NorthEasyMissions["npc_dota_shop_right_mid"], "item_contract_easy_right_top")
table.insert(NorthEasyMissions["npc_dota_shop_right_top"], "item_contract_easy_left_top")
table.insert(NorthEasyMissions["npc_dota_shop_right_top"], "item_contract_easy_mid_top")
table.insert(NorthEasyMissions["npc_dota_shop_right_top"], "item_contract_easy_right_mid")
table.insert(NorthHardMissions["npc_dota_shop_left_top"], "item_contract_hard_mid_mid")
table.insert(NorthHardMissions["npc_dota_shop_left_top"], "item_contract_hard_right_mid")
table.insert(NorthHardMissions["npc_dota_shop_left_top"], "item_contract_hard_right_bot")
table.insert(NorthHardMissions["npc_dota_shop_left_top"], "item_contract_hard_mid_bot")
table.insert(NorthHardMissions["npc_dota_shop_mid_mid"], "item_contract_hard_left_bot")
table.insert(NorthHardMissions["npc_dota_shop_mid_mid"], "item_contract_hard_right_bot")
table.insert(NorthHardMissions["npc_dota_shop_mid_mid"], "item_contract_hard_mid_bot")
table.insert(NorthHardMissions["npc_dota_shop_left_mid"], "item_contract_hard_mid_mid")
table.insert(NorthHardMissions["npc_dota_shop_left_mid"], "item_contract_hard_right_mid")
table.insert(NorthHardMissions["npc_dota_shop_left_mid"], "item_contract_hard_right_bot")
table.insert(NorthHardMissions["npc_dota_shop_left_mid"], "item_contract_hard_mid_bot")
table.insert(NorthHardMissions["npc_dota_shop_left_mid"], "item_contract_hard_right_top")
table.insert(NorthHardMissions["npc_dota_shop_left_bot"], "item_contract_hard_mid_mid")
table.insert(NorthHardMissions["npc_dota_shop_left_bot"], "item_contract_hard_right_mid")
table.insert(NorthHardMissions["npc_dota_shop_left_bot"], "item_contract_hard_right_bot")
table.insert(NorthHardMissions["npc_dota_shop_left_bot"], "item_contract_hard_mid_bot")
table.insert(NorthHardMissions["npc_dota_shop_left_bot"], "item_contract_hard_right_top")
table.insert(NorthHardMissions["npc_dota_shop_mid_top"], "item_contract_hard_mid_mid")
table.insert(NorthHardMissions["npc_dota_shop_mid_top"], "item_contract_hard_left_bot")
table.insert(NorthHardMissions["npc_dota_shop_mid_top"], "item_contract_hard_right_bot")
table.insert(NorthHardMissions["npc_dota_shop_mid_top"], "item_contract_hard_mid_bot")
table.insert(NorthHardMissions["npc_dota_shop_right_mid"], "item_contract_hard_left_top")
table.insert(NorthHardMissions["npc_dota_shop_right_mid"], "item_contract_hard_mid_mid")
table.insert(NorthHardMissions["npc_dota_shop_right_mid"], "item_contract_hard_left_mid")
table.insert(NorthHardMissions["npc_dota_shop_right_mid"], "item_contract_hard_left_bot")
table.insert(NorthHardMissions["npc_dota_shop_right_mid"], "item_contract_hard_mid_bot")
table.insert(NorthHardMissions["npc_dota_shop_right_bot"], "item_contract_hard_left_top")
table.insert(NorthHardMissions["npc_dota_shop_right_bot"], "item_contract_hard_mid_mid")
table.insert(NorthHardMissions["npc_dota_shop_right_bot"], "item_contract_hard_left_mid")
table.insert(NorthHardMissions["npc_dota_shop_right_bot"], "item_contract_hard_left_bot")
table.insert(NorthHardMissions["npc_dota_shop_right_bot"], "item_contract_hard_mid_bot")
table.insert(NorthHardMissions["npc_dota_shop_mid_bot"], "item_contract_hard_left_top")
table.insert(NorthHardMissions["npc_dota_shop_mid_bot"], "item_contract_hard_mid_mid")
table.insert(NorthHardMissions["npc_dota_shop_mid_bot"], "item_contract_hard_left_bot")
table.insert(NorthHardMissions["npc_dota_shop_mid_bot"], "item_contract_hard_mid_top")
table.insert(NorthHardMissions["npc_dota_shop_mid_bot"], "item_contract_hard_right_bot")
table.insert(NorthHardMissions["npc_dota_shop_mid_bot"], "item_contract_hard_right_top")
table.insert(NorthHardMissions["npc_dota_shop_right_top"], "item_contract_hard_mid_mid")
table.insert(NorthHardMissions["npc_dota_shop_right_top"], "item_contract_hard_left_mid")
table.insert(NorthHardMissions["npc_dota_shop_right_top"], "item_contract_hard_left_bot")
table.insert(NorthHardMissions["npc_dota_shop_right_top"], "item_contract_hard_mid_bot")
table.insert(NorthHardMissions["npc_dota_shop_left_top"], "item_contract_medium_left_bot")
table.insert(NorthHardMissions["npc_dota_shop_mid_mid"], "item_contract_medium_left_top")
table.insert(NorthHardMissions["npc_dota_shop_mid_mid"], "item_contract_medium_left_mid")
table.insert(NorthHardMissions["npc_dota_shop_mid_mid"], "item_contract_medium_right_mid")
table.insert(NorthHardMissions["npc_dota_shop_mid_mid"], "item_contract_medium_right_top")
table.insert(NorthHardMissions["npc_dota_shop_left_mid"], "item_contract_medium_left_bot")
table.insert(NorthHardMissions["npc_dota_shop_left_mid"], "item_contract_medium_mid_top")
table.insert(NorthHardMissions["npc_dota_shop_left_bot"], "item_contract_medium_left_top")
table.insert(NorthHardMissions["npc_dota_shop_left_bot"], "item_contract_medium_left_mid")
table.insert(NorthHardMissions["npc_dota_shop_left_bot"], "item_contract_medium_mid_top")
table.insert(NorthHardMissions["npc_dota_shop_right_mid"], "item_contract_medium_mid_top")
table.insert(NorthHardMissions["npc_dota_shop_right_mid"], "item_contract_medium_right_bot")
table.insert(NorthHardMissions["npc_dota_shop_right_bot"], "item_contract_medium_mid_top")
table.insert(NorthHardMissions["npc_dota_shop_right_bot"], "item_contract_medium_right_mid")
table.insert(NorthHardMissions["npc_dota_shop_right_bot"], "item_contract_medium_right_top")
table.insert(NorthHardMissions["npc_dota_shop_mid_bot"], "item_contract_medium_left_mid")
table.insert(NorthHardMissions["npc_dota_shop_mid_bot"], "item_contract_medium_right_mid")
table.insert(NorthHardMissions["npc_dota_shop_right_top"], "item_contract_medium_right_bot")
table.insert(SouthEasyMissions["npc_dota_shop_mid_mid"], "item_contract_easy_mid_bot")
table.insert(SouthEasyMissions["npc_dota_shop_left_mid"], "item_contract_easy_left_bot")
table.insert(SouthEasyMissions["npc_dota_shop_left_bot"], "item_contract_easy_left_mid")
table.insert(SouthEasyMissions["npc_dota_shop_left_bot"], "item_contract_easy_right_bot")
table.insert(SouthEasyMissions["npc_dota_shop_left_bot"], "item_contract_easy_mid_bot")
table.insert(SouthEasyMissions["npc_dota_shop_right_mid"], "item_contract_easy_right_bot")
table.insert(SouthEasyMissions["npc_dota_shop_right_bot"], "item_contract_easy_left_bot")
table.insert(SouthEasyMissions["npc_dota_shop_right_bot"], "item_contract_easy_right_mid")
table.insert(SouthEasyMissions["npc_dota_shop_right_bot"], "item_contract_easy_mid_bot")
table.insert(SouthEasyMissions["npc_dota_shop_mid_bot"], "item_contract_easy_left_mid")
table.insert(SouthEasyMissions["npc_dota_shop_mid_bot"], "item_contract_easy_left_bot")
table.insert(SouthEasyMissions["npc_dota_shop_mid_bot"], "item_contract_easy_right_mid")
table.insert(SouthEasyMissions["npc_dota_shop_mid_bot"], "item_contract_easy_right_bot")
table.insert(SouthHardMissions["npc_dota_shop_left_top"], "item_contract_hard_mid_mid")
table.insert(SouthHardMissions["npc_dota_shop_left_top"], "item_contract_hard_mid_top")
table.insert(SouthHardMissions["npc_dota_shop_left_top"], "item_contract_hard_right_mid")
table.insert(SouthHardMissions["npc_dota_shop_left_top"], "item_contract_hard_right_bot")
table.insert(SouthHardMissions["npc_dota_shop_left_top"], "item_contract_hard_right_top")
table.insert(SouthHardMissions["npc_dota_shop_mid_mid"], "item_contract_hard_left_top")
table.insert(SouthHardMissions["npc_dota_shop_mid_mid"], "item_contract_hard_mid_top")
table.insert(SouthHardMissions["npc_dota_shop_mid_mid"], "item_contract_hard_right_top")
table.insert(SouthHardMissions["npc_dota_shop_left_mid"], "item_contract_hard_mid_mid")
table.insert(SouthHardMissions["npc_dota_shop_left_mid"], "item_contract_hard_mid_top")
table.insert(SouthHardMissions["npc_dota_shop_left_mid"], "item_contract_hard_right_mid")
table.insert(SouthHardMissions["npc_dota_shop_left_mid"], "item_contract_hard_right_bot")
table.insert(SouthHardMissions["npc_dota_shop_left_mid"], "item_contract_hard_right_top")
table.insert(SouthHardMissions["npc_dota_shop_left_bot"], "item_contract_hard_mid_mid")
table.insert(SouthHardMissions["npc_dota_shop_left_bot"], "item_contract_hard_mid_top")
table.insert(SouthHardMissions["npc_dota_shop_left_bot"], "item_contract_hard_right_mid")
table.insert(SouthHardMissions["npc_dota_shop_left_bot"], "item_contract_hard_right_top")
table.insert(SouthHardMissions["npc_dota_shop_mid_top"], "item_contract_hard_left_top")
table.insert(SouthHardMissions["npc_dota_shop_mid_top"], "item_contract_hard_mid_mid")
table.insert(SouthHardMissions["npc_dota_shop_mid_top"], "item_contract_hard_left_bot")
table.insert(SouthHardMissions["npc_dota_shop_mid_top"], "item_contract_hard_right_bot")
table.insert(SouthHardMissions["npc_dota_shop_mid_top"], "item_contract_hard_mid_bot")
table.insert(SouthHardMissions["npc_dota_shop_mid_top"], "item_contract_hard_right_top")
table.insert(SouthHardMissions["npc_dota_shop_right_mid"], "item_contract_hard_left_top")
table.insert(SouthHardMissions["npc_dota_shop_right_mid"], "item_contract_hard_mid_mid")
table.insert(SouthHardMissions["npc_dota_shop_right_mid"], "item_contract_hard_left_mid")
table.insert(SouthHardMissions["npc_dota_shop_right_mid"], "item_contract_hard_left_bot")
table.insert(SouthHardMissions["npc_dota_shop_right_mid"], "item_contract_hard_mid_top")
table.insert(SouthHardMissions["npc_dota_shop_right_bot"], "item_contract_hard_left_top")
table.insert(SouthHardMissions["npc_dota_shop_right_bot"], "item_contract_hard_mid_mid")
table.insert(SouthHardMissions["npc_dota_shop_right_bot"], "item_contract_hard_left_mid")
table.insert(SouthHardMissions["npc_dota_shop_right_bot"], "item_contract_hard_mid_top")
table.insert(SouthHardMissions["npc_dota_shop_mid_bot"], "item_contract_hard_left_top")
table.insert(SouthHardMissions["npc_dota_shop_mid_bot"], "item_contract_hard_mid_mid")
table.insert(SouthHardMissions["npc_dota_shop_mid_bot"], "item_contract_hard_mid_top")
table.insert(SouthHardMissions["npc_dota_shop_mid_bot"], "item_contract_hard_right_top")
table.insert(SouthHardMissions["npc_dota_shop_right_top"], "item_contract_hard_left_top")
table.insert(SouthHardMissions["npc_dota_shop_right_top"], "item_contract_hard_mid_mid")
table.insert(SouthHardMissions["npc_dota_shop_right_top"], "item_contract_hard_left_mid")
table.insert(SouthHardMissions["npc_dota_shop_right_top"], "item_contract_hard_left_bot")
table.insert(SouthHardMissions["npc_dota_shop_right_top"], "item_contract_hard_mid_top")
table.insert(SouthHardMissions["npc_dota_shop_left_top"], "item_contract_medium_left_mid")
table.insert(SouthHardMissions["npc_dota_shop_left_top"], "item_contract_medium_left_bot")
table.insert(SouthHardMissions["npc_dota_shop_left_top"], "item_contract_medium_mid_bot")
table.insert(SouthHardMissions["npc_dota_shop_mid_mid"], "item_contract_medium_left_mid")
table.insert(SouthHardMissions["npc_dota_shop_mid_mid"], "item_contract_medium_left_bot")
table.insert(SouthHardMissions["npc_dota_shop_mid_mid"], "item_contract_medium_right_mid")
table.insert(SouthHardMissions["npc_dota_shop_mid_mid"], "item_contract_medium_right_bot")
table.insert(SouthHardMissions["npc_dota_shop_left_mid"], "item_contract_medium_left_top")
table.insert(SouthHardMissions["npc_dota_shop_left_mid"], "item_contract_medium_mid_bot")
table.insert(SouthHardMissions["npc_dota_shop_left_bot"], "item_contract_medium_left_top")
table.insert(SouthHardMissions["npc_dota_shop_mid_top"], "item_contract_medium_left_mid")
table.insert(SouthHardMissions["npc_dota_shop_mid_top"], "item_contract_medium_right_mid")
table.insert(SouthHardMissions["npc_dota_shop_right_mid"], "item_contract_medium_mid_bot")
table.insert(SouthHardMissions["npc_dota_shop_right_mid"], "item_contract_medium_right_top")
table.insert(SouthHardMissions["npc_dota_shop_right_bot"], "item_contract_medium_right_top")
table.insert(SouthHardMissions["npc_dota_shop_right_top"], "item_contract_medium_right_mid")
table.insert(SouthHardMissions["npc_dota_shop_right_top"], "item_contract_medium_right_bot")
table.insert(SouthHardMissions["npc_dota_shop_right_top"], "item_contract_medium_mid_bot")




table.insert(NorthEasyMissions["npc_dota_shop_left_top"], "item_contract_medium_left_bot")
table.insert(NorthEasyMissions["npc_dota_shop_mid_mid"], "item_contract_medium_left_top")
table.insert(NorthEasyMissions["npc_dota_shop_mid_mid"], "item_contract_medium_left_mid")
table.insert(NorthEasyMissions["npc_dota_shop_mid_mid"], "item_contract_medium_right_mid")
table.insert(NorthEasyMissions["npc_dota_shop_mid_mid"], "item_contract_medium_right_top")
table.insert(NorthEasyMissions["npc_dota_shop_left_mid"], "item_contract_medium_left_bot")
table.insert(NorthEasyMissions["npc_dota_shop_left_mid"], "item_contract_medium_mid_top")
table.insert(NorthEasyMissions["npc_dota_shop_left_bot"], "item_contract_medium_left_top")
table.insert(NorthEasyMissions["npc_dota_shop_left_bot"], "item_contract_medium_left_mid")
table.insert(NorthEasyMissions["npc_dota_shop_left_bot"], "item_contract_medium_mid_top")
table.insert(NorthEasyMissions["npc_dota_shop_right_mid"], "item_contract_medium_mid_top")
table.insert(NorthEasyMissions["npc_dota_shop_right_mid"], "item_contract_medium_right_bot")
table.insert(NorthEasyMissions["npc_dota_shop_right_bot"], "item_contract_medium_mid_top")
table.insert(NorthEasyMissions["npc_dota_shop_right_bot"], "item_contract_medium_right_mid")
table.insert(NorthEasyMissions["npc_dota_shop_right_bot"], "item_contract_medium_right_top")
table.insert(NorthEasyMissions["npc_dota_shop_mid_bot"], "item_contract_medium_left_mid")
table.insert(NorthEasyMissions["npc_dota_shop_mid_bot"], "item_contract_medium_right_mid")
table.insert(NorthEasyMissions["npc_dota_shop_right_top"], "item_contract_medium_right_bot")


table.insert(SouthEasyMissions["npc_dota_shop_left_top"], "item_contract_medium_left_mid")
table.insert(SouthEasyMissions["npc_dota_shop_left_top"], "item_contract_medium_left_bot")
table.insert(SouthEasyMissions["npc_dota_shop_left_top"], "item_contract_medium_mid_bot")
table.insert(SouthEasyMissions["npc_dota_shop_mid_mid"], "item_contract_medium_left_mid")
table.insert(SouthEasyMissions["npc_dota_shop_mid_mid"], "item_contract_medium_left_bot")
table.insert(SouthEasyMissions["npc_dota_shop_mid_mid"], "item_contract_medium_right_mid")
table.insert(SouthEasyMissions["npc_dota_shop_mid_mid"], "item_contract_medium_right_bot")
table.insert(SouthEasyMissions["npc_dota_shop_left_mid"], "item_contract_medium_left_top")
table.insert(SouthEasyMissions["npc_dota_shop_left_mid"], "item_contract_medium_mid_bot")
table.insert(SouthEasyMissions["npc_dota_shop_left_bot"], "item_contract_medium_left_top")
table.insert(SouthEasyMissions["npc_dota_shop_mid_top"], "item_contract_medium_left_mid")
table.insert(SouthEasyMissions["npc_dota_shop_mid_top"], "item_contract_medium_right_mid")
table.insert(SouthEasyMissions["npc_dota_shop_right_mid"], "item_contract_medium_mid_bot")
table.insert(SouthEasyMissions["npc_dota_shop_right_mid"], "item_contract_medium_right_top")
table.insert(SouthEasyMissions["npc_dota_shop_right_bot"], "item_contract_medium_right_top")
table.insert(SouthEasyMissions["npc_dota_shop_right_top"], "item_contract_medium_right_mid")
table.insert(SouthEasyMissions["npc_dota_shop_right_top"], "item_contract_medium_right_bot")
table.insert(SouthEasyMissions["npc_dota_shop_right_top"], "item_contract_medium_mid_bot")
end



function CBattleship8D:OrderExecutionFilter(keys)
  
  local playerID = keys.issuer_player_id_const
  local ability = EntIndexToHScript(keys.entindex_ability)
  local target = EntIndexToHScript(keys.entindex_target)
  local orderType = keys.order_type
  local queuePos = keys.queue
  local player = PlayerResource:GetPlayer(playerID)


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

function CBattleship8D:OnNPCSpawned(keys)
if BOAT_JUST_BAUGHT ==0 then
  local npc = EntIndexToHScript(keys.entindex)
  if THINK_TICKS > 20 then
  if npc:IsIllusion() then
			npc:SetModel( "models/noah_boat.vmdl" )
			npc:SetOriginalModel( "models/noah_boat.vmdl" )
		end
	if npc:IsRealHero() then
		RemoveWearables( npc )
		stopPhysics(npc)
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
  else
  BOAT_JUST_BAUGHT=0
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
				badGoldEach = badGoldEach + GoldDif * (DOCK_SOUTH_LEFT + DOCK_SOUTH_RIGHT)/2 * (0.1 + 0.8 * (1/EMP_GOLD_NUMBER))
				BAD_GOLD_TOTAL_MOD = 0
				GOOD_GOLD_TOTAL_MOD = GoldDif
				empGoldHist=empGoldHist .. "N:" .. EMP_GOLD_NUMBER .. "L:S "
				storage:SetEmpGoldHist(empGoldHist)
			elseif BAD_GOLD_TOTAL_MOD > GOOD_GOLD_TOTAL_MOD then
				GoldDif = BAD_GOLD_TOTAL_MOD - GOOD_GOLD_TOTAL_MOD
				goodGoldEach = goodGoldEach + GoldDif * (DOCK_NORTH_LEFT + DOCK_NORTH_RIGHT)/2 * (0.1 + 0.8 * (1/EMP_GOLD_NUMBER))
				BAD_GOLD_TOTAL_MOD = GoldDif
				GOOD_GOLD_TOTAL_MOD = 0
				empGoldHist=empGoldHist .. "N:" .. EMP_GOLD_NUMBER .. "L:N "
				storage:SetEmpGoldHist(empGoldHist)
			end
			if NUM_GOOD_PLAYERS ~= 0 and NUM_BAD_PLAYERS ~= 0 then
				goodGoldEach = goodGoldEach / NUM_GOOD_PLAYERS
				badGoldEach = badGoldEach / NUM_BAD_PLAYERS
			end
			--trying out full game igold team comparison stuff crap shit
			--BAD_GOLD_TOTAL_MOD = 0
			--GOOD_GOLD_TOTAL_MOD = 0
			Notifications:TopToAll({text="#emp_gold", duration=5.0, style={color="#B2B2B2",  fontSize="50px;"}})
			Notifications:TopToAll({text="#north_gets", duration=5.0, style={color="#B2B2B2",  fontSize="30px;"}})
			Notifications:TopToAll({text=tostring(math.floor(badGoldEach+0.5)) .. " ", duration=5.0, style={color="#FFD700",  fontSize="30px;"}, continue=true})
			Notifications:TopToAll({text="#for_each_player", duration=5.0, style={color="#B2B2B2",  fontSize="30px;"}, continue=true})
			Notifications:TopToAll({text="#south_gets", duration=5.0, style={color="#B2B2B2",  fontSize="30px;"}})
			Notifications:TopToAll({text=tostring(math.floor(goodGoldEach+0.5)) .. " ", duration=5.0, style={color="#FFD700",  fontSize="30px;"}, continue=true})
			Notifications:TopToAll({text="#for_each_player", duration=5.0, style={color="#B2B2B2",  fontSize="30px;"}, continue=true})
			 table.insert(empGoldArray,{
			 Emp_Gold_Number=EMP_GOLD_NUMBER,
			 South_Gold=goodGoldEach,
			 North_gold=badGoldEach,
			 })
			
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
					 creature = CreateUnitByName( "npc_dota_boat_" .. team .. "_" .. tier , spawnLocation:GetAbsOrigin() + Vector(-300 + i * 200,0,0), true, nil, nil, DOTA_TEAM_BADGUYS )
				else
					 creature = CreateUnitByName( "npc_dota_boat_" .. team .. "_" .. tier , spawnLocation:GetAbsOrigin() + Vector(-300 + i * 200,0,0), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end
                --Sets the waypath to follow. path_wp1 in this example
				if creature~=nil then
						creature:CreatureLevelUp(level)
				end
				
                i = i + 1
        end
	reapplyWP()
end

function getEmpGoldForTeam(team)
			local gold = 0
			local team_players = 0
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 then
					local herogold = hero:GetGold()
					if herogold>0 and not hero:HasModifier("pergatory_perm") then
						if hero:GetTeamNumber() == team then
							team_players = team_players + 1
						end
					end
				end
			end
			if team_players==0 then
				team_players=1
			end
			 local minGold = 500 * EMP_GOLD_NUMBER
			local goldEach = 500 * EMP_GOLD_NUMBER
			local GoldDif = 0
			
			if GOOD_GOLD_TOTAL_MOD > BAD_GOLD_TOTAL_MOD then
				GoldDif = GOOD_GOLD_TOTAL_MOD - BAD_GOLD_TOTAL_MOD
				goldEach = goldEach + GoldDif * (DOCK_SOUTH_LEFT + DOCK_SOUTH_RIGHT)/2 * (0.1 + 0.8 * (1/EMP_GOLD_NUMBER))
				BAD_GOLD_TOTAL_MOD = 0
				GOOD_GOLD_TOTAL_MOD = GoldDif
				if team == DOTA_TEAM_BADGUYS  then 
					return goldEach / team_players
					else
					return minGold / team_players
				end
			end
			if BAD_GOLD_TOTAL_MOD > GOOD_GOLD_TOTAL_MOD then
				GoldDif = BAD_GOLD_TOTAL_MOD - GOOD_GOLD_TOTAL_MOD
				goldEach = goldEach + GoldDif * (DOCK_NORTH_LEFT + DOCK_NORTH_RIGHT)/2 * (0.1 + 0.8 * (1/EMP_GOLD_NUMBER))
				BAD_GOLD_TOTAL_MOD = GoldDif
				GOOD_GOLD_TOTAL_MOD = 0
				if team == DOTA_TEAM_GOODGUYS  then 
					return goldEach  / team_players
					else
					return minGold / team_players
				end
			end
			if NUM_GOOD_PLAYERS ~= 0 and NUM_BAD_PLAYERS ~= 0 then
				return goldEach / team_players
			end
			return goldEach / team_players
		
end

function reapplyWP()
	for _,creep in pairs( Entities:FindAllByClassname( "npc_dota_cre*" )) do
		if creep:HasGroundMovementCapability() and not creep:IsAncient() and not creep:HasModifier("ghost_ship_creep") then
			local waypoint =nil
				if creep~=nil then
					if creep:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
						 waypoint = Entities:FindByNameNearest( "south_wp_*", creep:GetOrigin(), 0 )
					elseif  creep:GetTeamNumber() == DOTA_TEAM_BADGUYS then
						 waypoint = Entities:FindByNameNearest( "north_wp_*", creep:GetOrigin(), 0 )
					end
					if waypoint then
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
				end
		end
	end
end
-- Evaluate the state of the game

function sellBoat(casterUnit)
local hero = casterUnit
  local herogold = casterUnit:GetGold()
	if string.match(hero:GetName(),"disruptor") then
							hero:SetGold(herogold + 2250, true)
							hero:SetGold(0, false)
							 print ( '[BAREBONES] player was disruptor and got 2250')
						elseif string.match(hero:GetName(),"ursa") then
							hero:SetGold(herogold + 6000, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was ursa and got 6000')
						elseif string.match(hero:GetName(),"meepo") then
							hero:SetGold(herogold + 4500, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was meepo and got 4500')
						elseif string.match(hero:GetName(),"tidehunter") then
							hero:SetGold(herogold + 750, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was tidehunter and got 750')
						elseif string.match(hero:GetName(),"apparition") then
							hero:SetGold(herogold + 750, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was apparition and got 750')
						elseif string.match(hero:GetName(),"rattletrap") then
							hero:SetGold(herogold + 750, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was rattletrap and got 750')
						elseif string.match(hero:GetName(),"morphling") then
							hero:SetGold(herogold + 2250, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was morphling and got 2250')
						elseif string.match(hero:GetName(),"storm_spirit") then
							hero:SetGold(herogold + 2250, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was storm_spirit and got 2250')
						elseif string.match(hero:GetName(),"ember_spirit") then
							hero:SetGold(herogold + 4500, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was zuus and got 6000')
						elseif string.match(hero:GetName(),"slark") then
							hero:SetGold(herogold + 4500, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was npc_dota_hero_winter_wyvern and got 4500')
						elseif string.match(hero:GetName(),"jakiro") then
							hero:SetGold(herogold + 4500, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was jakiro and got 4500')
						elseif string.match(hero:GetName(),"lion") then
							hero:SetGold(herogold + 2250, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was lion and got 2250')
						elseif string.match(hero:GetName(),"tusk") then
							hero:SetGold(herogold + 6000, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was tusk and got 6000')
						elseif string.match(hero:GetName(),"visage") then
							hero:SetGold(herogold + 6000, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was visage and got 4500')
						elseif string.match(hero:GetName(),"nevermore") then
							hero:SetGold(herogold + 2250, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was nevermore and got 2250')
						elseif string.match(hero:GetName(),"shredder") then
							hero:SetGold(herogold + 4500, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was sniper and got 2250')
						elseif string.match(casterUnit:GetName(),"wind") then
							casterUnit:SetGold(herogold + 6000, true)
							casterUnit:SetGold(0, false)
							print ( '[BAREBONES] player was lone_druid and got 6000')
						elseif string.match(casterUnit:GetName(),"crystal") then
							casterUnit:SetGold(herogold + 750, true)
							casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was lone_druid and got 6000')
						elseif string.match(hero:GetName(),"phantom") then
							hero:SetGold(herogold + 750, true)
							hero:SetGold(0, false)
							print ( '[BAREBONES] player was phantom_lancer and got 750')
						elseif string.match(hero:GetName(),"vengefulspirit") then
							hero:SetGold(herogold + 500, true)
							hero:SetGold(0, false)
						elseif string.match(hero:GetName(),"enigma") then
							hero:SetGold(herogold + 3000, true)
							hero:SetGold(0, false)
						elseif string.match(hero:GetName(),"bane") then
							hero:SetGold(herogold + 5000, true)
							hero:SetGold(0, false)
							
					end
end

function CBattleship8D:OnThink()
		if THINK_TICKS < 160 then
			if NUM_PLAYERS == 0 then
				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
						NUM_PLAYERS=NUM_PLAYERS+1
						RemoveWearables( hero )
					end
				end
			end
		end
			 
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if GameRules:GetGameTime() ~= LAST_TIME then
			
					if THINK_TICKS == 5 then
		Timers:CreateTimer( 300, function()
			spawnTide()
		end)
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
		if THINK_TICKS == 7 then	
		 Notifications:TopToAll({text="#inst_five", duration=6.0, style={color="#07C300",  fontSize="18px;"}})
		 Notifications:TopToAll({text="#inst_six", duration=6.0, style={color="#58ACFA",  fontSize="18px;"}, continue=true})
		 Notifications:TopToAll({text="#inst_seven", duration=6.0, style={color="#07C300",  fontSize="18px;"}, continue=true})
		 Notifications:TopToAll({text="#inst_eight", duration=6.0, style={color="#58ACFA",  fontSize="18px;"}, continue=true})
		
			NUM_GOOD_PLAYERS = 0
			NUM_BAD_PLAYERS = 0
				for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
					if hero ~= nil and hero:IsOwnedByAnyPlayer() then
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
			local i=0
			while i < 5-NUM_GOOD_PLAYERS do
			GOOD_GOLD_PER_TICK = GOOD_GOLD_PER_TICK + 1
			i=i+1
			end
			i=0
			while i < 5-NUM_BAD_PLAYERS do
			BAD_GOLD_PER_TICK = BAD_GOLD_PER_TICK + 1
			i=i+1
			end
		end
		
		
		--iterates through heroes every 2 seconds
		if THINK_TICKS % 2 == 0 then
			if THINK_TICKS % 4 == 0 and SPY_ANNOUNCMENT_FLAG == 1 then
				SPY_ANNOUNCMENT_FLAG = 0
				 Notifications:TopToAll({text="#buy_spy_header", duration=4.0, style={color="#58ACFA",  fontSize="30px;"}})
				 Notifications:TopToAll({text="#spys_south_start", duration=4.0, style={color="#CC33FF",  fontSize="30px;"}})
				 Notifications:TopToAll({text=tostring(SPYS_SOUTH) .. " ", duration=4.0, style={color="#CC3300",  fontSize="30px;"}, continue=true})
				 Notifications:TopToAll({text="#spys_end", duration=4.0, style={color="#CC33FF",  fontSize="30px;"}, continue=true})
				 Notifications:TopToAll({text="#spys_north_start", duration=4.0, style={color="#CC33FF",  fontSize="30px;"}})
				 Notifications:TopToAll({text=tostring(SPYS_NORTH) .. " ", duration=4.0, style={color="#CC3300",  fontSize="30px;"}, continue=true})
				 Notifications:TopToAll({text="#spys_end", duration=4.0, style={color="#CC33FF",  fontSize="30px;"}, continue=true})
				
				
			end
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 then
					HandleShopChecks(hero)
					if hero:IsIllusion() then
						hero:SetModel( "models/noah_boat.vmdl" )
						hero:SetOriginalModel( "models/noah_boat.vmdl" )
					end
					if string.match(hero:GetName(),"tusk") then
							local casterUnit = hero
							--print('[ItemFunctions] wind_ult_buffet end loaction ' .. tostring(targetPos))
							--print('[AbilityFunctions] battleshipHealth started!')
							if casterUnit:IsAlive() and hero:IsOwnedByAnyPlayer() and herohp[casterUnit:GetPlayerID()] == nil then
								herohp[casterUnit:GetPlayerID()] = casterUnit:GetHealthPercent() 
								casterUnit:SetModel("models/battleship_boat0")
								casterUnit:SetOriginalModel("models/battleship_boat0")
							end
							if casterUnit:IsAlive() and hero:IsOwnedByAnyPlayer() then
								if casterUnit:GetHealthPercent() < 7  and herohp[casterUnit:GetPlayerID()] > 6 then
									casterUnit:SetModel("models/battleship_boat4")
									casterUnit:SetOriginalModel("models/battleship_boat4")
								--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() < 25 and herohp[casterUnit:GetPlayerID()] > 24 then
									casterUnit:SetModel("models/battleship_boat3")
									casterUnit:SetOriginalModel("models/battleship_boat3")
									--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() < 50 and herohp[casterUnit:GetPlayerID()] > 49 then
									casterUnit:SetModel("models/battleship_boat2")
									casterUnit:SetOriginalModel("models/battleship_boat2")
									--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() < 75 and herohp[casterUnit:GetPlayerID()] > 74 then
									casterUnit:SetModel("models/battleship_boat1")
									casterUnit:SetOriginalModel("models/battleship_boat1")
									--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								elseif casterUnit:GetHealthPercent() > 74 and herohp[casterUnit:GetPlayerID()] < 75 then
									casterUnit:SetModel("models/battleship_boat0")
									casterUnit:SetOriginalModel("models/battleship_boat0")
									--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								--print('[AbilityFunctions] battleshipHealth found hp to be' .. casterUnit:GetHealthPercent())
								end
									herohp[casterUnit:GetPlayerID()] = casterUnit:GetHealthPercent() 
							end
						end
						
					
							local casterPos = hero:GetAbsOrigin()
							local targetUnitOne = Entities:FindByName( nil, "south_kicker")
							local targetUnitTwo = Entities:FindByName( nil, "north_kicker")
							local directionOne =  casterPos - targetUnitOne:GetAbsOrigin()
							local directionTwo =  casterPos - targetUnitTwo:GetAbsOrigin()
						
						
						
		

						
						if PlayerResource:GetConnectionState( hero:GetPlayerID() ) ~= 2 or hero:HasOwnerAbandoned() or hero:HasModifier("pergatory_perm") then
								print('inside disconnect')
										if DisconnectTime[hero]~= nil then
											DisconnectTime[hero]=DisconnectTime[hero]+2
											print('disconnect time: ' .. DisconnectTime[hero])
											else
											DisconnectTime[hero]=1
										end
											if DisconnectTime[hero]==180 or DisconnectTime[hero]==181 then
											Notifications:TopToAll({text="#player_kickable", duration=6.0, style={color="#800000",  fontSize="30px;"}})
				
											 					
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
										if (DisconnectKicked[hero] == 1 and NUM_PLAYERS>1 or hero:HasOwnerAbandoned()) and herogold > 30 and false == hero:HasModifier("pergatory_perm") and NUM_PLAYERS>1 then
											GameRules:SendCustomMessage("#remove_player", DOTA_TEAM_GOODGUYS, 0)
											storage:SetDisconnectState(DisconnectKicked)
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
						if height:Length() > 110 and false == hero:HasModifier("line_mod")  and false == hero:HasModifier("fly_bat") and false == hero:HasModifier("fly") and false == hero:HasModifier("modifier_spirit_breaker_charge_of_darkness") and false == hero:HasModifier("modifier_kunkka_torrent") and false == hero:HasModifier("modifier_batrider_flaming_lasso") and false == hero:HasModifier("modifier_mirana_leap")  and false == hero:IsStunned() and  hero:IsAlive()  then 
							
							local abil1 = hero:GetAbilityByIndex(1)
							
							print( 'player found at z of: ' .. tostring(height:Length()) .. "and cd check is " .. tostring(abil1:GetCooldownTimeRemaining() > abil1:GetCooldown(abil1:GetLevel())-2) .. " and name of hero is " .. hero:GetName() .. " so name check is " .. tostring(string.match(hero:GetName(),"morphling")))
						
							if abil1:GetCooldownTimeRemaining() >= abil1:GetCooldown(abil1:GetLevel())-2 and (string.match(hero:GetName(),"morphling") or string.match(hero:GetName(),"kunkka")) then
							
							else
								lasth=LastLocs[hero]*Vector(0,0,1)
								if	lasth:Length() <110 then
									hero:SetOrigin(LastLocs[hero])		
									else
									hero:SetOrigin(LastLocs2[hero])		
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
							if LastLocs[hero]~=nil then
								if LastLocs2[hero] ~=nil and (LastLocs[hero] - hero:GetOrigin()):Length() >20 then
									LastLocs2[hero] = LastLocs[hero]
									--print("update ll2")
								elseif LastLocs2[hero]==nil then
									LastLocs2[hero] = LastLocs[hero]
								--	print("irst time ll2")
								else
								--	print("no update ll2")
								end
							end
							if  LastLocs[hero]~=nil and (LastLocs[hero] - hero:GetOrigin()):Length() >20 then
								--print((LastLocs[hero] - hero:GetOrigin()):Length())
								LastLocs[hero] = hero:GetOrigin()
							elseif LastLocs[hero]==nil then
							--	print("first time")
								LastLocs[hero] = hero:GetOrigin()
								--print((LastLocs[hero] - hero:GetOrigin()):Length())
								else
							--	print("no update ll")
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
		
		if THINK_TICKS % 2 == 0 then
			reapplyWP()
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
		if THINK_TICKS % 240 == 0 then
			CREEP_LEVEL=CREEP_LEVEL+1
		end
		
		
		local bsuiTimerData = {
			nEmpire = 240-THINK_TICKS % 240;
			nCreep = nCreepval;
			nNorthGold = getEmpGoldForTeam(DOTA_TEAM_BADGUYS);
			nSouthGold = getEmpGoldForTeam(DOTA_TEAM_GOODGUYS);
			
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
		Notifications:TopToAll({text=keys.name, duration=5.0, style={color="#800000",  fontSize="18px;"}})
		Notifications:TopToAll({text="#dc_drop", duration=5.0, style={color="#800000",  fontSize="18px;"}, continue=true})
		
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
end


function CBattleship8D:OnEntityKilled( keys )
	
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	
	--handle tower gold
	if killedUnit:IsTower()  then
			print( "Tower Killed" )
			if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS and not string.match(killedUnit:GetUnitName(), "dock") then
				GOOD_GOLD_PER_TICK = GOOD_GOLD_PER_TICK + 2
				print( "Bad Tower, Good guys gold per tick is now: " .. GOOD_GOLD_PER_TICK )
				Notifications:TopToAll({text="#north_tower_died", duration=5.0, style={color="#FF6600",  fontSize="18px;"}})
				Notifications:TopToAll({text=tostring(100), duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})

		
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
			elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS and not string.match(killedUnit:GetUnitName(), "dock") then
				BAD_GOLD_PER_TICK = BAD_GOLD_PER_TICK + 2
				print( "Good Tower, Bad guys gold per tick is now: " .. BAD_GOLD_PER_TICK )
				Notifications:TopToAll({text="#south_tower_died", duration=5.0, style={color="#FF6600",  fontSize="18px;"}})
				Notifications:TopToAll({text=tostring(100), duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})

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
					GoodWon=true

					
					GameRules:SendCustomMessage("#wrap_up", DOTA_TEAM_GOODGUYS, 0)
					storage:SetWinner("South")
					GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
					GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
					
					GameRules:SetSafeToLeave( true )
				elseif string.match(killedUnit:GetUnitName(), "left") then
					DOCK_NORTH_LEFT = 0
					Notifications:TopToAll({text="#left_north_harbor_died", duration=5.0, style={color="#FF6600",  fontSize="50px;"}})
				elseif string.match(killedUnit:GetUnitName(), "right") then
					DOCK_NORTH_RIGHT = 0
					Notifications:TopToAll({text="#right_north_harbor_died", duration=5.0, style={color="#FF6600",  fontSize="50px;"}})
				
				end
				
				
			elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS then
				if DOCK_SOUTH_LEFT+DOCK_SOUTH_RIGHT==1 then
					GoodWon=false

					GameRules:SendCustomMessage("#wrap_up", DOTA_TEAM_GOODGUYS, 0)
					storage:SetWinner("North")
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
					
					GameRules:SetSafeToLeave( true )
				elseif string.match(killedUnit:GetUnitName(), "left") then
					DOCK_SOUTH_LEFT = 0
					Notifications:TopToAll({text="#left_north_harbor_died", duration=5.0, style={color="#B2B2B2",  fontSize="18px;"}})
			
				elseif string.match(killedUnit:GetUnitName(), "right") then
					DOCK_SOUTH_RIGHT = 0
					Notifications:TopToAll({text="#right_south_harbor_died", duration=5.0, style={color="#B2B2B2",  fontSize="18px;"}})
			
				end
				
			end
			print( "North docks:" .. DOCK_NORTH_LEFT .. DOCK_NORTH_RIGHT )
			print( "South docks:" .. DOCK_SOUTH_LEFT .. DOCK_SOUTH_RIGHT )
		end
		
		--handle ending game
		if string.match(killedUnit:GetUnitName(), "base") then
			print( "MATCHED BASE IS TRUE" )
			if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS then
					GoodWon=true
				storage:SetWinner("South")
				GameRules:SendCustomMessage("#wrap_up", DOTA_TEAM_GOODGUYS, 0)
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
				
				GameRules:SetSafeToLeave( true )
			elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS then
				GoodWon=false

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
		CBattleship8D:quickSpawn("north","right", "four", 1, CREEP_NUM_HUGE+2)
		CBattleship8D:quickSpawn("north","left", "four", 1, CREEP_NUM_HUGE+2)
		GameRules:SendCustomMessage("#north_tide", DOTA_TEAM_GOODGUYS, 0)
		Notifications:TopToAll({hero="npc_dota_hero_tidehunter", imagestyle="portrait", continue=true})
		Notifications:TopToAll({text="#north_tide", duration=5.0, style={color="#44BB44",  fontSize="50px;"}, continue=true})
			 table.insert(tideKillerArray,{
			 Killer_Team="North",
			 Game_time=GameRules:GetGameTime()/60+0.5,
			 })
			 tideKiller=tideKiller .. "N" .. math.floor(GameRules:GetGameTime()/60+0.5)
			 storage:SetTideKillers(tideKiller)
	end
	if  killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		CBattleship8D:quickSpawn("south","right", "four", 1, CREEP_NUM_HUGE+2)
		CBattleship8D:quickSpawn("south","left", "four", 1, CREEP_NUM_HUGE+2)
		Notifications:TopToAll({hero="npc_dota_hero_tidehunter", imagestyle="portrait", continue=true})
		Notifications:TopToAll({text="#south_tide", duration=5.0, style={color="#44BB44",  fontSize="50px;"}, continue=true})
		 table.insert(tideKillerArray,{
			 Killer_Team="South",
			 Game_time=GameRules:GetGameTime()/60+0.5,
			 })
			  tideKiller=tideKiller .. "S" .. math.floor(GameRules:GetGameTime()/60+0.5)
			  storage:SetTideKillers(tideKiller)
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
  if killedUnit:GetGoldBounty() and killerEntity:IsRealHero() then
		if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + killedUnit:GetGoldBounty()
		elseif killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + killedUnit:GetGoldBounty()
		end
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
	if killerEntity:IsRealHero() then
	  
	  if killedUnit:IsRealHero() then 
	  if herokills[killedUnit:GetPlayerID()] > 2 then
		if killerEntity ~= nil and killerEntity:IsOwnedByAnyPlayer() then
			local herogold = killerEntity:GetGold()
			if killerEntity:GetTeamNumber() ~= killedUnit:GetTeam()  then
				killerEntity:SetGold(herogold + herokills[killedUnit:GetPlayerID()] * 100, true)
				killerEntity:SetGold(0, false)
				if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + herokills[killedUnit:GetPlayerID()] * 100
					Notifications:BottomToAll({text="#streak_end_one_n", duration=5.0, style={color="#A70606",  fontSize="30px;"}})
					Notifications:BottomToAll({text=tostring(killerEntity:GetStreak() * 100) .. " ", duration=5.0, style={color="#FFD700",  fontSize="30px;"}, continue=true})
					Notifications:BottomToAll({text="#streak_end_two_n", duration=5.0, style={color="#A70606",  fontSize="30px;"}, continue=true})
				
				elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
					BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + herokills[killedUnit:GetPlayerID()] * 100
					Notifications:BottomToAll({text="#streak_end_one_s", duration=5.0, style={color="#A70606",  fontSize="30px;"}})
					Notifications:BottomToAll({text=tostring(killerEntity:GetStreak() * 100) .. " ", duration=5.0, style={color="#FFD700",  fontSize="30px;"}, continue=true})
					Notifications:BottomToAll({text="#streak_end_two_s", duration=5.0, style={color="#A70606",  fontSize="30px;"}, continue=true})
				
				end
			end
		end
			herokills[killedUnit:GetPlayerID()] = 0
	   end
-- handle awarding kill streak gold
	herokills[killerEntity:GetPlayerID()] = herokills[killerEntity:GetPlayerID()] + 1
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
		
			if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD - killerEntity:GetStreak() * 30
				Notifications:BottomToAll({text="#streak_reward_one_n", duration=5.0, style={color="#A70606",  fontSize="18px;"}})
				Notifications:BottomToAll({text=tostring(killerEntity:GetStreak() * 30) .. " ", duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
				Notifications:BottomToAll({text="#streak_reward_two_n", duration=5.0, style={color="#A70606",  fontSize="18px;"}, continue=true})
			
			elseif  killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD - killerEntity:GetStreak() * 30
				Notifications:BottomToAll({text="#streak_reward_one_s", duration=5.0, style={color="#A70606",  fontSize="18px;"}})
				Notifications:BottomToAll({text=tostring(killerEntity:GetStreak() * 30) .. " ", duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
				Notifications:BottomToAll({text="#streak_reward_two_s", duration=5.0, style={color="#A70606",  fontSize="18px;"}, continue=true})
			
			end
		end
		if  killerEntity == killedUnit then
			Notifications:BottomToAll({text="#kill_self_one", duration=5.0, style={color="#A70606",  fontSize="18px;"}})
			Notifications:BottomToAll({text=tostring(killerEntity:GetGoldBounty()) .. " ", duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
			Notifications:BottomToAll({text="#kill_self_two", duration=5.0, style={color="#A70606",  fontSize="18px;"}, continue=true})

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
						Notifications:BottomToAll({text=PlayerResource:GetPlayerName( killerEntity:GetPlayerID()) .. " ", duration=5.0, style={color="#FF9955",  fontSize="18px;"}})
						Notifications:BottomToAll({text="#avenge_one", duration=5.0, style={color="#FF9900",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text=PlayerResource:GetPlayerName( hero:GetPlayerID()) .. " ", duration=5.0, style={color="#FF9955",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text="#avenge_two", duration=5.0, style={color="#FF9900",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text=tostring(math.floor(bounty/4+0.5)) .. " ", duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text="#avenge_three", duration=5.0, style={color="#FF9900",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text=tostring(math.floor(bounty/2+0.5)) .. " ", duration=5.0, style={color="#FFD700",  fontSize="18px;"}, continue=true})
						Notifications:BottomToAll({text="#avenge_four", duration=5.0, style={color="#FF9900",  fontSize="18px;"}, continue=true})
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
			CBattleship8D:quickSpawn("north","right", "four", 1, CREEP_NUM_HUGE+2)
			CBattleship8D:quickSpawn("north","left", "four", 1, CREEP_NUM_HUGE+2)
			Notifications:TopToAll({text="#team_wipe_north", duration=5.0, style={color="#44BB44",  fontSize="50px;"}, continue=true})

						
		end
		if badDead == NUM_BAD_PLAYERS and killedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS and NUM_BAD_PLAYERS>1 then
			CBattleship8D:quickSpawn("south","right", "four", 1, CREEP_NUM_HUGE+2)
			CBattleship8D:quickSpawn("south","left", "four", 1, CREEP_NUM_HUGE+2)
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
                print("Reconnecting hero for player ")
				casterUnit = hero
            end
		end
    end
local itemName = keys.itemname 
if item_code_lookup[itemName] ~= nil then
print(item_code_lookup[itemName])
	  storage:AddToPlayerItemHist(casterUnit:GetPlayerID(),item_code_lookup[itemName])--math.floor(GameRules:GetGameTime()/60+0.5) .. item_code_lookup[itemName])
end	  
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
				become_boat(casterUnit, "npc_dota_hero_disruptor")
				elseif string.match(itemName,"gyrocopter") then
					become_boat(casterUnit, "npc_dota_hero_ursa")
				elseif string.match(itemName,"brewmaster") then
					become_boat(casterUnit, "npc_dota_hero_meepo")
				elseif string.match(itemName,"tidehunter") then
					become_boat(casterUnit, "npc_dota_hero_tidehunter")
				elseif string.match(itemName,"puck") then
					become_boat(casterUnit, "npc_dota_hero_ancient_apparition")
				elseif string.match(itemName,"morphling") then
					become_boat(casterUnit, "npc_dota_hero_morphling")
				elseif string.match(itemName,"storm_spirit") then
					become_boat(casterUnit, "npc_dota_hero_storm_spirit")
				elseif string.match(itemName,"zuus") then
					become_boat(casterUnit, "npc_dota_hero_ember_spirit")
				elseif string.match(itemName,"magnus") then
					become_boat(casterUnit, "npc_dota_hero_slark")
				elseif string.match(itemName,"jakiro") then
					become_boat(casterUnit, "npc_dota_hero_jakiro")
				elseif string.match(itemName,"lion") then
					become_boat(casterUnit, "npc_dota_hero_lion")
				elseif string.match(itemName,"spectre") then
					become_boat(casterUnit, "npc_dota_hero_tusk")
				elseif string.match(itemName,"visage") then
					become_boat(casterUnit, "npc_dota_hero_visage")
				elseif string.match(itemName,"nevermore") then
					become_boat(casterUnit, "npc_dota_hero_nevermore")
				elseif string.match(itemName,"rubick") then
					become_boat(casterUnit, "npc_dota_hero_rattletrap")
				elseif string.match(itemName,"shredder") then
					become_boat(casterUnit, "npc_dota_hero_sniper")
				elseif string.match(itemName,"treant") then
					become_boat(casterUnit, "npc_dota_hero_windrunner")
				elseif string.match(itemName,"crystal") then
					become_boat(casterUnit, "npc_dota_hero_crystal_maiden")
				elseif string.match(itemName,"phantom") then
					become_boat(casterUnit, "npc_dota_hero_phantom_lancer")
				elseif string.match(itemName,"wisp") then
					become_boat(casterUnit, "npc_dota_hero_pugna")
			end
		else
		
		 Notifications:Top(casterUnit:GetPlayerID(), {text="#to_base", duration=3.0, style={color="#800000",  fontSize="50px;"}})
				
				
				if string.match(itemName,"kunkka") then
					casterUnit:SetGold(herogold + 3000, true)
					casterUnit:SetGold(0, false)
					 print ( '[BAREBONES] player was disruptor and got 3000')
				elseif string.match(itemName,"gyrocopter") then
					casterUnit:SetGold(herogold + 10000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was ursa and got 10000')
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
					print ( '[BAREBONES] player was npc_dota_hero_winter_wyvern and got 6000')
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
					print ( '[BAREBONES] player was visage and got 6000')
				elseif string.match(itemName,"nevermore") then
					casterUnit:SetGold(herogold + 3000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was nevermore and got 3000')
				elseif string.match(itemName,"sniper") then
					casterUnit:SetGold(herogold + 6000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was sniper and got 3000')
				elseif string.match(itemName,"treant") then
					casterUnit:SetGold(herogold + 10000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was lone_druid and got 10000')
				elseif string.match(itemName,"wisp") then
					casterUnit:SetGold(herogold + 10000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was lone_druid and got 10000')
				elseif string.match(itemName,"crystal") then
					casterUnit:SetGold(herogold + 1000, true)
					casterUnit:SetGold(0, false)
					print ( '[BAREBONES] player was lone_druid and got 10000')
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
	local droppeditemlist = {}
	local itemstacks = {}
    if (casterUnit:IsHero() or casterUnit:HasInventory()) and heroname ~= casterUnit:GetName() then 
    	for itemSlot = 0, 11, 1 do 
            if casterUnit ~= nil then
                local Item = casterUnit:GetItemInSlot( itemSlot )
				if Item ~= nil and not string.match(Item:GetName(), "boat") and not string.match(Item:GetName(), "trade_") and not string.match(Item:GetName(), "contract") then
					print("Item in slot is: " .. Item:GetName())
					itemlist[itemSlot] = Item:GetName()
					 itemstacks[itemSlot]  = Item:GetCurrentCharges()
						casterUnit:RemoveItem(Item)
					
				elseif Item ~= nil and (string.match(Item:GetName(), "boat")  or string.match(Item:GetName(), "trade_") or string.match(Item:GetName(), "contract")) then
					print("Item in slot is: trade_manifest")
					itemlist[itemSlot] = "item_fluff"
					casterUnit:RemoveItem(Item)
				
				else
					print("Item in slot is: filler")
					itemlist[itemSlot] = "item_fluff"
					
				end
            end
		end
    end
	for _,item in pairs( Entities:FindAllByName("item_*")) do
								print("found an item")

				if item~=nil and item:GetName()~=nil and item:GetName()~=""then
				print("found an item with a name")
					if item:GetPurchaser() == casterUnit then
						print("insertingItem")
						table.insert(droppeditemlist, item)
					end
				end
	end
	if heroname ~= casterUnit:GetName() then
			local gold = casterUnit:GetGold()
			local xp = casterUnit:GetCurrentXP()
			print("calling replace hero")
			BOAT_JUST_BAUGHT=1
			local hero = PlayerResource:ReplaceHeroWith( casterUnit:GetPlayerID(), heroname , 0, 0 )
			SendToServerConsole( "dota_combine_models 0" ) 
			
				print("called replace hero")
				if hero ~= nil then
					local id = hero:GetPlayerOwnerID()
					
					if id == plyID then
					RemoveWearables( hero )
						print("this is the new hero, put items in " .. hero:GetName())
						hero:SetGold(gold, true)
						hero:SetGold(0, false)
						hero:AddExperience(xp, false, false)
						for b = 0, 11, 1 do 
							local newItem = CreateItem(itemlist[b], hero, hero)
							if newItem ~= nil then                   -- makes sure that the item exists and making sure it is the correct item
								
								if b==5 and (string.match(heroname,"vengefulspirit") or string.match(heroname,"enigma") or string.match(heroname,"bane")) then
								local newItem2 = CreateItem("item_trade_manifest", hero, hero)
									hero:AddItem(newItem2)
									local data =
									{
										Player_ID = hero:GetPlayerID();
										Ally_ID = allyteamnumber;
									}
									FireGameEvent("Team_Can_Buy",data)
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
								if b<5 and  string.match(itemlist[b],"fluff") then
									hero:AddItem(newItem)
								elseif not  string.match(itemlist[b],"fluff") then
									hero:AddItem(newItem)
								else
										hero:RemoveItem(newItem)
								end
								
								if itemstacks[b] then
									newItem:SetCurrentCharges(itemstacks[b])
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
						if hero:IsHero() or hero:HasInventory() then 
							for itemSlot = 0, 11, 1 do 
								if hero ~= nil then
									local activateItem = hero:GetItemInSlot( itemSlot )
									if activateItem ~= nil and string.match(activateItem:GetName(), "bow") then
										print("activating " .. activateItem:GetName())
										activateItem:ToggleAbility()
										
									elseif activateItem ~= nil and string.match(activateItem:GetName(), "fluff") then
										print("Item in slot is: filler")
										hero:RemoveItem(activateItem)
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
			--	 print('[ItemFunctions] dubuffTower found a tower!')
				local curArmor = curTower:GetPhysicalArmorBaseValue()
				if curTower ~= nil and curTower:IsTower() then
			--	print('[ItemFunctions] dubuffTower really found a tower! cur armor is' .. curArmor)
					if curTower:GetTeamNumber() ~=  casterUnit:GetTeamNumber()  then
						curTower:SetPhysicalArmorBaseValue(curArmor-1.0)
				--		print('[ItemFunctions] dubuffTower found an enamy tower.  new armor is' .. curArmor-1.0)
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
				-- print('[ItemFunctions] healTowers found a tower!')
				local curArmor = curTower:GetPhysicalArmorBaseValue()
				if curTower ~= nil and curTower:IsTower() then
				--print('[ItemFunctions] healTowers really found a tower!')
					if curTower:GetTeamNumber() ==  casterUnit:GetTeamNumber()  then
						local hp1 = (curTower:GetMaxHealth()-curTower:GetHealth())*.1
						curTower:SetHealth(curTower:GetHealth()+hp1)
				--		print('[ItemFunctions] healTowers found an ally tower.')
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
		Notifications:TopToAll({hero="npc_dota_hero_tidehunter", imagestyle="portrait", continue=true})
		Notifications:TopToAll({text="#spawn_tide", duration=5.0, style={color="#80BB44",  fontSize="50px;"}, continue=true})
		
			
end



function RemoveWearables( hero )
      -- Setup variables
	  Timers:CreateTimer( 0.1, function()
	hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
	
end
	  )
end


function UnstickPlayer(eventSourceIndex, args)
print("in unstick")
	  local pID = args.PlayerID

    for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			print("unsticking" .. hero:GetName())
			local herogold = hero:GetGold()
			if herogold>0 then
				if hero:GetPlayerID() == pID then
					if false == hero:HasModifier("pergatory_3") then
						 if LastLocs2[hero]~= nil and (LastLocs2[hero] - hero:GetOrigin()):Length() <1000 then
							local vecorig = LastLocs2[hero]
							hero:SetOrigin(vecorig)
							stopPhysics(hero)
						end
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
					print("assignedHero")
				end
		end
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
		
		print(itemName .. " vs " .. casterUnit:GetName())
		if (directionOne:Length() < 600 or directionTwo:Length() < 600) and herogold>cost-1 and not string.match(casterUnit:GetName(),itemName ) then
			boat=true
			casterUnit:SetGold(herogold-cost,true)
			casterUnit:SetGold(0,false)
			sellBoat(casterUnit)
			EmitSoundOnClient("General.Buy",PlayerResource:GetPlayer(pID))
		Timers:CreateTimer( .1, function()
	
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
			elseif string.match(itemName,"morphling") then
				become_boat(casterUnit, "npc_dota_hero_morphling")
			elseif string.match(itemName,"storm_spirit") then
				become_boat(casterUnit, "npc_dota_hero_storm_spirit")
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
			elseif string.match(itemName,"vengefulspirit") then
				become_boat(casterUnit, "npc_dota_hero_vengefulspirit")
			elseif string.match(itemName,"enigma") then
				become_boat(casterUnit, "npc_dota_hero_enigma")
			elseif string.match(itemName,"bane") then
				become_boat(casterUnit, "npc_dota_hero_bane")
		end
		Timers:CreateTimer( .1, function()
		local data =
			{
				Player_ID = casterUnit:GetPlayerID()
			}
			FireGameEvent("Hero_Near_Ship_Shop",data)
		end)
	end)
	elseif(directionOne:Length() > 599 and directionTwo:Length() > 599) then
		
	Notifications:Top(casterUnit:GetPlayerID(), {text="#to_base", duration=3.0, style={color="#800000",  fontSize="50px;"}})
	EmitSoundOnClient("ui.contract_fail",PlayerResource:GetPlayer(pID))
	else
		EmitSoundOnClient("ui.contract_fail",PlayerResource:GetPlayer(pID)) 
		end
	end
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
				print("assignedHero")
			end
		end
	end
	
	if heroBuying~=nil and heroBuying:IsAlive() then
		
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
			local cost=tonumber(args.cost)
			local herogold = heroBuying:GetGold()
			if herogold>cost-1 then
				EmitSoundOnClient("General.Buy",PlayerResource:GetPlayer(pID))
				print(tempItem:GetName())
				heroBuying:AddItem(tempItem)
				heroBuying:SetGold(herogold-cost,true)
				heroBuying:SetGold(0,false)
			else
				EmitSoundOnClient("ui.contract_fail",PlayerResource:GetPlayer(pID))
			end
		end
	end 
end

function GiveEasy(eventSourceIndex, args)
	print("in give easy")
	local pID = args.PlayerID
	local teamNum=PlayerResource:GetTeam(pID)
	local heroBuying
	--get list of heroes on this team
	local i=0
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
				if hero:GetPlayerID() == pID then
					heroBuying= hero
					print("assignedHero")
				end
		end
	end
	if heroBuying~=nil and heroBuying:IsAlive() and not CheckInvFull(heroBuying,1) and not HasQuest(heroBuying) then
		local nearestShop= Entities:FindByNameNearest("npc_dota_buil*",heroBuying:GetOrigin(),0)
		local casterPos = heroBuying:GetAbsOrigin()
		local ShopDist =  casterPos - nearestShop:GetAbsOrigin()
		if ShopDist:Length()<600 then
			print("inrange")
			local missionPool
			if heroBuying:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
				print(nearestShop:GetUnitName())
				PrintTable(SouthEasyMissions[nearestShop:GetUnitName()])
				missionPool=SouthEasyMissions[nearestShop:GetUnitName()]
				else
				missionPool=NorthEasyMissions[nearestShop:GetUnitName()]
			end
			local chosenMission=missionPool[RandomInt( 1, #missionPool )]
			newItem = CreateItem(chosenMission, hero, hero)
			if newItem ~= nil then -- makes sure that the item exists and making sure it is the correct item
				print("Item Is: " .. newItem:GetName() )
				
				heroBuying:AddItem(newItem)
				EmitSoundOnClient("ui.npe_objective_given",PlayerResource:GetPlayer(heroBuying:GetPlayerID()))
				
					print(newItem)
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
		print("in give easy")
	local pID = args.PlayerID
	local teamNum=PlayerResource:GetTeam(pID)
	local heroBuying
	--get list of heroes on this team
	local i=0
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
				if hero:GetPlayerID() == pID then
					heroBuying= hero
					print("assignedHero")
				end
		end
	end
	if heroBuying~=nil and heroBuying:IsAlive() and not CheckInvFull(heroBuying,1) and not HasQuest(heroBuying) then
		local nearestShop= Entities:FindByNameNearest("npc_dota_buil*",heroBuying:GetOrigin(),0)
		local casterPos = heroBuying:GetAbsOrigin()
		local ShopDist =  casterPos - nearestShop:GetAbsOrigin()
		if ShopDist:Length()<600 then
			print("inrange")
			local missionPool
			if heroBuying:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
				missionPool=SouthHardMissions[nearestShop:GetUnitName()]
				else
				missionPool=NorthHardMissions[nearestShop:GetUnitName()]
			end
			local chosenMission=missionPool[RandomInt( 1, #missionPool )]
			newItem = CreateItem(chosenMission, hero, hero)
			if newItem ~= nil then -- makes sure that the item exists and making sure it is the correct item
				print("Item Is: " .. newItem:GetName() )
				
				heroBuying:AddItem(newItem)
				EmitSoundOnClient("ui.npe_objective_given",PlayerResource:GetPlayer(heroBuying:GetPlayerID()))
					print(newItem)
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
	if hero ~= nil then

			for itemSlot = 0, 5, 1 do 
				local Item = hero:GetItemInSlot( itemSlot )
				if Item ~= nil and  string.match(Item:GetName(), "trade_manifest") then
					cotinue=1
				end		
			end
	end
					
	if hero ~= nil and hero:IsOwnedByAnyPlayer() and hero:GetPlayerOwnerID() ~= -1 then -- and string.match(hero:GetName(),"*trade*") then
		local casterPos = hero:GetAbsOrigin()
		local nearestShop= Entities:FindByNameNearest("npc_dota_buil*",casterPos,0)
		if nearestShop then

			

		local ShopDist =  casterPos - nearestShop:GetAbsOrigin()
		if WasNearShop[hero]==nil then
			WasNearShop[hero] = true
		end
			local targetUnitOne = Entities:FindByName( nil, "south_boat_shop")
			local targetUnitTwo = Entities:FindByName( nil, "north_boat_shop")
			local directionOne =  casterPos - targetUnitOne:GetAbsOrigin()
			local directionTwo =  casterPos - targetUnitTwo:GetAbsOrigin()
			
			for itemSlot = 0, 5, 1 do 
				local Item = hero:GetItemInSlot( itemSlot )
				if Item ~= nil  and string.match(Item:GetName(),"contract_empty") and ShopDist:Length()<600 then	
							hero:RemoveItem(Item)
							hero:SetGold(hero:GetGold()+100*EMP_GOLD_NUMBER/2,true)
							hero:SetGold(0,false)
							hero:AddExperience(200,0,false,true)
							Notifications:Top(hero:GetPlayerID(), {text="#mission_done", duration=3.0, style={ color=" #60A0D6;", fontSize= "45px;", textShadow= "2px 2px 2px #662222;"}})
							Notifications:Top(hero:GetPlayerID(),{text=100*EMP_GOLD_NUMBER/2, duration=3.0, style={color="#FFD700",  fontSize="45px;"}, continue=true})

				end		
			end
			
		

			
		if ShopDist:Length()<600 and (directionOne:Length() > 1000 and directionTwo:Length() > 1000) and cotinue==1 then
			
			if WasNearShop[hero]==false then
				print("sending entershop")
				WasNearShop[hero]=true
				local data =
				{
					Player_ID = hero:GetPlayerID()
				}
				FireGameEvent("Hero_Near_Shop",data)
			end
		
			for itemSlot = 0, 5, 1 do 
				if hero ~= nil then
					local Item = hero:GetItemInSlot( itemSlot )
					if Item ~= nil then
						local itemStrippedEasy=string.gsub(Item:GetName(),"item_contract_easy","")
						local itemStrippedMedium=string.gsub(Item:GetName(),"item_contract_medium","")
						local itemStrippedHard=string.gsub(Item:GetName(),"item_contract_hard","")
						if  string.match(nearestShop:GetUnitName(),itemStrippedEasy) then
							hero:RemoveItem(Item)
							hero:SetGold(hero:GetGold()+130*EMP_GOLD_NUMBER/2,true)
							hero:SetGold(0,false)
							hero:AddExperience(xp_to_level[hero:GetLevel()]*.33,0,false,true)
							if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
								GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + 130*EMP_GOLD_NUMBER/2
							elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
								BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + 130*EMP_GOLD_NUMBER/2
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
									local herogold = otherHero:GetGold()
									if otherHero:GetTeamNumber() == hero:GetTeam()  and otherHero~=hero then
										otherHero:SetGold(herogold + 16*EMP_GOLD_NUMBER/2, true)
										otherHero:SetGold(0, false)
										if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
											GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + 16*EMP_GOLD_NUMBER/2
										elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
											BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + 16*EMP_GOLD_NUMBER/2
										end
									end
								end
							end
						Notifications:Top(hero:GetPlayerID(), {text="#mission_done", duration=3.0, style={color=" #60A0D6;", fontSize= "45px;", textShadow= "2px 2px 2px #662222;"}})
						Notifications:Top(hero:GetPlayerID(), {text=130*EMP_GOLD_NUMBER/2, duration=3.0, style={color="#FFD700",  fontSize="45px;"}, continue=true})
						Notifications:Top(hero:GetPlayerID(), {text="#mission_done_team", duration=3.0, style={ color=" #60A0D6;", fontSize= "35px;", textShadow= "2px 2px 2px #662222;"}})
						Notifications:Top(hero:GetPlayerID(), {text=16*EMP_GOLD_NUMBER/2, duration=3.0, style={color="#FFD700",  fontSize="35px;"}, continue=true})
						
						elseif string.match(nearestShop:GetUnitName(),itemStrippedMedium) then
							hero:RemoveItem(Item)
							hero:SetGold(hero:GetGold()+300*EMP_GOLD_NUMBER/2,true)
							hero:SetGold(0,false)
								print("hero level: " .. hero:GetLevel())
								print("nect level: " .. xp_to_level[hero:GetLevel()])
							if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
								GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + 300*EMP_GOLD_NUMBER/2
							elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
								BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + 300*EMP_GOLD_NUMBER/2
							end
							
							hero:AddExperience(xp_to_level[hero:GetLevel()]*.33,0,false,true)
							for _,otherHero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
								if otherHero ~= nil and otherHero:IsOwnedByAnyPlayer() then
									local herogold = otherHero:GetGold()
									if otherHero:GetTeamNumber() == hero:GetTeam()  and otherHero~=hero then
										otherHero:SetGold(herogold + 26*EMP_GOLD_NUMBER/2, true)
										otherHero:SetGold(0, false)
										if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
											GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + 26*EMP_GOLD_NUMBER/2
										elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
											BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + 26*EMP_GOLD_NUMBER/2
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
						Notifications:Top(hero:GetPlayerID(),{text=300*EMP_GOLD_NUMBER/2, duration=3.0, style={color="#FFD700",  fontSize="45px;"}, continue=true})
						Notifications:Top(hero:GetPlayerID(), {text="#mission_done_team", duration=3.0, style={ color=" #60A0D6;", fontSize= "35px;", textShadow= "2px 2px 2px #662222;"}})
						Notifications:Top(hero:GetPlayerID(),{text=26*EMP_GOLD_NUMBER/2, duration=3.0, style={color="#FFD700",  fontSize="35px;"}, continue=true})
						
						elseif string.match(nearestShop:GetUnitName(),itemStrippedHard) then
							hero:RemoveItem(Item)
							hero:SetGold(hero:GetGold()+500*EMP_GOLD_NUMBER/2,true)
							hero:SetGold(0,false)
							hero:AddExperience(xp_to_level[hero:GetLevel()]*.33,0,false,true)
							if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
								GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + 200
							elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
								BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + 200
							end
						
							local allyteamnumber=hero:GetPlayerID()
							for _,otherHero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
								if otherHero ~= nil and otherHero:IsOwnedByAnyPlayer() then
									local herogold = otherHero:GetGold()
									if otherHero:GetTeamNumber() == hero:GetTeam()  and otherHero~=hero then
										otherHero:SetGold(herogold + 36*EMP_GOLD_NUMBER/2, true)
										otherHero:SetGold(0, false)
										if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
											GOOD_GOLD_TOTAL_MOD = GOOD_GOLD_TOTAL_MOD + 36*EMP_GOLD_NUMBER/2
										elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
											BAD_GOLD_TOTAL_MOD = BAD_GOLD_TOTAL_MOD + 36*EMP_GOLD_NUMBER/2
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
						 Notifications:Top(hero:GetPlayerID(),{text=500*EMP_GOLD_NUMBER/2, duration=3.0, style={color="#FFD700",  fontSize="45px;"}, continue=true})
						Notifications:Top(hero:GetPlayerID(), {text="#mission_done_team", duration=3.0, style={ color=" #60A0D6;", fontSize= "35px;", textShadow= "2px 2px 2px #662222;"}})
						Notifications:Top(hero:GetPlayerID(),{text=35*EMP_GOLD_NUMBER/2, duration=3.0, style={color="#FFD700",  fontSize="35px;"}, continue=true})
						
							end
					end
				end
			end
			elseif WasNearShop[hero]==true then
				print("sending leftshop")
				WasNearShop[hero]=false
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
	print("getDisconnect")
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			if hero:GetPlayerID() == playerID then
				if DisconnectKicked[hero]~= nil then
					return DisconnectKicked[hero]
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
	print(playerID)
    for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			if hero:GetPlayerID() == playerID then
				return hero:GetLevel()
			end
		end
	end
	return 0
end

