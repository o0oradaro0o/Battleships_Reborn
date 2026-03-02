item_chaos_poison_mix = class({})
LinkLuaModifier("modifier_item_chaos_poison_mix", "items/item_chaos_poison_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaos_poison_mix_2", "items/item_chaos_poison_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaos_poison_mix_poison_debuff", "items/item_chaos_poison_mix.lua", LUA_MODIFIER_MOTION_NONE)

item_chaos_poison_mix_bow_doubled = class({})
item_chaos_poison_mix_two_bow_doubled = class({})
item_chaos_poison_mix_three_bow_doubled = class({})

function item_chaos_poison_mix_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_chaos_poison_mix"
end

function item_chaos_poison_mix_two_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_chaos_poison_mix"
end

function item_chaos_poison_mix_three_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_chaos_poison_mix"
end

----------------------------------------------------------------------
-- Primary Weapon: Chaos (Projectile-based with random damage)
----------------------------------------------------------------------

modifier_item_chaos_poison_mix = class({})

function modifier_item_chaos_poison_mix:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_chaos_poison_mix:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_chaos_poison_mix:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_chaos_poison_mix_2", {})

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.base_damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed = self.ability:GetSpecialValueFor("speed")

    self.num_attacks = 1  -- Chaos fires 2 shots

    local particles = {
      "particles/basic_projectile/chaos_one_projectile.vpcf",
      "particles/basic_projectile/chaos_two_projectile.vpcf",
      "particles/basic_projectile/chaos_three_projectile.vpcf"
    }

    local sounds_fire = {
      "Hero_Zuus.Attack",
      "Hero_Zuus.Attack",
      "Hero_Zuus.Attack"
    }

    self.particle = particles[self.level]
    self.fire_sound = sounds_fire[self.level]

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_chaos_poison_mix:OnIntervalThink()
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
    -- Fire chaos weapon with random damage
    for i = 1, self.num_attacks do
      local target

      if TableCount(enemies) > 0 then
        target = GetRandomTableElement(enemies)
      else
        return
      end

      -- Chaos damage multiplier: random between -0.5 and 2.5
      local dmgMult = RandomFloat(-0.5, 2.5)
      local actual_damage = self.base_damage * dmgMult
      
      -- Select particle based on damage multiplier
      local particleName = self.particle
      if dmgMult < 0.0 then
        particleName = "particles/basic_projectile/caulk_one_projectile.vpcf"  -- Negative damage
      elseif dmgMult < 0.5 then
        particleName = "particles/basic_projectile/chaos_" .. (self.level == 3 and "ult" or tostring(self.level)) .. "_projectile_weak.vpcf"
      end

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
          ModifierName = "modifier_item_chaos_poison_mix",
          ModifierLevel = self.level,
          ModifierDamage = actual_damage
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

function modifier_item_chaos_poison_mix:OnRefresh(keys)
  if not IsServer() then
    return
  end

  if keys.target == nil then
    return
  end

  local hit_sounds = {
    "Hero_Zuus.ProjectileImpact",
    "Hero_Zuus.ProjectileImpact",
    "Hero_Zuus.ProjectileImpact"
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

function modifier_item_chaos_poison_mix:OnDestroy()
  if IsServer() then
    self.parent:RemoveModifierByName("modifier_item_chaos_poison_mix_2")
  end
end

----------------------------------------------------------------------
-- Secondary Weapon: Poison (Projectile with DoT)
----------------------------------------------------------------------

modifier_item_chaos_poison_mix_2 = class({})

function modifier_item_chaos_poison_mix_2:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_chaos_poison_mix_2:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_chaos_poison_mix_2:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.fire_rate_2 = self.ability:GetSpecialValueFor("fire_rate_2")
    self.damage_2 = self.ability:GetSpecialValueFor("dmg_2")
    self.range_2 = self.ability:GetSpecialValueFor("range_2")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed_2 = self.ability:GetSpecialValueFor("speed_2")
    self.psn_dur = self.ability:GetSpecialValueFor("psn_dur")
    self.poison_damage = self.ability:GetSpecialValueFor("damage_2")

    self.num_attacks = 1  -- Poison fires 2 shots

    local particles = {
      "particles/basic_projectile/poison_one_projectile.vpcf",
      "particles/basic_projectile/poison_two_projectile.vpcf",
      "particles/basic_projectile/poison_three_projectile.vpcf"
    }

    local sounds_fire = {
      "Hero_Venomancer.Attack",
      "Hero_Venomancer.Attack",
      "Hero_Venomancer.Attack"
    }

    self.particle = particles[self.level]
    self.fire_sound = sounds_fire[self.level]

    self:StartIntervalThink(self.fire_rate_2)
  end
end

function modifier_item_chaos_poison_mix_2:OnIntervalThink()
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
          ModifierName = "modifier_item_chaos_poison_mix_2",
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

function modifier_item_chaos_poison_mix_2:OnRefresh(keys)
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
  
  EmitSoundOn("Hero_Venomancer.ProjectileImpact", keys.target)
  
  -- Apply poison DoT
  keys.target:AddNewModifier(keys.caster, self:GetAbility(), "modifier_item_chaos_poison_mix_poison_debuff", {duration = self.psn_dur})
end

----------------------------------------------------------------------
-- Poison DoT Debuff
----------------------------------------------------------------------

modifier_item_chaos_poison_mix_poison_debuff = class({})

function modifier_item_chaos_poison_mix_poison_debuff:IsDebuff()
  return true
end

function modifier_item_chaos_poison_mix_poison_debuff:IsHidden()
  return false
end

function modifier_item_chaos_poison_mix_poison_debuff:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_chaos_poison_mix_poison_debuff:GetEffectName()
  return "particles/basic_projectile/status_effect_poison.vpcf"
end

function modifier_item_chaos_poison_mix_poison_debuff:OnCreated()
  if IsServer() then
    self:StartIntervalThink(0.5)
  end
end

function modifier_item_chaos_poison_mix_poison_debuff:OnIntervalThink()
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
