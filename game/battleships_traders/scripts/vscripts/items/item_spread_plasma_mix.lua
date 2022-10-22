item_spread_plasma_mix = class({})
LinkLuaModifier("modifier_item_spread_plasma_mix", "items/item_spread_plasma_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spread_plasma_mix_2", "items/item_spread_plasma_mix.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_spread_plasma_mix_dearmor", "items/item_spread_plasma_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spread_plasma_mix_dearmor_2", "items/item_spread_plasma_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spread_plasma_mix_dearmor_3", "items/item_spread_plasma_mix.lua", LUA_MODIFIER_MOTION_NONE)

item_spread_plasma_mix_bow_doubled = class({})
item_spread_plasma_mix_two_bow_doubled = class({})
item_spread_plasma_mix_three_bow_doubled = class({})

function item_spread_plasma_mix_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_spread_plasma_mix"
end

function item_spread_plasma_mix_two_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_spread_plasma_mix"
end

function item_spread_plasma_mix_three_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_spread_plasma_mix"
end

modifier_item_spread_plasma_mix = class({})

function modifier_item_spread_plasma_mix:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_spread_plasma_mix:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_spread_plasma_mix:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_spread_plasma_mix_2", {})

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed = self.ability:GetSpecialValueFor("speed")
    -- boolean
    self.doubled = self.ability:GetSpecialValueFor("doubled_wep") == 1

    self.num_attacks = 1

    local particles = {
      "particles/basic_projectile/spread_one_projectile.vpcf",
      "particles/basic_projectile/spread_two_projectile.vpcf",
      "particles/basic_projectile/spread_three_projectile.vpcf"
    }

    local sounds_fire = {
      "Hero_Bane.Attack",
      "Hero_VengefulSpirit.Attack",
      "Hero_Terrorblade_Morphed.Attack",
      "Hero_Zuus.ArcLightning.Attack"
    }

    self.particle = particles[self.level]

    self.fire_sound = sounds_fire[self.level]

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_spread_plasma_mix:OnIntervalThink()
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
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
        ExtraData = {
          ModifierName = "modifier_item_spread_plasma_mix",
          ModifierLevel = self.level,
          ModifierDamage = self.damage,
        }
      }
      --print(self.ability:GetAbilityName())
      -- check if the caster has the weapon_passive ability, add it if they Don't
      if not self.parent:HasAbility("weapon_passive") then
        self.parent:AddAbility("weapon_passive")
      end
      -- send the projectile to the FireProjectile of the weapon_passive
      self.parent:FindAbilityByName("weapon_passive"):FireProjectile(projectile)

      EmitSoundOn(self.fire_sound, caster)
    end
  end
end

function modifier_item_spread_plasma_mix:OnRefresh(keys)

  if not IsServer() then
    return
  end

  if keys.target == nil then
    return
  end


  local hit_sounds = {
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact"
  }

  local hit_sound = hit_sounds[keys.extradata.ModifierLevel]


  local enemies =
    FindUnitsInRadius(
    keys.caster:GetTeam(),
    keys.target:GetAbsOrigin(),
    nil,
    self:GetAbility():GetSpecialValueFor("aoe"),
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
    DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
    FIND_ANY_ORDER,
    false
  )



    for _, enemy in pairs(enemies) do
      local mult = 1
      if enemy:GetEntityIndex() ~= keys.target:GetEntityIndex() and not enemy:IsRealHero() then
        mult = 0.25
      end

      local damageTable = {
        victim = enemy,
        attacker = keys.caster,
        damage = keys.extradata.ModifierDamage * mult,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self:GetAbility()
      }
      ApplyDamage(damageTable)
    end
   
end


function modifier_item_spread_plasma_mix:OnDestroy()
  -- Runs when the modifier is destroyed.( kv )
  if IsServer() then
    self.parent:RemoveModifierByName("modifier_item_spread_plasma_mix_2")
  end
end

----------------------------------------------------------------------

modifier_item_spread_plasma_mix_2 = class({})

function modifier_item_spread_plasma_mix_2:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_spread_plasma_mix_2:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_spread_plasma_mix_2:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.fire_rate_2 = self.ability:GetSpecialValueFor("fire_rate_2")
    self.damage_2 = self.ability:GetSpecialValueFor("dmg_2")
    self.range_2 = self.ability:GetSpecialValueFor("range_2")
    self.level = self.ability:GetSpecialValueFor("level")
    self.speed_2 = self.ability:GetSpecialValueFor("speed_2")
    self.armor_dur_2 = self.ability:GetSpecialValueFor("armor_dur_2")
    

    self.num_attacks = 1

    local particles = {
      "particles/basic_projectile/plasma_one_projectile.vpcf",
      "particles/basic_projectile/plasma_two_projectile.vpcf",
      "particles/basic_projectile/plasma_three_projectile.vpcf"
    }

    local sounds_fire = {
      "Hero_Bane.Attack",
      "Hero_VengefulSpirit.Attack",
      "Hero_Terrorblade_Morphed.Attack",
      "Hero_Zuus.ArcLightning.Attack"
    }

    self.particle = particles[self.level]

    self.fire_sound = sounds_fire[self.level]

    self:StartIntervalThink(self.fire_rate_2)
  end
end

function modifier_item_spread_plasma_mix_2:OnIntervalThink()
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

      local particleName

      particleName = self.particle

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
          ModifierName = "modifier_item_spread_plasma_mix_2",
          ModifierLevel = self.level,
          ModifierDamage = self.damage_2,
          ModifierDuration = self.armor_dur_2
        }
      }
      --print(self.ability:GetAbilityName())
      -- check if the caster has the weapon_passive ability, add it if they Don't
      if not self.parent:HasAbility("weapon_passive") then
        self.parent:AddAbility("weapon_passive")
      end
      -- send the projectile to the FireProjectile of the weapon_passive
      self.parent:FindAbilityByName("weapon_passive"):FireProjectile(projectile)


      EmitSoundOn(self.fire_sound, caster)
    end
  end
end

function modifier_item_spread_plasma_mix_2:OnRefresh(keys)

  if not IsServer() then
    return
  end

  if keys.target == nil then
    return
  end
  

  local hit_sounds = {
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact"
  }

  local hit_sound = hit_sounds[keys.extradata.ModifierLevel]

 
    local damageTable = {
      victim = keys.target,
      attacker = keys.caster,
      damage =  keys.extradata.ModifierDamage,
      damage_type = DAMAGE_TYPE_PHYSICAL,
      ability = self:GetAbility()
    }
    ApplyDamage(damageTable)
    local modname = "modifier_item_spread_plasma_mix_dearmor"
    if  keys.extradata.ModifierLevel == 2 then
      modname = "modifier_item_spread_plasma_mix_dearmor_2"
    elseif  keys.extradata.ModifierLevel == 3 then
      modname = "modifier_item_spread_plasma_mix_dearmor_3"
    end
    --check if target already has modname
    if  keys.target:HasModifier(modname) then
      local durToAdd = keys.extradata.ModifierDuration
      local mod =  keys.target:FindModifierByName(modname)
      local dur = mod:GetRemainingTime()
      mod:SetDuration(dur + durToAdd, true)
    else
      keys.target:AddNewModifier(keys.caster, self:GetAbility(), modname, {duration = keys.extradata.ModifierDuration})
    end
end

----------------------------------------------------------------------

modifier_item_spread_plasma_mix_dearmor = class({})

function modifier_item_spread_plasma_mix_dearmor:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
  }
  return funcs
end

function modifier_item_spread_plasma_mix_dearmor:GetModifierPhysicalArmorBonus()
  return (-1*self:GetAbility():GetSpecialValueFor("armor_down_2"))
end

----------------------------------------------------------------------

modifier_item_spread_plasma_mix_dearmor_2 = class({})

function modifier_item_spread_plasma_mix_dearmor_2:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
  }
  return funcs
end

function modifier_item_spread_plasma_mix_dearmor_2:GetModifierPhysicalArmorBonus()
  return (-1*self:GetAbility():GetSpecialValueFor("armor_down_2"))
end

----------------------------------------------------------------------

modifier_item_spread_plasma_mix_dearmor_3 = class({})

function modifier_item_spread_plasma_mix_dearmor_3:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
  }
  return funcs
end

function modifier_item_spread_plasma_mix_dearmor_3:GetModifierPhysicalArmorBonus()
  return (-1*self:GetAbility():GetSpecialValueFor("armor_down_2"))
end






