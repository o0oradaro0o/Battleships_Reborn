item_fire_coal_mix = class({})
LinkLuaModifier("modifier_item_fire_coal_mix", "items/item_fire_coal_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fire_coal_mix_2", "items/item_fire_coal_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fire_coal_mix_2_aura_debuff", "items/item_fire_coal_mix.lua", LUA_MODIFIER_MOTION_NONE)

item_fire_coal_mix_bow_doubled = class({})
item_fire_coal_mix_two_bow_doubled = class({})
item_fire_coal_mix_three_bow_doubled = class({})

function item_fire_coal_mix_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_fire_coal_mix"
end

function item_fire_coal_mix_two_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_fire_coal_mix"
end

function item_fire_coal_mix_three_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_fire_coal_mix"
end

----------------------------------------------------------------------
-- Primary Weapon: Fire (Projectile-based)
----------------------------------------------------------------------

modifier_item_fire_coal_mix = class({})

function modifier_item_fire_coal_mix:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_fire_coal_mix:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_fire_coal_mix:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_fire_coal_mix_2", {})

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed = self.ability:GetSpecialValueFor("speed")

    self.num_attacks = 1

    local particles = {
      "particles/basic_projectile/fire_one_projectile.vpcf",
      "particles/basic_projectile/fire_two_projectile.vpcf",
      "particles/basic_projectile/fire_three_projectile.vpcf"
    }

    local sounds_fire = {
      "Hero_Jakiro.DualBreath.Cast",
      "Hero_Jakiro.DualBreath.Cast",
      "Hero_Jakiro.DualBreath.Cast"
    }

    self.particle = particles[self.level]
    self.fire_sound = sounds_fire[self.level]

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_fire_coal_mix:OnIntervalThink()
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
          ModifierName = "modifier_item_fire_coal_mix",
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

function modifier_item_fire_coal_mix:OnRefresh(keys)
  if not IsServer() then
    return
  end

  if keys.target == nil then
    return
  end

  local hit_sounds = {
    "Hero_Jakiro.DualBreath.Impact",
    "Hero_Jakiro.DualBreath.Impact",
    "Hero_Jakiro.DualBreath.Impact"
  }

  local hit_sound = hit_sounds[keys.extradata.ModifierLevel]

  local damageTable = {
    victim = keys.target,
    attacker = keys.caster,
    damage = keys.extradata.ModifierDamage,
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = self:GetAbility()
  }
  ApplyDamage(damageTable)
  
  EmitSoundOn(hit_sound, keys.target)
end

function modifier_item_fire_coal_mix:OnDestroy()
  if IsServer() then
    self.parent:RemoveModifierByName("modifier_item_fire_coal_mix_2")
  end
end

----------------------------------------------------------------------
-- Secondary Weapon: Coal (Aura with burn damage)
----------------------------------------------------------------------

modifier_item_fire_coal_mix_2 = class({})

function modifier_item_fire_coal_mix_2:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_fire_coal_mix_2:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_fire_coal_mix_2:IsAura()
  return true
end

function modifier_item_fire_coal_mix_2:GetModifierAura()
  return "modifier_item_fire_coal_mix_2_aura_debuff"
end

function modifier_item_fire_coal_mix_2:GetAuraRadius()
  return self:GetAbility():GetSpecialValueFor("range_2")
end

function modifier_item_fire_coal_mix_2:GetAuraDuration()
  return 0.5
end

function modifier_item_fire_coal_mix_2:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_fire_coal_mix_2:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_item_fire_coal_mix_2:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

function modifier_item_fire_coal_mix_2:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.fire_rate_2 = self.ability:GetSpecialValueFor("fire_rate_2")
    self.damage_2 = self.ability:GetSpecialValueFor("dmg_2")
    self.range_2 = self.ability:GetSpecialValueFor("range_2")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed_2 = self.ability:GetSpecialValueFor("speed_2")

    self.num_attacks = 1

    local particles = {
      "particles/basic_projectile/coal_one_projectile.vpcf",
      "particles/basic_projectile/coal_two_projectile.vpcf",
      "particles/basic_projectile/coal_three_projectile.vpcf"
    }

    local sounds_fire = {
      "Hero_Batrider.Attack",
      "Hero_Lion.Attack",
      "Hero_Nevermore.Attack"
    }

    self.particle = particles[self.level]
    self.fire_sound = sounds_fire[self.level]

    self:StartIntervalThink(self.fire_rate_2)
  end
end

function modifier_item_fire_coal_mix_2:OnIntervalThink()
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
          ModifierName = "modifier_item_fire_coal_mix_2",
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

function modifier_item_fire_coal_mix_2:OnRefresh(keys)
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
  
  EmitSoundOn("Hero_Lion.ProjectileImpact", keys.target)
  
  -- Apply coal stun chance
  local ability = self:GetAbility()
  if ability and RandomInt(0, 15) == 0 then
    local stun_dur = ability:GetSpecialValueFor("stun_dur")
    keys.target:AddNewModifier(keys.caster, ability, "modifier_stunned", {duration = stun_dur})
    EmitSoundOn("Hero_Lion.Impale", keys.target)
  end
end

----------------------------------------------------------------------
-- Fire Aura Debuff (Burn damage over time)
----------------------------------------------------------------------

modifier_item_fire_coal_mix_2_aura_debuff = class({})

function modifier_item_fire_coal_mix_2_aura_debuff:IsDebuff()
  return true
end

function modifier_item_fire_coal_mix_2_aura_debuff:GetEffectName()
  return "particles/basic_projectile/fire_burn_effect_small.vpcf"
end

function modifier_item_fire_coal_mix_2_aura_debuff:OnCreated()
  if IsServer() then
    self:StartIntervalThink(0.5)
  end
end

function modifier_item_fire_coal_mix_2_aura_debuff:OnIntervalThink()
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
