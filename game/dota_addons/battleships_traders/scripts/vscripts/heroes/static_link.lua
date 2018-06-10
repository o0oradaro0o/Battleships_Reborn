static_link_lua = static_link_lua or class({})
LinkLuaModifier("modifier_static_link_drain", "heroes/static_link.lua", LUA_MODIFIER_MOTION_NONE)

function static_link_lua:OnSpellStart()
  local ability = self
  local caster = self:GetCaster()
  local target = self:GetCursorTarget()

  local soundStart = "Ability.static.start"
  
  local drain_length = self:GetSpecialValueFor("drain_length")  

  caster:EmitSound(sound)

  target:AddNewModifier(caster, ability, "modifier_static_link_drain", {duration = drain_length})
end

modifier_static_link_drain = modifier_static_link_drain or class({})

function modifier_static_link_drain:IsDebuff()  return true end
function modifier_static_link_drain:IsHidden()  return false end
function modifier_static_link_drain:IsPurgable() return false end
function modifier_static_link_drain:GetModifierProvidesFOWVision() return true end

function modifier_static_link_drain:OnCreated()
  if not IsServer() then return end

  self.caster = self:GetCaster()
  self.target = self:GetParent()
  self.ability = self:GetAbility()

  self.drain_rate = self.ability:GetSpecialValueFor("drain_rate")
  self.drain_range_buffer = self.ability:GetSpecialValueFor("drain_range_buffer")
  self.radius = self.ability:GetSpecialValueFor("radius")
  self.vision_radius = self.ability:GetSpecialValueFor("vision_radius")
  self.vision_duration = self.ability:GetSpecialValueFor("vision_duration")

  local castRange = self.ability:GetCastRange(self.caster:GetAbsOrigin(), self.target)
  self.break_range = castRange + self.drain_range_buffer

  self.soundLoop = "Ability.static.loop"

  self.caster:StopSound(self.soundLoop)
  self.caster:EmitSound(self.soundLoop)

  local particleFile = "particles/units/heroes/hero_razor/razor_static_link.vpcf"
  self.particle = ParticleManager:CreateParticle(particleFile, PATTACH_POINT_FOLLOW, self.caster)
  ParticleManager:SetParticleControlEnt(self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_static", self.caster:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
  
 
  self:StartIntervalThink(0.25)
end

function modifier_static_link_drain:OnDestroy()
  if not IsServer() then return end

  local soundEnd = "Ability.static.end"

  self.caster:StopSound(self.soundLoop)
  self.caster:EmitSound(soundEnd)

  ParticleManager:DestroyParticle(self.particle, true)
end

function modifier_static_link_drain:OnIntervalThink()
  if not IsServer() then return end

  local outOfRange = CalcDistanceBetweenEntityOBB(self.caster,self.target) > self.break_range
  if outOfRange or not self.caster:IsAlive() or not self.target:IsAlive() then
    self:Destroy()
  end

  local damageTable = {
    victim = self.target,
    damage = self.drain_rate,
    damage_type = DAMAGE_TYPE_MAGICAL,
    attacker = self.caster,
    ability = self.ability
  }

  local damageDealt = ApplyDamage(damageTable)

  
    if self.target:IsRealHero() then
        self.caster:SetMana(self.caster:GetMana()+self.drain_rate/2)
    else
        self.caster:SetMana(self.caster:GetMana()+self.drain_rate/4)
    end
end