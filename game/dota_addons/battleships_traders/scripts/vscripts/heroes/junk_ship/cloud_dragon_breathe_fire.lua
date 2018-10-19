cloud_dragon_breathe_fire_lua = cloud_dragon_breathe_fire_lua or class({})

function cloud_dragon_breathe_fire_lua:OnSpellStart()
  local caster = self:GetCaster()
  local casterPosition = caster:GetAbsOrigin()
  local ability = self
  local particle = "particles/basic_projectile/custom_fire_ball.vpcf"
  local sound = "Hero_DragonKnight.BreathFire"

  local start_radius = ability:GetSpecialValueFor( "start_radius" )
  local end_radius = ability:GetSpecialValueFor( "end_radius" )
  local speed = ability:GetSpecialValueFor( "speed" )
  local range = ability:GetSpecialValueFor("range")

  EmitSoundOn(sound, caster)

  local vPos = nil
  if self:GetCursorTarget() then
    vPos = self:GetCursorTarget():GetOrigin()
  else
    vPos = self:GetCursorPosition()
  end

  local vDirection = vPos - casterPosition
  vDirection.z = 0.0
  vDirection = vDirection:Normalized()

  local projectile = {
    Ability = ability,
    EffectName = particle,
    vSpawnOrigin = caster:GetAbsOrigin(),
    fDistance = range*2,
    fStartRadius = start_radius,
    fEndRadius = end_radius,
    Source = caster,
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

function cloud_dragon_breathe_fire_lua:OnProjectileHit( hTarget, vLocation )
  if IsServer() then
    local damage = self:GetSpecialValueFor( "damage" )

    if not hTarget then
      return nil
    end
    
    local damage = {
      victim = hTarget,
      attacker = self:GetCaster():GetOwner(),
      damage = damage,
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self
    }

    ApplyDamage( damage )
  end
end