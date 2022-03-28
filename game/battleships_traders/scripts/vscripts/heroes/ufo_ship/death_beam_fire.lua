death_beam_fire_lua = death_beam_fire_lua or class({})

LinkLuaModifier("modifier_death_beam", "heroes/ufo_ship/death_beam_fire", LUA_MODIFIER_MOTION_NONE)

function death_beam_fire_lua:OnSpellStart()

  if not IsServer() then return end
  local caster = self:GetCaster()
  local ability = self

  local duration = ability:GetSpecialValueFor("duration")

  caster:AddNewModifier(caster, ability, "modifier_death_beam", {duration = duration})

end


modifier_death_beam = class({})

function modifier_death_beam:IsHidden() return false end
function modifier_death_beam:IsPurgable() return false end
function modifier_death_beam:IsDebuff() return false end

function modifier_death_beam:OnCreated(params)
  if not IsServer() then return end
  self.caster =   self:GetCaster()
  self:StartIntervalThink(0.1)
	self:OnIntervalThink()
end

localCurInDegrees=0;

function modifier_death_beam:OnIntervalThink()
  local caster = self.caster
  local casterPosition = caster:GetAbsOrigin()
  localCurInDegrees=localCurInDegrees+3;
  local localCurRads = localCurInDegrees*(math.pi/180)
  local vpos = casterPosition+Vector(0*math.cos( localCurRads )-math.sin( localCurRads ), 0*math.sin( localCurRads )+math.cos(  localCurRads ), 0)
   localCurRads = (localCurInDegrees+120)*(math.pi/180)
  local vpos2 = casterPosition+Vector(0*math.cos( localCurRads )-math.sin( localCurRads ), 0*math.sin( localCurRads )+math.cos(  localCurRads ), 0)
   localCurRads = (localCurInDegrees+240)*(math.pi/180)
  local vpos3 = casterPosition+Vector(0*math.cos( localCurRads )-math.sin( localCurRads ), 0*math.sin( localCurRads )+math.cos(  localCurRads ), 0)
  fire(vpos, self)
  fire(vpos2, self)
  fire(vpos3, self)
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

function death_beam_fire_lua:OnProjectileHit( hTarget, vLocation )
  if IsServer() then
    local damage = self:GetSpecialValueFor( "damage" )

    if not hTarget then
      return nil
    end
    
    local damage = {
      victim = hTarget,
      attacker = self:GetCaster(),
      damage = damage,
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self
    }

    ApplyDamage( damage )
  end
end