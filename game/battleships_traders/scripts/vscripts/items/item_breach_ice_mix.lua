item_breach_ice_mix = class({})
LinkLuaModifier("modifier_item_breach_ice_mix", "items/item_breach_ice_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_breach_ice_mix_2", "items/item_breach_ice_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_breach_ice_mix_breach_debuff", "items/item_breach_ice_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_breach_ice_mix_ice_slow", "items/item_breach_ice_mix.lua", LUA_MODIFIER_MOTION_NONE)

item_breach_ice_mix_bow_doubled = class({})
item_breach_ice_mix_two_bow_doubled = class({})
item_breach_ice_mix_three_bow_doubled = class({})

function item_breach_ice_mix_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_breach_ice_mix"
end

function item_breach_ice_mix_two_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_breach_ice_mix"
end

function item_breach_ice_mix_three_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_breach_ice_mix"
end

----------------------------------------------------------------------
-- Primary Weapon: Breach (Projectile with delayed damage)
----------------------------------------------------------------------

modifier_item_breach_ice_mix = class({})

function modifier_item_breach_ice_mix:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_breach_ice_mix:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_breach_ice_mix:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_breach_ice_mix_2", {})

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed = self.ability:GetSpecialValueFor("speed")
    self.delay = self.ability:GetSpecialValueFor("delay")
    self.remove = self.ability:GetSpecialValueFor("remove")
    self.pure_pct = self.ability:GetSpecialValueFor("pure_pct")

    self.num_attacks = 1  -- Breach fires 1 shot

    local particles = {
      "particles/basic_projectile/breach_one_projectile.vpcf",
      "particles/basic_projectile/breach_two_projectile.vpcf",
      "particles/basic_projectile/breach_three_projectile.vpcf"
    }

    local sounds_fire = {
      "Hero_Tinker.Attack",
      "Hero_Tinker.Attack",
      "Hero_Tinker.Attack"
    }

    self.particle = particles[self.level]
    self.fire_sound = sounds_fire[self.level]

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_breach_ice_mix:OnIntervalThink()
  if IsServer() then
    local enemies =
      FindUnitsInRadius(
      self.parent:GetTeam(),
      self.parent:GetAbsOrigin(),
      nil,
      self.range,
      DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
      FIND_ANY_ORDER,
      false
    )
    
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
        iMoveSpeed = self.speed,
        bDodgeable = true,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        bProvidesVision = false,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
        ExtraData = {
          ModifierName = "modifier_item_breach_ice_mix",
          ModifierLevel = self.level,
          ModifierDamage = self.damage
        }
      }
      
      if not self.parent:HasAbility("weapon_passive") then
        self.parent:AddAbility("weapon_passive")
      end
      
      self.parent:FindAbilityByName("weapon_passive"):FireProjectile(projectile)

      EmitSoundOn(self.fire_sound, self.parent)
    end
  end
end

function modifier_item_breach_ice_mix:OnRefresh(keys)
  if not IsServer() then
    return
  end

  if keys.target == nil then
    return
  end

  -- Apply breach indicator effect with debuff that will deal damage after delay
  keys.target:AddNewModifier(keys.caster, self:GetAbility(), "modifier_item_breach_ice_mix_breach_debuff", {
    duration = self.remove,
    damage = keys.extradata.ModifierDamage,
    delay = self.delay
  })
  
  EmitSoundOn("Hero_Tinker.ProjectileImpact", keys.target)
  
  -- Apply breach indicator visual
  local particle = ParticleManager:CreateParticle("particles/basic_projectile/breach_ind.vpcf", PATTACH_OVERHEAD_FOLLOW, keys.target)
  ParticleManager:SetParticleControl(particle, 0, keys.target:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_item_breach_ice_mix:OnDestroy()
  if IsServer() then
    self.parent:RemoveModifierByName("modifier_item_breach_ice_mix_2")
  end
end

----------------------------------------------------------------------
-- Breach Debuff (Delayed Damage)
----------------------------------------------------------------------

modifier_item_breach_ice_mix_breach_debuff = class({})

function modifier_item_breach_ice_mix_breach_debuff:IsHidden()
  return true
end

function modifier_item_breach_ice_mix_breach_debuff:OnCreated(kv)
  if IsServer() then
    self.damage = kv.damage
    self.delay = kv.delay or 2.5
    self.pure_pct = self:GetAbility():GetSpecialValueFor("pure_pct")
    
    self:StartIntervalThink(self.delay)
  end
end

function modifier_item_breach_ice_mix_breach_debuff:OnIntervalThink()
  if IsServer() then
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    
    -- Calculate damage split
    local pure_damage = self.damage * (self.pure_pct / 100)
    local physical_damage = self.damage - pure_damage
    
    -- Apply physical damage
    local damageTable = {
      victim = parent,
      attacker = caster,
      damage = physical_damage,
      damage_type = DAMAGE_TYPE_PHYSICAL,
      ability = ability
    }
    ApplyDamage(damageTable)
    
    -- Apply pure damage
    damageTable.damage = pure_damage
    damageTable.damage_type = DAMAGE_TYPE_PURE
    ApplyDamage(damageTable)
    
    -- Visual effect
    local particle = ParticleManager:CreateParticle("particles/basic_projectile/breach_boom.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
    
    EmitSoundOn("Hero_Tinker.ProjectileImpact", parent)
  end
end

----------------------------------------------------------------------
-- Secondary Weapon: Ice (Projectile with slow)
----------------------------------------------------------------------

modifier_item_breach_ice_mix_2 = class({})

function modifier_item_breach_ice_mix_2:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_breach_ice_mix_2:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_breach_ice_mix_2:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.fire_rate_2 = self.ability:GetSpecialValueFor("fire_rate_2")
    self.damage_2 = self.ability:GetSpecialValueFor("dmg_2")
    self.range_2 = self.ability:GetSpecialValueFor("range_2")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed_2 = self.ability:GetSpecialValueFor("speed_2")
    self.slow_pct = self.ability:GetSpecialValueFor("slow_pct")
    self.slow_dur = self.ability:GetSpecialValueFor("slow_dur")

    self.num_attacks = 1  -- Ice fires 1 shot

    local particles = {
      "particles/basic_projectile/ice_one_projectile.vpcf",
      "particles/basic_projectile/ice_two_projectile.vpcf",
      "particles/basic_projectile/ice_three_projectile.vpcf"
    }

    local sounds_fire = {
      "Hero_Crystal.Attack",
      "Hero_Crystal.Attack",
      "Hero_Crystal.Attack"
    }

    self.particle = particles[self.level]
    self.fire_sound = sounds_fire[self.level]

    self:StartIntervalThink(self.fire_rate_2)
  end
end

function modifier_item_breach_ice_mix_2:OnIntervalThink()
  if IsServer() then
    local enemies =
      FindUnitsInRadius(
      self.parent:GetTeam(),
      self.parent:GetAbsOrigin(),
      nil,
      self.range_2,
      DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
      FIND_ANY_ORDER,
      false
    )
    
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
          ModifierName = "modifier_item_breach_ice_mix_2",
          ModifierLevel = self.level,
          ModifierDamage = self.damage_2
        }
      }
      
      if not self.parent:HasAbility("weapon_passive") then
        self.parent:AddAbility("weapon_passive")
      end
      
      self.parent:FindAbilityByName("weapon_passive"):FireProjectile(projectile)

      EmitSoundOn(self.fire_sound, self.parent)
    end
  end
end

function modifier_item_breach_ice_mix_2:OnRefresh(keys)
  if not IsServer() then
    return
  end

  if keys.target == nil then
    return
  end

  -- Apply instant damage
  local damageTable = {
    victim = keys.target,
    attacker = keys.caster,
    damage = keys.extradata.ModifierDamage,
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = self:GetAbility()
  }
  ApplyDamage(damageTable)
  
  -- Apply slow effect
  keys.target:AddNewModifier(keys.caster, self:GetAbility(), "modifier_item_breach_ice_mix_ice_slow", {
    duration = self.slow_dur
  })
  
  EmitSoundOn("Hero_Crystal.ProjectileImpact", keys.target)
  
  -- Apply ice debuff visual
  local particle = ParticleManager:CreateParticle("particles/basic_projectile/ice_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
  ParticleManager:SetParticleControl(particle, 0, keys.target:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle)
end

----------------------------------------------------------------------
-- Ice Slow Debuff
----------------------------------------------------------------------

modifier_item_breach_ice_mix_ice_slow = class({})

function modifier_item_breach_ice_mix_ice_slow:IsHidden()
  return false
end

function modifier_item_breach_ice_mix_ice_slow:IsDebuff()
  return true
end

function modifier_item_breach_ice_mix_ice_slow:OnCreated(kv)
  if IsServer() then
    self.slow_pct = self:GetAbility():GetSpecialValueFor("slow_pct")
  end
end

function modifier_item_breach_ice_mix_ice_slow:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
  }
end

function modifier_item_breach_ice_mix_ice_slow:GetModifierMoveSpeedBonus_Percentage()
  return -self.slow_pct
end

function modifier_item_breach_ice_mix_ice_slow:GetEffectName()
  return "particles/basic_projectile/ice_debuff.vpcf"
end

function modifier_item_breach_ice_mix_ice_slow:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
