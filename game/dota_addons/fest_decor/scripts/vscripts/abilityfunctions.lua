
PlayerColors = {
 {46, 106, 230},

 {92, 230, 173},

 {173, 0, 173},

 {220,217,10},

 {230, 98, 0},

 {230, 122, 176},

 {146, 164, 64},
 
 {92, 197, 224},
 
 {0, 119, 31},
 
 {149, 96, 0}
}


if abilityFunctions == nil then
	print ( '[AbilityFunctions] creating abilityFunctions' )
	abilityFunctions = {} -- Creates an array to let us beable to index abilityFunctions when creating new functions
	abilityFunctions.__index = abilityFunctions
end
 
function abilityFunctions:new() -- Creates the new class
	print ( '[AbilityFunctions] abilityFunctions:new' )
	o = o or {}
	setmetatable( o, abilityFunctions )
	return o
end
 
function abilityFunctions:start() -- Runs whenever the abilityFunctions.lua is ran
	print('[AbilityFunctions] abilityFunctions started!')
end

--MoveToPosition(Vector vDest)

function WinterMove(args)
	local casterUnit = args.caster
	
	--handle reseting animation timing
	if casterUnit.count==nil then
		casterUnit.count=0
		StartAnimation(casterUnit, {duration=2.0, activity=ACT_DOTA_RUN, rate=.5})
	end
	casterUnit.count=casterUnit.count+1
	
	--keep track of hero path
	if casterUnit.loclist==nil then
		casterUnit.loclist = {}
	end
		table.insert(casterUnit.loclist, 1, casterUnit:GetOrigin())
		if #casterUnit.loclist >10000 then
			casterUnit.loclist [#casterUnit.loclist] = nil
		end
		
	--move ther hero
	 local direction =  casterUnit:GetForwardVector()
	 
		if not IsPhysicsUnit(casterUnit) then
		Physics:Unit(casterUnit)
	end
	
	
	if casterUnit.targ_position~=nil then
		local targ_dist = (casterUnit.targ_position) - casterUnit:GetOrigin()*Vector(1,1,0)
		
		if targ_dist:Length() <200 then

			casterUnit.targ_position = (casterUnit:GetOrigin()+direction*1000)*Vector(1,1,0)

			casterUnit:MoveToPosition(  casterUnit:GetOrigin()+direction*1000)
		end
	end
		

	if casterUnit.presentList~=nil then
		local i=1
		for _,present in  pairs(casterUnit.presentList) do
			if present.direction==nil then
				present.direction=1
			end
			local height = 0;
			height = (present:GetOrigin()*Vector(0,0,1)):Length()
			if height>180 then
				present.direction=-1
				height=height+9*present.direction
			elseif height<60 then
				present.direction=1
				height=height+9*present.direction
			else
				height=height+9*present.direction
			end
			present:SetOrigin(casterUnit.loclist[10*i+5]*Vector(1,1,0)+Vector(1,1,height))
			i=i+1
		end
	end
	local vec = direction*40
	casterUnit:AddPhysicsVelocity(vec)
	
	if casterUnit.count%40==0 then
		StartAnimation(casterUnit, {duration=2.0, activity=ACT_DOTA_RUN, rate=.5})
		casterUnit.count=0
	end
end

function AddOrniment1(args)
	AddGift(args,"npc_dota_Orniment1")
end

function AddOrniment2(args)
	AddGift(args,"npc_dota_Orniment2")
end

function AddGift(args, name)
	local Hero = args.target
	local casterUnit = args.caster
	local deadloc = Vector(10000,10000,10000)
	casterUnit:SetOrigin(deadloc)
	
	if Hero.presentList==nil then
		Hero.presentList = {}
	end
	if #Hero.presentList >98 then
	  Notifications:Top(Hero:GetPlayerOwnerID(), {text="#many_orbs", duration=1.0, style={color=" #008000;", fontSize= "45px;", textShadow= "2px 2px 2px #ff0000;"}})
		return
	end
	
	 local creature = CreateUnitByName( name , Hero.loclist[#Hero.presentList*10+15] , true, nil, nil, Hero:GetTeamNumber() )
	 local pId = Hero:GetPlayerOwnerID()+1
	 if(pId == nil) then
	 pId = 1
	 end
	print(pId)
	if string.match(name, "Orniment1") then
		creature:SetRenderColor(PlayerColors[pId][1],PlayerColors[pId][2],PlayerColors[pId][3])
	 end
	 
		table.insert(Hero.presentList, creature)
		if #Hero.presentList >100 then
			Hero.presentList [#casterUnit.presentList] = nil
		end
		
	Timers:CreateTimer( 0.03, function()
	
      local self = args.caster
		self:ForceKill(true)
	 return nil
    end
  )
end

function killMe(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		print("killMe!")
		local casterUnit = args.target
			if casterUnit~=nil then
		stopPhysics(casterUnit)
		end
		
		local damageTable = {
			victim = casterUnit,
			attacker = casterUnit,
			damage = 10000,
			damage_type = DAMAGE_TYPE_PURE,
		}
		
		ApplyDamage(damageTable)
	if casterUnit.presentList~=nil then
		for _,present in  pairs(casterUnit.presentList) do
			present:RemoveSelf()
		end
	end
		casterUnit.presentList={}
	
end

function killMeIfImNotTheCaster(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
local casterUnit = args.caster

		local TargetUnit = args.target
		if TargetUnit~=casterUnit then
		
			if TargetUnit~=nil then
				stopPhysics(TargetUnit)
				end
				
				local damageTable = {
					victim = TargetUnit,
					attacker = TargetUnit,
					damage = 10000,
					damage_type = DAMAGE_TYPE_PURE,
				}
				
				ApplyDamage(damageTable)
			if TargetUnit.presentList~=nil then
				for _,present in  pairs(TargetUnit.presentList) do
					present:RemoveSelf()
				end
			end
				TargetUnit.presentList={}
		end
	
end



function DepositOrb(args) -- keys is the information sent by the ability
--print('[ItemFunctions] gunning_it started! ')
		local casterUnit = args.caster
		if casterUnit.presentList~= nil then
			if #casterUnit.presentList > 0 then
				
				creature = table.remove(casterUnit.presentList)
				creature:SetOrigin(casterUnit.loclist[10+5]*Vector(1,1,0)+Vector(1,1,250))
				
				local pointValue = 1
				if string.match(creature:GetUnitName(), "2")  then
					pointValue=5
					creature:SetModel("plus5")
				elseif string.match(creature:GetUnitName(), "3")  then
					pointValue=3
					creature:SetModel("plus3")
				else
					creature:SetModel("plus1")
					pointValue = 1
				end
				creature:SetModelScale(3)
				creature:MoveToPosition(Vector(0,-20000,200))
				local pId = casterUnit:GetPlayerOwnerID()+1
				 if(pId == nil) then
				 pId = 1
				 end
				creature:SetRenderColor(PlayerColors[pId][1],PlayerColors[pId][2],PlayerColors[pId][3])
				if casterUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
						storage:AddGoodStoredPoints(pointValue)
				else
						storage:AddBadStoredPoints(pointValue)
				end
				
				
				Timers:CreateTimer( 0.03, function()
					creature:ForceKill(true)
				end)
			else
				  Notifications:Top(casterUnit:GetPlayerOwnerID(), {text="#no_orbs", duration=1.0, style={color=" #008000;", fontSize= "45px;", textShadow= "2px 2px 2px #ff0000;"}})
				  
			end
			else
				 Notifications:Top(casterUnit:GetPlayerOwnerID(), {text="#no_orbs", duration=1.0, style={color="#008000",  fontSize="45px;", textShadow= "2px 2px #ff0000;"}})
		end
end


function stopPhysics(casterUnit) -- keys is the information sent by the ability

        local direction =  casterUnit:GetForwardVector()
        local vec = direction:Normalized() * 0.0
		
		Physics:Unit(casterUnit)
		
		casterUnit:SetPhysicsVelocity(vec)

end

function RandomMove(args)
	local casterUnit = args.caster
	casterUnit:MoveToPosition(  casterUnit:GetOrigin()+RandomVector( RandomFloat( 300, 400 )))
end

function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
    if type(t) ~= "table" then return end

    done = done or {}
    done[t] = true
    indent = indent or 0

    local l = {}
    for k, v in pairs(t) do
        table.insert(l, k)
    end

    table.sort(l)
    for k, v in ipairs(l) do
        -- Ignore FDesc
        if v ~= 'FDesc' then
            local value = t[v]

            if type(value) == "table" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..":")
                PrintTable (value, indent + 2, done)
            elseif type(value) == "userdata" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
            else
                if t.FDesc and t.FDesc[v] then
                    print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
                else
                    print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                end
            end
        end
    end
end

