speed_shift = class({})
LinkLuaModifier("modifier_speedshift", "heroes/fail_boat/speedshift.lua", LUA_MODIFIER_MOTION_NONE)

function speed_shift:GetIntrinsicModifierName()
    return "modifier_speedshift"
  end
------------------------------------------------------------

modifier_speedshift = class({})


function modifier_speedshift:OnUpgrade()
	local caster = self:GetCaster()
	caster:AddNewModifier(self:GetCaster(), self, "modifier_speedshift", {})
end

function modifier_speedshift:OnOwnerSpawned()
	local caster = self:GetCaster()
	caster:AddNewModifier(self:GetCaster(), self, "modifier_speedshift", {})
end


function modifier_speedshift:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  }
  return funcs
end


function modifier_speedshift:OnCreated()
    self:StartIntervalThink(0.1)
    self.currentms=0

end

function modifier_speedshift:OnIntervalThink()
    local targetms = self:GetParent():GetModifierStackCount( 'modifier_speedshift', self:GetParent() )-self:GetAbility():GetSpecialValueFor("ms_range")*0.5 
    if self.currentms<targetms then
        self.currentms = self.currentms+1
    elseif self.currentms>targetms then
        self.currentms = self.currentms-1
    else
            if IsServer() then
                local newtargetms = RandomInt( 0, self:GetAbility():GetSpecialValueFor("ms_range")*1.5 )
                self:GetParent():SetModifierStackCount('modifier_speedshift', self:GetParent(),newtargetms )
                print('targetms  ' .. newtargetms)
            end
    end
end

function modifier_speedshift:GetModifierMoveSpeedBonus_Constant( params )
	return self.currentms
end