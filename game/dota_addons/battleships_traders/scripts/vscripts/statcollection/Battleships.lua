customSchema = class({})
require('storage')

function customSchema:init()

    -- Check the schema_examples folder for different implementations

    -- Flag Example
    statCollection:setFlags({version = storage:GetVersion()})

    -- Listen for changes in the current state
    ListenToGameEvent('game_rules_state_change', function(keys)
        local state = GameRules:State_Get()

        -- Send custom stats when the game ends
        if state == DOTA_GAMERULES_STATE_POST_GAME then

            -- Build game array
            local game = BuildGameArray()

            -- Build players array
            local players = BuildPlayersArray()

            -- Send custom stats
            statCollection:sendCustom({game=game, players=players})
        end
    end, nil)
end

-------------------------------------

-- Returns a table with our custom game tracking.
function BuildGameArray()
	
    local game = {}
	game.eh=storage:GetEmpGoldHist()
	game.wn=storage:getWinner()
	--game.th=storage:GetTideKillers()
    return game
end
-- Returns a table containing data for every player in the game
function BuildPlayersArray()
    local players = {}
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if not PlayerResource:IsBroadcaster(playerID) then

                local hero = PlayerResource:GetSelectedHeroEntity(playerID)
				
				local teamname="North"
				if hero:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
					teamname="South"
				end
				
				local kickStatus="Active"
				if storage:GetDisconnectState(playerID)~=0 then
					kickStatus="Kicked"
				end
				
                table.insert(players, {
                    --steamID32 required in here
                    steamID32 = PlayerResource:GetSteamAccountID(playerID),
					tm=teamname,
                    -- Example functions of generic stats (keep, delete or change any that you don't need)
                    shp = storage:GetHeroName(playerID), --Hero by its short name
                    kls  = hero:GetKills(),   --Number of kills of this players hero
                    dth  = hero:GetDeaths(),  --Number of deaths of this players hero
					 lvl = hero:GetLevel(),
					afk = kickStatus,
                    -- Item List
                    bo=storage:GetPlayerHist(playerID),
                })
            end
        end
    end
	DeepPrintTable(players) 
    return players
end
