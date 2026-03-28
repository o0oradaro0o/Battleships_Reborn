-- Supernova Cannon: Plasma/Fire Mix Ultimate Weapon
-- Fires powerful projectiles that create supernova explosions on impact
-- Pushes nearby units away from the impact point with diminishing force

item_plasma_fire_mix_ult_bow = class({})
LinkLuaModifier(
  "modifier_item_plasma_fire_mix_ult_bow",
  "items/item_plasma_fire_mix_ult.lua",
  LUA_MODIFIER_MOTION_NONE
)

function item_plasma_fire_mix_ult_bow:Precache(context)
  PrecacheResource("particle", "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/invoker/invoker_ti6/invoker_sun_strike_ti6.vpcf", context)
  PrecacheResource("particle", "particles/basic_projectile/supernova_cannon_projectile.vpcf", context)
  PrecacheResource("particle", "particles/basic_projectile/fire_burn_effect_small.vpcf", context)
  PrecacheResource("particle", "particles/nova_cannon_explosion.vpcf", context)
  PrecacheResource("particle", "particles/poison_light_ult.vpcf", context)
  PrecacheResource("particle", "particles/poison_light_ult_debuff.vpcf", context)
end

function item_plasma_fire_mix_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_plasma_fire_mix_ult_bow"
end

function item_plasma_fire_mix_ult_bow:OnProjectileHit(target, location)
  if not IsServer() then
    return
  end

  if target == nil then
    return
  end

  local caster = self:GetCaster()
  local impact_point = target:GetAbsOrigin()
  local push_radius = self:GetSpecialValueFor("push_radius")
  local base_push_distance = self:GetSpecialValueFor("push_distance")
  
  -- Deal damage to primary target
  local damageTable = {
    victim = target,
    attacker = caster,
    damage = self:GetSpecialValueFor("dmg"),
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = self
  }
  ApplyDamage(damageTable)

  -- Create Phoenix Supernova death flash at impact
  local particle_flash = "particles/nova_cannon_explosion.vpcf"
  local effect_flash = ParticleManager:CreateParticle(particle_flash, PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(effect_flash, 0, impact_point)
  ParticleManager:ReleaseParticleIndex(effect_flash)

  -- Play explosion sound
  EmitSoundOn("Hero_Phoenix.SunRay.Cast", target)
  
  -- Find all enemy units near the impact point
  local enemies = FindUnitsInRadius(
    caster:GetTeam(),
    impact_point,
    nil,
    push_radius,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
    DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
    FIND_ANY_ORDER,
    false
  )
  
  -- Calculate push velocity based on number of units (diminishing with more units)
  local num_enemies = #enemies
  local push_velocity = base_push_distance
  
  if num_enemies > 1 then
    -- Diminishing formula: push_velocity = base / sqrt(num_enemies)
    push_velocity = base_push_distance / math.sqrt(num_enemies)
  end
  
  -- Push all affected units away from impact point using physics
  for _, enemy in pairs(enemies) do
    if enemy ~= target then
      -- Calculate push direction (away from impact point)
      local push_direction = (enemy:GetAbsOrigin() - impact_point):Normalized()
      
      -- Apply the physics-based knockback (like Force Staff)
      if not enemy:IsBuilding() then
        -- Initialize physics if not already active
        if not IsPhysicsUnit(enemy) then
          Physics:Unit(enemy)
        end
        
        -- Apply velocity in the push direction
        -- Velocity is scaled to create smooth movement similar to Force Staff
        local velocity_vector = push_direction * push_velocity * 3
        enemy:SetPhysicsVelocity(velocity_vector)
        enemy:SetPhysicsFriction(0.1)
        enemy:StartPhysicsSimulation()
        
        -- Stop physics after a short duration
        Timers:CreateTimer(0.5, function()
          if enemy and not enemy:IsNull() then
            enemy:OnPhysicsFrame(nil)
            enemy:SetPhysicsVelocity(Vector(0, 0, 0))
          end
        end)
        
        -- Add visual effect to pushed units
        local particle_push = "particles/basic_projectile/fire_burn_effect_small.vpcf"
        local effect_push = ParticleManager:CreateParticle(particle_push, PATTACH_ABSORIGIN_FOLLOW, enemy)
        ParticleManager:ReleaseParticleIndex(effect_push)
      end
    end
  end
  
  -- Play impact sound at location
  -- EmitSoundOnLocationWithCaster(impact_point, "Hero_Phoenix.SunRay.Stop", caster)
end

----------------------------------------------------------------------
-- Supernova Cannon Modifier
----------------------------------------------------------------------

modifier_item_plasma_fire_mix_ult_bow = class({})

function modifier_item_plasma_fire_mix_ult_bow:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_plasma_fire_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_plasma_fire_mix_ult_bow:IsHidden()
  return true
end

function modifier_item_plasma_fire_mix_ult_bow:IsPurgable()
  return false
end

function modifier_item_plasma_fire_mix_ult_bow:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self.ability:GetCaster()

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.speed = self.ability:GetSpecialValueFor("speed")

    self.num_attacks = 2

    -- Supernova Cannon projectile - combines Phoenix fire and plasma energy
    self.particle = "particles/basic_projectile/supernova_cannon_projectile.vpcf"

    self.fire_sound = "Hero_Phoenix.LaunchFire"

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_plasma_fire_mix_ult_bow:OnIntervalThink()
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
    
    -- Fire the Supernova Cannon
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
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
      }
      ProjectileManager:CreateTrackingProjectile(projectile)

      EmitSoundOn(self.fire_sound, self.caster)
    end
  end
end

function modifier_item_plasma_fire_mix_ult_bow:OnDestroy()
  if IsServer() then
    -- Cleanup if needed
  end
end


