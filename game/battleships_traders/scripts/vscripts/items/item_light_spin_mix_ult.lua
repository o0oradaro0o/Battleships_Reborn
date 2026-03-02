-------------------------------------------------------------------------------
-- REFLECTION BEAM - Light/Spin Hybrid Ultimate Weapon
-- Fires a projectile that chains to the caster with a damaging beam
-------------------------------------------------------------------------------

item_light_spin_mix_ult_bow = class({})
LinkLuaModifier("modifier_item_light_spin_mix_ult_bow", "items/item_light_spin_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)

function item_light_spin_mix_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_light_spin_mix_ult_bow"
end

function item_light_spin_mix_ult_bow:OnProjectileHit(target, location)
  if not IsServer() then return end
  
  if not target then return false end
  
  local caster = self:GetCaster()
  local damage = self:GetSpecialValueFor("dmg")
  local beam_damage = self:GetSpecialValueFor("beam_damage")
  local beam_width = self:GetSpecialValueFor("beam_width")
  
  -- Deal initial projectile damage to target
  local damageTable = {
    victim = target,
    attacker = caster,
    damage = damage,
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = self
  }
  ApplyDamage(damageTable)
  
  -- Impact effects
  EmitSoundOn("Hero_Phoenix.SunRay.Cast", target)
  
  local beam_height = Vector(0, 0, 50)
  -- Create beam effect from target back to caster
  local beam_particle = ParticleManager:CreateParticle(
    "particles/light_spin_ult_beam.vpcf",
    PATTACH_ABSORIGIN,
    target
  )
  ParticleManager:SetParticleControl(beam_particle, 0, caster:GetAbsOrigin()+beam_height)
  ParticleManager:SetParticleControl(beam_particle, 1, caster:GetAbsOrigin()+beam_height)
  ParticleManager:SetParticleControl(beam_particle, 3, target:GetAbsOrigin()+beam_height)
  
  -- Destroy beam particle after 0.3 seconds
  Timers:CreateTimer(0.1, function()
    ParticleManager:DestroyParticle(beam_particle, false)
    ParticleManager:ReleaseParticleIndex(beam_particle)
  end)
  
  -- Play beam sound
  EmitSoundOn("Hero_Phoenix.SunRay.Loop", target)
  
  -- Find all units between target and caster
  local caster_pos = caster:GetAbsOrigin()
  local target_pos = target:GetAbsOrigin()
  local direction = (caster_pos - target_pos):Normalized()
  local distance = (caster_pos - target_pos):Length2D()
  
  -- Find all enemies in a line between target and caster
  local enemies = FindUnitsInRadius(
    caster:GetTeam(),
    target_pos,
    nil,
    distance,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
    DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
    FIND_ANY_ORDER,
    false
  )
  
  -- Damage enemies in the beam path
  for _, enemy in pairs(enemies) do
    if enemy ~= target then
      -- Check if enemy is actually in the beam path
      local enemy_pos = enemy:GetAbsOrigin()
      local point_to_line_dist = self:GetDistanceFromLine(target_pos, caster_pos, enemy_pos)
      
      if point_to_line_dist <= beam_width then
        -- Check if enemy is between caster and target
        local to_enemy = (enemy_pos - target_pos)
        local projection = to_enemy:Dot(direction)
        
        if projection >= 0 and projection <= distance then
          -- Deal beam damage
          local beam_damage_table = {
            victim = enemy,
            attacker = caster,
            damage = beam_damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
          }
          ApplyDamage(beam_damage_table)
          
          -- Small impact effect
          local impact_particle = ParticleManager:CreateParticle(
            "particles/units/heroes/hero_phoenix/phoenix_sunray_beam_enemy_flash.vpcf",
            PATTACH_ABSORIGIN,
            enemy
          )
          ParticleManager:SetParticleControl(impact_particle, 0, enemy:GetAbsOrigin())
          ParticleManager:ReleaseParticleIndex(impact_particle)
        end
      end
    end
  end
  
  -- Stop beam sound after short delay
  Timers:CreateTimer(0.3, function()
    StopSoundOn("Hero_Phoenix.SunRay.Loop", target)
  end)
  
  return true
end

-- Helper function to calculate distance from point to line
function item_light_spin_mix_ult_bow:GetDistanceFromLine(line_start, line_end, point)
  local line_vec = line_end - line_start
  local point_vec = point - line_start
  local line_length = line_vec:Length2D()
  
  if line_length == 0 then
    return (point - line_start):Length2D()
  end
  
  local line_normalized = line_vec / line_length
  local projection = point_vec:Dot(line_normalized)
  
  -- Clamp projection to line segment
  projection = math.max(0, math.min(line_length, projection))
  
  local closest_point = line_start + line_normalized * projection
  return (point - closest_point):Length2D()
end

-------------------------------------------------------------------------------
-- Weapon Firing Modifier (attached to wielder)
-------------------------------------------------------------------------------

modifier_item_light_spin_mix_ult_bow = class({})

function modifier_item_light_spin_mix_ult_bow:IsHidden()
  return true
end

function modifier_item_light_spin_mix_ult_bow:IsPurgable()
  return false
end

function modifier_item_light_spin_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_light_spin_mix_ult_bow:OnCreated(kv)
  if not IsServer() then return end
  
  self.ability = self:GetAbility()
  self.parent = self:GetParent()
  
  -- Weapon stats
  self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
  self.damage = self.ability:GetSpecialValueFor("dmg")
  self.range = self.ability:GetSpecialValueFor("range")
  self.speed = self.ability:GetSpecialValueFor("speed")
  
  -- Spinning light beam projectile
  self.particle = "particles/light_spin_ult.vpcf"
  self.fire_sound = "Hero_Wisp.Attack"
  
  self:StartIntervalThink(self.fire_rate)
end

function modifier_item_light_spin_mix_ult_bow:OnIntervalThink()
  if not IsServer() then return end
  
  -- Find enemies in range
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
  
  if #enemies == 0 then return end
  
  -- Select random target
  local target = enemies[RandomInt(1, #enemies)]
  
  -- Fire tracking projectile
  local projectile = {
    Target = target,
    Source = self.parent,
    Ability = self.ability,
    EffectName = self.particle,
    iMoveSpeed = self.speed,
    bDodgeable = true,
    bVisibleToEnemies = true,
    bReplaceExisting = false,
    bProvidesVision = true,
    iVisionRadius = 600,
    iVisionTeamNumber = self.parent:GetTeamNumber(),
    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
  }
  
  ProjectileManager:CreateTrackingProjectile(projectile)
  
  -- Play fire sound
  EmitSoundOn(self.fire_sound, self.parent)
end
