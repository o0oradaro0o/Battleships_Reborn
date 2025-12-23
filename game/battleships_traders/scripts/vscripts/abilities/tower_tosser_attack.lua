-------------------------------------------------------------------------------
-- TOWER TOSSER ATTACK ABILITY
-- Ability given to spawned towers to handle their attacks
-------------------------------------------------------------------------------

tower_tosser_attack = class({})
LinkLuaModifier("modifier_tower_tosser_attack", "abilities/tower_tosser_attack.lua", LUA_MODIFIER_MOTION_NONE)

function tower_tosser_attack:Precache(context)
  PrecacheResource("particle", "particles/light_spin_tower_proj.vpcf", context)
end

function tower_tosser_attack:GetIntrinsicModifierName()
  return "modifier_tower_tosser_attack"
end

----------------------------------------------------------------------
-- Tower Attack Modifier
----------------------------------------------------------------------

modifier_tower_tosser_attack = class({})

function modifier_tower_tosser_attack:IsHidden()
  return false
end

function modifier_tower_tosser_attack:IsPurgable()
  return false
end

function modifier_tower_tosser_attack:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    
    -- Initialize shot counter with fallbacks
    local max_shots_value = self.ability:GetSpecialValueFor("max_shots")
    self.shots_remaining = (max_shots_value and max_shots_value > 0) and max_shots_value or 10
    
    local damage_value = self.ability:GetSpecialValueFor("damage")
    self.damage = (damage_value and damage_value > 0) and damage_value or 135
    
    local fire_rate_value = self.ability:GetSpecialValueFor("fire_rate")
    self.fire_rate = (fire_rate_value and fire_rate_value > 0) and fire_rate_value or 0.3
    
    local range_value = self.ability:GetSpecialValueFor("range")
    self.range = (range_value and range_value > 0) and range_value or 800
    
    -- Debug prints
    print("[Tower Tosser] Tower created with:")
    print("  - Shots remaining: " .. self.shots_remaining)
    print("  - Damage: " .. self.damage)
    print("  - Fire rate: " .. self.fire_rate)
    print("  - Range: " .. self.range)
    
    -- Start attacking
    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_tower_tosser_attack:OnIntervalThink()
  if not IsServer() then return end
  
  local tower = self.parent
  
  -- Check if we've run out of shots
  if self.shots_remaining <= 0 then
    print("[Tower Tosser] Tower out of shots, destroying...")
    -- Stop attacking
    self:StartIntervalThink(-1)
    
    -- Kill the tower immediately
    tower:ForceKill(false)
    return
  end
  
  -- Find enemies in range
  local enemies = FindUnitsInRadius(
    tower:GetTeam(),
    tower:GetAbsOrigin(),
    nil,
    self.range,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
    FIND_ANY_ORDER,
    false
  )
  
  if #enemies == 0 then return end
  
  -- Select random target
  local target = enemies[RandomInt(1, #enemies)]
  
  -- Create visual projectile effect
  local projectile_info = {
    Target = target,
    Source = tower,
    Ability = self.ability,
    EffectName = "particles/light_spin_tower_proj.vpcf",
    iMoveSpeed = 1200,
    bDodgeable = false,
    bProvidesVision = false,
    bVisibleToEnemies = true
  }
  
  ProjectileManager:CreateTrackingProjectile(projectile_info)
  
  -- Play attack sound
  EmitSoundOn("Hero_Tinker.Attack", tower)
  
  -- Decrement shots
  self.shots_remaining = self.shots_remaining - 1
end

function modifier_tower_tosser_attack:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_TOOLTIP
  }
end

function modifier_tower_tosser_attack:OnTooltip()
  return self.shots_remaining
end

----------------------------------------------------------------------
-- Projectile Hit - Deal damage when projectile hits
----------------------------------------------------------------------

function tower_tosser_attack:OnProjectileHit(target, location)
  if not IsServer() then return end
  
  if not target then return false end
  
  local caster = self:GetCaster()
  local damage = self:GetSpecialValueFor("damage")
  
  -- Get the original owner (the player's ship)
  local owner = caster:GetOwner()
  if not owner then
    owner = caster
  end
  
  -- Deal damage
  local damageTable = {
    victim = target,
    attacker = owner,
    damage = damage,
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = self
  }
  ApplyDamage(damageTable)
  
  -- Impact effect
  EmitSoundOn("Hero_Tinker.ProjectileImpact", target)
  
  return true
end
