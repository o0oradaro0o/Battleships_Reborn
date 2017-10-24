

BadTempPoints = 0

function StartAddingPoints(trigger)
	if not  trigger.activator:IsRealHero() then
		BadTempPoints=BadTempPoints+1
		storage:SetBadPoints(BadTempPoints)
	end

	if  trigger.activator:IsRealHero() and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			local ability = "Deopsit_Orbs"
			trigger.activator:AddAbility(ability)
			local abil = trigger.activator:GetAbilityByIndex(2)
			abil:SetLevel(2)
	end

end


function StopAddingPoints(trigger)
    -- Find the respective exit to every entrance
	if not  trigger.activator:IsRealHero() then
		BadTempPoints=BadTempPoints-1
	    storage:SetBadPoints(BadTempPoints)
	end	
	if trigger.activator:IsRealHero() and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		local ability = "Deopsit_Orbs"
		trigger.activator:RemoveAbility(ability)
		trigger.activator:RemoveModifierByName("orb_deposit")
								
	end

end
