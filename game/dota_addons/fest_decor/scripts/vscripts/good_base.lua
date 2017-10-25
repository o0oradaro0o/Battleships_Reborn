

GoodTempPoints = 0

function StartAddingPoints(trigger)
local pointValue = 1
	if string.match(trigger.activator:GetUnitName(), "2")  then
		pointValue=5

	elseif string.match(trigger.activator:GetUnitName(), "3")  then
		pointValue=3

	else
		pointValue = 1
	end

if not  trigger.activator:IsRealHero() then
	GoodTempPoints=GoodTempPoints+pointValue
	storage:SetGoodPoints(GoodTempPoints)
end

if  trigger.activator:IsRealHero() and trigger.activator:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		local ability = "Deopsit_Orbs"
		trigger.activator:AddAbility(ability)
		local abil = trigger.activator:GetAbilityByIndex(2)
		abil:SetLevel(2)
end

end


function StopAddingPoints(trigger)
    -- Find the respective exit to every entrance
	local pointValue = 1
	if string.match(trigger.activator:GetUnitName(), "2")  then
		pointValue=5

	elseif string.match(trigger.activator:GetUnitName(), "3")  then
		pointValue=3

	else
		pointValue = 1
	end
	
if not  trigger.activator:IsRealHero() then
	GoodTempPoints=GoodTempPoints-pointValue
	    storage:SetGoodPoints(GoodTempPoints)
end

	if trigger.activator:IsRealHero() and trigger.activator:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		local ability = "Deopsit_Orbs"
		trigger.activator:RemoveAbility(ability)
		trigger.activator:RemoveModifierByName("orb_deposit")
								
	end

end
