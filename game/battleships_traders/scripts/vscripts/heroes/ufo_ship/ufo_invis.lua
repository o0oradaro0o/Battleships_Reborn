ufo_invis = class({})
LinkLuaModifier( "modifier_ufo_invis", "heroes/ufo_ship/ufo_invis.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function ufo_invis:GetIntrinsicModifierName()
	return "modifier_ufo_invis"
end


modifier_ufo_invis = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ufo_invis:IsHidden()
	-- dynamic
	-- if IsServer() then
		return not (self.invisOn and (not self:GetParent():PassivesDisabled()))
	-- end
end

function modifier_ufo_invis:IsDebuff()
	return false
end

function modifier_ufo_invis:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ufo_invis:OnCreated( kv )
	-- references
    self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    self.cooldown  = self:GetAbility():GetSpecialValueFor( "cooldown" )
	self.interval = 0.1

	self.invisOn = true

	-- Start interval
	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()
end

function modifier_ufo_invis:OnRefresh( kv )
	-- references
    self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    self.cooldown  = self:GetAbility():GetSpecialValueFor( "cooldown" )
end

function modifier_ufo_invis:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ufo_invis:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ufo_invis:OnIntervalThink()
	if IsServer() then
		-- Hero search flag based on detecting or undetecting
		local flag = 0
		if self.invisOn then
			flag = DOTA_UNIT_TARGET_FLAG_NO_INVIS
		else
			flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
		end

		-- Find Enemy Heroes in Radius
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			flag,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- Flip if detected
        if (self.invisOn) == (#enemies>0) then
            self:GetCaster():RemoveModifierByName("modifier_invisible")
            self:GetAbility():StartCooldown(self.cooldown)
        elseif not self:GetCaster():HasModifier("modifier_invisible") and self:GetAbility():GetCooldownTimeRemaining()==0.5 then
            local particleName = "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf_hex.vpcf"
            local particle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
            ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 2, Vector(explosion_radius, 1, 1))
            ParticleManager:ReleaseParticleIndex(particle)
        elseif not self:GetCaster():HasModifier("modifier_invisible") and self:GetAbility():GetCooldownTimeRemaining()==0 then
            self:GetCaster():AddNewModifier(self:GetCaster(),nil, "modifier_invisible", {})
        end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ufo_invis:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf"
end

function modifier_ufo_invis:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

