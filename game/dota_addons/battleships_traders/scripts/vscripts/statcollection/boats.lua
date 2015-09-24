

local customSchema = class({})
function customSchema:init(options)
    -- The schema version we are currently using
    self.SCHEMA_KEY = 'W65ADMNC1GCRTLQN' -- GET THIS FROM AN ADMIN ON THE SITE, THAT APPROVES YOUR SCHEMA
    -- Do we need to enable the round API or not.
    self.HAS_ROUNDS = true
    -- Do we want statCollection to use team winner for game victory?
    self.GAME_WINNER = false
    -- Do we want statCollection to use ancient explosions for game victory?
    self.ANCIENT_EXPLOSION = false
    --We want to have a reference to this later
    self.statCollection = options.statCollection
end

function customSchema:submitRound(round_data)
    winners = round_data.winner_data
    game = round_data.game_data
    players = round_data.player_data

    self.statCollection:sendCustom({game=game, players=players})
    
    return {
        winners = winners,
        lastRound = round_data.rounds_left == 0
    }
end

return customSchema
