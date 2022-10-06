weapon_passive = class({})


------------------------------------------------------------



function weapon_passive:FireProjectile(projectile)
    projectile.Ability = self

    ProjectileManager:CreateTrackingProjectile(projectile)
end

--handle extradata hit
function weapon_passive:OnProjectileHit_ExtraData(target, location, extradata)
    -- find the item on the caster that matches extradata itemName
    local caster = self:GetCaster()
    local modifier = caster:FindModifierByName(extradata.ModifierName)
    local ParticalTable = {
        caster = caster,
        target = target,
        extradata = extradata
    }

    modifier:OnRefresh(ParticalTable)
end
