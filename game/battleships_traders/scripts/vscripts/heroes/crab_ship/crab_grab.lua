crab_grab = class({})

LinkLuaModifier("modifier_crab_grab_caster", "heroes/crab_ship/crab_grab", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crab_grab_target", "heroes/crab_ship/crab_grab", LUA_MODIFIER_MOTION_NONE)

function crab_grab:OnSpellStart()
  if not IsServer() then return end
  local caster = self:GetCaster()
  local ability = self
  local target = self:GetCursorTarget()

  local duration = ability:GetSpecialValueFor("duration")

  caster:AddNewModifier(caster, ability, "modifier_crab_grab_caster", {duration = duration, target = target:GetEntityIndex()})
  target:AddNewModifier(caster, ability, "modifier_crab_grab_target", {duration = duration})
end

modifier_crab_grab_caster = class({})

function modifier_crab_grab_caster:IsHidden() return false end
function modifier_crab_grab_caster:IsPurgable() return false end
function modifier_crab_grab_caster:IsDebuff() return false end

function modifier_crab_grab_caster:OnCreated(params)
  if not IsServer() then return end

  self.target = EntIndexToHScript(params.target)

  self:StartIntervalThink(1/30)
end

function modifier_crab_grab_caster:OnIntervalThink()
  if not IsServer() then return end
  
  local targetPosition = self.target:GetAbsOrigin()
  local targetForwardVector = self.target:GetForwardVector()

  local position = targetPosition - targetForwardVector * 50

  if not self.target:HasModifier("modifier_crab_grab_caster") then
    self:GetParent():SetAbsOrigin(position)
    self:GetParent():SetForwardVector(targetForwardVector)
  end
end

function modifier_crab_grab_caster:OnDestroy()
  if not IsServer() then return end
  local targetModifier = self.target:FindModifierByName("modifier_crab_grab_target")
  if targetModifier then
    targetModifier:Destroy()
  end
end

function modifier_crab_grab_caster:CheckState()
  return {
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  }
end

modifier_crab_grab_target = class({})

function modifier_crab_grab_target:IsHidden() return false end
function modifier_crab_grab_target:IsPurgable() return false end
function modifier_crab_grab_target:IsDebuff() return true end

function modifier_crab_grab_target:OnCreated()
  self.tick_rate = self:GetAbility():GetSpecialValueFor("tick_rate")
  self.damage_per_tick = self:GetAbility():GetSpecialValueFor("damage_per_tick")
  self.slow = self:GetAbility():GetSpecialValueFor("slow")

  if IsServer() then
    self:StartIntervalThink(self.tick_rate)
  end
end

function modifier_crab_grab_target:OnRefresh()
  self.tick_rate = self:GetAbility():GetSpecialValueFor("tick_rate")
  self.damage_per_tick = self:GetAbility():GetSpecialValueFor("damage_per_tick")
  self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_crab_grab_target:OnIntervalThink()
  local caster = self:GetCaster()
  local target = self:GetParent()
  local ability = self:GetAbility()

  local damage = self.damage_per_tick
  local damage_type = ability:GetAbilityDamageType()
  local damage_flags = ability:GetAbilityTargetFlags()

  caster:EmitSound("Hero_NyxAssassin.attack")

  ApplyDamage({
    victim = target,
    attacker = caster,
    damage = damage,
    damage_type = damage_type,
    damage_flags = damage_flags,
    ability = ability,
  })
end

function modifier_crab_grab_target:OnDestroy()
  if IsServer() then
    local caster = self:GetCaster()
    local casterModifier = caster:FindModifierByName("modifier_crab_grab_caster")
    if casterModifier then
      casterModifier:Destroy()
    end
  end
end

function modifier_crab_grab_target:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  }
end

function modifier_crab_grab_target:GetModifierMoveSpeedBonus_Percentage()
  return self.slow
end