

if storage == nil then
  print ( '[Timers] creating storage' )
  storage = {}
  storage.__index = storage
end

function storage:new( o )
  o = o or {}
  setmetatable( o, storage )
  return o
end

function storage:start() -- Runs whenever the itemFunctions.lua is ran
	 --print('[storage] itemFunctions started!')
	  storage = self
  self.storage = {}
end

tideKiller=""
empGoldHist=""
playerItemHist={}
playerSaleHist={}
playerBoatHist={}
DisconnectKicked={}
winner=""
settingsString=""
name_lookup = {}
name_lookup["npc_dota_hero_zuus"] = "Barrel"
name_lookup["npc_dota_hero_ancient_apparition"] = "Zodiac"
name_lookup["npc_dota_hero_tidehunter"] = "Pontoon Boat"
name_lookup["npc_dota_hero_crystal_maiden"] = "Canoe"
name_lookup["npc_dota_hero_phantom_lancer"] = "Airboat"
name_lookup["npc_dota_hero_rattletrap"] = "Catamaran"
name_lookup["npc_dota_hero_batrider"] = "Whaling Dinghy"
name_lookup["npc_dota_hero_jakiro"] = "Galleon"
name_lookup["npc_dota_hero_nevermore"] = "Broken Sea Plane"
name_lookup["npc_dota_hero_meepo"] = "House Boat"
name_lookup["npc_dota_hero_disruptor"] = "Shore Guard"
name_lookup["npc_dota_hero_winter_wyvern"] = "Speed Boat"
name_lookup["npc_dota_hero_storm_spirit"] = "Junk Ship"
name_lookup["npc_dota_hero_lion"] = "Yacht"
name_lookup["npc_dota_hero_ember_spirit"] = "Tug Boat"
name_lookup["npc_dota_hero_slark"] = "Viking Warship"
name_lookup["npc_dota_hero_sniper"] = "Submarine"
name_lookup["npc_dota_hero_visage"] = "Noah's Ark"
name_lookup["npc_dota_hero_ursa"] = "Aircraft Carrier"
name_lookup["npc_dota_hero_pugna"] = "Ice Breaker"
name_lookup["npc_dota_hero_razor"] = "Stormchaser Hydrofoil"
name_lookup["npc_dota_hero_windrunner"] = "Construction Ship"
name_lookup["npc_dota_hero_tusk"] = "Battleship"
name_lookup["npc_dota_hero_vengefulspirit"] = "Phoenician"
name_lookup["npc_dota_hero_enigma"] = "Ghost"
name_lookup["npc_dota_hero_bane"] = "Cargo"
name_lookup["npc_dota_hero_brewmaster"] = "Riverboat"




function storage:GetEmpGoldHist()
	return empGoldHist
end

function storage:GetTideKillers()
	return tideKiller
end

function storage:SetEmpGoldHist(eg)
	empGoldHist=eg
end

function storage:SetTideKillers(tk)
	 tideKiller=tk
end

function storage:GetVersion()
return "2.0.1"
end

function storage:AddToPlayerItemHist(pid, ic)

	if playerItemHist[pid]==nil then
		 playerItemHist[pid]={}
		  --print("Created Array")
	end
	if ic~=nil then
		table.insert( playerItemHist[pid], ic)
	end
end

function storage:AddToPlayerSaleHist(pid, ic)

	if playerSaleHist[pid]==nil then
		playerSaleHist[pid]={}
		  --print("Created Array")
	end
	if ic~=nil then
		table.insert( playerSaleHist[pid], ic)
	end
end

function storage:AddToPlayerBoatHist(pid, ic)

	if playerBoatHist[pid]==nil then
		playerBoatHist[pid]={}
		  --print("Created Array")
	end
	if ic~=nil then
		table.insert( playerBoatHist[pid], ic)
	end
end

function storage:GetPlayerHist(playerID)
	if playerItemHist[playerID] ~= nil then
		return playerItemHist[playerID]
	end
	return "none"
end

function storage:GetPlayerSaleHist(playerID)
	if playerSaleHist[playerID] ~= nil then
		return playerSaleHist[playerID]
	end
	return "none"
end

function storage:GetPlayerBoatHist(playerID)
	if playerBoatHist[playerID] ~= nil then
		return playerBoatHist[playerID]
	end
	return "none"
end

function storage:getWinner(playerID)
	return winner
end
function storage:SetWinner(w)
	 winner=w
end

function storage:getGameSettings(playerID)
	return settingsString
end
function storage:SetGameSettings(SS)
	settingsString=SS
end



function  storage:SetDisconnectState(dissconeects)
	DisconnectKicked=dissconeects
end

function  storage:GetDisconnectState(playerID)
	 --print("getDisconnect")
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
	
	function storage:GetHeroName(playerID)
    for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
		if hero ~= nil and hero:IsOwnedByAnyPlayer() then
			if hero:GetPlayerID() == playerID then
				return name_lookup[hero:GetName()]
			end
		end
	end
	return "failed"
end

storage:start()