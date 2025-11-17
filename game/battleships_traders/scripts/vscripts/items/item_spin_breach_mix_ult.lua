-------------------------------------------------------------------------------
-- TEMPORARY TOWER TOSSER - Spin/Breach Hybrid Ultimate Weapon
-- Fires a projectile that spawns a stationary attacking tower
-------------------------------------------------------------------------------

item_spin_breach_mix_ult_bow = class({})
LinkLuaModifier("modifier_item_spin_breach_mix_ult_bow", "items/item_spin_breach_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)

function item_spin_breach_mix_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_spin_breach_mix_ult_bow"
end

function item_spin_breach_mix_ult_bow:OnProjectileHit(target, location)
  if not IsServer() then return end
  
  if not target then return false end
  
  local caster = self:GetCaster()
  local tower_duration = self:GetSpecialValueFor("tower_duration")
  
  -- Create spawn effect at target location
  local spawn_position = target:GetAbsOrigin() + Vector(0, 0, 50)
  local spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_ABSORIGIN, target)
  ParticleManager:SetParticleControl(spawn_particle, 0, spawn_position)
  ParticleManager:ReleaseParticleIndex(spawn_particle)
  
  EmitSoundOn("Hero_Antimage.Blink_out", target)
  
  -- Spawn the tower unit at target location
  local tower = CreateUnitByName(
    "npc_tower_tosser_tower",
    spawn_position,
    true,
    caster,
    caster,
    caster:GetTeam()
  )
  
  if tower then
    print("[Tower Tosser] Tower spawned successfully at " .. tostring(spawn_position))
    
    -- Set tower properties
    tower:SetOwner(caster)
    tower:SetControllableByPlayer(caster:GetPlayerID(), false)
    
    print("[Tower Tosser] Tower health: " .. tower:GetHealth() .. " / " .. tower:GetMaxHealth())
    print("[Tower Tosser] Tower duration: " .. tower_duration)
    
    -- Add visual effect for tower
    local tower_particle = ParticleManager:CreateParticle("particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient_trail_steam.vpcf", PATTACH_ABSORIGIN_FOLLOW, tower)
    ParticleManager:SetParticleControl(tower_particle, 0, tower:GetAbsOrigin() + Vector(0, 0, 50))
    
    -- Make tower invulnerable, unselectable, and handle expiration
    local invuln_mod = tower:AddNewModifier(caster, self, "modifier_tower_tosser_invulnerable", {
      duration = tower_duration,
      particle = tower_particle
    })
    
    if invuln_mod then
      print("[Tower Tosser] Invulnerability modifier applied successfully")
    else
      print("[Tower Tosser] ERROR: Failed to apply invulnerability modifier")
    end
    
    -- Play creation sound
    EmitSoundOn("Hero_Rattletrap.Power_Cogs", tower)
  else
    print("[Tower Tosser] ERROR: Failed to spawn tower")
  end
  
  return true
end

----------------------------------------------------------------------
-- Tower Tosser Weapon Modifier
----------------------------------------------------------------------

modifier_item_spin_breach_mix_ult_bow = class({})

function modifier_item_spin_breach_mix_ult_bow:GetAbilityTextureName()
  local abilityName = self.ability:GetAbilityName()
  return abilityName
end

function modifier_item_spin_breach_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_spin_breach_mix_ult_bow:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.range = self.ability:GetSpecialValueFor("range")
    self.speed = self.ability:GetSpecialValueFor("speed")

    self.num_attacks = 1

    self.particle = "particles/basic_projectile/spin_breach_ult_projectile.vpcf"
    self.fire_sound = "Hero_Tinker.Attack"

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_spin_breach_mix_ult_bow:OnIntervalThink()
  if not IsServer() then return end
  
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
  
  if #enemies == 0 then return end
  
  -- Select random target
  local target = enemies[RandomInt(1, #enemies)]
  
  -- Fire tracking projectile directly (no weapon_passive needed)
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
  
  -- Play fire sound
  EmitSoundOn(self.fire_sound, self.parent)
end

function modifier_item_spin_breach_mix_ult_bow:OnDestroy()
  if IsServer() then
    -- Cleanup
  end
end

----------------------------------------------------------------------
-- Tower Invulnerability Modifier
----------------------------------------------------------------------

modifier_tower_tosser_invulnerable = class({})
LinkLuaModifier("modifier_tower_tosser_invulnerable", "items/item_spin_breach_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_tower_tosser_invulnerable:IsHidden()
  return true
end

function modifier_tower_tosser_invulnerable:IsPurgable()
  return false
end

function modifier_tower_tosser_invulnerable:OnCreated(kv)
  if IsServer() then
    self.particle = kv.particle
    print("[Tower Invuln] Modifier created, duration: " .. (self:GetDuration() or "infinite"))
  end
end

function modifier_tower_tosser_invulnerable:OnDestroy()
  if IsServer() then
    print("[Tower Invuln] Modifier destroyed, cleaning up tower")
    local parent = self:GetParent()
    
    -- Clean up particle
    if self.particle then
      ParticleManager:DestroyParticle(self.particle, false)
      ParticleManager:ReleaseParticleIndex(self.particle)
    end
    
    -- Kill the tower
    if parent and not parent:IsNull() then
      print("[Tower Invuln] Killing tower")
      parent:ForceKill(false)
    end
  end
end

function modifier_tower_tosser_invulnerable:CheckState()
  return {
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  }
end


