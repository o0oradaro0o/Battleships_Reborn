-------------------------------------------------------------------------------
-- BREACH ICE ORBIT - Orbiting Ice Bomb Ability
-- Used by the ice bomb dummy unit spawned by Creeping Cold weapon
-------------------------------------------------------------------------------

breach_ice_orbit = class({})
LinkLuaModifier("modifier_breach_ice_orbit", "abilities/breach_ice_orbit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_breach_ice_orbit_aura", "abilities/breach_ice_orbit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_breach_ice_orbit_slow", "abilities/breach_ice_orbit.lua", LUA_MODIFIER_MOTION_NONE)

-- Don't use intrinsic modifier - we'll add it manually with parameters
-- function breach_ice_orbit:GetIntrinsicModifierName()
--   return "modifier_breach_ice_orbit"
-- end

----------------------------------------------------------------------
-- Orbit Modifier - Main logic for the orbiting bomb
----------------------------------------------------------------------

modifier_breach_ice_orbit = class({})

function modifier_breach_ice_orbit:IsHidden()
  return true
end

function modifier_breach_ice_orbit:IsPurgable()
  return false
end

function modifier_breach_ice_orbit:OnCreated(kv)
  if not IsServer() then return end
  
  self.parent = self:GetParent()
  self.caster = self:GetCaster()
  self.ability = self:GetAbility()
  
  -- Get parameters
  self.target_entindex = tonumber(kv.target_entindex)
  
  -- Validate we have a target entindex
  if not self.target_entindex then
    print("[Breach Ice Orbit] ERROR: No target_entindex provided!")
    self:Destroy()
    return
  end
  
  self.direct_damage = tonumber(kv.direct_damage) or 200
  self.explosion_damage = tonumber(kv.explosion_damage) or 400
  self.orbit_duration = tonumber(kv.orbit_duration) or 3.0
  self.orbit_radius = tonumber(kv.orbit_radius) or 150
  self.orbit_speed = tonumber(kv.orbit_speed) or 360  -- degrees per second
  self.slow_radius = tonumber(kv.slow_radius) or 250
  self.collision_radius = tonumber(kv.collision_radius) or 80
  
  self.target = EntIndexToHScript(self.target_entindex)
  
  if not self.target or not self.target:IsAlive() then
    print("[Breach Ice Orbit] ERROR: Invalid target!")
    self:Destroy()
    return
  end
  
  -- Initialize orbit angle
  self.angle = RandomFloat(0, 360)
  self.start_time = GameRules:GetGameTime()
  
  print("[Breach Ice Orbit] Bomb created! Target: " .. self.target:GetUnitName())
  print("  - Orbit radius: " .. self.orbit_radius)
  print("  - Orbit speed: " .. self.orbit_speed)
  print("  - Starting angle: " .. self.angle)
  
  -- Make the dummy unit bigger so we can see it
  self.parent:SetModelScale(2.0)
  
  -- Add core effect to the bomb
  self.particle_core = ParticleManager:CreateParticle(
    "particles/ice_breach_ult_bomb_core.vpcf",
    PATTACH_ABSORIGIN_FOLLOW,
    self.parent
  )
  ParticleManager:SetParticleControl(self.particle_core, 0, self.parent:GetAbsOrigin())
  
  -- Add trail effect to the bomb
  self.particle_trail = ParticleManager:CreateParticle(
    "particles/ice_breach_ult_bomb_trail.vpcf",
    PATTACH_ABSORIGIN_FOLLOW,
    self.parent
  )
  ParticleManager:SetParticleControl(self.particle_trail, 0, self.parent:GetAbsOrigin())
  
  -- Play loop sound
  EmitSoundOn("Hero_Crystal.CrystalNova", self.parent)
  
  -- Add aura modifier for slow effect
  self.parent:AddNewModifier(self.caster, self.ability, "modifier_breach_ice_orbit_aura", {})
  
  -- Start thinking for orbit and collision detection
  self:StartIntervalThink(0.03)
  
  -- Debug counter
  self.debug_counter = 0
end

function modifier_breach_ice_orbit:OnIntervalThink()
  if not IsServer() then return end
  
  -- Check if target is still valid
  if not self.target or not self.target:IsAlive() then
    self:ExplodeOnTarget(self.target or self.parent, true)
    return
  end
  
  -- Check if duration expired
  local elapsed = GameRules:GetGameTime() - self.start_time
  if elapsed >= self.orbit_duration then
    self:ExplodeOnTarget(self.target, true)
    return
  end
  
  -- Update orbit position
  self.angle = self.angle + (self.orbit_speed * 0.03)
  if self.angle >= 360 then
    self.angle = self.angle - 360
  end
  
  local radians = math.rad(self.angle)
  local target_pos = self.target:GetAbsOrigin()
  local offset = Vector(
    math.cos(radians) * self.orbit_radius,
    math.sin(radians) * self.orbit_radius,
    50
  )
  
  local new_pos = target_pos + offset
  
  -- Debug output every second
  self.debug_counter = self.debug_counter + 1
  if self.debug_counter % 33 == 0 then  -- Every ~1 second (0.03 * 33)
    print("[Breach Ice Orbit] Angle: " .. math.floor(self.angle) .. "° | Target pos: " .. tostring(target_pos) .. " | Bomb pos: " .. tostring(new_pos))
  end
  
  -- Directly set position (works better for flying units)
  self.parent:SetOrigin(new_pos)
  self.parent:SetAbsOrigin(new_pos)
  
  -- Check for collision with allied units (same team as target)
  local allies = FindUnitsInRadius(
    self.target:GetTeam(),
    self.parent:GetAbsOrigin(),
    nil,
    self.collision_radius,
    DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_CLOSEST,
    false
  )
  
  -- Check if we hit an ally of the target (not the target itself)
  for _, ally in pairs(allies) do
    if ally ~= self.target and ally:IsAlive() then
      self:ExplodeOnTarget(ally, false)
      return
    end
  end
end

function modifier_breach_ice_orbit:ExplodeOnTarget(target, is_timeout)
  if not IsServer() then return end
  
  local damage = is_timeout and self.explosion_damage or self.direct_damage
  
  -- Create explosion effect
  local particle_explosion = ParticleManager:CreateParticle(
    "models/items/faceless_void/faceless_void_arcana/debut/particles/drow_frost_arrow_explosion_b.vpcf",
    PATTACH_ABSORIGIN,
    target
  )
  ParticleManager:SetParticleControl(particle_explosion, 0, target:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle_explosion)
  
  -- Apply damage
  local damageTable = {
    victim = target,
    attacker = self.caster,
    damage = damage,
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = self.ability
  }
  ApplyDamage(damageTable)
  
  -- Play explosion sound
  EmitSoundOn("Hero_Crystal.CrystalNova.Explosion", target)
  
  -- Destroy the bomb
  self:Destroy()
end

function modifier_breach_ice_orbit:OnDestroy()
  if not IsServer() then return end
  
  -- Clean up particles
  if self.particle_core then
    ParticleManager:DestroyParticle(self.particle_core, false)
    ParticleManager:ReleaseParticleIndex(self.particle_core)
  end
  
  if self.particle_trail then
    ParticleManager:DestroyParticle(self.particle_trail, false)
    ParticleManager:ReleaseParticleIndex(self.particle_trail)
  end
  
  -- Stop sound
  StopSoundOn("Hero_Crystal.CrystalNova", self.parent)
  
  -- Kill the dummy unit
  if self.parent and IsValidEntity(self.parent) then
    self.parent:ForceKill(false)
  end
end

function modifier_breach_ice_orbit:CheckState()
  return {
    [MODIFIER_STATE_INVULNERABLE] = true,
    -- [MODIFIER_STATE_UNSELECTABLE] = true,  -- Temporarily disabled for testing
    -- [MODIFIER_STATE_NO_HEALTH_BAR] = true,  -- Temporarily disabled for testing
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
    [MODIFIER_STATE_NO_TEAM_SELECT] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
  }
end

----------------------------------------------------------------------
-- Aura Modifier - Provides the slowing aura
----------------------------------------------------------------------

modifier_breach_ice_orbit_aura = class({})

function modifier_breach_ice_orbit_aura:IsHidden()
  return true
end

function modifier_breach_ice_orbit_aura:IsAura()
  return true
end

function modifier_breach_ice_orbit_aura:GetModifierAura()
  return "modifier_breach_ice_orbit_slow"
end

function modifier_breach_ice_orbit_aura:GetAuraRadius()
  return self:GetAbility():GetSpecialValueFor("slow_radius") or 250
end

function modifier_breach_ice_orbit_aura:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_breach_ice_orbit_aura:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_breach_ice_orbit_aura:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NONE
end

----------------------------------------------------------------------
-- Slow Debuff - Applied to enemies near the bomb
----------------------------------------------------------------------

modifier_breach_ice_orbit_slow = class({})

function modifier_breach_ice_orbit_slow:IsHidden()
  return false
end

function modifier_breach_ice_orbit_slow:IsDebuff()
  return true
end

function modifier_breach_ice_orbit_slow:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
  }
end

function modifier_breach_ice_orbit_slow:GetModifierMoveSpeedBonus_Percentage()
  return -(self:GetAbility():GetSpecialValueFor("slow_pct") or 30)
end

function modifier_breach_ice_orbit_slow:GetEffectName()
  return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_breach_ice_orbit_slow:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
