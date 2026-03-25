-- Entropic Contagion: Chaos/Poison Mix Ultimate Weapon
-- Fires infectious projectiles that spawn drifting toxic clouds on impact
-- Clouds poison any units that enter them, with stacking poison damage

item_chaos_poison_mix_ult_bow = class({})
LinkLuaModifier("modifier_item_chaos_poison_mix_ult_bow", "items/item_chaos_poison_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_entropic_cloud_thinker", "items/item_chaos_poison_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_entropic_cloud_aura", "items/item_chaos_poison_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_entropic_cloud_aura_effect", "items/item_chaos_poison_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_entropic_poison_debuff", "items/item_chaos_poison_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)

function item_chaos_poison_mix_ult_bow:Precache(context)
  -- Precache custom entropic projectile particle
  PrecacheResource("particle", "particles/basic_projectile/entropic_contagion_projectile.vpcf", context)
  PrecacheResource("particle", "particles/basic_projectile/entropic_contagion_trail.vpcf", context)
  PrecacheResource("particle", "particles/basic_projectile/entropic_contagion_glow.vpcf", context)
  PrecacheResource("particle", "particles/basic_projectile/entropic_contagion_chaos_sparks.vpcf", context)
  
  -- Precache cloud particles (using Venomancer particles)
  PrecacheResource("particle", "particles/chaos_poison_effect.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf", context)
  
  -- Precache impact effect
  PrecacheResource("particle", "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher.vpcf", context)
end

function item_chaos_poison_mix_ult_bow:GetIntrinsicModifierName()
  return "modifier_item_chaos_poison_mix_ult_bow"
end

function item_chaos_poison_mix_ult_bow:OnProjectileHit(target, location)
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

  -- Play impact sound and effect
  EmitSoundOn("Hero_Venomancer.ProjectileImpact", target)
  
  local particle_impact = ParticleManager:CreateParticle(
    "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher.vpcf",
    PATTACH_ABSORIGIN,
    target
  )
  ParticleManager:ReleaseParticleIndex(particle_impact)

  -- Roll for cloud spawn (15% chance)
  local cloud_chance = self:GetSpecialValueFor("cloud_chance")
  local roll = RandomInt(1, 100)
  if roll <= cloud_chance then
    -- Spawn clouds at impact point
    self:SpawnClouds(caster, impact_point)
  end
end

function item_chaos_poison_mix_ult_bow:SpawnClouds(caster, location)
  if not IsServer() then
    return
  end

  -- Determine number of clouds (2-4)
  local num_clouds = RandomInt(
    self:GetSpecialValueFor("cloud_count_min"),
    self:GetSpecialValueFor("cloud_count_max")
  )

  -- Spawn clouds with slight offset and random drift directions
  for i = 1, num_clouds do
    Timers:CreateTimer(0.05 * i, function()
      if caster and not caster:IsNull() then
        -- Random small offset from impact point
        local offset = Vector(RandomInt(-50, 50), RandomInt(-50, 50), 0)
        local spawn_position = location + offset
        
        -- Create flying cloud unit (using courier as base for flying movement)
        local cloud = CreateUnitByName("npc_dota_courier", spawn_position, false, caster, caster, caster:GetTeam())
        
        if cloud then
          -- Make cloud invisible model
          cloud:SetModelScale(0.01)
          cloud:SetOriginalModel("models/development/invisiblebox.vmdl")
          cloud:SetModel("models/development/invisiblebox.vmdl")
          
          -- Random drift direction
          local angle = RandomFloat(0, 360) * math.pi / 180
          local drift_direction = Vector(math.cos(angle), math.sin(angle), 0)
          
          -- Add cloud thinker modifier (handles movement and lifetime)
          cloud:AddNewModifier(caster, self, "modifier_entropic_cloud_thinker", {
            lifetime = self:GetSpecialValueFor("cloud_lifetime"),
            drift_x = drift_direction.x,
            drift_y = drift_direction.y,
            drift_speed = RandomInt(100, 200),
            poison_damage = RandomInt(
              self:GetSpecialValueFor("poison_damage_min"),
              self:GetSpecialValueFor("poison_damage_max")
            ),
            cloud_radius = self:GetSpecialValueFor("cloud_radius"),
            poison_max_stacks = self:GetSpecialValueFor("poison_max_stacks"),
            poison_duration = self:GetSpecialValueFor("poison_duration"),
            poison_tick_rate = self:GetSpecialValueFor("poison_tick_rate")
          })
        end
      end
    end)
  end
  
  -- Play cloud spawn sound
  -- EmitSoundOnLocationWithCaster(location, "Hero_Venomancer.PlagueWard", caster)
end

----------------------------------------------------------------------
-- Entropic Contagion Main Modifier (Weapon Firing)
----------------------------------------------------------------------

modifier_item_chaos_poison_mix_ult_bow = class({})

function modifier_item_chaos_poison_mix_ult_bow:GetAbilityTextureName()
  local ability = self:GetAbility()
  if ability then
    return ability:GetAbilityName()
  end
  return ""
end

function modifier_item_chaos_poison_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_chaos_poison_mix_ult_bow:IsHidden()
  return true
end

function modifier_item_chaos_poison_mix_ult_bow:IsPurgable()
  return false
end

function modifier_item_chaos_poison_mix_ult_bow:OnCreated(kv)
  if IsServer() then
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self.ability:GetCaster()

    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.damage = self.ability:GetSpecialValueFor("dmg")
    self.range = self.ability:GetSpecialValueFor("range")
    self.speed = self.ability:GetSpecialValueFor("speed")

    -- Custom Entropic Contagion projectile particle
    self.particle = "particles/basic_projectile/entropic_contagion_projectile.vpcf"
    self.fire_sound = "Hero_Venomancer.Attack"

    self:StartIntervalThink(self.fire_rate)
  end
end

function modifier_item_chaos_poison_mix_ult_bow:OnIntervalThink()
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
    
    if TableCount(enemies) == 0 then
      return
    end

    local target = GetRandomTableElement(enemies)

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

function modifier_item_chaos_poison_mix_ult_bow:OnDestroy()
  if IsServer() then
    -- Cleanup if needed
  end
end

----------------------------------------------------------------------
-- Cloud Thinker Modifier (Cloud Movement AI and Lifetime)
----------------------------------------------------------------------

modifier_entropic_cloud_thinker = class({})

function modifier_entropic_cloud_thinker:IsHidden()
  return true
end

function modifier_entropic_cloud_thinker:IsPurgable()
  return false
end

function modifier_entropic_cloud_thinker:OnCreated(params)
  if IsServer() then
    self.cloud = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    
    -- Store cloud parameters
    self.lifetime = params.lifetime or 8.0
    self.elapsed_time = 0
    self.drift_direction = Vector(params.drift_x or 0, params.drift_y or 0, 0)
    self.drift_speed = params.drift_speed or 150
    self.cloud_radius = params.cloud_radius or 200
    self.poison_damage = params.poison_damage or 50
    self.poison_max_stacks = params.poison_max_stacks or 5
    self.poison_duration = params.poison_duration or 3.0
    self.poison_tick_rate = params.poison_tick_rate or 0.5
    
    -- Make the cloud fly and move
    self.cloud:SetBaseMoveSpeed(self.drift_speed)
    
    -- Create cloud visual particle (attached to unit)
    self.particle_cloud = ParticleManager:CreateParticle(
      "particles/chaos_poison_effect.vpcf",
      PATTACH_OVERHEAD_FOLLOW,
      self.cloud
    )
    ParticleManager:SetParticleControl(self.particle_cloud, 0, self.cloud:GetAbsOrigin())
    ParticleManager:SetParticleControl(self.particle_cloud, 1, Vector(self.cloud_radius, 0, 0))
    
    -- Create damaging aura modifier
    self.cloud:AddNewModifier(self.caster, self.ability, "modifier_entropic_cloud_aura", {
      damage = self.poison_damage,
      max_stacks = self.poison_max_stacks,
      tick_rate = self.poison_tick_rate,
      poison_duration = self.poison_duration,
      radius = self.cloud_radius
    })
    
    self:StartIntervalThink(0.03)
  end
end

function modifier_entropic_cloud_thinker:OnIntervalThink()
  if IsServer() then
    if not self.cloud or self.cloud:IsNull() then
      return
    end

    self.elapsed_time = self.elapsed_time + 0.03

    -- Check if cloud has exceeded lifetime
    if self.elapsed_time >= self.lifetime then
      self:DestroyCloud()
      return
    end
    
    -- Update cloud position directly (drift movement) - smooth small steps
    local current_pos = self.cloud:GetAbsOrigin()
    local new_pos = current_pos + (self.drift_direction * self.drift_speed * 0.03)
    self.cloud:SetAbsOrigin(new_pos)
    FindClearSpaceForUnit(self.cloud, new_pos, false)
  end
end

function modifier_entropic_cloud_thinker:DestroyCloud()
  if IsServer() then
    -- Clean up cloud particle
    if self.particle_cloud then
      ParticleManager:DestroyParticle(self.particle_cloud, false)
      ParticleManager:ReleaseParticleIndex(self.particle_cloud)
    end

    -- Destroy cloud unit
    if self.cloud and not self.cloud:IsNull() then
      self.cloud:ForceKill(false)
    end
  end
end

function modifier_entropic_cloud_thinker:OnDestroy()
  if IsServer() then
    self:DestroyCloud()
  end
end

function modifier_entropic_cloud_thinker:CheckState()
  return {
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true
  }
end

----------------------------------------------------------------------
-- Cloud Aura Modifier (Applies Poison to Nearby Enemies)
----------------------------------------------------------------------

modifier_entropic_cloud_aura = class({})

function modifier_entropic_cloud_aura:IsHidden()
  return true
end

function modifier_entropic_cloud_aura:IsPurgable()
  return false
end

function modifier_entropic_cloud_aura:OnCreated(params)
  if IsServer() then
    self.damage = params.damage or 50
    self.max_stacks = params.max_stacks or 5
    self.tick_rate = params.tick_rate or 0.5
    self.poison_duration = params.poison_duration or 3.0
    self.radius = params.radius or 200
  end
end

function modifier_entropic_cloud_aura:IsAura()
  return true
end

function modifier_entropic_cloud_aura:GetAuraRadius()
  return self.radius or 200
end

function modifier_entropic_cloud_aura:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_entropic_cloud_aura:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_entropic_cloud_aura:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_entropic_cloud_aura:GetModifierAura()
  return "modifier_entropic_cloud_aura_effect"
end

function modifier_entropic_cloud_aura:GetAuraEntityReject(target)
  return false
end

----------------------------------------------------------------------
-- Cloud Aura Effect (Applied to Units in Cloud)
----------------------------------------------------------------------

modifier_entropic_cloud_aura_effect = class({})

function modifier_entropic_cloud_aura_effect:IsHidden()
  return true
end

function modifier_entropic_cloud_aura_effect:IsPurgable()
  return false
end

function modifier_entropic_cloud_aura_effect:OnCreated()
  if IsServer() then
    local aura_modifier = self:GetCaster():FindModifierByName("modifier_entropic_cloud_aura")
    if aura_modifier then
      self.damage = aura_modifier.damage
      self.max_stacks = aura_modifier.max_stacks
      self.tick_rate = aura_modifier.tick_rate
      self.poison_duration = aura_modifier.poison_duration
    else
      self.damage = 50
      self.max_stacks = 5
      self.tick_rate = 0.5
      self.poison_duration = 3.0
    end
    
    -- Apply poison debuff to unit entering cloud
    self:ApplyPoison()
  end
end

function modifier_entropic_cloud_aura_effect:OnRefresh()
  if IsServer() then
    -- Refresh poison when still in cloud
    self:ApplyPoison()
  end
end

function modifier_entropic_cloud_aura_effect:ApplyPoison()
  if IsServer() then
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    
    if parent and not parent:IsNull() and parent:IsAlive() then
      local poison_modifier = parent:FindModifierByName("modifier_entropic_poison_debuff")
      if poison_modifier then
        -- Refresh existing poison (adds stack)
        poison_modifier:ForceRefresh()
      else
        -- Apply new poison
        parent:AddNewModifier(caster, ability, "modifier_entropic_poison_debuff", {
          duration = self.poison_duration,
          damage = self.damage,
          max_stacks = self.max_stacks,
          tick_rate = self.tick_rate,
          poison_duration = self.poison_duration
        })
      end
    end
  end
end

----------------------------------------------------------------------
-- Poison Debuff Modifier (Stacking Poison Damage)
----------------------------------------------------------------------

modifier_entropic_poison_debuff = class({})

function modifier_entropic_poison_debuff:IsDebuff()
  return true
end

function modifier_entropic_poison_debuff:IsHidden()
  return false
end

function modifier_entropic_poison_debuff:IsPurgable()
  return true
end

function modifier_entropic_poison_debuff:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_entropic_poison_debuff:OnCreated(params)
  if IsServer() then
    self.damage_per_tick = params.damage or 50
    self.max_stacks = params.max_stacks or 5
    self.tick_rate = params.tick_rate or 0.5
    self.poison_duration = params.poison_duration or 3.0
    
    -- Start with 1 stack
    self:SetStackCount(1)
    
    -- Create poison particle effect
    self.particle_poison = ParticleManager:CreateParticle(
      "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf",
      PATTACH_ABSORIGIN_FOLLOW,
      self:GetParent()
    )
    ParticleManager:SetParticleControl(self.particle_poison, 0, self:GetParent():GetAbsOrigin())
    
    self:StartIntervalThink(self.tick_rate)
  end
end

function modifier_entropic_poison_debuff:OnRefresh(params)
  if IsServer() then
    -- Increment stacks up to max
    local current_stacks = self:GetStackCount()
    local new_stacks = math.min(current_stacks + 1, self.max_stacks)
    self:SetStackCount(new_stacks)
    
    -- Refresh duration
    self:SetDuration(self.poison_duration, true)
  end
end

function modifier_entropic_poison_debuff:OnIntervalThink()
  if IsServer() then
    local parent = self:GetParent()
    if not parent or parent:IsNull() or not parent:IsAlive() then
      self:Destroy()
      return
    end
    
    -- Deal damage based on stack count
    local total_damage = self.damage_per_tick * self:GetStackCount()
    
    ApplyDamage({
      victim = parent,
      attacker = self:GetCaster(),
      damage = total_damage,
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self:GetAbility()
    })
    
    -- Visual feedback on damage tick
    local particle_tick = ParticleManager:CreateParticle(
      "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf",
      PATTACH_ABSORIGIN,
      parent
    )
    ParticleManager:ReleaseParticleIndex(particle_tick)
  end
end

function modifier_entropic_poison_debuff:OnDestroy()
  if IsServer() then
    -- Clean up poison particle
    if self.particle_poison then
      ParticleManager:DestroyParticle(self.particle_poison, false)
      ParticleManager:ReleaseParticleIndex(self.particle_poison)
    end
  end
end

function modifier_entropic_poison_debuff:GetEffectName()
  return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf"
end

function modifier_entropic_poison_debuff:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_entropic_poison_debuff:GetTexture()
  return "venomancer_poison_nova"
end
