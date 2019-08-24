--------------------------------
---    WAVE FORM     ---
--------------------------------
speed_boat_wave = speed_boat_wave or class({})
LinkLuaModifier("modifier_wave_form", "heroes/speed_boat_wave.lua", LUA_MODIFIER_MOTION_NONE)

function speed_boat_wave:OnSpellStart()
  if IsServer() then
    -- Prevent some stupid shit that happens when you try to zip while already zipping
    if self:GetCaster():FindModifierByName("modifier_wave_form") then
      return
    end

    -- Ability properties
    local caster = self:GetCaster()
    local target_loc = self:GetCursorPosition()
    local caster_loc = caster:GetAbsOrigin()
    -- Ability parameters
    local speed       = self:GetSpecialValueFor("ball_speed")
    local damage_radius   =   self:GetSpecialValueFor("damage_radius")

    local damage      =   self:GetSpecialValueFor("damage_base")

    -- Motion control properties
    self.traveled   = 0
    self.target_loc = target_loc
    self.distance   = (target_loc - caster_loc):Length2D()
    self.direction  = (target_loc - caster_loc):Normalized()

    -- Play the cast sound
    caster:EmitSound("Hero_Morphling.Waveform")

    -- Fire the ball of death!
    local projectile =
    {
      Ability       = self,
      EffectName      = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf",
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
      bProvidesVision   = false,
      iVisionRadius     = 0,
      iVisionTeamNumber   = caster:GetTeamNumber(),
      ExtraData     = {damage = damage,
        speed = speed * FrameTime()
      }
    }

    self.projectileID = ProjectileManager:CreateLinearProjectile(projectile)

    -- Add Motion-Controller Modifier
    caster:AddNewModifier(caster, self, "modifier_wave_form", {})
--    StartAnimation(self:GetCaster(), {duration=10.0, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=1.0})
  end
end

function speed_boat_wave:OnProjectileThink_ExtraData(location, ExtraData)
  -- Move the caster as long as he has not reached the distance he wants to go to, and he still has enough mana
  local caster = self:GetCaster()
  local targetDist = caster:GetAbsOrigin()-self.target_loc

  if caster:IsAlive() and (targetDist:Length()>100 or targetDist:Length()>1200) then
   

    -- Set the caster slightly forwards
    caster:SetAbsOrigin(Vector(location.x, location.y, GetGroundPosition(location, caster).z))
    caster:Purge(false, true, true, true, true)

  else
    -- Once the caster can no longer travel, remove this projectile
    -- Find a clear space to stand on
    Timers:CreateTimer(FrameTime(), function()
      caster:SetAbsOrigin(Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, GetGroundPosition(caster:GetAbsOrigin(), caster).z))   
      FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
      ResolveNPCPositions(caster:GetAbsOrigin(), 64)
    end)

    -- Get rid of the Ball
    local modifier = caster:FindModifierByName("modifier_wave_form")
    if modifier then modifier:Destroy() end
    ProjectileManager:DestroyLinearProjectile(self.projectileID)
  end
end

function speed_boat_wave:OnProjectileHit_ExtraData(target, location, ExtraData)
    if IsServer() then
      --print("inProjHit")
    if target then
      local caster = self:GetCaster()
      local damage_flags = DOTA_DAMAGE_FLAG_NONE
      local damageTable = {
        victim = target,
        damage = ExtraData.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        attacker = caster,
        ability = self.ability
      }
    
      local damageDealt = ApplyDamage(damageTable)
     
    end
  end
end

--- BALL LIGHTNING MODIFIER
modifier_wave_form = modifier_wave_form or class({})

-- Modifier properties
function modifier_wave_form:IsDebuff()  return false end
function modifier_wave_form:IsHidden()  return false end
function modifier_wave_form:IsPurgable() return false end



function modifier_wave_form:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    -- MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    -- MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
    -- MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  }
  return funcs
end
