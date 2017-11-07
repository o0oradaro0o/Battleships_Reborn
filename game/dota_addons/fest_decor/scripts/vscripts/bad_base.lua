

BadTempPoints = 0

function StartAddingPoints(trigger)
	local pointValue = 1
	print('[DepositOrb]  StartAddingPoints BadTempPoints')
	if string.match(trigger.activator:GetUnitName(), "2")  then
		pointValue=5

	elseif string.match(trigger.activator:GetUnitName(), "4")  then
		pointValue=3

	elseif not string.match(trigger.activator:GetUnitName(), "tree") then
		pointValue = 1
	end
				
	if not  trigger.activator:IsRealHero() then
		BadTempPoints=BadTempPoints+pointValue
		storage:SetBadPoints(BadTempPoints)
	end

	if  trigger.activator:IsRealHero() and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			local ability = "Deopsit_Orbs"
			if trigger.activator:GetAbilityByIndex(2) == nil  or string.match(trigger.activator:GetAbilityByIndex(2):GetName(), "hidden") then
			if trigger.activator:GetAbilityByIndex(2)~= nil then
				trigger.activator:RemoveAbility(trigger.activator:GetAbilityByIndex(2):GetName())
				end
				trigger.activator:AddAbility(ability)
				local abil = trigger.activator:GetAbilityByIndex(2)
				abil:SetLevel(1)
					else
					if trigger.activator:GetAbilityByIndex(3)~= nil then
						trigger.activator:RemoveAbility(trigger.activator:GetAbilityByIndex(3):GetName())
					end
					trigger.activator:AddAbility(ability)
				local abil = trigger.activator:GetAbilityByIndex(3)
				abil:SetLevel(1)
					end
	end

end


function StopAddingPoints(trigger)
    -- Find the respective exit to every entrance
	local pointValue = 1
	if string.match(trigger.activator:GetUnitName(), "2")  then
		pointValue=5

	elseif string.match(trigger.activator:GetUnitName(), "4")  then
		pointValue=3

	elseif not string.match(trigger.activator:GetUnitName(), "tree") then
		pointValue = 1
	end
				
	if not  trigger.activator:IsRealHero() then
		BadTempPoints=BadTempPoints-pointValue
	    storage:SetBadPoints(BadTempPoints)
	end	
	if trigger.activator:IsRealHero() and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		local ability = "Deopsit_Orbs"
		trigger.activator:RemoveAbility(ability)
		trigger.activator:RemoveModifierByName("orb_deposit")

								
	end

end
