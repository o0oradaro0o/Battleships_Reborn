crab_walk = class({})

LinkLuaModifier("modifier_crab_walk", "heroes/crab_ship/crab_walk", LUA_MODIFIER_MOTION_NONE)

function crab_walk:OnSpellStart()
  if not IsServer() then return end
  local caster = self:GetCaster()
  local ability = self

  local duration = ability:GetSpecialValueFor("duration")

  caster:EmitSound("DOTA_Item.SpiderLegs.Cast")

  caster:AddNewModifier(caster, ability, "modifier_crab_walk", {duration = duration})
end

modifier_crab_walk = class({})

function modifier_crab_walk:IsHidden() return false end
function modifier_crab_walk:IsPurgable() return false end
function modifier_crab_walk:IsDebuff() return false end

function modifier_crab_walk:CheckState()
  return {
    [MODIFIER_STATE_FLYING] = true,
  }
end

function modifier_crab_walk:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  }
end

function modifier_crab_walk:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility():GetSpecialValueFor("move_speed_pct")
end

function modifier_crab_walk:GetEffectName()
  return "particles/items5_fx/spider_legs_buff.vpcf"
end