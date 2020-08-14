timber_chain_lua = class({})

function timber_chain_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorPosition()
    local casterPosition = caster:GetAbsOrigin()
    local sound_cast = "Hero_Shredder.TimberChain.Cast"
    local sound_retract = "Hero_Shredder.TimberChain.Retract"
    local sound_impact = "Hero_Shredder.TimberChain.Impact"
    local particle = "particles/units/heroes/hero_shredder/shredder_timberchain.vpcf"

    Physics:Unit(caster)

    EmitSoundOn(sound_cast, caster)

    local chain_radius = ability:GetSpecialValueFor("chain_radius")
    local range = ability:GetSpecialValueFor("range")
    local speed = ability:GetSpecialValueFor("speed")

    local direction = (target - casterPosition):Normalized()

    local target
    local searchPosition
    local foundTarget = false
    local foundUnit

    for i=50,range,5 do
        searchPosition = casterPosition + direction * i

        local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, searchPosition, nil, chain_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        
        for _,unit in pairs(units) do
            if unit:GetEntityIndex() ~= caster:GetEntityIndex() then
                foundUnit = unit
                break
            end
        end

        if foundUnit or not GridNav:IsTraversable(searchPosition) or GridNav:IsBlocked(searchPosition) then
            foundTarget = true
            break
        end
    end

    local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(particle_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", casterPosition, true)
    if foundUnit then
        ParticleManager:SetParticleControlEnt(particle_fx, 1, foundUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", searchPosition, true)
    else
        ParticleManager:SetParticleControl(particle_fx, 1, searchPosition)
    end
    ParticleManager:SetParticleControl(particle_fx, 2, Vector(speed, 0, 0))
    ParticleManager:SetParticleControl(particle_fx, 3, Vector(10, 0, 0))

    local length = (searchPosition - casterPosition):Length2D()
    local duration = length / speed

    -- if we didn't find a tree with the hook
    if not foundTarget then
        Timers:CreateTimer(duration, function()
            ParticleManager:DestroyParticle(particle_fx, false)
        end)
        return 
    end

    -- Wait until the chain reaches its target to start pulling
    Timers:CreateTimer(duration, function()
        -- After we've hit the target, drag us to the tree
        caster:SetPhysicsVelocity(direction * speed)

        -- Keep dragging us in the direction
        local maxDuration = 5
        local durationSoFar = 0
        local frameTime = 1/30

        Timers:CreateTimer(function()
            if not caster:IsAlive() then
                return
            end

            casterPosition = caster:GetAbsOrigin()
            if IsValidEntity(foundUnit) and foundUnit:IsAlive() then
                searchPosition = foundUnit:GetAbsOrigin()
            end
            local distanceToTarget = (searchPosition - casterPosition):Length2D()
            local direction = (searchPosition - casterPosition):Normalized()

            caster:SetPhysicsVelocity(direction * speed)

            if distanceToTarget < 50 or durationSoFar > maxDuration then
                caster:SetPhysicsVelocity(Vector(0, 0, 0))
                ParticleManager:DestroyParticle(particle_fx, false)

                FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)

                return
            end

            durationSoFar = durationSoFar + frameTime

            return frameTime
        end)

        -- Timers:CreateTimer(duration, function()
        --     -- When we've arrived, set our velocty back to normal and kill the tree
        --     caster:SetPhysicsVelocity(Vector(0, 0, 0))
        --     ParticleManager:DestroyParticle(particle_fx, false)
        -- end)
    end)

end