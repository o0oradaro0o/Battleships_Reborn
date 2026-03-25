-- Abyssal Rift Cannon: Coal/Chaos Mix Ultimate Weapon
-- A reality-tearing weapon that opens portals to the abyss
-- Ghostly spirits emerge from rifts and seek targets to kamikaze into

item_coal_chaos_mix_ult_bow = class({})
LinkLuaModifier("modifier_item_coal_chaos_mix_ult_bow", "items/item_coal_chaos_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_spirit_ai", "items/item_coal_chaos_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_spirit_speed_buff", "items/item_coal_chaos_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_spirit_regen_buff", "items/item_coal_chaos_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_spirit_invuln_buff", "items/item_coal_chaos_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_spirit_invis_buff", "items/item_coal_chaos_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)

function item_coal_chaos_mix_ult_bow:Precache(context)
  -- Projectile particles
  PrecacheResource("particle", "particles/darkness_chaos_ult.vpcf", context)
  
  -- Portal particles
  PrecacheResource("particle", "particles/units/heroes/hero_enigma/enigma_blackhole.vpcf", context)
  PrecacheResource("particle", "particles/dark_chaos_rift.vpcf", context)
  
  -- Spirit trail (using demonic purge debuff instead of slow)
  PrecacheResource("particle", "particles/units/heroes/hero_shadow_demon/shadow_demon_demonic_purge_debuff.vpcf", context)
  
  -- Spirit impact effects (corrected particle names)
  PrecacheResource("particle", "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_silencer/silencer_last_word.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_dazzle/dazzle_shallow_grave.vpcf", context)
  PrecacheResource("particle", "particles/items2_fx/phase_boots.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_livingarmor.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf", context)
  PrecacheResource("particle", "particles/generic_hero_status/status_invisibility_start.vpcf", context)
  
  -- Spirit model
  PrecacheResource("model", "models/heroes/shadow_demon/shadow_demon.vmdl", context)
end

function item_coal_chaos_mix_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_coal_chaos_mix_ult_bow"
end

function item_coal_chaos_mix_ult_bow:OnProjectileHit(target, location)
  if not IsServer() then
    return
  end

  if target == nil then
    return
  end

  local caster = self:GetCaster()
  local impact_point = target:GetAbsOrigin()
  
  -- Deal direct damage to primary target
  local damageTable = {
    victim = target,
    attacker = caster,
    damage = self:GetSpecialValueFor("dmg"),
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = self
  }
  ApplyDamage(damageTable)

  -- Play impact sound
  EmitSoundOn("Hero_Lion.ProjectileImpact", target)

  -- Roll for portal spawn (8% chance)
  local portal_chance = self:GetSpecialValueFor("portal_chance")
  local roll = RandomInt(1, 100)
  if roll <= portal_chance then
    -- Create portal visual effect high above the impact point
    local portal_height = 400  -- Height above the ground
    local portal_position = impact_point + Vector(0, 0, portal_height)
    
    local particle_portal = ParticleManager:CreateParticle(
      "particles/dark_chaos_rift.vpcf",
      PATTACH_WORLDORIGIN,
      nil
    )
    ParticleManager:SetParticleControl(particle_portal, 0, portal_position)
    ParticleManager:SetParticleControl(particle_portal, 1, portal_position)
    
    -- Destroy portal after 2 seconds
    Timers:CreateTimer(2.0, function()
      ParticleManager:DestroyParticle(particle_portal, false)
      ParticleManager:ReleaseParticleIndex(particle_portal)
    end)

    -- Play portal opening sound
    -- EmitSoundOnLocationWithCaster(portal_position, "Hero_Enigma.Black_Hole.Cast", caster)

    -- Spawn spirits from portal (at elevated position)
    self:SpawnSpiritsFromPortal(caster, portal_position)
  end
end

function item_coal_chaos_mix_ult_bow:SpawnSpiritsFromPortal(caster, location)
  if not IsServer() then
    return
  end

  -- Determine number of spirits (1-5)
  local num_spirits = RandomInt(
    self:GetSpecialValueFor("spirit_count_min"),
    self:GetSpecialValueFor("spirit_count_max")
  )

  -- Spawn spirits with staggered delay
  for i = 1, num_spirits do
    local delay = RandomFloat(0.1, 0.2) * i
    Timers:CreateTimer(delay, function()
      if caster and not caster:IsNull() then
        self:CreateSpirit(caster, location)
      end
    end)
  end
end

function item_coal_chaos_mix_ult_bow:CreateSpirit(caster, location)
  if not IsServer() then
    return
  end

  -- Spawn at portal center
  local spawn_location = location

  -- Determine spirit type using weighted random
  local roll = RandomInt(1, 100)
  local spirit_type = "damage"  -- Default
  local spirit_color = Vector(255, 50, 50)  -- Red
  local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
  local damage_value = RandomInt(200, 300)
  local movement_speed = RandomInt(350, 450)
  local spirit_hp = RandomInt(150, 250)

  if roll <= 40 then
    -- 40% - Damage Spirit (Red)
    spirit_type = "damage"
    spirit_color = Vector(255, 50, 50)
    target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    damage_value = RandomInt(200, 300)
  elseif roll <= 58 then
    -- 18% - Stun Spirit (Purple)
    spirit_type = "stun"
    spirit_color = Vector(150, 50, 255)
    target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    damage_value = 100
  elseif roll <= 70 then
    -- 12% - Silence Spirit (Gray)
    spirit_type = "silence"
    spirit_color = Vector(100, 100, 100)
    target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    damage_value = 50
  elseif roll <= 80 then
    -- 10% - Healing Spirit (Green)
    spirit_type = "healing"
    spirit_color = Vector(50, 255, 150)
    target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    damage_value = RandomInt(200, 300)
  elseif roll <= 88 then
    -- 8% - Speed Spirit (Cyan)
    spirit_type = "speed"
    spirit_color = Vector(50, 200, 255)
    target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    damage_value = 0
  elseif roll <= 94 then
    -- 6% - Regen Spirit (Lime)
    spirit_type = "regen"
    spirit_color = Vector(150, 255, 50)
    target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    damage_value = 0
  elseif roll <= 98 then
    -- 4% - Invulnerability Spirit (White)
    spirit_type = "invuln"
    spirit_color = Vector(255, 255, 200)
    target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    damage_value = 0
  else
    -- 2% - Invisibility Spirit (Dark Blue)
    spirit_type = "invis"
    spirit_color = Vector(50, 50, 150)
    target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    damage_value = 0
  end

  -- Create spirit unit
  local spirit = CreateUnitByName(
    "npc_abyssal_spirit",
    spawn_location,
    true,
    caster,
    caster,
    caster:GetTeam()
  )

  if spirit then
    -- Set unit properties (no player control)
    spirit:SetOwner(caster)
    spirit:SetBaseMoveSpeed(movement_speed)
    spirit:SetMaxHealth(spirit_hp)
    spirit:SetHealth(spirit_hp)
    
    -- Apply visual tint
    spirit:SetRenderColor(spirit_color.x, spirit_color.y, spirit_color.z)
    
    -- Scale model
    spirit:SetModelScale(RandomFloat(0.4, 0.6))


    -- Play spawn sound
    EmitSoundOn("Hero_ShadowDemon.ShadowPoison.Cast", spirit)

    -- Calculate burst direction (random outward direction from portal)
    local burst_angle = RandomFloat(0, 360)
    local burst_direction = Vector(math.cos(burst_angle), math.sin(burst_angle), 0)
    local burst_distance = RandomInt(300, 500)
    local burst_target_pos = spawn_location + (burst_direction * burst_distance)

    -- Find a valid target for this spirit
    local potential_targets = FindUnitsInRadius(
      spirit:GetTeam(),
      spirit:GetAbsOrigin(),
      nil,
      1200,  -- larger search range
      target_team,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NO_INVIS,
      FIND_CLOSEST,
      false
    )
    
    -- Select any valid target (can include the original target)
    local valid_target = nil
    if #potential_targets > 0 then
      valid_target = potential_targets[RandomInt(1, #potential_targets)]
    end

    -- Add AI modifier with spirit type, damage, assigned target, and burst info
    spirit:AddNewModifier(caster, self, "modifier_abyssal_spirit_ai", {
      spirit_type = spirit_type,
      damage = damage_value,
      target_team = target_team,
      particle_trail = particle_trail,
      assigned_target = valid_target and valid_target:entindex() or -1,
      burst_target_x = burst_target_pos.x,
      burst_target_y = burst_target_pos.y,
      burst_target_z = burst_target_pos.z
    })
  end
end

----------------------------------------------------------------------
-- Abyssal Rift Cannon Main Modifier
----------------------------------------------------------------------

modifier_item_coal_chaos_mix_ult_bow = class({})

function modifier_item_coal_chaos_mix_ult_bow:GetAbilityTextureName()
  local ability = self:GetAbility()
  if ability then
    return ability:GetAbilityName()
  end
  return ""
end

function modifier_item_coal_chaos_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_coal_chaos_mix_ult_bow:IsHidden()
  return true
end

function modifier_item_coal_chaos_mix_ult_bow:IsPurgable()
  return false
end

function modifier_item_coal_chaos_mix_ult_bow:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self.ability:GetCaster()

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.speed = self.ability:GetSpecialValueFor("speed")

    -- Machine gun style - fires 1 projectile per interval
    self.num_attacks = 1

    -- Abyssal projectile particle
    self.particle = "particles/darkness_chaos_ult.vpcf"
    self.fire_sound = "Hero_Enigma.MidnightPulse"

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_coal_chaos_mix_ult_bow:OnIntervalThink()
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
    
    -- Fire the Abyssal Rift Cannon
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

function modifier_item_coal_chaos_mix_ult_bow:OnDestroy()
  if IsServer() then
    -- Cleanup if needed
  end
end

----------------------------------------------------------------------
-- Spirit AI Modifier
----------------------------------------------------------------------

modifier_abyssal_spirit_ai = class({})

function modifier_abyssal_spirit_ai:IsHidden()
  return true
end

function modifier_abyssal_spirit_ai:IsPurgable()
  return false
end

function modifier_abyssal_spirit_ai:OnCreated(params)
  if IsServer() then
    self.spirit = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    
    -- Store spirit parameters
    self.spirit_type = params.spirit_type or "damage"
    self.damage = params.damage or 100
    self.target_team = params.target_team or DOTA_UNIT_TARGET_TEAM_ENEMY
    self.particle_trail = params.particle_trail or -1
    
    -- Store the assigned target entity index
    self.assigned_target_entindex = params.assigned_target or -1
    self.assigned_target = nil
    
    -- Try to get the assigned target entity
    if self.assigned_target_entindex ~= -1 then
      self.assigned_target = EntIndexToHScript(self.assigned_target_entindex)
    end
    
    -- Burst phase parameters
    self.is_bursting = true
    self.burst_target = Vector(params.burst_target_x or 0, params.burst_target_y or 0, params.burst_target_z or 0)
    self.burst_duration = 0.8  -- 0.8 seconds to burst out
    self.burst_timer = 0
    
    self.lifetime = 0
    self.max_lifetime = 10.0  -- Extended to 10 seconds
    self.attack_delay = 1.0  -- Cannot attack for first 1 second
    self.has_impacted = false

    self:StartIntervalThink(0.03)
  end
end

function modifier_abyssal_spirit_ai:OnIntervalThink()
  if IsServer() then
    if self.has_impacted or not self.spirit or self.spirit:IsNull() then
      return
    end

    self.lifetime = self.lifetime + 0.03

    -- Check if spirit has exceeded lifetime
    if self.lifetime >= self.max_lifetime then
      self:DestroySpirit()
      return
    end

    -- Check if assigned target is still valid
    if self.assigned_target and (self.assigned_target:IsNull() or not self.assigned_target:IsAlive()) then
      self:DestroySpirit()
      return
    end

    -- Handle burst phase
    if self.is_bursting then
      self.burst_timer = self.burst_timer + 0.03
      
      local current_pos = self.spirit:GetAbsOrigin()
      local direction = (self.burst_target - current_pos):Normalized()
      local distance = (self.burst_target - current_pos):Length2D()
      
      -- Move spirit outward during burst
      if distance > 50 and self.burst_timer < self.burst_duration then
        local move_speed = 800  -- Fast burst speed
        local new_pos = current_pos + (direction * move_speed * 0.03)
        self.spirit:SetAbsOrigin(new_pos)
        FindClearSpaceForUnit(self.spirit, new_pos, false)
      else
        -- Burst phase complete
        self.is_bursting = false
      end
      
      return
    end

    -- Normal hunting phase (after burst)
    if self.assigned_target then
      -- Check distance to target
      local distance = (self.assigned_target:GetAbsOrigin() - self.spirit:GetAbsOrigin()):Length2D()
      local strike_distance = 150  -- Distance to trigger impact
      
      -- If within striking distance and past attack delay, trigger impact
      if distance <= strike_distance and self.lifetime >= self.attack_delay then
        self:TriggerSpiritImpact(self.assigned_target)
        return
      end
      
      -- Before attack delay: just move toward target without attacking
      if self.lifetime < self.attack_delay then
        ExecuteOrderFromTable({
          UnitIndex = self.spirit:entindex(),
          OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
          TargetIndex = self.assigned_target:entindex(),
          Queue = false,
        })
      else
        -- After attack delay: issue attack order
        ExecuteOrderFromTable({
          UnitIndex = self.spirit:entindex(),
          OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
          TargetIndex = self.assigned_target:entindex(),
          Queue = false,
        })
      end
    else
      -- No assigned target, just despawn after a short time
      if self.lifetime > 2.0 then
        self:DestroySpirit()
      end
    end
  end
end

function modifier_abyssal_spirit_ai:TriggerSpiritImpact(target)
  if not IsServer() or self.has_impacted then
    return
  end

  self.has_impacted = true
  local impact_location = self.spirit:GetAbsOrigin()

  -- Apply effect based on spirit type
  if self.spirit_type == "damage" then
    ApplyDamage({
      victim = target,
      attacker = self.caster,
      damage = self.damage,
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self.ability
    })
    
    local particle = ParticleManager:CreateParticle(
      "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf",
      PATTACH_ABSORIGIN,
      target
    )
    ParticleManager:ReleaseParticleIndex(particle)
    EmitSoundOn("Hero_Terrorblade.Sunder.Cast", target)
    
  elseif self.spirit_type == "stun" then
    ApplyDamage({
      victim = target,
      attacker = self.caster,
      damage = self.damage,
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self.ability
    })
    
    target:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = 1.5})
    
    local particle = ParticleManager:CreateParticle(
      "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf",
      PATTACH_ABSORIGIN,
      target
    )
    ParticleManager:ReleaseParticleIndex(particle)
    EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", target)
    
  elseif self.spirit_type == "silence" then
    ApplyDamage({
      victim = target,
      attacker = self.caster,
      damage = self.damage,
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self.ability
    })
    
    target:AddNewModifier(self.caster, self.ability, "modifier_silence", {duration = 3.0})
    
    local particle = ParticleManager:CreateParticle(
      "particles/units/heroes/hero_silencer/silencer_last_word.vpcf",
      PATTACH_ABSORIGIN,
      target
    )
    ParticleManager:ReleaseParticleIndex(particle)
    EmitSoundOn("Hero_Silencer.LastWord.Damage", target)
    
  elseif self.spirit_type == "healing" then
    target:Heal(self.damage, self.caster)
    
    local particle = ParticleManager:CreateParticle(
      "particles/units/heroes/hero_dazzle/dazzle_shallow_grave.vpcf",
      PATTACH_ABSORIGIN,
      target
    )
    ParticleManager:ReleaseParticleIndex(particle)
    EmitSoundOn("Hero_Dazzle.Shallow_Grave", target)
    
  elseif self.spirit_type == "speed" then
    target:AddNewModifier(self.caster, self.ability, "modifier_abyssal_spirit_speed_buff", {duration = 4.0})
    
    local particle = ParticleManager:CreateParticle(
      "particles/items2_fx/phase_boots.vpcf",
      PATTACH_ABSORIGIN_FOLLOW,
      target
    )
    ParticleManager:ReleaseParticleIndex(particle)
    EmitSoundOn("DOTA_Item.PhaseBoots.Activate", target)
    
  elseif self.spirit_type == "regen" then
    target:AddNewModifier(self.caster, self.ability, "modifier_abyssal_spirit_regen_buff", {duration = 5.0})
    
    local particle = ParticleManager:CreateParticle(
      "particles/units/heroes/hero_treant/treant_livingarmor.vpcf",
      PATTACH_ABSORIGIN_FOLLOW,
      target
    )
    ParticleManager:ReleaseParticleIndex(particle)
    EmitSoundOn("Hero_Treant.LivingArmor.Cast", target)
    
  elseif self.spirit_type == "invuln" then
    target:AddNewModifier(self.caster, self.ability, "modifier_abyssal_spirit_invuln_buff", {duration = 1.5})
    
    local particle = ParticleManager:CreateParticle(
      "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf",
      PATTACH_ABSORIGIN_FOLLOW,
      target
    )
    ParticleManager:ReleaseParticleIndex(particle)
    EmitSoundOn("Hero_Omniknight.GuardianAngel.Cast", target)
    
  elseif self.spirit_type == "invis" then
    target:AddNewModifier(self.caster, self.ability, "modifier_abyssal_spirit_invis_buff", {duration = 4.0})
    
    local particle = ParticleManager:CreateParticle(
      "particles/generic_hero_status/status_invisibility_start.vpcf",
      PATTACH_ABSORIGIN,
      target
    )
    ParticleManager:ReleaseParticleIndex(particle)
    EmitSoundOn("Hero_Riki.Blink_Strike", target)
  end

  -- Destroy spirit after impact
  self:DestroySpirit()
end

function modifier_abyssal_spirit_ai:DestroySpirit()
  if IsServer() then
    -- Clean up trail particle
    if self.particle_trail and self.particle_trail ~= -1 then
      ParticleManager:DestroyParticle(self.particle_trail, false)
      ParticleManager:ReleaseParticleIndex(self.particle_trail)
    end

    -- Play death sound
    if self.spirit and not self.spirit:IsNull() then
      EmitSoundOn("Hero_ShadowDemon.ShadowPoison.Impact", self.spirit)
      self.spirit:ForceKill(false)
    end
  end
end

function modifier_abyssal_spirit_ai:OnDestroy()
  if IsServer() then
    self:DestroySpirit()
  end
end

function modifier_abyssal_spirit_ai:CheckState()
  return {
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
  }
end

function modifier_abyssal_spirit_ai:DeclareFunctions()
  return {
    MODIFIER_EVENT_ON_ATTACK_LANDED
  }
end

function modifier_abyssal_spirit_ai:OnAttackLanded(params)
  if IsServer() then
    if params.attacker == self.spirit then
      -- Prevent attacks during the attack delay period
      if self.lifetime < self.attack_delay then
        return
      end
      
      -- Check if this is the assigned target
      if params.target == self.assigned_target then
        -- Trigger spirit impact effect
        self:TriggerSpiritImpact(params.target)
      else
        -- Hit wrong target, just destroy without effect
        self:DestroySpirit()
      end
    end
  end
end

----------------------------------------------------------------------
-- Spirit Buff Modifiers
----------------------------------------------------------------------

-- Speed Buff Modifier
modifier_abyssal_spirit_speed_buff = class({})

function modifier_abyssal_spirit_speed_buff:IsHidden()
  return false
end

function modifier_abyssal_spirit_speed_buff:IsPurgable()
  return true
end

function modifier_abyssal_spirit_speed_buff:OnCreated()
  if IsServer() then
    self.particle = ParticleManager:CreateParticle("particles/items2_fx/phase_boots.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  end
end

function modifier_abyssal_spirit_speed_buff:OnDestroy()
  if IsServer() and self.particle then
    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)
  end
end

function modifier_abyssal_spirit_speed_buff:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
  }
end

function modifier_abyssal_spirit_speed_buff:GetModifierMoveSpeedBonus_Percentage()
  return 50
end

-- Regen Buff Modifier
modifier_abyssal_spirit_regen_buff = class({})

function modifier_abyssal_spirit_regen_buff:IsHidden()
  return false
end

function modifier_abyssal_spirit_regen_buff:IsPurgable()
  return true
end

function modifier_abyssal_spirit_regen_buff:OnCreated()
  if IsServer() then
    self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_livingarmor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  end
end

function modifier_abyssal_spirit_regen_buff:OnDestroy()
  if IsServer() and self.particle then
    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)
  end
end

function modifier_abyssal_spirit_regen_buff:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
  }
end

function modifier_abyssal_spirit_regen_buff:GetModifierConstantHealthRegen()
  return 50
end

-- Invulnerability Buff Modifier
modifier_abyssal_spirit_invuln_buff = class({})

function modifier_abyssal_spirit_invuln_buff:IsHidden()
  return false
end

function modifier_abyssal_spirit_invuln_buff:IsPurgable()
  return false
end

function modifier_abyssal_spirit_invuln_buff:OnCreated()
  if IsServer() then
    self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  end
end

function modifier_abyssal_spirit_invuln_buff:OnDestroy()
  if IsServer() and self.particle then
    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)
  end
end

function modifier_abyssal_spirit_invuln_buff:CheckState()
  return {
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true
  }
end

-- Invisibility Buff Modifier
modifier_abyssal_spirit_invis_buff = class({})

function modifier_abyssal_spirit_invis_buff:IsHidden()
  return false
end

function modifier_abyssal_spirit_invis_buff:IsPurgable()
  return true
end

function modifier_abyssal_spirit_invis_buff:OnCreated()
  if IsServer() then
    self.particle = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  end
end

function modifier_abyssal_spirit_invis_buff:OnDestroy()
  if IsServer() and self.particle then
    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)
  end
end

function modifier_abyssal_spirit_invis_buff:CheckState()
  return {
    [MODIFIER_STATE_INVISIBLE] = true
  }
end

function modifier_abyssal_spirit_invis_buff:DeclareFunctions()
  return {
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED
  }
end

function modifier_abyssal_spirit_invis_buff:OnAttack(params)
  if IsServer() then
    if params.attacker == self:GetParent() then
      self:Destroy()
    end
  end
end

function modifier_abyssal_spirit_invis_buff:OnAbilityExecuted(params)
  if IsServer() then
    if params.unit == self:GetParent() then
      self:Destroy()
    end
  end
end
