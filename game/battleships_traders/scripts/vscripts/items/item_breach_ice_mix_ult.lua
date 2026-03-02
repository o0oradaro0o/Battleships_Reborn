-------------------------------------------------------------------------------
-- CREEPING COLD - Breach/Ice Mix Ultimate Weapon
-- Fires projectiles that spawn orbiting ice bombs around targets
-- Bombs explode on contact with allies or after timeout
-------------------------------------------------------------------------------

item_breach_ice_mix_ult_bow = class({})
LinkLuaModifier("modifier_item_breach_ice_mix_ult_bow", "items/item_breach_ice_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)

function item_breach_ice_mix_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_breach_ice_mix_ult_bow"
end

function item_breach_ice_mix_ult_bow:OnProjectileHit(target, location)
  if not IsServer() then return end
  
  if not target then return false end
  
  local caster = self:GetCaster()
  
  -- Play impact sound
  EmitSoundOn("Hero_Crystal.CrystalNova", target)
  
  -- Create impact effect
  local particle_impact = ParticleManager:CreateParticle(
    "models/items/faceless_void/faceless_void_arcana/debut/particles/drow_frost_arrow_explosion_b.vpcf",
    PATTACH_ABSORIGIN,
    target
  )
  ParticleManager:ReleaseParticleIndex(particle_impact)
  
  -- Spawn the orbiting ice bomb
  local bomb_position = target:GetAbsOrigin()
  local bomb = CreateUnitByName(
    "npc_ice_bomb",
    bomb_position,
    true,
    caster,
    caster,
    caster:GetTeam()
  )
  
  if bomb then
    bomb:SetOwner(caster)
    bomb:SetControllableByPlayer(caster:GetPlayerID(), false)
    
    -- Add the orbit ability which handles all the behavior
    local orbit_ability = bomb:FindAbilityByName("breach_ice_orbit")
    if orbit_ability then
      orbit_ability:SetLevel(1)
      
      -- Get target entindex
      local target_idx = target:entindex()
      print("[Creeping Cold] Spawning bomb for target entindex: " .. tostring(target_idx))
      
      -- Pass the target info to the ability
      local orbit_modifier = bomb:AddNewModifier(caster, orbit_ability, "modifier_breach_ice_orbit", {
        target_entindex = target_idx,
        direct_damage = self:GetSpecialValueFor("bomb_damage"),
        explosion_damage = self:GetSpecialValueFor("explosion_damage"),
        orbit_duration = self:GetSpecialValueFor("orbit_duration"),
        orbit_radius = self:GetSpecialValueFor("orbit_radius"),
        orbit_speed = self:GetSpecialValueFor("orbit_speed"),
        slow_radius = self:GetSpecialValueFor("slow_radius"),
        slow_pct = self:GetSpecialValueFor("slow_pct"),
        collision_radius = self:GetSpecialValueFor("collision_radius")
      })
    else
      print("[Creeping Cold] ERROR: Could not find breach_ice_orbit ability on bomb!")
    end
  else
    print("[Creeping Cold] ERROR: Failed to create bomb unit!")
  end
  
  return true
end

----------------------------------------------------------------------
-- Creeping Cold Main Modifier (Weapon Firing)
----------------------------------------------------------------------

modifier_item_breach_ice_mix_ult_bow = class({})

function modifier_item_breach_ice_mix_ult_bow:GetAbilityTextureName()
  local ability = self:GetAbility()
  if ability then
    return ability:GetAbilityName()
  end
  return ""
end

function modifier_item_breach_ice_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_breach_ice_mix_ult_bow:IsHidden()
  return true
end

function modifier_item_breach_ice_mix_ult_bow:IsPurgable()
  return false
end

function modifier_item_breach_ice_mix_ult_bow:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self.ability:GetCaster()

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.range = self.ability:GetSpecialValueFor("range")
    self.speed = self.ability:GetSpecialValueFor("speed")

    -- Ice projectile with frozen effect
    self.particle = "particles/neutral_fx/icefire_bomb.vpcf"
    self.fire_sound = "Hero_Crystal.Attack"

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_breach_ice_mix_ult_bow:OnIntervalThink()
  if IsServer() then
    local enemies = FindUnitsInRadius(
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
    
    if TableCount(enemies) == 0 then
      return
    end

    local target = GetRandomTableElement(enemies)
    local projectile_count = self.ability:GetSpecialValueFor("projectile_count")

    -- Fire multiple projectiles
    for i = 1, projectile_count do
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
    end

    EmitSoundOn(self.fire_sound, self.caster)
  end
end

function modifier_item_breach_ice_mix_ult_bow:OnDestroy()
  if IsServer() then
    -- Cleanup if needed
  end
end


