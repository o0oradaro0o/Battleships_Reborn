item_caulk = class({})
LinkLuaModifier( "modifier_item_caulk", "items/item_caulk.lua", LUA_MODIFIER_MOTION_NONE )

item_caulk_bow = class({})
item_caulk_bow_doubled = class({})
item_caulk_two_bow = class({})
item_caulk_two_bow_doubled = class({})
item_caulk_three_bow = class({})
item_caulk_three_bow_doubled = class({})
item_caulk_ult_bow = class({})

function item_caulk_bow:GetIntrinsicModifierName()
  return "modifier_item_caulk"
end

function item_caulk_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_caulk"
end

function item_caulk_two_bow:GetIntrinsicModifierName()
  return "modifier_item_caulk"
end

function item_caulk_two_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_caulk"
end

function item_caulk_three_bow:GetIntrinsicModifierName()
  return "modifier_item_caulk"
end

function item_caulk_three_bow_doubled:GetIntrinsicModifierName()
  return "modifier_item_caulk"
end

function item_caulk_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_caulk"
end

function item_caulk_bow:OnProjectileHit(target, location)
  item_caulk:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_caulk_bow_doubled:OnProjectileHit(target, location)
  item_caulk:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_caulk_two_bow:OnProjectileHit(target, location)
  item_caulk:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_caulk_two_bow_doubled:OnProjectileHit(target, location)
  item_caulk:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_caulk_three_bow:OnProjectileHit(target, location)
  item_caulk:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_caulk_three_bow_doubled:OnProjectileHit(target, location)
  item_caulk:OnProjectileHit(self, self:GetCaster(), target, location)
end

function item_caulk_ult_bow:OnProjectileHit(target, location)
  item_caulk:OnProjectileHit(self, self:GetCaster(), target, location)
end

------------------------------------------------------------------------

function item_caulk:OnProjectileHit(ability, caster, target, location)
  if not IsServer() then return end

  local damage = ability:GetSpecialValueFor( "damage" )

  local hit_sounds = {
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact",
    "Hero_VengefulSpirit.ProjectileImpact",
  }

  local hit_sound = hit_sounds[ability:GetLevel()]

  EmitSoundOn(hit_sound, target)

  if caster:GetTeam() == target:GetTeam() then
    target:Heal(damage, caster)
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

modifier_item_caulk = class({})

function modifier_item_caulk:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_caulk:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_caulk:OnCreated( kv )   
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.fire_rate = self.ability:GetSpecialValueFor( "fire_rate" )
    self.damage = self.ability:GetSpecialValueFor( "damage" )
    self.range = self.ability:GetSpecialValueFor( "range" )
    self.level = self.ability:GetSpecialValueFor( "level" )    
    self.speed = self.ability:GetSpecialValueFor( "speed" )
    -- boolean
    self.doubled = self.ability:GetSpecialValueFor( "doubled" ) == 1

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
      print(self.ability:GetAbilityName() ..  " Weapon Level should be 1-4, is actually: " .. self.level)
      self.num_attacks = 0
    end

    local heal_particles = {
      "particles/basic_projectile/caulk_one_projectile.vpcf",
      "particles/basic_projectile/caulk_two_projectile.vpcf",
      "particles/basic_projectile/caulk_three_projectile.vpcf",
      "particles/basic_projectile/caulk_ult_projectile.vpcf",
    }

    local damage_particles = {
      "particles/basic_projectile/caulk_one_damage_projectile.vpcf",
      "particles/basic_projectile/caulk_two_damage_projectile.vpcf",
      "particles/basic_projectile/caulk_three_damage_projectile.vpcf",
      "particles/basic_projectile/caulk_ult_damage_projectile.vpcf",
    }

    local sounds_fire = {
      "Hero_Bane.Attack",
      "Hero_VengefulSpirit.Attack",
      "Hero_Terrorblade_Morphed.Attack",
      "Hero_Zuus.ArcLightning.Attack",
    }

    self.damage_particle = damage_particles[self.level]
    self.heal_particle = heal_particles[self.level]

    self.fire_sound = sounds_fire[self.level]

    self:StartIntervalThink( self.fire_rate )
  end
end

function modifier_item_caulk:OnIntervalThink()
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

    local allies = FindUnitsInRadius(
      self.parent:GetTeam(), 
      self.parent:GetAbsOrigin(), 
      nil, 
      self.range, 
      DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
      DOTA_UNIT_TARGET_FLAG_NO_INVIS, 
      FIND_ANY_ORDER,
      false
    )

    allies = filter(
      function(ally) 
        return ally:GetHealth() < ally:GetMaxHealth() and ally ~= self.parent
      end, 
      allies
    )

    -- Fire the weapon
    for i=1,self.num_attacks do
      local target

      if TableCount(allies) > 0 and TableCount(enemies) > 0 then
        if RandomInt(0, 100) < 50 then
          target = GetRandomTableElement(enemies)
        else
          target = GetRandomTableElement(allies)
        end
      elseif TableCount(allies) > 0 and TableCount(enemies) == 0 then
        target = GetRandomTableElement(allies)
      elseif TableCount(allies) == 0 and TableCount(enemies) > 0 then
        target = GetRandomTableElement(enemies)
      else
        return
      end

      local particleName

      if self.parent:GetTeam() == target:GetTeam() then
        particleName = self.heal_particle
      else
        particleName = self.damage_particle
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
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
      }

      ProjectileManager:CreateTrackingProjectile(projectile)
      EmitSoundOn(self.fire_sound, caster)
    end
  end
end