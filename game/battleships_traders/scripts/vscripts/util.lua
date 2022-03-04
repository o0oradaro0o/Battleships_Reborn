-- The probability that the winner beats the loser
function Probability(winnerRank, loserRank)
  return 1.0 * 1.0 / (1 + 1.0 * (10 ^ (1.0 * (loserRank - winnerRank) / 400))) 
end
-- This takes the average mmr of each team, and returns how much each side
-- should win / lose
-- K is a hyperparameter that determines how much mmr is at stake
function GetEloRatingChange(winnerRank, loserRank, K)
  K = K or 50
  Pa = Probability(winnerRank, loserRank) 

  rankChange = K * (1 - Pa) 

  return rankChange
end

function GetRandomTableElement( myTable )
  -- iterate over whole table to get all keys
  local keyset = {}
  for k in pairs(myTable) do
      table.insert(keyset, k)
  end
  -- now you can reliably return a random key
  return myTable[keyset[RandomInt(1, #keyset)]]
end
  
function TableCount( t )
  local n = 0
  for _ in pairs( t ) do
    n = n + 1
  end
  return n
end

function maxValue(a)
	local values = {}

	for k,v in pairs(a) do
		if type(k) == "number" and type(v) == "number" then
			values[#values+1] = v
		end
	end
	table.sort(values) -- automatically sorts lowest to highest

	return values[#values]
end

function maxKey(a)
	local maxval = maxValue(a)
	local inv={}
	for k,v in pairs(a) do
		inv[v]=k
	end
	return inv[maxval]
 end

----------------------------------------------------------------------
--- Returns a list of units that your weapon can hit
--- Weapons with >1000 range can't hit towers
--- Returns a random unit that it finds
----------------------------------------------------------------------
function getRandomWeaponTarget(caster, range)
  local typeFilter = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC

  if range < 1000 then
    typeFilter = typeFilter + DOTA_UNIT_TARGET_BUILDING
  end

  local targets = FindUnitsInRadius(
    caster:GetTeam(), 
    caster:GetAbsOrigin(), 
    nil, 
    range, 
    DOTA_UNIT_TARGET_TEAM_ENEMY, 
    typeFilter, 
    DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 
    FIND_ANY_ORDER,
    false
  )

  if TableCount(targets) > 0 then
    return GetRandomTableElement(targets)
  else
    return nil
  end
end

-- filter(function, table)
-- e.g: filter(is_even, {1,2,3,4}) -> {2,4}
function filter(func, tbl)
  local newtbl= {}
  for i,v in pairs(tbl) do
    if func(v) then
      newtbl[i]=v
    end
  end
  return newtbl
end

function TableContainsValue( t, value )
  for _, v in pairs( t ) do
    if v == value then
      return true
    end
  end

  return false
end