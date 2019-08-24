--------------------------------
---    BALL LIGHTNING      ---
--------------------------------
ball_lightning_lua = ball_lightning_lua or class({})
LinkLuaModifier("modifier_ball_lightning", "heroes/ball_lightning.lua", LUA_MODIFIER_MOTION_NONE)

function ball_lightning_lua:OnSpellStart()
  if IsServer() then
    -- Prevent some stupid shit that happens when you try to zip while already zipping
    if self:GetCaster():FindModifierByName("modifier_ball_lightning") then
      return
    end

    -- Ability properties
    local caster = self:GetCaster()
    local target_loc = self:GetCursorPosition()
    local caster_loc = caster:GetAbsOrigin()
    -- Ability parameters
    local speed       = self:GetSpecialValueFor("ball_speed")
    local vision      =   self:GetSpecialValueFor("ball_vision_radius")
    local tree_radius     =   100
    local max_distance = self:GetSpecialValueFor("max_distance")

    -- Motion control properties
    self.traveled   = 0
    self.distance   = math.min((target_loc - caster_loc):Length2D(),  max_distance)
    self.direction  = (target_loc - caster_loc):Normalized()

    -- Play the cast sound
    caster:EmitSound("Hero_StormSpirit.BallLightning")
    caster:EmitSound("Hero_StormSpirit.BallLightning.Loop")

    -- Fire the ball of death!
    local projectile =
    {
      Ability       = self,
      EffectName      = "particles/basic_projectile/no_particle_particle.vpcf",
      vSpawnOrigin    = caster_loc,
      fDistance     = self.distance,
      fStartRadius    = damage_radius,
      fEndRadius      = damage_radius,
      Source        = caster,
      bHasFrontalCone   = false,
      bReplaceExisting  = false,
      iUnitTargetTeam   = self:GetAbilityTargetTeam(),
      iUnitTargetFlags  = self:GetAbilityTargetFlags(),
      iUnitTargetType   = self:GetAbilityTargetType(),
      bDeleteOnHit    = false,
      vVelocity       = self.direction * speed * Vector(1, 1, 0),
      bProvidesVision   = true,
      iVisionRadius     = vision,
      iVisionTeamNumber   = caster:GetTeamNumber(),
      ExtraData     = {damage = damage,
        damagePerUnit = damagePerUnit,
        tree_radius = tree_radius,
        speed = speed * FrameTime()
      }
    }

    self.projectileID = ProjectileManager:CreateLinearProjectile(projectile)

    -- Add Motion-Controller Modifier
    caster:AddNewModifier(caster, self, "modifier_ball_lightning", {})
--    StartAnimation(self:GetCaster(), {duration=10.0, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=1.0})
  end
end

function ball_lightning_lua:OnProjectileThink_ExtraData(location, ExtraData)
  -- Move the caster as long as he has not reached the distance he wants to go to, and he still has enough mana
  local caster = self:GetCaster()

  if (self.traveled + ExtraData.speed < self.distance) and caster:IsAlive() and caster:GetMana() > 0 then
   
    -- Destroy the trees in the way
    GridNav:DestroyTreesAroundPoint(location, ExtraData.tree_radius, false)

    -- Set the caster slightly forwards
    caster:SetAbsOrigin(Vector(location.x, location.y, GetGroundPosition(location, caster).z))
    caster:Purge(false, true, true, true, true)

    -- Calculate the new travel distance
    self.traveled = self.traveled + ExtraData.speed
    caster:SetMana(caster:GetMana()-5)
    self.units_traveled_in_last_tick = ExtraData.speed
  else
    -- Once the caster can no longer travel, remove this projectile
    -- Find a clear space to stand on
    Timers:CreateTimer(FrameTime(), function()
      caster:SetAbsOrigin(Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, GetGroundPosition(caster:GetAbsOrigin(), caster).z))   
      FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
      ResolveNPCPositions(caster:GetAbsOrigin(), 64)
    end)

    caster:StopSound("Hero_StormSpirit.BallLightning.Loop")

    -- Get rid of the Ball
    local modifier = caster:FindModifierByName("modifier_ball_lightning")
    if modifier then modifier:Destroy() end
    ProjectileManager:DestroyLinearProjectile(self.projectileID)
  end
end

function ball_lightning_lua:OnProjectileHit_ExtraData(target, location, ExtraData)
    if IsServer() then
    if target then
      local caster = self:GetCaster()
      local damage = ExtraData.damage + ExtraData.damagePerUnit * math.floor(self.traveled * 0.01)
      local damage_flags = DOTA_DAMAGE_FLAG_NONE

     
    end
  end
end

--- BALL LIGHTNING MODIFIER
modifier_ball_lightning = modifier_ball_lightning or class({})

-- Modifier properties
function modifier_ball_lightning:IsDebuff()  return false end
function modifier_ball_lightning:IsHidden()  return false end
function modifier_ball_lightning:IsPurgable() return false end

function modifier_ball_lightning:OnCreated()
  if not IsServer() then return end

  local caster = self:GetCaster()
  local particlePath = "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf"

  self.particle = ParticleManager:CreateParticle(particlePath, PATTACH_ABSORIGIN_FOLLOW, caster)
  ParticleManager:SetParticleControlEnt(self.particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
end

function modifier_ball_lightning:OnDestroy()
  if not IsServer() then return end

  ParticleManager:DestroyParticle(self.particle, true)
end


-- function modifier_ball_lightning:GetEffectName()
--   return "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf"
-- end

function modifier_ball_lightning:CheckState()
  local state = {
   [MODIFIER_STATE_MAGIC_IMMUNE] = true
  }
  return state
end

-- function modifier_ball_lightning:GetEffectAttachType()
--   -- Yep, this is a thing.
--   return PATTACH_ROOTBONE_FOLLOW
-- end

function modifier_ball_lightning:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  }
  return funcs
end

-- function modifier_ball_lightning:GetOverrideAnimation()
--   return ACT_DOTA_OVERRIDE_ABILITY_4
-- end

function modifier_ball_lightning:GetAbsoluteNoDamagePhysical()
  return 1
end

function modifier_ball_lightning:GetAbsoluteNoDamageMagical()
  return 1
end

function modifier_ball_lightning:GetAbsoluteNoDamagePure()
  return 1
end