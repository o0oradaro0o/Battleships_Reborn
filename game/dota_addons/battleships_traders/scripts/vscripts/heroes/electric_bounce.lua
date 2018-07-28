electric_bounce_lua = class({})
LinkLuaModifier("modifier_electric_bounce", "heroes/electric_bounce.lua", LUA_MODIFIER_MOTION_NONE)

function electric_bounce_lua:OnSpellStart()
  local caster = self:GetCaster()
  local ability = self

  local sound = "DOTA_Item.Mjollnir.Activate"

  local duration = ability:GetSpecialValueFor("duration")

  caster:EmitSound("DOTA_Item.Mjollnir.Activate")
  caster:AddNewModifier(caster, ability, "modifier_electric_bounce", {duration = duration})
end

------------------------------------------------------------

modifier_electric_bounce = class({})

function modifier_electric_bounce:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL}
	return decFuncs
end

function modifier_electric_bounce:OnCreated()
  local caster = self:GetParent()
  local ability = self:GetAbility()
  local particle = "particles/basic_projectile/mjollnir_shield_.vpcf"

  if IsServer() then
    self.index = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
    self:AddParticle( self.index, false, false, -1, false, true )
  end
end

function modifier_electric_bounce:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE,
  }
  return funcs
end

function modifier_electric_bounce:OnTakeDamage(keys)
  local unit = keys.unit
  local caster = self:GetParent()

  if unit == caster then
   
    if keys.inflictor then
      local ability = keys.inflictor

      local abilityKv = ability:GetAbilityKeyValues()
      local fire_rate = abilityKv.AbilitySpecial.fire_rate
      if string.match(ability:GetAbilityName(), "_bow") then

        local damage = keys.damage
        local sound = "Hero_WitchDoctor.Paralyzing_Cask_Bounce"
    
        local radarSteamId = 35695824
        local vicFrankSteamId = 70585706
        local playerSteamId = caster:GetPlayerOwnerID()

    
        EmitSoundOn(sound, caster)
    


        local modifierName = ability:GetAbilityName() .. "_shooting"

        if ability:GetAbilityName() == "item_hull_sail_one_combo_bow" then
            modifierName = "modifier_item_hull_one"
        end

        if ability:GetCaster() ~= nil and ability:GetCaster():IsAlive() and Target~=caster then
            local info = {
                Ability = ability,
                Source = caster,
                Target = ability:GetCaster(),
                vSourceLoc = caster:GetAbsOrigin(),
                EffectName = tostring(abilityKv.Modifiers[modifierName].OnIntervalThink.TrackingProjectile.EffectName),
                bProvidesVision = false,
                iVisionRadius = 1000,
                iVisionTeamNumber = caster:GetTeamNumber(),
                bDeleteOnHit = false,
                iMoveSpeed = abilityKv.Modifiers[modifierName].OnIntervalThink.TrackingProjectile.MoveSpeed,
                vVelocity = 700
            }
            projectile = ProjectileManager:CreateTrackingProjectile(info)
        end
    end
end
  end
end