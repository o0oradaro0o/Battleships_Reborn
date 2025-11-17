-- Swine Storm: Ice/Wind Mix Ultimate Weapon
-- Fires tornado projectiles that waver side to side
-- Contains flying pig units that collide with ships

item_ice_wind_mix_ult_bow = class({})
LinkLuaModifier("modifier_item_ice_wind_mix_ult_bow", "items/item_ice_wind_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_swine_storm_tornado_thinker", "items/item_ice_wind_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_swine_storm_pig_ai", "items/item_ice_wind_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_swine_storm_slow_debuff", "items/item_ice_wind_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_swine_storm_speed_buff", "items/item_ice_wind_mix_ult.lua", LUA_MODIFIER_MOTION_NONE)

function item_ice_wind_mix_ult_bow:Precache(context)
  PrecacheResource("particle", "particles/basic_projectile/swine_storm_tornado.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_windrun.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_brewmaster/brewmaster_windwalk.vpcf", context)
  PrecacheResource("model", "models/items/windrunner/windrunner_arcana/windranger_arcana_fx_model_tornado_sml.vmdl", context)
  PrecacheResource("model", "models/pets/poogie/poogie.vmdl", context)
  PrecacheResource("model", "models/pets/poogie/poogie_apprentice.vmdl", context)
  PrecacheResource("model", "models/pets/poogie/poogie_bee.vmdl", context)
  PrecacheResource("model", "models/pets/poogie/poogie_emperor.vmdl", context)
  PrecacheResource("model", "models/pets/poogie/poogie_pink.vmdl", context)
  PrecacheResource("model", "models/pets/poogie/poogie_pumpkin.vmdl", context)
end

function item_ice_wind_mix_ult_bow:GetIntrinsicModifierName()
    return "modifier_item_ice_wind_mix_ult_bow"
end

----------------------------------------------------------------------
-- Swine Storm Main Modifier (Weapon Firing)
----------------------------------------------------------------------
modifier_item_ice_wind_mix_ult_bow = class({})

function modifier_item_ice_wind_mix_ult_bow:IsHidden()
    return true
end

function modifier_item_ice_wind_mix_ult_bow:IsPurgable()
    return false
end

function modifier_item_ice_wind_mix_ult_bow:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_ice_wind_mix_ult_bow:OnCreated(kv)
    if not IsServer() then return end
    
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.caster = self.ability:GetCaster()
    
    self.fire_rate = self.ability:GetSpecialValueFor("fire_rate")
    self.range = self.ability:GetSpecialValueFor("range")
    
    self:StartIntervalThink(self.fire_rate)
end

function modifier_item_ice_wind_mix_ult_bow:OnIntervalThink()
    if not IsServer() then return end
    
    local enemies = FindUnitsInRadius(
        self.parent:GetTeam(),
        self.parent:GetAbsOrigin(),
        nil,
        self.range,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
        FIND_ANY_ORDER,
        false
    )
    
    if #enemies == 0 then return end
    
    local target = enemies[RandomInt(1, #enemies)]
    
    -- Play wind sound
    EmitSoundOn("Hero_Invoker.Tornado", self.parent)
    
    -- Create tornado projectile (dummy unit)
    self:CreateTornado(target)
end

function modifier_item_ice_wind_mix_ult_bow:CreateTornado(target)
    if not IsServer() then return end
    
    local spawn_pos = self.parent:GetAbsOrigin()
    
    -- Create tornado dummy unit
    local tornado = CreateUnitByName(
        "npc_swine_storm_tornado",
        spawn_pos,
        true,
        self.caster,
        self.caster,
        self.caster:GetTeam()
    )
    
    if not tornado then return end
    
    tornado:SetOwner(self.caster)
    
    -- Add tornado thinker modifier
    tornado:AddNewModifier(self.caster, self.ability, "modifier_swine_storm_tornado_thinker", {
        target_entindex = target:entindex()
    })
end

function modifier_item_ice_wind_mix_ult_bow:OnDestroy()
    if not IsServer() then return end
end

----------------------------------------------------------------------
-- Tornado Thinker Modifier (Wavering Projectile Motion)
----------------------------------------------------------------------
modifier_swine_storm_tornado_thinker = class({})

function modifier_swine_storm_tornado_thinker:IsHidden()
    return true
end

function modifier_swine_storm_tornado_thinker:IsPurgable()
    return false
end

function modifier_swine_storm_tornado_thinker:OnCreated(params)
    if not IsServer() then return end
    
    self.tornado = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    
    -- Get target
    self.target_entindex = params.target_entindex or -1
    self.target = EntIndexToHScript(self.target_entindex)
    
    if not self.target or self.target:IsNull() then
        self.tornado:ForceKill(false)
        return
    end
    
    -- Tornado parameters
    self.speed = tonumber(self.ability:GetSpecialValueFor("tornado_speed")) or 800
    self.lifetime = 0
    self.max_lifetime = tonumber(self.ability:GetSpecialValueFor("tornado_duration")) or 6
    self.waver_amplitude = 200 -- Side-to-side distance (increased from 80)
    self.waver_frequency = 2.5 -- Oscillations per second (increased from 2)
    self.angle = 0
    self.tracking_strength = 0.3 -- How much to adjust toward target each frame (0-1)
    
    -- Tornado collision parameters
    self.tornado_damage = tonumber(self.ability:GetSpecialValueFor("pig_damage")) or 100
    self.tornado_heal = tonumber(self.ability:GetSpecialValueFor("pig_heal")) or 100
    self.tornado_collision_radius = 150
    self.hit_units = {} -- Track units already hit by tornado
    
    -- Tornado visual effect
    self.particle = ParticleManager:CreateParticle(
        "particles/basic_projectile/swine_storm_tornado.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        self.tornado
    )
    ParticleManager:SetParticleControl(self.particle, 0, self.tornado:GetAbsOrigin())
    
    -- Spawn 1-3 pigs
    self.num_pigs = RandomInt(
        tonumber(self.ability:GetSpecialValueFor("pig_count_min")) or 1,
        tonumber(self.ability:GetSpecialValueFor("pig_count_max")) or 3
    )
    self.pigs = {}
    
    for i = 1, self.num_pigs do
        local pig = self:SpawnPig(i)
        if pig then
            table.insert(self.pigs, pig)
        end
    end
    
    self:StartIntervalThink(0.03)
end

function modifier_swine_storm_tornado_thinker:SpawnPig(index)
    if not IsServer() then return nil end
    
    -- Random pig model
    local pig_models = {
        "models/pets/poogie/poogie.vmdl",
        "models/pets/poogie/poogie_apprentice.vmdl",
        "models/pets/poogie/poogie_bee.vmdl",
        "models/pets/poogie/poogie_emperor.vmdl",
        "models/pets/poogie/poogie_pink.vmdl",
        "models/pets/poogie/poogie_pumpkin.vmdl"
    }
    
    local pig = CreateUnitByName(
        "npc_swine_storm_pig",
        self.tornado:GetAbsOrigin(),
        true,
        self.caster,
        self.caster,
        self.caster:GetTeam()
    )
    
    if not pig then return nil end
    
    pig:SetOwner(self.caster)
    pig:SetModel(pig_models[RandomInt(1, #pig_models)])
    pig:SetOriginalModel(pig_models[RandomInt(1, #pig_models)])
    
    -- Get pig stats from ability
    local pig_damage = tonumber(self.ability:GetSpecialValueFor("pig_damage")) or 100
    local pig_heal = tonumber(self.ability:GetSpecialValueFor("pig_heal")) or 100
    local slow_pct = tonumber(self.ability:GetSpecialValueFor("slow_pct")) or 30
    local slow_dur = tonumber(self.ability:GetSpecialValueFor("slow_dur")) or 2
    local speed_pct = tonumber(self.ability:GetSpecialValueFor("speed_pct")) or 30
    local speed_dur = tonumber(self.ability:GetSpecialValueFor("speed_dur")) or 3
    local collision_radius = tonumber(self.ability:GetSpecialValueFor("pig_collision_radius")) or 80
    
    -- Add pig AI modifier with all parameters
    pig:AddNewModifier(self.caster, self.ability, "modifier_swine_storm_pig_ai", {
        tornado_entindex = self.tornado:entindex(),
        target_entindex = self.target_entindex,
        orbit_offset = (index - 1) * (360 / self.num_pigs),
        damage = pig_damage,
        heal = pig_heal,
        slow_pct = slow_pct,
        slow_dur = slow_dur,
        speed_pct = speed_pct,
        speed_dur = speed_dur,
        collision_radius = collision_radius
    })
    
    return pig
end

function modifier_swine_storm_tornado_thinker:OnIntervalThink()
    if not IsServer() then return end
    
    self.lifetime = self.lifetime + 0.03
    
    -- Check if tornado should expire
    if self.lifetime >= self.max_lifetime or not self.target or self.target:IsNull() or not self.target:IsAlive() then
        self:DestroyTornado()
        return
    end
    
    -- Update angle for wavering
    self.angle = self.angle + (self.waver_frequency * 360 * 0.03)
    
    local current_pos = self.tornado:GetAbsOrigin()
    local target_pos = self.target:GetAbsOrigin()
    
    -- Calculate direction to target (constantly updating for tracking)
    local to_target = target_pos - current_pos
    local desired_direction = to_target:Normalized()
    
    -- Update forward direction to gradually track target
    if not self.forward_direction then
        self.forward_direction = desired_direction
    else
        -- Blend current direction with desired direction for smooth tracking
        self.forward_direction = (self.forward_direction * (1 - self.tracking_strength) + desired_direction * self.tracking_strength):Normalized()
    end
    
    -- Calculate perpendicular direction for wavering
    self.right_direction = Vector(-self.forward_direction.y, self.forward_direction.x, 0)
    
    -- Calculate wavering offset (perpendicular to forward direction)
    local waver_offset = math.sin(math.rad(self.angle)) * self.waver_amplitude
    
    -- Move tornado forward with wavering
    local forward_movement = self.forward_direction * self.speed * 0.03
    local waver_movement = self.right_direction * waver_offset * 0.03 * self.waver_frequency
    local new_pos = current_pos + forward_movement + waver_movement
    
    self.tornado:SetAbsOrigin(new_pos)
    FindClearSpaceForUnit(self.tornado, new_pos, false)
    
    -- Check for tornado collisions with ships
    self:CheckTornadoCollisions(new_pos)
    
    -- Check if tornado reached target
    local distance_to_target = (target_pos - new_pos):Length2D()
    if distance_to_target < 100 then
        self:DestroyTornado()
    end
end

function modifier_swine_storm_tornado_thinker:CheckTornadoCollisions(tornado_pos)
    if not IsServer() then return end
    
    local ships = FindUnitsInRadius(
        self.caster:GetTeam(),
        tornado_pos,
        nil,
        self.tornado_collision_radius,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
        FIND_CLOSEST,
        false
    )
    
    for _, ship in pairs(ships) do
        -- Exclude the caster and units we've already hit
        if ship ~= self.caster and not self.hit_units[ship:entindex()] then
            -- Mark unit as hit
            self.hit_units[ship:entindex()] = true
            
            -- Play impact sound
            EmitSoundOn("Hero_Invoker.Tornado.Target", ship)
            
            if ship:GetTeam() == self.caster:GetTeam() then
                -- Ally: Heal
                ship:Heal(self.tornado_heal, self.caster)
                
                -- Healing particle
                local particle = ParticleManager:CreateParticle(
                    "particles/units/heroes/hero_brewmaster/brewmaster_windwalk.vpcf",
                    PATTACH_ABSORIGIN,
                    ship
                )
                ParticleManager:ReleaseParticleIndex(particle)
            else
                -- Enemy: Deal damage
                ApplyDamage({
                    victim = ship,
                    attacker = self.caster,
                    damage = self.tornado_damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self.ability
                })
                
                -- Damage particle
                local particle = ParticleManager:CreateParticle(
                    "particles/generic_gameplay/generic_slowed_cold.vpcf",
                    PATTACH_ABSORIGIN_FOLLOW,
                    ship
                )
                ParticleManager:ReleaseParticleIndex(particle)
            end
        end
    end
end

function modifier_swine_storm_tornado_thinker:DestroyTornado()
    if not IsServer() then return end
    
    -- Destroy particle
    if self.particle then
        ParticleManager:DestroyParticle(self.particle, false)
        ParticleManager:ReleaseParticleIndex(self.particle)
    end
    
    -- Make remaining pigs hit the target if they haven't collided
    for _, pig in pairs(self.pigs) do
        if pig and not pig:IsNull() and pig:IsAlive() then
            local pig_modifier = pig:FindModifierByName("modifier_swine_storm_pig_ai")
            if pig_modifier and not pig_modifier.has_collided then
                -- Force pig to collide with target
                pig_modifier:ForceHitTarget()
            else
                pig:ForceKill(false)
            end
        end
    end
    
    -- Destroy tornado
    if self.tornado and not self.tornado:IsNull() then
        self.tornado:ForceKill(false)
    end
end

function modifier_swine_storm_tornado_thinker:OnDestroy()
    if not IsServer() then return end
    self:DestroyTornado()
end

function modifier_swine_storm_tornado_thinker:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true
    }
end

----------------------------------------------------------------------
-- Pig AI Modifier (Orbiting and Collision Detection)
----------------------------------------------------------------------
modifier_swine_storm_pig_ai = class({})

function modifier_swine_storm_pig_ai:IsHidden()
    return true
end

function modifier_swine_storm_pig_ai:IsPurgable()
    return false
end

function modifier_swine_storm_pig_ai:OnCreated(params)
    if not IsServer() then return end
    
    self.pig = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    
    -- Get tornado
    self.tornado_entindex = params.tornado_entindex or -1
    self.tornado = EntIndexToHScript(self.tornado_entindex)
    
    -- Get original target
    self.target_entindex = params.target_entindex or -1
    self.target = EntIndexToHScript(self.target_entindex)
    
    if not self.tornado or self.tornado:IsNull() then
        self.pig:ForceKill(false)
        return
    end
    
    -- Orbit parameters
    self.orbit_radius = 120
    self.orbit_speed = 180 -- Degrees per second for orbiting
    self.orbit_angle = params.orbit_offset or 0
    self.collision_radius = params.collision_radius or 80
    self.has_collided = false
    
    -- Spin parameters (for spinning in place)
    self.spin_angle = RandomFloat(0, 360) -- Random starting angle
    self.spin_speed = RandomFloat(180, 540) * (RandomInt(0, 1) == 0 and 1 or -1) -- Random speed (0.5-1.5 rotations/sec) and direction
    
    -- Pig stats (passed from tornado)
    self.damage = params.damage or 100
    self.heal = params.heal or 100
    self.slow_pct = params.slow_pct or 30
    self.slow_dur = params.slow_dur or 2
    self.speed_pct = params.speed_pct or 30
    self.speed_dur = params.speed_dur or 3
    
    self:StartIntervalThink(0.03)
end

function modifier_swine_storm_pig_ai:OnIntervalThink()
    if not IsServer() then return end
    
    if self.has_collided then return end
    
    -- Check if tornado still exists
    if not self.tornado or self.tornado:IsNull() or not self.tornado:IsAlive() then
        self.pig:ForceKill(false)
        return
    end
    
    -- Update orbit angle (revolving around tornado center)
    self.orbit_angle = self.orbit_angle + (self.orbit_speed * 0.03)
    if self.orbit_angle >= 360 then
        self.orbit_angle = self.orbit_angle - 360
    end
    
    -- Update spin angle (spinning in place)
    self.spin_angle = self.spin_angle + (self.spin_speed * 0.03)
    while self.spin_angle >= 360 do
        self.spin_angle = self.spin_angle - 360
    end
    while self.spin_angle < 0 do
        self.spin_angle = self.spin_angle + 360
    end
    
    -- Calculate orbit position around tornado
    local tornado_pos = self.tornado:GetAbsOrigin()
    local offset_x = math.cos(math.rad(self.orbit_angle)) * self.orbit_radius
    local offset_y = math.sin(math.rad(self.orbit_angle)) * self.orbit_radius
    local pig_pos = tornado_pos + Vector(offset_x, offset_y, 50)
    
    self.pig:SetAbsOrigin(pig_pos)
    FindClearSpaceForUnit(self.pig, pig_pos, false)
    
    -- Set pig facing angle to spin in place
    self.pig:SetAngles(0, self.spin_angle, 0)
    
    -- Check for collisions with ships
    local ships = FindUnitsInRadius(
        self.caster:GetTeam(),
        pig_pos,
        nil,
        self.collision_radius,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
        FIND_CLOSEST,
        false
    )
    
    for _, ship in pairs(ships) do
        -- Exclude the caster and the pig itself from collision
        if ship ~= self.caster and ship ~= self.pig and ship:GetUnitName() ~= "npc_swine_storm_pig" and ship:GetUnitName() ~= "npc_swine_storm_tornado" then
            self:OnPigCollision(ship)
            break
        end
    end
end

function modifier_swine_storm_pig_ai:OnPigCollision(ship)
    if not IsServer() or self.has_collided then return end
    
    self.has_collided = true
    
    -- Play impact sound
    EmitSoundOn("Hero_Techies.Suicide", self.pig)
    
    if ship:GetTeam() == self.caster:GetTeam() then
        -- Ally: Heal and apply speed buff
        ship:Heal(self.heal, self.caster)
        
        -- Apply speed buff (use ability if available, otherwise nil is fine for buff-only modifier)
        ship:AddNewModifier(self.caster, self.ability, "modifier_swine_storm_speed_buff", {
            duration = self.speed_dur,
            speed_pct = self.speed_pct
        })
        
        -- Healing particle
        local particle = ParticleManager:CreateParticle(
            "particles/units/heroes/hero_brewmaster/brewmaster_windwalk.vpcf",
            PATTACH_ABSORIGIN,
            ship
        )
        ParticleManager:ReleaseParticleIndex(particle)
    else
        -- Enemy: Deal damage and apply slow
        ApplyDamage({
            victim = ship,
            attacker = self.caster,
            damage = self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self.ability
        })
        
        -- Apply slow debuff (pass slow_pct as parameter)
        ship:AddNewModifier(self.caster, self.ability, "modifier_swine_storm_slow_debuff", {
            duration = self.slow_dur,
            slow_pct = self.slow_pct
        })
        
        -- Damage particle
        local particle = ParticleManager:CreateParticle(
            "particles/generic_gameplay/generic_slowed_cold.vpcf",
            PATTACH_ABSORIGIN_FOLLOW,
            ship
        )
        ParticleManager:ReleaseParticleIndex(particle)
    end
    
    -- Remove pig
    self.pig:ForceKill(false)
end

function modifier_swine_storm_pig_ai:ForceHitTarget()
    if not IsServer() or self.has_collided then return end
    
    -- Check if target still exists
    if self.target and not self.target:IsNull() and self.target:IsAlive() then
        -- Hit the original target
        self:OnPigCollision(self.target)
    else
        -- No valid target, just kill the pig
        self.pig:ForceKill(false)
    end
end

function modifier_swine_storm_pig_ai:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true
    }
end

----------------------------------------------------------------------
-- Slow Debuff Modifier
----------------------------------------------------------------------
modifier_swine_storm_slow_debuff = class({})

function modifier_swine_storm_slow_debuff:IsHidden()
    return false
end

function modifier_swine_storm_slow_debuff:IsDebuff()
    return true
end

function modifier_swine_storm_slow_debuff:IsPurgable()
    return true
end

function modifier_swine_storm_slow_debuff:OnCreated(params)
    if not IsServer() then return end
    -- Try to get from params first, then from ability
    self.slow_pct = params.slow_pct or (self:GetAbility() and self:GetAbility():GetSpecialValueFor("slow_pct")) or 30
end

function modifier_swine_storm_slow_debuff:OnRefresh(params)
    if not IsServer() then return end
    self.slow_pct = params.slow_pct or (self:GetAbility() and self:GetAbility():GetSpecialValueFor("slow_pct")) or 30
end

function modifier_swine_storm_slow_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_swine_storm_slow_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -self.slow_pct
end

function modifier_swine_storm_slow_debuff:GetEffectName()
    return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_swine_storm_slow_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

----------------------------------------------------------------------
-- Speed Buff Modifier
----------------------------------------------------------------------
modifier_swine_storm_speed_buff = class({})

function modifier_swine_storm_speed_buff:IsHidden()
    return false
end

function modifier_swine_storm_speed_buff:IsDebuff()
    return false
end

function modifier_swine_storm_speed_buff:IsPurgable()
    return true
end

function modifier_swine_storm_speed_buff:OnCreated(params)
    if not IsServer() then return end
    -- Try to get from params first, then from ability
    self.speed_pct = params.speed_pct or (self:GetAbility() and self:GetAbility():GetSpecialValueFor("speed_pct")) or 30
end

function modifier_swine_storm_speed_buff:OnRefresh(params)
    if not IsServer() then return end
    self.speed_pct = params.speed_pct or (self:GetAbility() and self:GetAbility():GetSpecialValueFor("speed_pct")) or 30
end

function modifier_swine_storm_speed_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_swine_storm_speed_buff:GetModifierMoveSpeedBonus_Percentage()
    return self.speed_pct
end

function modifier_swine_storm_speed_buff:GetEffectName()
    return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_windrun.vpcf"
end

function modifier_swine_storm_speed_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
