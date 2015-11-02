

local debounce=false

local distanceFactor=100
local number=4
local nearnessLimit=20
local yOffset=-320
local printRandom = false
local maxDistance=30
local shapeCount=0
local terrainPerTouch=100
local connection
local hits=0
local maxHits=5
local yHeightLimit=2
local alwaysRing=false
local alwaysBlock=false
local ut = require(workspace.Utils);
local tu = require(workspace.TerrainUtils);

local debounce=false

tu.distanceFactor=100
local number=4
local nearnessLimit=20
local yOffset=-320
local shapeCount=0
local terrainPerTouch=1
local connection
local hits=0
local maxHits=5
local yHeightLimit=2

function placeNewIceMachine()
	local newOrigin = Vector3.new(0,-10,0)+script.Parent.Position
	local newIceMachine=script.Parent:clone()
	newIceMachine.Parent=workspace
	newIceMachine.Position=newOrigin
end

function createNTerrain(hit)
	hits=hits+1

	if (hit.Parent and hit.Parent:FindFirstChild("Humanoid")) then
		if debounce==false then
			script.Parent.BrickColor=BrickColor.new("Really red")
			debounce=true
			for _ = 1,terrainPerTouch do
				local options={offset=script.Parent.Position + Vector3.new(0, yOffset, 0)}
				options["shape"]="ring"
				--options["pos"]=Vector3.new(0,0,0)
				--options["pos"]=Vector3.new(ut.powup(1000),ut.powup(1000),ut.powup(1000))
				--options["degreeStep"]=5
				--options["stretchVector"]=Vector3.new(math.random()*4-2, math.random()*4-2, math.random()*4-2)
				--options["randomRotationPercentage"]=100
				options["rotation"] = CFrame.Angles(math.pi*2*math.random(), math.pi*2*math.random(), math.pi*2*math.random())
				--options["stretchVector"]=Vector3.new(2,1,10).unit
				options["airPercentage"]=10
				--options["randomRotationPercentage"]=10
				options["useExtraY"]=1
				options["useRadiusMult"]=ut.oneInBool(2)
				options["useRadiusPeriodicScaler"]=true
				--options["waitPerStep"]=0.00001
				tu.makeTerrain(options)
				shapeCount=shapeCount+1
				wait(0.05)
				tu.distanceFactor=tu.distanceFactor*1.001
			end

			--print("distanceFactor=", distanceFactor, " pertouch=", terrainPerTouch)
			--if hits>maxHits then
--				placeNewIceMachine()
				--connection:disconnect()
--				script.Parent.BrickColor=BrickColor.new("Electric blue")
--			end
			wait(0.4)
			debounce=false
		else
			script.Parent.BrickColor=BrickColor.new("New Yeller")
			wait(0.4)
		end
	end

end

wait(1)
connection = script.Parent.Touched:connect(createNTerrain)
startOptions={shape="ring",
	pos=Vector3.new(0,250,0),
	thickness=13,
	radius=10,
	useExtraY=false,
	radiusMult=1,
	reverser=1,
	degreeStep=1,
	material=Enum.Material.Glacier,
	rotation=false}
tu.setupMissingTerrainOptions(startOptions)
ut.printTable(startOptions)
tu.materialRing(startOptions)
function log(n)
	return math.log(n)
end

function sq(n)
	return math.sqrt(n)
end

function powup(n)
	--occasionally return numbers as big as n, but mostly numbers much smaller
	local width=math.sqrt(math.sqrt(n))
	local num=math.random()*width
	return num*num*num*num
end

function tr(maxx, abs)
	--return a number centered around zero, falling off to maxx,
	--absolutify it if abs==true
	--based on x^2
	if abs==nil then
		abs=false
	end
	local num=math.random()*math.sqrt(maxx)
	local val=num*num
	if abs then
		return math.abs(res)
	end
end

function oneIn(nn)
	local rnd=math.random()*nn
	if rnd<1 then
		return true
	end
	return false
end

function radians(degs)
	return degs/180*math.pi
end

function rndRadians()
	return radians(math.random()*360)
end

function rndDegrees()
	return math.random()*360
end

function rb2(size, count, abso)
	if abso==nil then
		abso=true
	end
	local res=0
	for _ = 1,count do
		res=res+math.random()*size-size/2
	end
	if abso then
		res=math.abs(res)
	end
	return res
end


function chooseShape()
	if alwaysRing then
		return 'ring'
	end
	if alwaysBlock then
		return Enum.PartType.Block
	end
	local choice=math.random()*50
	local shape
	if choice>30 then
		return Enum.PartType.Ball
	end
	if choice>5 then
		return Enum.PartType.Block
	end
	if choice>0 then
		return 'ring'

	end
end

function rb(pper, nnumber, equalize, nonzero)

	if pper==nil then
		pper=distanceFactor
	end
	if nnumber==nil then
		nnumber=number
	end
	if equalize==nil then
		equalize=true
	end
	if nonzero==nil then
		nonzero=true
	end
	local res=0
	for _ = 1,nnumber do
		res=res+math.random()*pper
	end

	if equalize then
		local avg=pper*nnumber/2
		res=res-avg
	end
	if nonzero and res==0 then
		res=0.0001
	end
	if printRandom then
		print(pper, number, res)
	end

	return res
end

function polarToCartesian(origin, degrees, length)
	local radians=degrees/180*math.pi
	local xpart = math.cos(radians)
	local zpart = math.sin(radians)
	local xscaled=xpart*length
	local zscaled=zpart*length
	local xoffset=xscaled+origin.x
	local zoffset=zscaled+origin.z
	local yoffset=0+origin.y
	local res=Vector3.new(xoffset, yoffset, zoffset)
	return res
end

function placeNewIceMachine()
	local newOrigin = Vector3.new(0,-10,0)+script.Parent.Position
	local newIceMachine=script.Parent:clone()
	newIceMachine.Parent=workspace
	newIceMachine.Position=newOrigin
end

function createNTerrain(hit)
	hits=hits+1
	if (hit.Parent and hit.Parent:FindFirstChild("Humanoid")) then
		if debounce==false then
			script.Parent.BrickColor=BrickColor.new("Really red")
			debounce=true
			for _ = 1,terrainPerTouch do
				createTerrain()
				wait(0.05)
				distanceFactor=distanceFactor*1.001
			end

			--print("distanceFactor=", distanceFactor, " pertouch=", terrainPerTouch)
			if hits>maxHits then
				placeNewIceMachine()
				--connection:disconnect()
				script.Parent.BrickColor=BrickColor.new("Electric blue")
			end
			wait(0.4)
			debounce=false
		else
			script.Parent.BrickColor=BrickColor.new("New Yeller")
			wait(0.4)
		end
	end

end

function materialRing(center, radius, thickness, material, maxDegs)
	if material==nil then
		material=Enum.Material.Glacier
	end
	local reverser=(math.random(2)*2)-3

	local mult=1

	local useSinFrac = false
	local sinFrac=powup(50)
	local sinPeriodMult = 1
	local extraRadius=0
	local useExtraY=false
	local extraY=0
	local extraYMult=1
	local yMultPeriodScale=1
	local startDegs=math.random(360)
	if maxDegs == nil then
		if oneIn(2) then
			--spiral out of control
			mult=powup(100)-powup(100)
			if mult ~= 0 then
				mult=1/mult
			else
				mult=0
			end
			mult=mult/100 --scale it down
			mult=1+mult -- 1 + 1/(rnd(100) - rnd(100)) ==
		end

		if oneIn(2) then --spirals - non circular, slow or long periods
			useSinFrac = true --rb2(3,4)
			sinFrac=powup(50)
			sinPeriodMult = 1/math.random(5)
		end

		if oneIn(2) then
			useExtraY=true
			extraYMult=powup(200)
			yMultPeriodScale = powup(100)-powup(100)
			if yMultPeriodScale~= 0 then
				yMultPeriodScale=1/yMultPeriodScale
			else
				yMultPeriodScale=0
			end
			yMultPeriodScale=yMultPeriodScale/100 --scale it down
			yMultPeriodScale=1+yMultPeriodScale-- 1 + 1/(rnd(100) - rnd(100)) ==
		end
		maxDegs=startDegs+(powup(400))+40
		maxDegs=math.max(maxDegs, startDegs+270)
	else
		maxDegs=startDegs+360
	end
	--print(" radius=", radius," mult=",mult," startDegs=",startDegs," maxDegs=",maxDegs," thickness=",thickness, "Material=",material)
	if thickness<0 then
		print("bad thickness.", thickness)
	end
	for degs=startDegs,maxDegs,0.1 do
		local coord=polarToCartesian(center, degs*reverser, radius+extraRadius)
		coord=coord+Vector3.new(0, extraY, 0)
		if math.abs(coord.x)>1000 or math.abs(coord.y)>1000 or math.abs(coord.z)>10000 then
			--print("too far.", coord.x, coord.y, coord.z)
		else
			if useSinFrac then
				--print("sinFrac=",sinFrac)
			end

			--I should 3d rotate this ring.  which would be neat
			game.Workspace.Terrain:FillBall(coord, thickness, material)
			radius=radius*mult
			if useSinFrac ~= false then
				extraRadius=radius/sinFrac*math.sin((degs-startDegs)*sinPeriodMult/(2*math.pi))
				--print("Extraradius",extraRadius)
			end
			if useExtraY==true then
				extraY=math.sin((degs-startDegs)*yMultPeriodScale/(2*math.pi)) * extraYMult
				--print("extraY=",extraY)
			end
		end
	end
end

function createTerrain()
	local producerOffset=script.Parent.Position
	local pos = Vector3.new(powup(distanceFactor, 2, false), -1*powup(200)+powup(200)+yOffset, powup(distanceFactor, 2, false)) + producerOffset

	local shape=chooseShape()
	local size= Vector3.new(powup(120)+4, powup(40)+4, powup(120)+4)

	--no nearby start!
	local overlapsx = false
	local overlapsy = false
	local overlapsz = false
	if math.abs(pos.x)-size.x<nearnessLimit then
		overlapsx = true
	end
	if math.abs(pos.y)-size.y<nearnessLimit then
		overlapsy = true
	end
	if math.abs(pos.z)-size.z<nearnessLimit then
		overlapsz = true
	end
	if size.x<0 or size.y<0 or size.z<0 then
		print("bad size", size)
	end
	if overlapsx==true and overlapsy==true and overlapsz==true then
		--print("overlaps")
	else
		shapeCount=shapeCount+1
		local material=Enum.Material.Glacier
		if oneIn(3) then
			material=Enum.Material.Air
		end
		drawTerrainShape(shape, pos, size, material)

	end
end

function drawTerrainShape(shape, pos, size, material)
	if pos.x>1000 or pos.y>1000 or pos.z>10000 then

	else
		if shape==Enum.PartType.Ball then
			game.Workspace.Terrain:FillBall(pos,size.y, material)
		else
			if shape=='ring' then
				--materialRing(center, radius, thickness, material)
				local radius, thickness
				radius=powup(2500)+10
				thickness=rb2(5,10)+1
				if radius<thickness then

					local temp=radius
					radius=thickness
					thickness=temp
					print("switch radius=",radius,'thickness=',thickness)
				end
				materialRing(pos, radius, thickness, material)
			else
				local object= Instance.new("Part", workspace)
				object.Shape = shape
				object.Position = pos
				if oneIn(4) then
					object.CFrame=object.CFrame*CFrame.Angles(math.random()*math.pi*2,math.random()*math.pi*2,math.random()*math.pi*2)
				end
				object.Size = size
				if object.Position.y>script.Parent.Position.y-yHeightLimit then
					--print(pos,shape,size, "  Yoffset=",yOffset)
					--print("too high.")
				else
					game.Workspace.Terrain:FillBlock(object.CFrame, object.Size, material)
				end
				object:Destroy()
			end
		end
	end
end

connection = script.Parent.Touched:connect(createNTerrain)
materialRing(Vector3.new(0,250,0), 13, 10, nil, 360)
