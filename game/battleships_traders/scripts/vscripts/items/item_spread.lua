item_spread = class({})
LinkLuaModifier( "modifier_item_spread", "items/item_spread.lua", LUA_MODIFIER_MOTION_NONE )

item_spread_bow = class({})
item_spread_bow_doubled = class({})
item_spread_two_bow = class({})
item_spread_two_bow_doubled = class({})
item_spread_three_bow = class({})
item_spread_three_bow_doubled = class({})
item_spread_ult_bow = class({})

function item_spread_bow:GetIntrinsicModifierName()
  return "modifier_item_spread"
end

function item_spread_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_spread"
end

function item_spread_two_bow:GetIntrinsicModifierName()
  return "modifier_item_spread"
end

function item_spread_two_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_spread"
end

function item_spread_three_bow:GetIntrinsicModifierName()
  return "modifier_item_spread"
end

function item_spread_three_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_spread"
end

function item_spread_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_spread"
end

function item_spread_bow:OnProjectileHit(target, location)
  item_spread:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_spread_bow_doubled:OnProjectileHit(target, location)
  item_spread:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_spread_two_bow:OnProjectileHit(target, location)
  item_spread:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_spread_two_bow_doubled:OnProjectileHit(target, location)
  item_spread:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_spread_three_bow:OnProjectileHit(target, location)
  item_spread:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_spread_three_bow_doubled:OnProjectileHit(target, location)
  item_spread:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_spread_ult_bow:OnProjectileHit(target, location)
  item_spread:OnProjectileHit(self, self:GetCaster(), target, location)
end

------------------------------------------------------------------------

function item_spread:OnProjectileHit(ability, caster, target, location)
  if not IsServer() then return end

  if target == nil then return end

  local damage = ability:GetSpecialValueFor( "dmg" )

  local hit_sounds = {
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact",
  }

  local hit_sound = hit_sounds[ability:GetLevel()]

  local enemies = FindUnitsInRadius(
    caster:GetTeam(), 
    target:GetAbsOrigin(), 
    nil, 
    ability:GetSpecialValueFor( "aoe" ), 
    DOTA_UNIT_TARGET_TEAM_ENEMY, 
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 
    DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 
    FIND_ANY_ORDER,
    false
  )
  if ability:GetSpecialValueFor( "doubled_wep" ) == 1 then
    for _,enemy in pairs(enemies) do
      local mult = 1;
      if enemy:GetEntityIndex() ~= target:GetEntityIndex() and not enemy:IsRealHero() then
        mult = 0.25
      end

      local damageTable = {
        victim = enemy,
        attacker = caster, 
        damage = damage*mult,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = ability
      }
          
      ApplyDamage(damageTable)
    end
  else
    local damageTable = {
        victim = target,
        attacker = caster, 
        damage = damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = ability
      }
          
      ApplyDamage(damageTable)
  end
end

----------------------------------------------------------------------

modifier_item_spread = class({})

function modifier_item_spread:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_spread:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_spread:OnCreated( kv )   
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.fire_rate = self.ability:GetSpecialValueFor( "fire_rate" )
    self.damage = self.ability:GetSpecialValueFor( "dmg" )
    self.range = self.ability:GetSpecialValueFor( "range" )
    self.level = self.ability:GetSpecialValueFor( "level" )    
    self.speed = self.ability:GetSpecialValueFor( "speed" )
    -- boolean
    self.doubled = self.ability:GetSpecialValueFor( "doubled_wep" ) == 1

    self.num_attacks = 0

    if self.level < 4 then
      if not self.doubled then
        self.num_attacks = 1
      else
        self.num_attacks = 2
      end
    elseif self.level == 4 then
      self.num_attacks = 4
    else
      --print(self.ability:GetAbilityName() ..  " Weapon Level should be 1-4, is actually: " .. self.level)
      self.num_attacks = 0
    end

    local particles = {
      "particles/basic_projectile/spread_one_projectile.vpcf",
      "particles/basic_projectile/spread_two_projectile.vpcf",
      "particles/basic_projectile/spread_three_projectile.vpcf",
      "particles/basic_projectile/spread_ult_projectile.vpcf",
    }


    local sounds_fire = {
      "Hero_Bane.Attack",
      "Hero_VengefulSpirit.Attack",
      "Hero_Terrorblade_Morphed.Attack",
      "Hero_Zuus.ArcLightning.Attack",
    }

    self.particle = particles[self.level]

    self.fire_sound = sounds_fire[self.level]

    self:StartIntervalThink( self.fire_rate )
  end
end

function modifier_item_spread:OnIntervalThink()
  if IsServer() then
    
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
    -- Fire the weapon
    for i=1,self.num_attacks do
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
      --print(self.ability:GetAbilityName())
      ProjectileManager:CreateTrackingProjectile(projectile)
      EmitSoundOn(self.fire_sound, caster)
    end
  end
end