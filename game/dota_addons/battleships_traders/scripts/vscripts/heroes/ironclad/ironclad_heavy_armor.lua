LinkLuaModifier("modifier_ironclad_heavy_armor", "heroes/ironclad/ironclad_heavy_armor.lua", LUA_MODIFIER_MOTION_NONE)

ironclad_heavy_armor = class({})

function ironclad_heavy_armor:GetIntrinsicModifierName()
  return "modifier_ironclad_heavy_armor"
end

--------------------------------------------------------------------------------
modifier_ironclad_heavy_armor = class({})

function modifier_ironclad_heavy_armor:OnCreated()
  self.reduction_front = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction" )
  self.reduction_side = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction_side" )
  self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" ) / 2
  self.angle_side = self:GetAbility():GetSpecialValueFor( "side_angle" ) / 2

  if IsServer() then
    self.parent = self:GetParent()
  end
end

function modifier_ironclad_heavy_armor:OnRefresh( kv )
  self.reduction_back = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction" )
  self.reduction_side = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction_side" )
  self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" ) / 2
  self.angle_side = self:GetAbility():GetSpecialValueFor( "side_angle" ) / 2
end

function modifier_ironclad_heavy_armor:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
  }

  return funcs
end

function modifier_ironclad_heavy_armor:GetModifierPhysical_ConstantBlock( params )
  local parent = params.target
  local attacker = params.attacker
  local reduction = 0

  local facing_direction = parent:GetAnglesAsVector().y
  local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
  local attacker_direction = VectorToAngles( attacker_vector ).y
  local angle_diff = math.abs(AngleDiff(facing_direction, attacker_direction))

  -- calculate damage reduction
  if angle_diff < self.angle_front then
    -- Front
    reduction = 0
  elseif angle_diff < self.angle_side then
    -- Side
    reduction = self.reduction_side
    self:PlayEffects(false, attacker_vector)
  else
    -- Back
    reduction = self.reduction_back
    self:PlayEffects(true, attacker_vector)
  end

  return reduction * params.damage / 100
end

function modifier_ironclad_heavy_armor:PlayEffects(isBack)
  local particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf"
  local sound_cast = "Hero_Mars.Shield.Block"

  if not isBack then
    particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf"
    sound_cast = "Hero_Mars.Shield.BlockSmall"
  end

  local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:ReleaseParticleIndex(effect_cast)

  self.parent:EmitSound(sound_cast)
end
