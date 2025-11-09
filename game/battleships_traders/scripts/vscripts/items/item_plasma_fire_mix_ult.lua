item_plasma_fire_mix_ult_bow = class({})
LinkLuaModifier(
  "modifier_item_plasma_fire_mix_ult_bow",
  "items/item_plasma_fire_mix_ult.lua",
  LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
  "modifier_item_plasma_fire_mix_ult_bow_2",
  "items/item_plasma_fire_mix_ult.lua",
  LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
  "modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor",
  "items/item_plasma_fire_mix_ult.lua",
  LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
  "modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor_debuff",
  "items/item_plasma_fire_mix_ult.lua",
  LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
  "modifier_item_plasma_fire_mix_ult_bow_fire_aura",
  "items/item_plasma_fire_mix_ult.lua",
  LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
  "modifier_item_plasma_fire_mix_ult_bow_fire_aura_debuff",
  "items/item_plasma_fire_mix_ult.lua",
  LUA_MODIFIER_MOTION_NONE
)

function item_plasma_fire_mix_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_plasma_fire_mix_ult_bow"
end

function item_plasma_fire_mix_ult_bow:OnProjectileHit(target, location)
  if not IsServer() then
    return
  end

  if target == nil then
    return
  end

  local damageTable = {
    victim = target,
    attacker = self:GetCaster(),
    damage = self:GetSpecialValueFor("dmg"),
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = self
  }
  ApplyDamage(damageTable)

  -- create modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor at location for duration
  local particle_cast = "particles/radiation_battleship.vpcf"
  local sound_cast = "Hero_Alchemist.AcidSpray"

  -- Create Particle
  local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControl(effect_cast, 0, target:GetOrigin())
  ParticleManager:SetParticleControl(effect_cast, 3, target:GetOrigin())
  ParticleManager:SetParticleControl(effect_cast, 4, target:GetOrigin())
  ParticleManager:SetParticleControl(effect_cast, 5, target:GetOrigin())
  ParticleManager:SetParticleControl(effect_cast, 6, target:GetOrigin())
  ParticleManager:SetParticleControl(effect_cast, 7, target:GetOrigin())
  ParticleManager:SetParticleControl(effect_cast, 1, Vector(self:GetSpecialValueFor("aoe_dearmor"), 1, 1))
  -- destroy the particle after the duration
  Timers:CreateTimer(
    self:GetSpecialValueFor("dearmor_duration"),
    function()
      ParticleManager:DestroyParticle(effect_cast, false)
      ParticleManager:ReleaseParticleIndex(effect_cast)
    end
  )

  local modifier =
    target:AddNewModifier(
      self:GetCaster(),
    self,
    "modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor",
    {duration = self:GetSpecialValueFor("dearmor_duration")}
  )
end

----------------------------------------------------------------------
-- Modifier 1: Plasma Gun (main weapon)
----------------------------------------------------------------------

modifier_item_plasma_fire_mix_ult_bow = class({})

function modifier_item_plasma_fire_mix_ult_bow:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_plasma_fire_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_plasma_fire_mix_ult_bow:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self.ability:GetCaster()

    -- Add the second weapon modifier (Fire)
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_plasma_fire_mix_ult_bow_2", {})

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.speed = self.ability:GetSpecialValueFor("speed")

    self.num_attacks = 1

    self.particle = "particles/basic_projectile/plasma_ult_projectile.vpcf"

    self.fire_sound = "Hero_Zuus.ArcLightning.Attack"

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_plasma_fire_mix_ult_bow:OnIntervalThink()
  if IsServer() then
    local enemies =
      FindUnitsInRadius(
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
    -- Fire the weapon
    for i = 1, self.num_attacks do
      local target

      if TableCount(enemies) > 0 then
        target = GetRandomTableElement(enemies)
      else
        return
      end

      local particleName

      particleName = self.particle

      local projectile = {
        Target = target,
        Source = self.parent,
        Ability = self.ability,
        EffectName = particleName,
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

function modifier_item_plasma_fire_mix_ult_bow:OnDestroy()
  if IsServer() then
    self.parent:RemoveModifierByName("modifier_item_plasma_fire_mix_ult_bow_2")
  end
end

----------------------------------------------------------------------
-- Modifier 2: Fire Gun (secondary weapon with aura)
----------------------------------------------------------------------

modifier_item_plasma_fire_mix_ult_bow_2 = class({})

function modifier_item_plasma_fire_mix_ult_bow_2:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_plasma_fire_mix_ult_bow_2:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_plasma_fire_mix_ult_bow_2:IsAura()
  return true
end

function modifier_item_plasma_fire_mix_ult_bow_2:GetModifierAura()
  return "modifier_item_plasma_fire_mix_ult_bow_fire_aura_debuff"
end

function modifier_item_plasma_fire_mix_ult_bow_2:GetAuraRadius()
  return self:GetAbility():GetSpecialValueFor("range_2")
end

function modifier_item_plasma_fire_mix_ult_bow_2:GetAuraDuration()
  return 0.5
end

function modifier_item_plasma_fire_mix_ult_bow_2:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_plasma_fire_mix_ult_bow_2:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_item_plasma_fire_mix_ult_bow_2:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

function modifier_item_plasma_fire_mix_ult_bow_2:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self.ability:GetCaster()

    self.fire_rate_2 = self.ability:GetSpecialValueFor("fire_rate_2")
    self.damage_2 = self.ability:GetSpecialValueFor("dmg_2")
    self.range_2 = self.ability:GetSpecialValueFor("range_2")
    self.speed_2 = self.ability:GetSpecialValueFor("speed_2")

    self.num_attacks = 1

    self.particle = "particles/basic_projectile/fire_ult_projectile.vpcf"

    self.fire_sound = "Hero_Zuus.ArcLightning.Attack"

    self:StartIntervalThink(self.fire_rate_2)
  end
end

function modifier_item_plasma_fire_mix_ult_bow_2:OnIntervalThink()
  if IsServer() then
    local enemies =
      FindUnitsInRadius(
      self.parent:GetTeam(),
      self.parent:GetAbsOrigin(),
      nil,
      self.range_2,
      DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
      DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
      FIND_ANY_ORDER,
      false
    )
    -- Fire the weapon
    for i = 1, self.num_attacks do
      local target

      if TableCount(enemies) > 0 then
        target = GetRandomTableElement(enemies)
      else
        return
      end

      local particleName = self.particle

      local projectile = {
        Target = target,
        Source = self.parent,
        Ability = self.ability,
        EffectName = particleName,
        iMoveSpeed = self.speed_2,
        bDodgeable = true,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        bProvidesVision = false,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
        ExtraData = {
          ModifierName = "modifier_item_plasma_fire_mix_ult_bow_2",
          ModifierDamage = self.damage_2
        }
      }
      -- check if the caster has the weapon_passive ability, add it if they Don't
      if not self.parent:HasAbility("weapon_passive") then
        self.parent:AddAbility("weapon_passive")
      end
      -- send the projectile to the FireProjectile of the weapon_passive
      self.parent:FindAbilityByName("weapon_passive"):FireProjectile(projectile)

      EmitSoundOn(self.fire_sound, self.caster)
    end
  end
end

function modifier_item_plasma_fire_mix_ult_bow_2:OnRefresh(keys)
  if not IsServer() then
    return
  end

  if keys.target == nil then
    return
  end

  local damageTable = {
    victim = keys.target,
    attacker = keys.caster,
    damage = keys.extradata.ModifierDamage,
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = self:GetAbility()
  }
  ApplyDamage(damageTable)
end

----------------------------------------------------------------------
-- Plasma AOE Dearmor Zone
----------------------------------------------------------------------

modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor = class({})

function modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor:IsAura()
  return true
end

function modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor:GetModifierAura()
  return "modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor_debuff"
end

function modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor:GetAuraRadius()
  return self:GetAbility():GetSpecialValueFor("aoe_dearmor")
end

function modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor:GetAuraDuration()
  return 0.5
end

function modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor:GetAuraSearchFlags()
  return 0
end

function modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor:GetEffectName()
  return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor_debuff = class({})

function modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor_debuff:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
  }
  return funcs
end

function modifier_item_plasma_fire_mix_ult_bow_aoe_dearmor_debuff:GetModifierPhysicalArmorBonus()
  return (-1 * self:GetAbility():GetSpecialValueFor("aoe_dearmor_amount"))
end

----------------------------------------------------------------------
-- Fire Aura Damage Debuff
----------------------------------------------------------------------

modifier_item_plasma_fire_mix_ult_bow_fire_aura_debuff = class({})

function modifier_item_plasma_fire_mix_ult_bow_fire_aura_debuff:IsDebuff()
  return true
end

function modifier_item_plasma_fire_mix_ult_bow_fire_aura_debuff:GetEffectName()
  return "particles/basic_projectile/fire_burn_effect_small.vpcf"
end

function modifier_item_plasma_fire_mix_ult_bow_fire_aura_debuff:OnCreated()
  if IsServer() then
    self:StartIntervalThink(0.5)
  end
end

function modifier_item_plasma_fire_mix_ult_bow_fire_aura_debuff:OnIntervalThink()
  if IsServer() then
    local damageTable = {
      victim = self:GetParent(),
      attacker = self:GetCaster(),
      damage = self:GetAbility():GetSpecialValueFor("damage_2"),
      damage_type = DAMAGE_TYPE_PURE,
      ability = self:GetAbility()
    }
    ApplyDamage(damageTable)
  end
end
