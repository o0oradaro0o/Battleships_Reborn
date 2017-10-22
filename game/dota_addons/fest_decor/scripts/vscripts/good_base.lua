

GoodTempPoints = 0

function StartAddingPoints(trigger)
GoodTempPoints=GoodTempPoints+1
storage:SetGoodPoints(GoodTempPoints)

if  trigger.activator:IsRealHero() and trigger.activator:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		local ability = "Deopsit_Orbs"
		trigger.activator:AddAbility(ability)
		local abil = trigger.activator:GetAbilityByIndex(1)
		abil:SetLevel(1)
end

end


function StopAddingPoints(trigger)
    -- Find the respective exit to every entrance

	GoodTempPoints=GoodTempPoints-1
	    storage:SetGoodPoints(GoodTempPoints)
		
	if trigger.activator:IsRealHero() and trigger.activator:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		local ability = "Deopsit_Orbs"
		trigger.activator:RemoveAbility(ability)
		trigger.activator:RemoveModifierByName("orb_deposit")
								
	end

end
