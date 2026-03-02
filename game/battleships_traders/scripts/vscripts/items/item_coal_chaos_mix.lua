item_coal_chaos_mix = class({})
LinkLuaModifier("modifier_item_coal_chaos_mix", "items/item_coal_chaos_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_coal_chaos_mix_2", "items/item_coal_chaos_mix.lua", LUA_MODIFIER_MOTION_NONE)

item_coal_chaos_mix_bow_doubled = class({})
item_coal_chaos_mix_two_bow_doubled = class({})
item_coal_chaos_mix_three_bow_doubled = class({})

function item_coal_chaos_mix_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_coal_chaos_mix"
end

function item_coal_chaos_mix_two_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_coal_chaos_mix"
end

function item_coal_chaos_mix_three_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_coal_chaos_mix"
end

----------------------------------------------------------------------
-- Primary Weapon: Coal (Projectile with stun chance)
----------------------------------------------------------------------

modifier_item_coal_chaos_mix = class({})

function modifier_item_coal_chaos_mix:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_coal_chaos_mix:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_coal_chaos_mix:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_coal_chaos_mix_2", {})

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed = self.ability:GetSpecialValueFor("speed")
    self.stun_pct = self.ability:GetSpecialValueFor("stun_pct")
    self.stun_dur = self.ability:GetSpecialValueFor("stun_dur")

    self.num_attacks = 1  -- Coal weapons fire 1 projectile

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

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_coal_chaos_mix:OnIntervalThink()
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
          ModifierName = "modifier_item_coal_chaos_mix",
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

function modifier_item_coal_chaos_mix:OnRefresh(keys)
  if not IsServer() then
    return
  end

  if keys.target == nil then
    return
  end

  local hit_sounds = {
    "Hero_Lion.ProjectileImpact",
    "Hero_Lion.ProjectileImpact",
    "Hero_Lion.ProjectileImpact"
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
  
  -- Apply coal stun chance (1/16 chance = 6.25%, close to 6.67%)
  local ability = self:GetAbility()
  if ability and RandomInt(0, 15) == 0 then
    local stun_dur = ability:GetSpecialValueFor("stun_dur")
    keys.target:AddNewModifier(keys.caster, ability, "modifier_stunned", {duration = stun_dur})
    EmitSoundOn("Hero_Lion.Impale", keys.target)
  end
end

function modifier_item_coal_chaos_mix:OnDestroy()
  if IsServer() then
    self.parent:RemoveModifierByName("modifier_item_coal_chaos_mix_2")
  end
end

----------------------------------------------------------------------
-- Secondary Weapon: Chaos (Variable damage projectiles)
----------------------------------------------------------------------

if not chaosDmgHolderMix then
  chaosDmgHolderMix = {}
end

modifier_item_coal_chaos_mix_2 = class({})

function modifier_item_coal_chaos_mix_2:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_coal_chaos_mix_2:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_coal_chaos_mix_2:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.fire_rate_2 = self.ability:GetSpecialValueFor("fire_rate_2")
    self.damage_2 = self.ability:GetSpecialValueFor("dmg_2")
    self.range_2 = self.ability:GetSpecialValueFor("range_2")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed_2 = 950  -- Standard chaos projectile speed

    self.num_attacks = 1  -- Chaos weapons fire 1 projectile for doubled versions

    local particles_weak = {
      "particles/basic_projectile/caulk_one_projectile.vpcf",  -- Negative damage (healing)
      "particles/basic_projectile/caulk_one_projectile.vpcf",
      "particles/basic_projectile/caulk_one_projectile.vpcf"
    }

    local particles_normal = {
      "particles/basic_projectile/chaos_one_projectile_weak.vpcf",
      "particles/basic_projectile/chaos_two_projectile_weak.vpcf",
      "particles/basic_projectile/chaos_three_projectile_weak.vpcf"
    }

    local particles_strong = {
      "particles/basic_projectile/chaos_one_projectile_strong.vpcf",
      "particles/basic_projectile/chaos_two_projectile_strong.vpcf",
      "particles/basic_projectile/chaos_three_projectile_strong.vpcf"
    }

    local sounds_fire = {
      "Hero_Zuus.Attack",
      "Hero_Zuus.Attack",
      "Hero_Zuus.Attack"
    }

    self.particle_weak = particles_weak[self.level]
    self.particle_normal = particles_normal[self.level]
    self.particle_strong = particles_strong[self.level]
    self.fire_sound = sounds_fire[self.level]

    if chaosDmgHolderMix[self.ability] == nil then
      chaosDmgHolderMix[self.ability] = {}
    end

    self:StartIntervalThink(self.fire_rate_2)
  end
end

function modifier_item_coal_chaos_mix_2:OnIntervalThink()
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

      -- Chaos damage multiplier: -0.5 to 2.5 (RandomFloat(-1, 3.5) * 0.2)
      local dmgMult = RandomFloat(-1, 3.5) * 0.2
      local finalDamage = self.damage_2 * dmgMult

      -- Store the damage for when the projectile hits
      table.insert(chaosDmgHolderMix[self.ability], finalDamage)

      local particleName
      if dmgMult < 0.0 then
        particleName = self.particle_weak  -- Negative damage (healing)
      elseif dmgMult < 0.5 then
        particleName = self.particle_normal  -- Weak positive damage
      else
        particleName = self.particle_strong  -- Strong positive damage
      end

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
          ModifierName = "modifier_item_coal_chaos_mix_2"
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

function modifier_item_coal_chaos_mix_2:OnRefresh(keys)
  if not IsServer() then
    return
  end

  if keys.target == nil then
    return
  end

  -- Get stored damage from chaos damage holder
  if chaosDmgHolderMix[self:GetAbility()] and chaosDmgHolderMix[self:GetAbility()][1] ~= nil then
    local storedDamage = chaosDmgHolderMix[self:GetAbility()][1]
    
    if storedDamage < 0 then
      -- Negative damage = healing
      keys.target:Heal(-storedDamage, keys.caster)
    else
      -- Positive damage
      local damageTable = {
        victim = keys.target,
        attacker = keys.caster,
        damage = storedDamage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self:GetAbility()
      }
      ApplyDamage(damageTable)
    end
    
    -- Remove the used damage value from the table
    table.remove(chaosDmgHolderMix[self:GetAbility()], 1)
  end
  
  EmitSoundOn("Hero_Zuus.ProjectileImpact", keys.target)
end

function modifier_item_coal_chaos_mix_2:OnDestroy()
  if IsServer() then
    -- Clean up damage holder
    if chaosDmgHolderMix[self.ability] then
      chaosDmgHolderMix[self.ability] = nil
    end
  end
end
