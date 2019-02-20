miss_lua = class({})
LinkLuaModifier("modifier_miss", "heroes/miss.lua", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------

modifier_miss = class({})


function miss_lua:OnUpgrade()
	local caster = self:GetCaster()
	caster:AddNewModifier(self:GetCaster(), self, "modifier_miss", {})
end

function miss_lua:OnOwnerSpawned()
	local caster = self:GetCaster()
	caster:AddNewModifier(self:GetCaster(), self, "modifier_miss", {})
end


function modifier_miss:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE,
  }
  return funcs
end

function modifier_miss:OnTakeDamage(keys)
  local unit = keys.unit
  local caster = self:GetParent()

  if unit == caster then

      if keys.inflictor then
          local ability = keys.inflictor

          local abilityKv = ability:GetAbilityKeyValues()
          local fire_rate = abilityKv.AbilitySpecial.fire_rate
          local x = RandomInt(1, 100)
          --print(x)
          if x<=self:GetAbility():GetSpecialValueFor("evasion") then
            --print("missed!")
              local damage = keys.damage
              local sound = "Hero_Medusa.ManaShield.Proc"
              EmitSoundOn(sound, caster)
              EmitSoundOn(sound, caster)
              EmitSoundOn(sound, caster)
              EmitSoundOn(sound, caster)
              EmitSoundOn(sound, caster)
              EmitSoundOn(sound, caster)
              SendOverheadEventMessage(nil, 5,  self:GetAbility():GetCaster(), 5, nil)
              caster:SetHealth(caster:GetHealth() + damage)
          end
      end
  end
end
