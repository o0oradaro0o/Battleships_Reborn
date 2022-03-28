tractor_beam = tractor_beam or class({})

LinkLuaModifier("modifier_tractor_beam", "heroes/ufo_ship/tractor_beam", LUA_MODIFIER_MOTION_NONE)

function tractor_beam:OnSpellStart()

  if not IsServer() then return end
  local caster = self:GetCaster()
  local ability = self

  local duration = ability:GetSpecialValueFor("duration")


  local vPos = nil
  if self:GetCursorTarget() then
    vPos = self:GetCursorTarget():GetOrigin()
  else
    vPos = self:GetCursorPosition()
  end
  self.vPos = vPos
  local vDirection = vPos - caster:GetAbsOrigin()
  vDirection.z = 0.0
  vDirection = vDirection:Normalized()
  caster:AddNewModifier(caster, ability, "modifier_tractor_beam", {duration = duration})
  local particle = "particles/ufo_pull.vpcf"
  local sound = "Hero_DragonKnight.BreathFire"

  local particleName = "particles/ufo_pull.vpcf"
  self.particle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
  ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
  ParticleManager:SetParticleControl(self.particle, 1, vPos)

end


modifier_tractor_beam = class({})

function modifier_tractor_beam:IsHidden() return false end
function modifier_tractor_beam:IsPurgable() return false end
function modifier_tractor_beam:IsDebuff() return false end

function modifier_tractor_beam:OnCreated(params)
  if not IsServer() then return end
  self.caster =   self:GetCaster()
  self:StartIntervalThink(0.2)
	self:OnIntervalThink()
end

localCurInDegrees=0;

function modifier_tractor_beam:OnIntervalThink()
  local caster = self.caster
  local casterPosition = caster:GetAbsOrigin()

  fire(self.vPos, self)
end
function modifier_tractor_beam:OnDestroy(params)
  if not IsServer() then return end
  print( self.particle .. " was the particle index")
  ParticleManager:DestroyParticle(self.particle,true)

end

function fire(vPos, selfptr)
  local casterPosition = selfptr.caster:GetAbsOrigin()
  local particle = "particles/deathbeam.vpcf"
  local sound = "Hero_DragonKnight.BreathFire"

  local start_radius = selfptr:GetAbility():GetSpecialValueFor( "start_radius" )
  local end_radius = selfptr:GetAbility():GetSpecialValueFor( "end_radius" )
  local speed = selfptr:GetAbility():GetSpecialValueFor( "speed" )
  local range = selfptr:GetAbility():GetSpecialValueFor("range")

  EmitSoundOn(sound, caster)

  local vDirection = vPos - casterPosition
  vDirection.z = 0.0
  vDirection = vDirection:Normalized()

  local projectile = {
    Ability = selfptr:GetAbility(),
    EffectName = particle,
    vSpawnOrigin = selfptr.caster:GetAbsOrigin(),
    fDistance = range,
    fStartRadius = start_radius,
    fEndRadius = end_radius,
    Source = selfptr.caster,
    bHasFrontalCone = false,
    bReplaceExisting = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    bDeleteOnHit = false,
    vVelocity = vDirection * speed,
    bProvidesVision = false,
  }

  ProjectileManager:CreateLinearProjectile(projectile)
end

function tractor_beam:OnProjectileHit( hTarget, vLocation )
  if IsServer() then
    local damage = self:GetSpecialValueFor( "damage" )

    if not hTarget then
      return nil
    end
    
    

    ApplyDamage( damage )
  end
end