function GetCrabModeTimer()
  return GameRules.CrabModeTimer
end

function ToggleCrabMode()
  local crabMode = GetCrabModeTimer()
  if not crabMode then
    StartCrabMode()
  else
    StopCrabMode()
  end
end

function StartCrabMusic()
	CustomGameEventManager:Send_ServerToAllClients("start_song", {sound = "Music.CrabRave"})
end

function EndCrabMusic()
	CustomGameEventManager:Send_ServerToAllClients("end_song", {sound = "Music.CrabRave"})
end

function KillAllCrabs()
  -- kill all crabs
  local allNeutrals = FindUnitsInRadius(
    DOTA_TEAM_NEUTRALS,
    Vector(0,0,0),
    nil,
    FIND_UNITS_EVERYWHERE,
    DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    DOTA_UNIT_TARGET_ALL,
    DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
    FIND_ANY_ORDER,
    false)

  for _,crab in pairs(allNeutrals) do
    if crab:GetUnitName() == "npc_dota_creature_crab" then
      crab:ForceKill(false)
    end
  end
end

function StopCrabMode()
  if not GameRules.CrabModeTimer then return end
  KillAllCrabs()
  EndCrabMusic()
  Timers:RemoveTimer(GetCrabModeTimer())
  GameRules.CrabModeTimer = nil
  if GameRules.DanceTimer then
    Timers:RemoveTimer(GameRules.DanceTimer)
    GameRules.DanceTimer = nil
  end
  Timers:RemoveTimer(GameRules.DanceTimer)
  if GameRules.KillTimer then
    Timers:RemoveTimer(GameRules.KillTimer)
    GameRules.KillTimer = nil
  end

  -- make every hero vulnerable again
  local allHeroes = HeroList:GetAllHeroes()
  for _,hero in pairs(allHeroes) do
    hero:RemoveModifierByName("modifier_invulnerable")
  end

  -- make the towers stop dancing
  local allTowers = Entities:FindAllByClassname("npc_dota_tower")
  for _,tower in pairs(allTowers) do
    tower:RemoveGesture(ACT_DOTA_CUSTOM_TOWER_IDLE_RARE)
  end
end

function SpawnRandomCrab()
  -- spawn a crab along the edge of the map
  local sign = RandomInt(0, 1) == 0 and -1 or 1
  local position = Vector(8000 * sign, RandomInt(-8000, 8000), 0)
  local crab = CreateUnitByName("npc_dota_creature_crab", position, true, nil, nil, DOTA_TEAM_NEUTRALS)

  -- Give the crab a random size/speed. Bigger crabs are slower, have more health
  local size = RandomFloat(1, 100)

  local minSpeed = 100
  local maxSpeed = 400
  local minSize = 1
  local maxSize = 5
  local minHealth = 300
  local maxHealth = 1000

  local baseBounty = 20
  local ratio = size / 100

  local speed = minSpeed + ((maxSpeed - minSpeed) * (1 - ratio))
  local size = minSize + ((maxSize - minSize) * ratio)
  local health = minHealth + ((maxHealth - minHealth) * ratio)

  -- increase the health as the game goes on
  -- increase by 10% every 240 seconds
  local game_time = GameRules:GetDOTATime(false, false)
  local health_increase = 1 + (game_time / 240) * 0.05

  local health = health * health_increase

  -- bounty must be at least 1
  local bounty = math.max(1, baseBounty * size / 2)
  -- increase by 5% every 240 seconds
  local bounty_increase = 1 + (game_time / 240) * 0.05

  crab:SetModelScale(size)
  crab:SetBaseMaxHealth(health)
  crab:SetMaxHealth(health)
  crab:SetHealth(health)
  crab:SetMaximumGoldBounty(bounty)
  crab:SetMinimumGoldBounty(bounty)

  -- set it's movespeed to high for the first few seconds
  -- so it can get away from the spawn point
  crab:SetBaseMoveSpeed(1000)
  Timers:CreateTimer(7, function()
    if not crab:IsAlive() then return end
    if not IsValidEntity(crab) then return end
    crab:SetBaseMoveSpeed(speed)
  end)

  -- level up its abilities
  for i=0,24 do
    local ability = crab:GetAbilityByIndex(i)
    if ability then
      ability:SetLevel(ability:GetMaxLevel())
    end
  end
end

function MakeTowersDance()
  local allTowers = Entities:FindAllByClassname("npc_dota_tower")
  for _,tower in pairs(allTowers) do
    tower:StartGestureWithPlaybackRate(ACT_DOTA_CUSTOM_TOWER_IDLE_RARE, 1)
  end
end

function StartCrabMode()
  local crabMode = GetCrabModeTimer()
  if crabMode then return end

  StartCrabMusic()

  -- make every hero invulnerable
  local allHeroes = HeroList:GetAllHeroes()
  for _,hero in pairs(allHeroes) do
    hero:AddNewModifier(hero, nil, "modifier_invulnerable", {})
  end

  GameRules.CrabModeTimer = Timers:CreateTimer(function()
    SpawnRandomCrab()
    return 1
  end)

  GameRules.DanceTimer = Timers:CreateTimer(function()
    MakeTowersDance()
    return 5
  end)

  -- end crab mode after 1:49 if it's still going, along with the music
  GameRules.KilLTimer = Timers:CreateTimer(109, function()
    StopCrabMode()
  end)
end