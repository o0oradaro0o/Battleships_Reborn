

BadTempPoints = 0

function StartAddingPoints(trigger)
BadTempPoints=BadTempPoints+1
storage:SetBadPoints(BadTempPoints)

if  trigger.activator:IsRealHero() and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		local ability = "Deopsit_Orbs"
		trigger.activator:AddAbility(ability)
		local abil = trigger.activator:GetAbilityByIndex(1)
		abil:SetLevel(1)
end

end


function StopAddingPoints(trigger)
    -- Find the respective exit to every entrance

	BadTempPoints=BadTempPoints-1
	    storage:SetBadPoints(BadTempPoints)
		
	if trigger.activator:IsRealHero() and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		local ability = "Deopsit_Orbs"
		trigger.activator:RemoveAbility(ability)
		trigger.activator:RemoveModifierByName("orb_deposit")
								
	end

end
