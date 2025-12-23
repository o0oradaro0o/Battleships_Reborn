-- Burning Pitch Launcher: Fire/Coal Mix Ultimate Weapon
-- Fires powerful burning pitch projectiles that leave burning trails of tar
-- Targets hit leave burning pitch trails as they move, creating area denial zones

item_fire_coal_mix_ult_bow = class({})
LinkLuaModifier("modifier_item_fire_coal_mix_ult_bow", "items/item_fire_coal_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_burning_pitch_trail_debuff", "items/item_fire_coal_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_burning_pitch_trail_thinker_aura", "items/item_fire_coal_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_burning_pitch_trail_aura_debuff", "items/item_fire_coal_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)

function item_fire_coal_mix_ult_bow:Precache(context)
  PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_overheat_explosion.vpcf", context)
  PrecacheResource("particle", "particles/burning_pitch_trail.vpcf", context)
  PrecacheResource("particle", "particles/basic_projectile/burning_pitch_launcher_projectile.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn.vpcf", context)
end

function item_fire_coal_mix_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_fire_coal_mix_ult_bow"
end

function item_fire_coal_mix_ult_bow:OnProjectileHit(target, location)
  if not IsServer() then
    return
  end

  if target == nil then
    return
  end

  local caster = self:GetCaster()
  local impact_point = target:GetAbsOrigin()
  
  -- Deal primary damage to target
  local damageTable = {
    victim = target,
    attacker = caster,
    damage = self:GetSpecialValueFor("dmg"),
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = self
  }
  ApplyDamage(damageTable)

  -- Create impact explosion particle effect (lava/fire explosion)
  local particle_explosion = "particles/units/heroes/hero_lina/lina_overheat_explosion.vpcf"
  local effect_explosion = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(effect_explosion, 0, impact_point)
  ParticleManager:SetParticleControl(effect_explosion, 1, impact_point + Vector(0, 0, 200))
  ParticleManager:ReleaseParticleIndex(effect_explosion)

  -- Play impact sound
  EmitSoundOn("Hero_Lina.DragonSlave.Cast", target)
  
  -- Apply burning pitch trail debuff to target
  local trail_duration = self:GetSpecialValueFor("trail_duration")
  target:AddNewModifier(
    caster,
    self,
    "modifier_burning_pitch_trail_debuff",
    {duration = trail_duration}
  )
end

----------------------------------------------------------------------
-- Burning Pitch Launcher Modifier
----------------------------------------------------------------------

modifier_item_fire_coal_mix_ult_bow = class({})

function modifier_item_fire_coal_mix_ult_bow:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_fire_coal_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_fire_coal_mix_ult_bow:IsHidden()
  return true
end

function modifier_item_fire_coal_mix_ult_bow:IsPurgable()
  return false
end

function modifier_item_fire_coal_mix_ult_bow:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self.ability:GetCaster()

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.speed = self.ability:GetSpecialValueFor("speed")

    self.num_attacks = 2

    -- Burning Pitch Launcher projectile - burning tar projectile
    self.particle = "particles/basic_projectile/burning_pitch_launcher_projectile.vpcf"

    self.fire_sound = "Hero_Phoenix.LaunchFire"

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_fire_coal_mix_ult_bow:OnIntervalThink()
  if IsServer() then
    local enemies = FindUnitsInRadius(
      self.parent:GetTeam(),
      self.parent:GetAbsOrigin(),
      nil,
      self.range,
      DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
      DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
      FIND_ANY_ORDER,
      false
    )
    
    -- Fire the Burning Pitch Launcher
    for i = 1, self.num_attacks do
      local target

      if TableCount(enemies) > 0 then
        target = GetRandomTableElement(enemies)
      else
        return
      end

      local projectile = {
        Target = target,
        Source = self.parent,
        Ability = self.ability,
        EffectName = self.particle,
        iMoveSpeed = self.speed,
        bDodgeable = true,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        bProvidesVision = false,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
      }
      ProjectileManager:CreateTrackingProjectile(projectile)

      EmitSoundOn(self.fire_sound, self.caster)
    end
  end
end

function modifier_item_fire_coal_mix_ult_bow:OnDestroy()
  if IsServer() then
    -- Cleanup if needed
  end
end

----------------------------------------------------------------------
-- Burning Pitch Trail Debuff (Applied to hit targets)
----------------------------------------------------------------------

modifier_burning_pitch_trail_debuff = class({})

function modifier_burning_pitch_trail_debuff:IsDebuff()
  return true
end

function modifier_burning_pitch_trail_debuff:IsPurgable()
  return true
end

function modifier_burning_pitch_trail_debuff:GetEffectName()
  return "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf"
end

function modifier_burning_pitch_trail_debuff:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_burning_pitch_trail_debuff:OnCreated()
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    
    self.trail_radius = self.ability:GetSpecialValueFor("trail_radius")
    self.trail_ground_duration = self.ability:GetSpecialValueFor("trail_ground_duration")
    
    -- Table to track all active trail thinkers
    self.trail_thinkers = {}
    
    -- Create trail points as unit moves
    self:StartIntervalThink(0.2)
    
    EmitSoundOn("Hero_Phoenix.FireSpirits.Launch", self.parent)
  end
end

function modifier_burning_pitch_trail_debuff:OnIntervalThink()
  if IsServer() then
    local parent_pos = self.parent:GetAbsOrigin()
    
    -- Create a burning pitch trail point at current position
    local thinker = CreateModifierThinker(
      self.caster,
      self.ability,
      "modifier_burning_pitch_trail_thinker_aura",
      {duration = self.trail_ground_duration},
      parent_pos,
      self.caster:GetTeam(),
      false
    )
    
    table.insert(self.trail_thinkers, thinker)
    
    -- Create ground fire particle
    local particle = ParticleManager:CreateParticle(
      "particles/burning_pitch_trail.vpcf",
      PATTACH_ABSORIGIN,
      thinker
    )
    ParticleManager:SetParticleControl(particle, 0, parent_pos)
    ParticleManager:SetParticleControl(particle, 1, Vector(self.trail_radius, 1, 1))
    
    -- Destroy particle when thinker expires
    Timers:CreateTimer(self.trail_ground_duration, function()
      ParticleManager:DestroyParticle(particle, false)
      ParticleManager:ReleaseParticleIndex(particle)
    end)
  end
end

function modifier_burning_pitch_trail_debuff:OnDestroy()
  if IsServer() then
    StopSoundOn("Hero_Phoenix.FireSpirits.Launch", self.parent)
  end
end

function modifier_burning_pitch_trail_debuff:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
  }
end

function modifier_burning_pitch_trail_debuff:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility():GetSpecialValueFor("carrier_slow")
end

----------------------------------------------------------------------
-- Burning Pitch Trail Thinker Aura (Area of effect for each trail point)
----------------------------------------------------------------------

modifier_burning_pitch_trail_thinker_aura = class({})

function modifier_burning_pitch_trail_thinker_aura:IsAura()
  return true
end

function modifier_burning_pitch_trail_thinker_aura:GetModifierAura()
  return "modifier_burning_pitch_trail_aura_debuff"
end

function modifier_burning_pitch_trail_thinker_aura:GetAuraRadius()
  return self:GetAbility():GetSpecialValueFor("trail_radius")
end

function modifier_burning_pitch_trail_thinker_aura:GetAuraDuration()
  return 0.5
end

function modifier_burning_pitch_trail_thinker_aura:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_burning_pitch_trail_thinker_aura:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_burning_pitch_trail_thinker_aura:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

function modifier_burning_pitch_trail_thinker_aura:IsHidden()
  return true
end

----------------------------------------------------------------------
-- Burning Pitch Trail Aura Debuff (Applied to units in trail)
----------------------------------------------------------------------

modifier_burning_pitch_trail_aura_debuff = class({})

function modifier_burning_pitch_trail_aura_debuff:IsDebuff()
  return true
end

function modifier_burning_pitch_trail_aura_debuff:GetEffectName()
  return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn.vpcf"
end

function modifier_burning_pitch_trail_aura_debuff:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_burning_pitch_trail_aura_debuff:OnCreated()
  if IsServer() then
    self:StartIntervalThink(0.5)
  end
end

function modifier_burning_pitch_trail_aura_debuff:OnIntervalThink()
  if IsServer() then
    local damageTable = {
      victim = self:GetParent(),
      attacker = self:GetCaster(),
      damage = self:GetAbility():GetSpecialValueFor("trail_damage"),
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self:GetAbility()
    }
    ApplyDamage(damageTable)
    
    -- Play burn sound occasionally
    if RandomInt(1, 3) == 1 then
      EmitSoundOn("Hero_Phoenix.FireSpirits.Target", self:GetParent())
    end
  end
end

function modifier_burning_pitch_trail_aura_debuff:OnDestroy()
  if IsServer() then
    StopSoundOn("Hero_Phoenix.FireSpirits.Target", self:GetParent())
  end
end

function modifier_burning_pitch_trail_aura_debuff:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
  }
end

function modifier_burning_pitch_trail_aura_debuff:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility():GetSpecialValueFor("trail_slow")
end
