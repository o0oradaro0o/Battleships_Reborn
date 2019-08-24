cloud_dragon_lua = cloud_dragon_lua or class({})

function cloud_dragon_lua:OnSpellStart()
  if IsServer() then
    local ability = self
    local caster = self:GetCaster()
    local target_loc = self:GetCursorPosition()

    local unit_name = "npc_dota_cloud_dragon_statue"

    local duration = ability:GetSpecialValueFor("duration")
    local fire_interval = 1.5
    local radius = 900

    local statue = CreateUnitByName(
      unit_name, 
      target_loc, 
      true, 
      caster, 
      caster, 
      caster:GetTeam()
    )

    statue:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
    statue:CreatureLevelUp(ability:GetLevel())
    statue:SetOwner(caster)

    Timers:CreateTimer(duration + 1, function()
      statue:AddNoDraw()
    end)

    local ability_breathe_fire = statue:FindAbilityByName("cloud_dragon_breathe_fire_lua")
    ability_breathe_fire:SetLevel(ability:GetLevel())

    Timers:CreateTimer(.1, function()
      if statue:IsNull() or not statue:IsAlive() then
        return
      end

      local enemies = FindUnitsInRadius(
        statue:GetTeam(), 
        statue:GetAbsOrigin(), 
        nil, 
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
        FIND_ANY_ORDER, 
        false
      )

      if TableCount(enemies) > 0 then
        target = GetRandomTableElement(enemies)
        statue:CastAbilityOnPosition(target:GetAbsOrigin(), ability_breathe_fire, -1)
      end

      return fire_interval
    end)
  end
end