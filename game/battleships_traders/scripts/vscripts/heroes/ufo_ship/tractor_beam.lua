tractor_beam = tractor_beam or class({})

LinkLuaModifier("modifier_tractor_beam", "heroes/ufo_ship/tractor_beam", LUA_MODIFIER_MOTION_NONE)

function tractor_beam:OnSpellStart()
  if not IsServer() then return end

  local caster = self:GetCaster()
  local ability = self
  local target = self:GetCursorPosition()

  local duration = ability:GetSpecialValueFor("duration")

  local direction = (target - caster:GetAbsOrigin()):Normalized()

  caster:AddNewModifier(caster, ability, "modifier_tractor_beam", {
    direction_x = direction.x,
    direction_y = direction.y
  })
end

function tractor_beam:OnChannelFinish(interrupted)
  if not IsServer() then return end

  local caster = self:GetCaster()
  local ability = self

  caster:RemoveModifierByName("modifier_tractor_beam")
end

modifier_tractor_beam = class({})

function modifier_tractor_beam:IsHidden() return false end
function modifier_tractor_beam:IsPurgable() return false end
function modifier_tractor_beam:IsDebuff() return false end

function modifier_tractor_beam:OnCreated(keys)
  if not IsServer() then return end
  self.caster = self:GetCaster()
  self.direction = Vector(keys.direction_x, keys.direction_y, 0)

  local target = self.caster:GetAbsOrigin() + self.direction * self:GetAbility():GetSpecialValueFor("end_radius")

  self:StartIntervalThink(1/30)
	self:OnIntervalThink()

  local particleName = "particles/ufo_pull.vpcf"
  self.particle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, self.caster)
  ParticleManager:SetParticleControl(self.particle, 0, self.caster:GetAbsOrigin())
  ParticleManager:SetParticleControl(self.particle, 1, target)
end


function modifier_tractor_beam:OnIntervalThink()
  local caster = self.caster
  local casterPosition = caster:GetAbsOrigin()
  local range = self:GetAbility():GetSpecialValueFor("range")
  local suck_speed = 1.5
  local target = self.target

  if not IsServer() then return end

  local enemies = FindUnitsInRadius(
    caster:GetTeamNumber(),
    casterPosition,
    nil,
    range,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_ANY_ORDER,
    false
  )

  -- get enemies in a cone
  for _,enemy in pairs(enemies) do
    local enemyPosition = enemy:GetAbsOrigin()

    -- suck the target towards the caster
    local distance = (enemyPosition - casterPosition):Length2D()
    local enemyDirection = (enemyPosition - casterPosition):Normalized()

    -- get the difference in degrees between direction and enemy direction
    local angle = math.deg(math.acos(enemyDirection:Dot(self.direction)))

    -- pull the enemy towards the caster
    if angle < 45 then
      local newPosition = enemyPosition + enemyDirection * (distance - range) * (1 - angle / 90) * suck_speed * FrameTime()
      FindClearSpaceForUnit(enemy, newPosition, false)
    end
  end
end

function modifier_tractor_beam:OnDestroy()
  if not (self.particle) then return end
  ParticleManager:DestroyParticle(self.particle, true)
end
