customSchema = class({})

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

            -- Print the schema data to the console
            if statCollection.TESTING then
                PrintSchema(game,players)
            end

            -- Send custom stats
            if statCollection.HAS_SCHEMA then
                statCollection:sendCustom({game=game, players=players})
            end
        end
    end, nil)
end

-------------------------------------

function customSchema:submitRound(args)
    winners = BuildRoundWinnerArray()
    game = BuildGameArray()
    players = BuildPlayersArray()

    statCollection:sendCustom({game=game, players=players})

    return {winners = winners, lastRound = false}
end

-------------------------------------

function BuildRoundWinnerArray()
    local winners = {}
    local current_winner_team = GameRules.Winner or 0
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if not PlayerResource:IsBroadcaster(playerID) then
                winners[PlayerResource:GetSteamAccountID(playerID)] = (PlayerResource:GetTeam(playerID) == current_winner_team) and 1 or 0
            end
        end
    end
    return winners
end

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

-------------------------------------
--          Stat Functions         --
-------------------------------------

function PrintSchema( gameArray, playerArray )
    print("-------- GAME DATA --------")
    DeepPrintTable(gameArray)
    print("\n-------- PLAYER DATA --------")
    DeepPrintTable(playerArray)
    print("-------------------------------------")
end
