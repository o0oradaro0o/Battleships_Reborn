item_coal_chaos_mix_ult = class({})
LinkLuaModifier("modifier_item_coal_chaos_mix_ult_bow", "items/item_coal_chaos_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_coal_chaos_mix_ult_bow_2", "items/item_coal_chaos_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)

item_coal_chaos_mix_ult_bow = class({})

function item_coal_chaos_mix_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_coal_chaos_mix_ult_bow"
end

----------------------------------------------------------------------
-- Primary Weapon: Coal Ultimate (Enhanced stun projectiles)
----------------------------------------------------------------------

modifier_item_coal_chaos_mix_ult_bow = class({})

function modifier_item_coal_chaos_mix_ult_bow:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_coal_chaos_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_coal_chaos_mix_ult_bow:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_coal_chaos_mix_ult_bow_2", {})

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.speed = self.ability:GetSpecialValueFor("speed")
    self.stun_pct = self.ability:GetSpecialValueFor("stun_pct")
    self.stun_dur = self.ability:GetSpecialValueFor("stun_dur")

    self.num_attacks = 4  -- Ultimate coal weapon fires 4 projectiles

    self.particle = "particles/basic_projectile/coal_ult_projectile.vpcf"
    self.fire_sound = "Hero_Nevermore.Attack"

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_coal_chaos_mix_ult_bow:OnIntervalThink()
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
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
        ExtraData = {
          ModifierName = "modifier_item_coal_chaos_mix_ult_bow",
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

function modifier_item_coal_chaos_mix_ult_bow:OnRefresh(keys)
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
  
  -- Apply coal stun chance (10% = 1/10 chance)
  local ability = self:GetAbility()
  if ability and RandomInt(1, 10) == 1 then
    local stun_dur = ability:GetSpecialValueFor("stun_dur")
    keys.target:AddNewModifier(keys.caster, ability, "modifier_stunned", {duration = stun_dur})
    EmitSoundOn("Hero_Lion.Impale", keys.target)
  end
end

function modifier_item_coal_chaos_mix_ult_bow:OnDestroy()
  if IsServer() then
    self.parent:RemoveModifierByName("modifier_item_coal_chaos_mix_ult_bow_2")
  end
end

----------------------------------------------------------------------
-- Secondary Weapon: Chaos Ultimate (Enhanced variable damage)
----------------------------------------------------------------------

if not chaosDmgHolderMixUlt then
  chaosDmgHolderMixUlt = {}
end

modifier_item_coal_chaos_mix_ult_bow_2 = class({})

function modifier_item_coal_chaos_mix_ult_bow_2:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_coal_chaos_mix_ult_bow_2:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_coal_chaos_mix_ult_bow_2:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.fire_rate_2 = self.ability:GetSpecialValueFor("fire_rate_2")
    self.damage_2 = self.ability:GetSpecialValueFor("dmg_2")
    self.range_2 = self.ability:GetSpecialValueFor("range_2")
    self.speed_2 = 950

    self.num_attacks = 1  -- Ultimate chaos fires 1 projectile per interval

    self.particle_weak = "particles/basic_projectile/caulk_one_projectile.vpcf"
    self.particle_normal = "particles/basic_projectile/chaos_ult_projectile_weak.vpcf"
    self.particle_strong = "particles/basic_projectile/chaos_ult_projectile_strong.vpcf"
    self.fire_sound = "Hero_Zuus.Attack"

    if chaosDmgHolderMixUlt[self.ability] == nil then
      chaosDmgHolderMixUlt[self.ability] = {}
    end

    self:StartIntervalThink(self.fire_rate_2)
  end
end

function modifier_item_coal_chaos_mix_ult_bow_2:OnIntervalThink()
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
      table.insert(chaosDmgHolderMixUlt[self.ability], finalDamage)

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
          ModifierName = "modifier_item_coal_chaos_mix_ult_bow_2"
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

function modifier_item_coal_chaos_mix_ult_bow_2:OnRefresh(keys)
  if not IsServer() then
    return
  end

  if keys.target == nil then
    return
  end

  -- Get stored damage from chaos damage holder
  if chaosDmgHolderMixUlt[self:GetAbility()] and chaosDmgHolderMixUlt[self:GetAbility()][1] ~= nil then
    local storedDamage = chaosDmgHolderMixUlt[self:GetAbility()][1]
    
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
    table.remove(chaosDmgHolderMixUlt[self:GetAbility()], 1)
  end
  
  EmitSoundOn("Hero_Zuus.ProjectileImpact", keys.target)
end

function modifier_item_coal_chaos_mix_ult_bow_2:OnDestroy()
  if IsServer() then
    -- Clean up damage holder
    if chaosDmgHolderMixUlt[self.ability] then
      chaosDmgHolderMixUlt[self.ability] = nil
    end
  end
end
