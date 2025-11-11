-- Ice/Wind Mix Hybrid Weapon (Levels 1-3)
-- Ice weapon: Slows enemies, does NOT hit towers (CORRECTED)
-- Wind weapon: Knocks back enemies, CAN hit towers

item_ice_wind_mix = class({})
LinkLuaModifier("modifier_item_ice_wind_mix", "items/item_ice_wind_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ice_wind_mix_2", "items/item_ice_wind_mix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ice_wind_mix_ice_slow", "items/item_ice_wind_mix.lua", LUA_MODIFIER_MOTION_NONE)

item_ice_wind_mix_bow_doubled = class({})
item_ice_wind_mix_two_bow_doubled = class({})
item_ice_wind_mix_three_bow_doubled = class({})

function item_ice_wind_mix_bow_doubled:GetIntrinsicModifierName()
    return "modifier_item_ice_wind_mix"
end

function item_ice_wind_mix_two_bow_doubled:GetIntrinsicModifierName()
    return "modifier_item_ice_wind_mix"
end

function item_ice_wind_mix_three_bow_doubled:GetIntrinsicModifierName()
    return "modifier_item_ice_wind_mix"
end

----------------------------------------------------------------------
-- Primary Weapon: Ice (Projectile with slow) - DOES NOT HIT TOWERS
----------------------------------------------------------------------
modifier_item_ice_wind_mix = class({})

function modifier_item_ice_wind_mix:IsHidden()
    return true
end

function modifier_item_ice_wind_mix:IsPurgable()
    return false
end

function modifier_item_ice_wind_mix:OnCreated(kv)
    if not IsServer() then return end
    
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    -- Ice weapon stats (primary)
    self.dmg = self.ability:GetSpecialValueFor("dmg")
    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.range = self.ability:GetSpecialValueFor("range")
    self.speed = 1200 -- Ice projectile speed
    self.slow_pct = self.ability:GetSpecialValueFor("slow_pct")
    self.slow_dur = self.ability:GetSpecialValueFor("slow_dur")
    self.level = self.ability:GetSpecialValueFor("level")
    self.num_attacks = 1
    
    -- Determine particle based on level
    local particle_name = "particles/basic_projectile/ice_one_projectile.vpcf"
    if self.level == 2 then
        particle_name = "particles/basic_projectile/ice_two_projectile.vpcf"
    elseif self.level == 3 then
        particle_name = "particles/basic_projectile/ice_three_projectile.vpcf"
    end
    self.particle = particle_name
    
    -- Add secondary weapon modifier (wind)
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ice_wind_mix_2", {})
    
    self:StartIntervalThink(self.fire_rate)
end

function modifier_item_ice_wind_mix:OnIntervalThink()
    if not IsServer() then return end
    
    -- Check for weapon_passive ability
    local weapon_passive = self.parent:FindAbilityByName("weapon_passive")
    if not weapon_passive then
        weapon_passive = self.parent:AddAbility("weapon_passive")
        weapon_passive:SetLevel(1)
    end
    
    -- Play ice sound
    EmitSoundOn("Hero_Crystal.Attack", self.parent)
    
    -- Fire ice projectile
    for i = 1, self.num_attacks do
        local info = {
            EffectName = self.particle,
            Ability = weapon_passive,
            iMoveSpeed = self.speed,
            Source = self.parent,
            Target = nil,
            bDodgeable = true,
            bProvidesVision = false,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
            vSpawnOrigin = self.parent:GetAbsOrigin(),
            iVisionRadius = 0,
            iVisionTeamNumber = self.parent:GetTeamNumber(),
            ExtraData = {
                ModifierName = "modifier_item_ice_wind_mix",
                ModifierLevel = self.level,
                ModifierDamage = self.dmg
            }
        }
        
        ProjectileManager:CreateLinearProjectile(info)
    end
    
    self:StartIntervalThink(self.fire_rate)
end

function modifier_item_ice_wind_mix:OnRefresh(kv)
    if not IsServer() then return end
    
    -- This is called when the projectile hits
    local target = kv.target
    if not target then return end
    
    -- Apply ice damage
    ApplyDamage({
        victim = target,
        attacker = self.parent,
        damage = self.dmg,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self.ability
    })
    
    -- Apply slow debuff
    target:AddNewModifier(self.parent, self.ability, "modifier_item_ice_wind_mix_ice_slow", {
        duration = self.slow_dur
    })
    
    -- Play impact sound
    EmitSoundOn("Hero_Crystal.CrystalNova", target)
end

function modifier_item_ice_wind_mix:OnDestroy()
    if not IsServer() then return end
    
    -- Remove secondary weapon modifier
    if self.parent:HasModifier("modifier_item_ice_wind_mix_2") then
        self.parent:RemoveModifierByName("modifier_item_ice_wind_mix_2")
    end
end

function modifier_item_ice_wind_mix:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end

function modifier_item_ice_wind_mix:GetModifierProjectileName()
    return self.particle
end

----------------------------------------------------------------------
-- Ice Slow Debuff
----------------------------------------------------------------------
modifier_item_ice_wind_mix_ice_slow = class({})

function modifier_item_ice_wind_mix_ice_slow:IsHidden()
    return false
end

function modifier_item_ice_wind_mix_ice_slow:IsDebuff()
    return true
end

function modifier_item_ice_wind_mix_ice_slow:IsPurgable()
    return true
end

function modifier_item_ice_wind_mix_ice_slow:OnCreated(kv)
    if not IsServer() then return end
    
    self.ability = self:GetAbility()
    self.slow_pct = self.ability:GetSpecialValueFor("slow_pct")
end

function modifier_item_ice_wind_mix_ice_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_item_ice_wind_mix_ice_slow:GetModifierMoveSpeedBonus_Percentage()
    return -self.slow_pct
end

function modifier_item_ice_wind_mix_ice_slow:GetEffectName()
    return "particles/basic_projectile/ice_debuff.vpcf"
end

function modifier_item_ice_wind_mix_ice_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

----------------------------------------------------------------------
-- Secondary Weapon: Wind (Projectile with knockback) - CAN HIT TOWERS
----------------------------------------------------------------------
modifier_item_ice_wind_mix_2 = class({})

function modifier_item_ice_wind_mix_2:IsHidden()
    return true
end

function modifier_item_ice_wind_mix_2:IsPurgable()
    return false
end

function modifier_item_ice_wind_mix_2:OnCreated(kv)
    if not IsServer() then return end
    
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    -- Wind weapon stats (secondary - note "_2" suffix)
    self.dmg_2 = self.ability:GetSpecialValueFor("dmg_2")
    self.fire_rate_2 = self.ability:GetSpecialValueFor("fire_rate_2")
    self.range_2 = self.ability:GetSpecialValueFor("range_2")
    self.speed_2 = 900 -- Wind projectile speed
    self.bonus_dmg = self.ability:GetSpecialValueFor("bonus_dmg")
    self.min_range = self.ability:GetSpecialValueFor("min_range")
    self.min_range_dmg_pct = self.ability:GetSpecialValueFor("min_range_dmg_pct")
    self.level = self.ability:GetSpecialValueFor("level")
    self.num_attacks = 1
    
    -- Determine particle based on level
    local particle_name = "particles/basic_projectile/wind_one_projectile.vpcf"
    if self.level == 2 then
        particle_name = "particles/basic_projectile/wind_two_projectile.vpcf"
    elseif self.level == 3 then
        particle_name = "particles/basic_projectile/wind_three_projectile.vpcf"
    end
    self.particle = particle_name
    
    self:StartIntervalThink(self.fire_rate_2)
end

function modifier_item_ice_wind_mix_2:OnIntervalThink()
    if not IsServer() then return end
    
    -- Check for weapon_passive ability
    local weapon_passive = self.parent:FindAbilityByName("weapon_passive")
    if not weapon_passive then
        weapon_passive = self.parent:AddAbility("weapon_passive")
        weapon_passive:SetLevel(1)
    end
    
    -- Play wind sound
    EmitSoundOn("Hero_Windrunner.Attack", self.parent)
    
    -- Fire wind projectile
    for i = 1, self.num_attacks do
        local info = {
            EffectName = self.particle,
            Ability = weapon_passive,
            iMoveSpeed = self.speed_2,
            Source = self.parent,
            Target = nil,
            bDodgeable = true,
            bProvidesVision = false,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
            vSpawnOrigin = self.parent:GetAbsOrigin(),
            iVisionRadius = 0,
            iVisionTeamNumber = self.parent:GetTeamNumber(),
            ExtraData = {
                ModifierName = "modifier_item_ice_wind_mix_2",
                ModifierLevel = self.level,
                ModifierDamage = self.dmg_2
            }
        }
        
        ProjectileManager:CreateLinearProjectile(info)
    end
    
    self:StartIntervalThink(self.fire_rate_2)
end

function modifier_item_ice_wind_mix_2:OnRefresh(kv)
    if not IsServer() then return end
    
    -- This is called when the projectile hits
    local target = kv.target
    if not target then return end
    
    -- Calculate distance-based damage (wind weapon mechanic)
    local distance = (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D()
    local damage_multiplier = 1.0
    
    if distance < self.min_range then
        damage_multiplier = self.min_range_dmg_pct / 100
    end
    
    local final_damage = self.dmg_2 * damage_multiplier
    
    -- Apply wind damage
    ApplyDamage({
        victim = target,
        attacker = self.parent,
        damage = final_damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self.ability
    })
    
    -- Knockback effect (if target is not a building)
    if not target:IsBuilding() then
        local knockback_direction = (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
        local knockback_distance = 150 -- Default knockback distance
        local knockback_position = target:GetAbsOrigin() + knockback_direction * knockback_distance
        
        FindClearSpaceForUnit(target, knockback_position, true)
    end
    
    -- Heal nearby allies (wind weapon bonus mechanic)
    if self.bonus_dmg > 0 then
        local allies = FindUnitsInRadius(
            self.parent:GetTeamNumber(),
            self.parent:GetAbsOrigin(),
            nil,
            400,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false
        )
        
        for _, ally in pairs(allies) do
            if ally ~= self.parent then
                ally:Heal(self.bonus_dmg, self.ability)
            end
        end
    end
    
    -- Play impact sound
    EmitSoundOn("Hero_Windrunner.ArrowImpact", target)
end

function modifier_item_ice_wind_mix_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end

function modifier_item_ice_wind_mix_2:GetModifierProjectileName()
    return self.particle
end
