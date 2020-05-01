gamble = class({})

require("libraries/timers")


function gamble:OnSpellStart()
  local ability = self
    local caster = self:GetCaster()
    for _,mod in pairs( caster:FindAllModifiers()) do
        if  string.match(mod:GetName(), "gamble") then
            caster:RemoveModifierByName(mod:GetName())
        end
    end
	
  local abilityNames = {
    "gamble_heart",
    "gamble_bar",
    "gamble_diamond",
    "gamble_horseshoe",
    "gamble_bell",
    "gamble_cherry",
    "gamble_seven",
  }

  local spinSet = {
    {"gamble_spin3",
    "gamble_spin1",
    "gamble_spin2"},

    {"gamble_spin1",
    "gamble_spin2",
    "gamble_spin3"},

    {"gamble_spin2",
    "gamble_spin3",
    "gamble_spin1"}
}
  local startIndex = 0
  local endIndex = 2
  local newAbilitySet = {}
  local oldAbilities = {}

  local lesserRewardGold = ability:GetSpecialValueFor("lesser_reward")
  local greaterRewardGold = ability:GetSpecialValueFor("greater_reward")

  -- Store the old ability info
  for i=startIndex,endIndex do
    local oldAbility = caster:GetAbilityByIndex(i)

    oldAbilities[i] = {
      ability = oldAbility,
      level = oldAbility:GetLevel(),
      name = oldAbility:GetName(),
    }    
  end

  -- Delete the old abilities
  for i=startIndex,endIndex do
    local oldAbilityName = oldAbilities[i]["name"]
    caster:RemoveAbility(oldAbilityName)
  end
  EmitSoundOnClient("Hero_EarthSpirit.RollingBoulder.Loop", caster:GetPlayerOwner())
    for i=startIndex,endIndex do
        local oldAbilityLevel = oldAbilities[i]["level"]

        local newAbilityName = spinSet[1][i+1]
        --print(i .. spinSet[1][i+1])
        local newAbility = caster:AddAbility(newAbilityName)

        newAbility:SetAbilityIndex(i)
        newAbility:SetLevel(oldAbilityLevel)
    end

  Timers:CreateTimer(.1, function()
        
    for i=startIndex,endIndex do
        local tempAbility = caster:GetAbilityByIndex(i):GetName()
        caster:RemoveAbility(tempAbility)
    end
    
    for i=startIndex,endIndex do
        local oldAbilityLevel = oldAbilities[i]["level"]
    
        local newAbilityName = spinSet[2][i+1]
        local newAbility = caster:AddAbility(newAbilityName)
    
        newAbility:SetAbilityIndex(i)
        newAbility:SetLevel(oldAbilityLevel)
    end
end)

Timers:CreateTimer(.2, function()
        
    for i=startIndex,endIndex do
        local tempAbility = caster:GetAbilityByIndex(i):GetName()
        caster:RemoveAbility(tempAbility)
    end
    
    for i=startIndex,endIndex do
        local oldAbilityLevel = oldAbilities[i]["level"]
    
        local newAbilityName = spinSet[3][i+1]
        local newAbility = caster:AddAbility(newAbilityName)
    
        newAbility:SetAbilityIndex(i)
        newAbility:SetLevel(oldAbilityLevel)
    end
end)


Timers:CreateTimer(.3, function()
        
    for i=startIndex,endIndex do
        local tempAbility = caster:GetAbilityByIndex(i):GetName()
        caster:RemoveAbility(tempAbility)
    end
    startIndex=1
    local oldAbilityLevel = oldAbilities[0]["level"]

    local newAbilityName = GetRandomTableElement(abilityNames)
    newAbilitySet[newAbilityName] = true
    local newAbility = caster:AddAbility(newAbilityName .. "_one")
    
    newAbility:SetAbilityIndex(0)
    newAbility:SetLevel(oldAbilityLevel)
    newAbility:EndCooldown()
    EmitSoundOnClient("Hero_OgreMagi.Fireblast.x1", caster:GetPlayerOwner())
    for i=startIndex,endIndex do
        local oldAbilityLevel = oldAbilities[i]["level"]
    
        local newAbilityName = spinSet[1][i+1]
        local newAbility = caster:AddAbility(newAbilityName)
    
        newAbility:SetAbilityIndex(i)
        newAbility:SetLevel(oldAbilityLevel)
    end
end)

Timers:CreateTimer(.4, function()
        
    for i=startIndex,endIndex do
        local tempAbility = caster:GetAbilityByIndex(i):GetName()
        caster:RemoveAbility(tempAbility)
    end
    
    for i=startIndex,endIndex do
        local oldAbilityLevel = oldAbilities[i]["level"]
    
        local newAbilityName = spinSet[2][i+1]
        local newAbility = caster:AddAbility(newAbilityName)
    
        newAbility:SetAbilityIndex(i)
        newAbility:SetLevel(oldAbilityLevel)
    end
end)
Timers:CreateTimer(.5, function()
        
    for i=startIndex,endIndex do
        local tempAbility = caster:GetAbilityByIndex(i):GetName()
        caster:RemoveAbility(tempAbility)
    end
    
    for i=startIndex,endIndex do
        local oldAbilityLevel = oldAbilities[i]["level"]
    
        local newAbilityName = spinSet[3][i+1]
        local newAbility = caster:AddAbility(newAbilityName)
    
        newAbility:SetAbilityIndex(i)
        newAbility:SetLevel(oldAbilityLevel)
    end
end)

Timers:CreateTimer(.6, function()
    EmitSoundOnClient("Hero_OgreMagi.Fireblast.x1", caster:GetPlayerOwner())
    for i=startIndex,endIndex do
        local tempAbility = caster:GetAbilityByIndex(i):GetName()
        caster:RemoveAbility(tempAbility)
    end
    startIndex=2
    local oldAbilityLevel = oldAbilities[1]["level"]

    local newAbilityName = GetRandomTableElement(abilityNames)
    newAbilitySet[newAbilityName] = true
    local newAbility = caster:AddAbility(newAbilityName .. "_two")

    newAbility:SetAbilityIndex(1)
    newAbility:SetLevel(oldAbilityLevel)
    newAbility:EndCooldown()
    for i=startIndex,endIndex do
        local oldAbilityLevel = oldAbilities[i]["level"]
    
        local newAbilityName = spinSet[1][i+1]
        local newAbility = caster:AddAbility(newAbilityName)
    
        newAbility:SetAbilityIndex(i)
        newAbility:SetLevel(oldAbilityLevel)
    end
end)

Timers:CreateTimer(.7, function()
        
    for i=startIndex,endIndex do
        local tempAbility = caster:GetAbilityByIndex(i):GetName()
        caster:RemoveAbility(tempAbility)
    end
    
    for i=startIndex,endIndex do
        local oldAbilityLevel = oldAbilities[i]["level"]
    
        local newAbilityName = spinSet[2][i+1]
        local newAbility = caster:AddAbility(newAbilityName)
    
        newAbility:SetAbilityIndex(i)
        newAbility:SetLevel(oldAbilityLevel)
    end
end)

Timers:CreateTimer(.8, function()
        
    for i=startIndex,endIndex do
        local tempAbility = caster:GetAbilityByIndex(i):GetName()
        caster:RemoveAbility(tempAbility)
    end
    
    for i=startIndex,endIndex do
        local oldAbilityLevel = oldAbilities[i]["level"]
    
        local newAbilityName = spinSet[3][i+1]
        local newAbility = caster:AddAbility(newAbilityName)
    
        newAbility:SetAbilityIndex(i)
        newAbility:SetLevel(oldAbilityLevel)
    end
end)

Timers:CreateTimer(.9, function()
    EmitSoundOnClient("Hero_OgreMagi.Fireblast.x1", caster:GetPlayerOwner())
    for i=startIndex,endIndex do
        local tempAbility = caster:GetAbilityByIndex(i):GetName()
        caster:RemoveAbility(tempAbility)
    end
    startIndex=3
    local oldAbilityLevel = oldAbilities[2]["level"]

    local newAbilityName = GetRandomTableElement(abilityNames)
    newAbilitySet[newAbilityName] = true
    local newAbility = caster:AddAbility(newAbilityName .. "_three")

    newAbility:SetAbilityIndex(2)
    newAbility:SetLevel(oldAbilityLevel)
    newAbility:EndCooldown()
    StopSoundOn("Hero_EarthSpirit.RollingBoulder.Loop", caster)

end)

  Timers:CreateTimer( 1, function()

        -- Give a reward based on the number of matching abilities
        local numUniqueAbilities = TableCount(newAbilitySet)

        if numUniqueAbilities == 3 then
            -- do nothing
        elseif numUniqueAbilities == 2 then
            -- reward a bit of gold
            RewardGold(caster, lesserRewardGold)
        elseif numUniqueAbilities == 1 then
            -- reward a lot of gold
            RewardGold(caster, greaterRewardGold)
        end
    end)
end

function RewardGold(caster, rewardAmount)
    for i=1,rewardAmount do
        Timers:CreateTimer( .5+i*.3, function()
            caster.earnedbonusgold=rewardAmount
            caster:ModifyGold(1, false, 1)
            SendOverheadEventMessage(
                caster:GetPlayerOwner(), 
                OVERHEAD_ALERT_GOLD, 
                caster, 
                1, 
                caster:GetPlayerOwner()
            )
        end)
    end
end