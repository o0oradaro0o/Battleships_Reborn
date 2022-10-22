item_spread_plasma_mix_ult_bow = class({})
LinkLuaModifier(
  "modifier_item_spread_plasma_mix_ult_bow",
  "items/item_spread_plasma_mix_ult.lua",
  LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
  "modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor",
  "items/item_spread_plasma_mix_ult.lua",
  LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
  "modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor_debuff",
  "items/item_spread_plasma_mix_ult.lua",
  LUA_MODIFIER_MOTION_NONE
)



modifier_item_spread_plasma_mix_ult_bow = class({})

function item_spread_plasma_mix_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_spread_plasma_mix_ult_bow"
end

function item_spread_plasma_mix_ult_bow:OnProjectileHit(target, location)
  print("-----------------hit")
  if not IsServer() then
    return
  end

  if target == nil then
    return
  end

  local enemies =
    FindUnitsInRadius(
    self:GetCaster():GetTeam(),
    target:GetAbsOrigin(),
    nil,
    self:GetSpecialValueFor("aoe_dmg"),
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
    DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
    FIND_ANY_ORDER,
    false
  )

  for _, enemy in pairs(enemies) do
    local mult = 1
    if enemy:GetEntityIndex() ~= target:GetEntityIndex() and not enemy:IsRealHero() then
      mult = 0.25
    end

    local damageTable = {
      victim = enemy,
      attacker = self:GetCaster(),
      damage = self:GetSpecialValueFor("dmg") * mult,
      damage_type = DAMAGE_TYPE_PHYSICAL,
      ability = self
    }
    ApplyDamage(damageTable)
  end

  -- create modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor at location for duration
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
    "modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor",
    {duration = self:GetSpecialValueFor("dearmor_duration")}
  )
end

function modifier_item_spread_plasma_mix_ult_bow:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_spread_plasma_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_spread_plasma_mix_ult_bow:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self.ability:GetCaster()

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed = self.ability:GetSpecialValueFor("speed")
    -- boolean
    self.doubled = self.ability:GetSpecialValueFor("doubled_wep") == 1

    self.num_attacks = 1

    self.particle = "particles/basic_projectile/spread_plasma_ult_projectile.vpcf"

    self.fire_sound = "Hero_Zuus.ArcLightning.Attack"

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_spread_plasma_mix_ult_bow:OnIntervalThink()
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
      print(self.ability:GetAbilityName())
      ProjectileManager:CreateTrackingProjectile(projectile)

      EmitSoundOn(self.fire_sound, self.caster)
    end
  end
end

----------------------------------------------------------------------

modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor = class({})

function modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor:IsAura()
  return true
end

function modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor:GetModifierAura()
  return "modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor_debuff"
end

function modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor:GetAuraRadius()
  return 600
end

function modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor:GetAuraDuration()
  return 0.5
end

function modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor:GetAuraSearchFlags()
  return 0
end
function modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor:GetEffectName()
  return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor_debuff = class({})

function modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor_debuff:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
  }
  return funcs
end

function modifier_item_spread_plasma_mix_ult_bow_aoe_dearmor_debuff:GetModifierPhysicalArmorBonus()
  return (-1 * self:GetAbility():GetSpecialValueFor("aoe_dearmor_amount"))
end
