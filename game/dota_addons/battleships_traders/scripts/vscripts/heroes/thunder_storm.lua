LinkLuaModifier("modifier_thunder_storm", "heroes/thunder_storm.lua", LUA_MODIFIER_MOTION_NONE)

thunder_storm = class({})
modifier_thunder_storm = class({})

function modifier_thunder_storm:OnCreated()


    if IsServer() then
        self:StartIntervalThink(.2)
    end
end

function modifier_thunder_storm:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_aoe_rupture_lua")
    end
end
function modifier_thunder_storm:GetEffectName()
	return "particles/units/heroes/hero_razor/razor_rain_storm.vpcf"
  end

 function modifier_thunder_storm:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
  end

function  modifier_thunder_storm:OnIntervalThink()
	
	
	local caster =  self:GetAbility():GetCaster()
	if RandomInt(0, 100)>caster:GetMana()/20+10 then
		return
	end
	local sound = "Hero_Zuus.GodsWrath"
	local ability =  self:GetAbility()
	local lightning_radius = ability:GetSpecialValueFor("lightning_radius")
	local lightning_bolt_search_radius = ability:GetSpecialValueFor("lightning_bolt_search_radius")
	local duration = ability:GetSpecialValueFor("duration")
	local lightning_tick_interval_min =  ability:GetSpecialValueFor("lightning_tick_interval_min")
	local lightning_tick_interval_max = ability:GetSpecialValueFor("lightning_tick_interval_max")

		-- Find an initial strike point
		local targetPoint = caster:GetAbsOrigin() + RandomVector( RandomFloat( 100, lightning_radius ) )
		-- If there's a nearby unit, strike it instead
		local enemies = FindUnitsInRadius(
			caster:GetTeam(),
      targetPoint,
      nil,
      lightning_bolt_search_radius,
      DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NO_INVIS,
      FIND_ANY_ORDER,
      false
    )

		local targetUnit
    for _,enemy in pairs(enemies) do
    	targetUnit = enemy
    	targetPoint = targetUnit:GetAbsOrigin()
    	break
    end

    thunder_storm:CastLightningBolt(ability, targetUnit, targetPoint)

	return RandomFloat(lightning_tick_interval_min, lightning_tick_interval_max)
end



function thunder_storm:OnUpgrade()
	local caster = self:GetCaster()
	caster:AddNewModifier(self:GetCaster(), self, "modifier_thunder_storm", {})
end

function thunder_storm:OnOwnerSpawned()
	local caster = self:GetCaster()
	caster:AddNewModifier(self:GetCaster(), self, "modifier_thunder_storm", {})
end



function thunder_storm:CastLightningBolt(ability, targetUnit, targetPoint)
	local caster = ability:GetCaster()
  local sound = "Hero_Zuus.LightningBolt"
  local particle = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
  local particleHeight = 2000

  local sight_radius = 900--ability:GetSpecialValueFor("sight_radius")
  local sight_duration = ability:GetSpecialValueFor("sight_duration")
  local damage = ability:GetSpecialValueFor("damage")

  EmitSoundOn(sound, caster)
	
	local particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, Vector(targetPoint.x,targetPoint.y,particleHeight))
	ParticleManager:SetParticleControl(particle, 1, targetPoint)
	ParticleManager:SetParticleControl(particle, 2, targetPoint)

	--create a dummy at the targeted location that has truesight
	local unit = CreateUnitByName("dummy_vision10", targetPoint, false, caster, caster, caster:GetTeam())
	unit:SetDayTimeVisionRange(sight_radius)
	unit:SetNightTimeVisionRange(sight_radius)
	unit:AddNoDraw()

	Timers:CreateTimer(sight_duration, function()
		unit:ForceKill(false)
	end)

	if targetUnit then
		local damageTable = {
			victim = targetUnit,
      attacker = caster, 
      damage = damage,
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = ability
	}
	if targetUnit:IsRealHero() then
		caster:SetMana(caster:GetMana()+50)
	else
		caster:SetMana(caster:GetMana()+15)
	end
    ApplyDamage(damageTable)
	end
end