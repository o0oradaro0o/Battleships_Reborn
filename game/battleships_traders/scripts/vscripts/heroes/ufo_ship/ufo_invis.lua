ufo_invis = class({})
LinkLuaModifier( "modifier_ufo_invis", "heroes/ufo_ship/ufo_invis.lua", LUA_MODIFIER_MOTION_NONE )

function ufo_invis:GetIntrinsicModifierName() return "modifier_ufo_invis" end

modifier_ufo_invis = class({})
function modifier_ufo_invis:IsHidden() return not self:GetParent():HasModifier("modifier_invisible") end
function modifier_ufo_invis:IsDebuff() return false end
function modifier_ufo_invis:IsPurgable() return false end

function modifier_ufo_invis:OnCreated()
	if not IsServer() then return end

	self.canFly = false
	self:StartIntervalThink(0.1)
	self:OnIntervalThink()
end

-- function modifier_ufo_invis:CheckState()
-- 	return { [MODIFIER_STATE_FLYING] = self.canfly }
-- end

function modifier_ufo_invis:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local cooldown = ability:GetCooldown(ability:GetLevel())
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self:GetAbility():GetSpecialValueFor( "radius" ),	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	if #enemies > 0 then
		if caster:HasModifier("modifier_invisible") then
			self.canFly = false
			caster:RemoveModifierByName("modifier_invisible")
		end
		if ability:IsActivated() then
			ability:SetActivated(false)
			ability:EndCooldown()
		end
	else
		if not ability:IsActivated() then
			ability:SetActivated(true)
			ability:StartCooldown(cooldown)
		end
	end

	if ability:IsCooldownReady() and ability:IsActivated() and not caster:HasModifier("modifier_invisible") then
		caster:AddNewModifier(self:GetCaster(), self, "modifier_invisible", {})
		self.canfly = true
	end
end

function modifier_ufo_invis:GetEffectName()
	return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf"
end