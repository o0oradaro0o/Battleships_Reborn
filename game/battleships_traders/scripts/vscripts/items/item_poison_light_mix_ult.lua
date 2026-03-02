-------------------------------------------------------------------------------
-- RADIOACTIVE DECAY ENHANCER - Poison/Light Hybrid Ultimate Weapon
-- Applies stacking Radioactive Decay debuff that amplifies ALL damage
-------------------------------------------------------------------------------

item_poison_light_mix_ult_bow = class({})
LinkLuaModifier("modifier_item_poison_light_mix_ult_bow", "items/item_poison_light_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_radioactive_decay_debuff", "items/item_poison_light_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)

function item_poison_light_mix_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_poison_light_mix_ult_bow"
end

function item_poison_light_mix_ult_bow:OnProjectileHit(target, location)
  if not IsServer() then return end
  
  if not target then return false end
  
  local caster = self:GetCaster()
  local damage = self:GetSpecialValueFor("dmg")
  local decay_duration = self:GetSpecialValueFor("decay_duration")
  local decay_max_stacks = self:GetSpecialValueFor("decay_max_stacks")
  
  -- Deal base damage
  local damageTable = {
    victim = target,
    attacker = caster,
    damage = damage,
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = self
  }
  ApplyDamage(damageTable)
  
  -- Apply or refresh Radioactive Decay debuff
  local decay_modifier = target:FindModifierByName("modifier_radioactive_decay_debuff")
  
  if decay_modifier then
    -- Increment stacks (up to max)
    local current_stacks = decay_modifier:GetStackCount()
    if current_stacks < decay_max_stacks then
      decay_modifier:SetStackCount(current_stacks + 1)
    end
    decay_modifier:SetDuration(decay_duration, true)
  else
    -- Apply new debuff with 1 stack
    target:AddNewModifier(caster, self, "modifier_radioactive_decay_debuff", {duration = decay_duration}):SetStackCount(1)
  end
  
  -- Impact effects
  EmitSoundOn("Hero_Alchemist.AcidSpray", target)
  
  
  return true
end

-------------------------------------------------------------------------------
-- Weapon Firing Modifier (attached to wielder)
-------------------------------------------------------------------------------

modifier_item_poison_light_mix_ult_bow = class({})

function modifier_item_poison_light_mix_ult_bow:IsHidden()
  return true
end

function modifier_item_poison_light_mix_ult_bow:IsPurgable()
  return false
end

function modifier_item_poison_light_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_poison_light_mix_ult_bow:OnCreated(kv)
  if not IsServer() then return end
  
  self.ability = self:GetAbility()
  self.parent = self:GetParent()
  
  -- Weapon stats
  self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
  self.damage = self.ability:GetSpecialValueFor("dmg")
  self.range = self.ability:GetSpecialValueFor("range")
  self.speed = self.ability:GetSpecialValueFor("speed")
  
  -- Particle effect - radioactive green-yellow projectile
  self.particle = "particles/poison_light_ult.vpcf"
  self.fire_sound = "Hero_Alchemist.UnstableConcoction.Fuse"
  
  self:StartIntervalThink(self.fire_rate)
end

function modifier_item_poison_light_mix_ult_bow:OnIntervalThink()
  if not IsServer() then return end
  
  -- Find enemies in range
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
  
  if #enemies == 0 then return end
  
  -- Select random target
  local target = enemies[RandomInt(1, #enemies)]
  
  -- Fire tracking projectile
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
  
  -- Play fire sound
  EmitSoundOn(self.fire_sound, self.parent)
end

-------------------------------------------------------------------------------
-- Radioactive Decay Debuff (applied to enemies)
-- Amplifies ALL damage taken by affected unit
-------------------------------------------------------------------------------

modifier_radioactive_decay_debuff = class({})

function modifier_radioactive_decay_debuff:IsDebuff()
  return true
end

function modifier_radioactive_decay_debuff:IsHidden()
  return false
end

function modifier_radioactive_decay_debuff:IsPurgable()
  return true
end

function modifier_radioactive_decay_debuff:GetTexture()
  return "poison_light_ult_bow"
end

function modifier_radioactive_decay_debuff:OnCreated(kv)
  if not IsServer() then return end
  
  self.ability = self:GetAbility()
  self.parent = self:GetParent()
  self.caster = self:GetCaster()
  
  -- Get decay damage per stack
  self.decay_damage_per_stack = self.ability:GetSpecialValueFor("decay_damage_per_stack")
  
  -- Create visual effect - store the particle index
  local particle_index = ParticleManager:CreateParticle(
    "particles/poison_light_ult_debuff.vpcf",
    PATTACH_ABSORIGIN_FOLLOW,
    self.parent
  )
  ParticleManager:SetParticleControl(particle_index, 0, self.parent:GetAbsOrigin())
  self:AddParticle(particle_index, false, false, -1, false, false)
  
end

function modifier_radioactive_decay_debuff:OnRefresh(kv)
  if not IsServer() then return end
  
  -- Update decay damage per stack in case ability values changed
  self.decay_damage_per_stack = self.ability:GetSpecialValueFor("decay_damage_per_stack")
end

function modifier_radioactive_decay_debuff:OnDestroy()
  if not IsServer() then return end
  
  -- Particles are automatically cleaned up by AddParticle()
  -- No manual cleanup needed
end

function modifier_radioactive_decay_debuff:DeclareFunctions()
  return {
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }
end

function modifier_radioactive_decay_debuff:OnTakeDamage(params)
  if not IsServer() then return end
  
  -- Only process if this unit is taking damage
  if params.unit ~= self.parent then return end
  
  -- Don't trigger on self-damage from this modifier (prevent infinite loop)
  if params.inflictor and params.inflictor == self.ability then return end
  
  -- Check if the damage has the flag marking it as radioactive decay damage
  if params.original_damage_flags and bit.band(params.original_damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
    return
  end
  
  -- Calculate bonus damage based on stacks
  local stack_count = self:GetStackCount()
  if stack_count <= 0 then return end
  
  local bonus_damage = stack_count * self.decay_damage_per_stack
  
  -- Apply bonus magical damage
  -- Use DOTA_DAMAGE_FLAG_REFLECTION to mark this damage so it doesn't trigger itself
  local damageTable = {
    victim = self.parent,
    attacker = self.caster,
    damage = bonus_damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
    ability = self.ability
  }
  ApplyDamage(damageTable)
  
  -- Play subtle decay sound
  EmitSoundOn("Hero_Venomancer.PoisonNova", self.parent)
end

function modifier_radioactive_decay_debuff:GetEffectName()
  return "particles/poison_light_ult_debuff.vpcf"
end

function modifier_radioactive_decay_debuff:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_radioactive_decay_debuff:GetStatusEffectName()
  return "particles/poison_light_ult_debuff.vpcf"
end
