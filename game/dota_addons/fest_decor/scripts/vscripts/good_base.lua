

GoodTempPoints = 0

function StartAddingPoints(trigger)


	local hero =  trigger.activator
	
local pointValue = 1
	if string.match(hero:GetUnitName(), "2")  then
		pointValue=5

	elseif string.match(hero:GetUnitName(), "4")  then
		pointValue=3

	elseif not string.match(hero:GetUnitName(), "tree") then
		pointValue = 1
	end

if not  hero:IsRealHero() then
	GoodTempPoints=GoodTempPoints+pointValue
	storage:SetGoodPoints(GoodTempPoints)
end

if  hero:IsRealHero() and hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		local ability = "Deopsit_Orbs"


		if hero:GetAbilityByIndex(2) == nil  or string.match(hero:GetAbilityByIndex(2):GetName(), "hidden") then
			if hero:GetAbilityByIndex(2)~= nil then
				hero:RemoveAbility(hero:GetAbilityByIndex(2):GetName())
				end
				hero:AddAbility(ability)
				local abil = hero:GetAbilityByIndex(2)
				abil:SetLevel(1)
					else
					if hero:GetAbilityByIndex(3)~= nil then
						hero:RemoveAbility(hero:GetAbilityByIndex(3):GetName())
					end
					hero:AddAbility(ability)
				local abil = hero:GetAbilityByIndex(3)
				abil:SetLevel(1)
					end
end

end


function StopAddingPoints(trigger)
    -- Find the respective exit to every entrance
	
	local hero =  trigger.activator
	
	if hero~=nil then
			local pointValue = 1
			if string.match(hero:GetUnitName(), "2")  then
				pointValue=5

			elseif string.match(hero:GetUnitName(), "4")  then
				pointValue=3

			elseif not string.match(hero:GetUnitName(), "tree") then
				pointValue = 1
			end
			
		if not  hero:IsRealHero() then
			GoodTempPoints=GoodTempPoints-pointValue
				storage:SetGoodPoints(GoodTempPoints)
		end

			if hero:IsRealHero() and hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				local ability = "Deopsit_Orbs"
				hero:RemoveAbility(ability)
				hero:RemoveModifierByName("orb_deposit")
										
			end
	end
end
