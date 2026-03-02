harpoon_blast = class({})

-- Fires a harpoon in a straight line, damaging the first enemy it hits and pushing them back.

function harpoon_blast:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorPosition()

    local direction = (target - caster:GetOrigin()):Normalized()
    local distance = self:GetCastRange(self:GetCursorPosition(), nil)
    local speed = self:GetSpecialValueFor("speed")
    local width = self:GetSpecialValueFor("spearwidth")
    local vision = self:GetSpecialValueFor("spearwidth")
    local spear_vision = self:GetSpecialValueFor("spear_vision")

    -- Create the harpoon projectile
    local projectile_info = {
        Target = nil,
        Source = caster,
        Ability = self,
        EffectName = "particles/units/heroes/hero_harpoon/harpoon_blast.vpcf",
        iMoveSpeed = speed,
        vSourceLoc = caster:GetOrigin(),
        bDodgeable = false,
        bProvidesVision = true,
        iVisionRadius = 300,
        iVisionTeamNumber = caster:GetTeamNumber(),
    }
    projectile_info.vSpawnOrigin = caster:GetOrigin()
    projectile_info.vVelocity = direction * speed
    projectile_info.iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
    projectile_info.iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    projectile_info.iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE
    projectile_info.fDistance = distance
    projectile_info.fStartRadius = width
    projectile_info.fEndRadius = width
    projectile_info.bVisibleToEnemies = true
    projectile_info.bReplaceExisting = false
    projectile_info.bDeleteOnHit = true
    projectile_info.bProvidesVision = true
    projectile_info.iVisionRadius = spear_vision
    projectile_info.iVisionTeamNumber = caster:GetTeamNumber()
    projectile_info.iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION

    ProjectileManager:CreateLinearProjectile(projectile_info)
end

function harpoon_blast:OnProjectileHit(target, location)
    if target and target:IsAlive() then
        -- Apply damage to the target
        local damage_info = {
            victim = target,
            attacker = self:GetCaster(),
            damage = self:GetSpecialValueFor("damage"),
            damage_type = self:GetAbilityDamageType(),
            ability = self,
        }
        ApplyDamage(damage_info)

        -- Apply knockback effect
        local knockback_info = {
            should_stun = 0,
            knockback_duration = self:GetSpecialValueFor("knockback_duration"),
            knockback_distance = self:GetSpecialValueFor("knockback_distance"),
            knockback_height = 0,
            center_x = location.x,
            center_y = location.y,
            center_z = location.z,
        }
        target:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback_info)
    end

    return true
end