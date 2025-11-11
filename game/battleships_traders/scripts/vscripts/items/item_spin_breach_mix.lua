item_spin_breach_mix = class({})
LinkLuaModifier("modifier_item_spin_breach_mix", "items/item_spin_breach_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spin_breach_mix_2", "items/item_spin_breach_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spin_breach_mix_breach_debuff", "items/item_spin_breach_mix.lua", LUA_MODIFIER_MOTION_NONE)

item_spin_breach_mix_bow_doubled = class({})
item_spin_breach_mix_two_bow_doubled = class({})
item_spin_breach_mix_three_bow_doubled = class({})

function item_spin_breach_mix_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_spin_breach_mix"
end

function item_spin_breach_mix_two_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_spin_breach_mix"
end

function item_spin_breach_mix_three_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_spin_breach_mix"
end

----------------------------------------------------------------------
-- Primary Weapon: Spin (Projectile with bounce/ricochet)
----------------------------------------------------------------------

modifier_item_spin_breach_mix = class({})

function modifier_item_spin_breach_mix:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_spin_breach_mix:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_spin_breach_mix:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_spin_breach_mix_2", {})

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed = self.ability:GetSpecialValueFor("speed")
    self.bounces = self.ability:GetSpecialValueFor("bounces")
    self.bounce_dmg = self.ability:GetSpecialValueFor("bounce_dmg")
    self.bounce_range = self.ability:GetSpecialValueFor("bounce_range")

    self.num_attacks = 1  -- Spin fires 1 shot

    local particles = {
      "particles/basic_projectile/spin_one_projectile.vpcf",
      "particles/basic_projectile/spin_two_projectile.vpcf",
      "particles/basic_projectile/spin_three_projectile.vpcf"
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

function modifier_item_spin_breach_mix:OnIntervalThink()
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
          ModifierName = "modifier_item_spin_breach_mix",
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

function modifier_item_spin_breach_mix:OnRefresh(keys)
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
  
  EmitSoundOn("Hero_Tinker.ProjectileImpact", keys.target)
  
  -- Apply bounce/ricochet effect using clusterBoom function
  local args = {
    caster = keys.caster,
    target = keys.target,
    ability = self:GetAbility()
  }
  
  -- Call the clusterBoom function from itemfunctions.lua
  if _G.clusterBoom then
    _G.clusterBoom(args)
  end
end

function modifier_item_spin_breach_mix:OnDestroy()
  if IsServer() then
    self.parent:RemoveModifierByName("modifier_item_spin_breach_mix_2")
  end
end

----------------------------------------------------------------------
-- Secondary Weapon: Breach (Projectile with delayed damage)
----------------------------------------------------------------------

modifier_item_spin_breach_mix_2 = class({})

function modifier_item_spin_breach_mix_2:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_spin_breach_mix_2:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_spin_breach_mix_2:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.fire_rate_2 = self.ability:GetSpecialValueFor("fire_rate_2")
    self.damage_2 = self.ability:GetSpecialValueFor("dmg_2")
    self.range_2 = self.ability:GetSpecialValueFor("range_2")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed_2 = self.ability:GetSpecialValueFor("speed_2")
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

    self:StartIntervalThink(self.fire_rate_2)
  end
end

function modifier_item_spin_breach_mix_2:OnIntervalThink()
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
          ModifierName = "modifier_item_spin_breach_mix_2",
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

function modifier_item_spin_breach_mix_2:OnRefresh(keys)
  if not IsServer() then
    return
  end

  if keys.target == nil then
    return
  end

  -- Apply breach indicator effect
  keys.target:AddNewModifier(keys.caster, self:GetAbility(), "modifier_item_spin_breach_mix_breach_debuff", {
    duration = keys.extradata.remove or self.remove,
    damage = keys.extradata.ModifierDamage,
    delay = self.delay
  })
  
  EmitSoundOn("Hero_Tinker.ProjectileImpact", keys.target)
  
  -- Apply breach indicator visual
  local particle = ParticleManager:CreateParticle("particles/basic_projectile/breach_ind.vpcf", PATTACH_OVERHEAD_FOLLOW, keys.target)
  ParticleManager:SetParticleControl(particle, 0, keys.target:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle)
end

----------------------------------------------------------------------
-- Breach Debuff (Delayed Damage)
----------------------------------------------------------------------

modifier_item_spin_breach_mix_breach_debuff = class({})

function modifier_item_spin_breach_mix_breach_debuff:IsHidden()
  return true
end

function modifier_item_spin_breach_mix_breach_debuff:OnCreated(kv)
  if IsServer() then
    self.damage = kv.damage
    self.delay = kv.delay or 2.5
    self.pure_pct = self:GetAbility():GetSpecialValueFor("pure_pct")
    
    self:StartIntervalThink(self.delay)
  end
end

function modifier_item_spin_breach_mix_breach_debuff:OnIntervalThink()
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

function modifier_item_spin_breach_mix_breach_debuff:OnDestroy()
  if IsServer() then
    local particle = ParticleManager:CreateParticle("particles/basic_projectile/breach_boom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
    
    EmitSoundOn("Hero_Tinker.ProjectileImpact", self:GetParent())
  end
end
