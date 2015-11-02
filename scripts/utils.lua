--Brouhahaha's TerrainUtils Verison 0.00001

local tu = {}

ut=require(workspace.Utils)

tu.alwaysRing=false
tu.alwaysBlock=false
tu.distanceFactor=1

function tu.chooseShape()
	local choice=math.random()*50
	local shape
	if choice>30 then
		--return Enum.PartType.Ball
		return "ball"
	end
	if choice>5 then
		--return Enum.PartType.Block
		return "block"
	end
	if choice>0 then
		return "ring"

	end
end

function tu.outOfLimits(pos, limits)
	return pos.x>limits.x or pos.y>limits.y or pos.z>limits.z or pos.x<limits.negx or pos.y<limits.negy or pos.z<limits.negz
end


--required options per shape.
--ring
--ball
--block

--every shape needs: offset, shape, pos, material, limits, airPercentage
--this is the list of options that will be autogenerated to reasonable values by setupMissingTerrainOptions.
--you can also provide your own if you want.
tu.OptionsAllShapesCanHave={offset=true, shape=true, pos=true, material=true, limits=true, airPercentage=true}

--options each shave can have; boolean represents whether a non-nil value is required/optional
tu.Shape2Option={
	ring={
		degreeStep=true,
		maxDegs=true,
		radius=true,
		reverser=true,
		rotation=true,
		startDegs=true,
		stretchVector=true,
		thickness=true,
		waitPerStep=true,

		--toggles
		useExtraY=true,
		useRadiusMult=true, --sets radiusMult
		useRadiusPeriodicScaler=true, --sets radiusPeriodicScaler, radiusMultiplicativeSinPeriod

		--background set options.
		radiusMult=false,
		yMultPeriod=false,
		yMultScale=false,
		radiusPeriodicScaler=false,
		radiusMultiplicativeSinPeriod=false,
	},
	ball={
		ballradius=true,
	},
	block={
		rotation=true,
		size=true,
	},
}

function checkOptions(options)
	--checks that all the options set are actually valid for this shape.
	for k, v in pairs(options) do
		if tu.OptionsAllShapesCanHave[k] or shapeNeedsOption(options['shape'], k) ~= nil then
			--print("option correctly set.  key=",k,"val=",v)
		else
			print("you have set an options which isnt actually used in this case.  watch out.  key=",k,"val=",v)
		end
	end
	for k,v in pairs(tu.Shape2Option[options['shape']]) do
		if v and options[k]==nil then
			print("this shape is supposed to have an option but it was set to nil. ", k)
		end
	end


end

function shapeNeedsOption(shape, option)
	return tu.Shape2Option[shape] and tu.Shape2Option[shape][option]
end

function tu.setupMissingTerrainOptions(options)
	--everything needs these options
	if options["offset"]==nil then options["offset"]=Vector3.new(0,0,0) end
	if options["shape"]==nil then options["shape"]=tu.chooseShape() end
	if options["pos"]==nil then
		options["pos"]= Vector3.new(
					ut.powup(tu.distanceFactor),
					-1*ut.powup(200)+ut.powup(200),
					ut.powup(tu.distanceFactor))
					+ options["offset"]
		--print("pos set at",options["pos"])
	end

	if options["material"]==nil then
		options["material"]=Enum.Material.Glacier
		if options["airPercentage"] then
			if math.random()*100 < options["airPercentage"] then
				options["material"] = Enum.Material.Air
			end
		end
	end

	if options['waitPerStep']==nil then
		options['waitPerStep']=0.0
	end

	if options["limits"]==nil then --do not draw object if it goes out of these bounds
		options["limits"]={x=1000, y=1000, z=1000, negx=-1000, negy=-1000, negz=-1000}
	end

	--whereas these may not need to be calculated for every shape.
	if options["size"]==nil and shapeNeedsOption(options["shape"], "size") then
		options["size"]= Vector3.new(ut.powup(120)+4, ut.powup(40)+4, ut.powup(120)+4)
	end
	if options["ballradius"]==nil and shapeNeedsOption(options["shape"], "ballradius") then
		options["ballradius"]= ut.powup(40)+4
	end
	if options["rotation"]==nil and shapeNeedsOption(options["shape"], "rotation") then
		options["rotation"]=CFrame.Angles(0,0,0)
		if options["randomRotationPercentage"] then
			if math.random()*100 < options["randomRotationPercentage"] then
				options["rotation"]=CFrame.Angles(math.random()*math.pi*2,math.random()*math.pi*2,math.random()*math.pi*2)
			end
		end

	end

	--ring options
	if options["radius"] == nil and shapeNeedsOption(options["shape"], "radius") then
		--options["radius"]=math.abs(ut.powup(500)+ut.powup(50)- ut.powup(50) + ut.powup(50) - ut.powup(50))+2
		options["radius"]=math.abs(math.random(500)-math.random(500))
	end
	if options["thickness"] == nil and shapeNeedsOption(options["shape"], "thickness") then
		options["thickness"]=ut.powupN(40, 50)+math.random(10)
	end
	if options["reverser"] == nil and shapeNeedsOption(options["shape"], "reverser") then
		options["reverser"]=ut.flipCoin()
	end

	if shapeNeedsOption(options["shape"], "useRadiusPeriodicScaler") then
		--give extra radius
		if options["useRadiusPeriodicScaler"] == nil then
			options["useRadiusPeriodicScaler"] = false
		end
		if options["useRadiusPeriodicScaler"] then
			if options["radiusPeriodicScaler"]==nil then
				options["radiusPeriodicScaler"] = 1/ut.powup(500) --what extra fraction of the current radius to mult
			end
			if options["radiusMultiplicativeSinPeriod"] == nil then
				options["radiusMultiplicativeSinPeriod"] = ut.powup(20)+0.001  --how many full sin waves should be contained in one revolution
			end
		end
	end

	if options["stretchVector"] == nil and shapeNeedsOption(options["shape"], "stretchVector") then
		options["stretchVector"] = Vector3.new(1,1,1)
	end

	if options["useExtraY"] == nil then
		options["useExtraY"] = false
	end

	if options["useExtraY"] and shapeNeedsOption(options["shape"], "useExtraY") then
		--extra Y added to a ring.
		--the value determined will be scaled by yMultScale
		if options ["yMultPeriod"] == nil then
			options["yMultPeriod"]= ut.powup(20)+1
			if ut.flipCoin()>0 then
				options["yMultPeriod"]= 1
			end
		end
		if options["yMultScale"] == nil then
			options["yMultScale"]=ut.powup(100)+ut.powup(10) --add this much, multiplied by sin of the angle * yMultPeriod, to the Y.
		end
	end

	if options["startDegs"]==nil and shapeNeedsOption(options["shape"], "startDegs") then
		options["startDegs"]=math.random(360)
	end

	if options["maxDegs"]==nil and shapeNeedsOption(options["shape"], "maxDegs") then
		options["maxDegs"]=math.abs(options["startDegs"]+360+ut.powup(400)-ut.powup(200))
	end

	if options["degreeStep"]==nil and shapeNeedsOption(options["shape"], "degreeStep") then
		options["degreeStep"]=0.25
	end

	if options["useRadiusMult"] == nil and shapeNeedsOption(options["shape"], "useRadiusMult") then
		options["useRadiusMult"] = false
	end

	if options["useRadiusMult"] then
		--ring spirals in / out at a constant rate
		local radiusMult=1
		radiusMult = ut.powup(100) - ut.powup(100)
		if radiusMult ~= 0 then
			radiusMult = 1/radiusMult
		else
			radiusMult = 0
		end
		radiusMult = radiusMult/100 --scale it down
		radiusMult = 1 + radiusMult
		options["radiusMult"]=radiusMult
	end
	checkOptions(options)
end

function tu.materialRing(options)
	local extraRadius = 0 --from radiusmult and also useRadiusScaler
	local extraY = 0
	local workingRadius = options["radius"]
	for degs = options["startDegs"], options["maxDegs"], options["degreeStep"] do
		local radius = workingRadius + extraRadius
		local coord = ut.polarToCartesian(options['pos'], degs*options['reverser'], radius)
		coord = coord+Vector3.new(0, extraY, 0)
		if options["rotation"] then --rotate the vector.
			local gap=coord-options["pos"]
			local rotated = options["rotation"]*gap
			coord = options["pos"] + rotated
		end

		if tu.outOfLimits(coord, options["limits"]) then
			print("too far.", coord.x, coord.y, coord.z)
			return
		else
			--I should 3d rotate this ring.  which would be neat
			game.Workspace.Terrain:FillBall(coord, options["thickness"], options["material"])
			if options["useRadiusMult"] then
				workingRadius=workingRadius + workingRadius * (options["radiusMult"]-1) * options["degreeStep"]
			end

			if options["useRadiusPeriodicScaler"] then
				local thisAngleScaler = math.sin((degs-options["startDegs"])*options["radiusMultiplicativeSinPeriod"]*2*math.pi/360)
				extraRadius = workingRadius * thisAngleScaler * options["radiusPeriodicScaler"]
			end
			if options["useExtraY"] then
				extraY=math.sin((degs-options["startDegs"])*options["yMultPeriod"]*2*math.pi/360) * options["yMultScale"]
			end
		end
		if options['waitPerStep']>0 then
			wait(options['waitPerStep'])
		end
	end
end


function tu.makeTerrain(options)
	tu.setupMissingTerrainOptions(options)
	print("MADE OPTIONS", string.rep("=",20))
	ut.printTable(options)

	if tu.outOfLimits(options["pos"], options["limits"]) then
		return
	end
	if options["shape"]=="ball" then
		game.Workspace.Terrain:FillBall(options["pos"],options["ballradius"], options["material"])
	end

	if options["shape"]=="ring" then
		tu.materialRing(options)
	end

	if options["shape"] == "block" then
		local object= Instance.new("Part", workspace)
		object.Shape = Enum.PartType.Block
		object.Position = options["pos"]--Brouhahaha's Utils Verison 0.00001

local ut = {}

function ut.flipCoin()
	return math.random(2)*2-3
end

function ut.powup(n)
	--occasionally return numbers as big as n, but mostly numbers much smaller
	return ut.powupN(n, 4)
end

function ut.powupN(num, N)
	--occasionally return numbers as big as n, but mostly numbers much smaller
	return math.pow(math.random(), N)*num
end

function ut.oneInBool(nn)
	local rnd=math.random()*nn
	if rnd<1 then
		return true
	end
	return false
end

function ut.rndRadians()
	return math.rad(math.random()*360)
end

function ut.rndDegrees()
	return math.random()*360
end

function ut.rb2(size, count, abso)
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

function ut.rb(pper, nnumber, equalize, nonzero)
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
	return res
end

function ut.rotateX(vec, angle)
	return Vector3.new(vec.x, vec.y*math.cos(angle)-vec.z*math.sin(angle), vec.y*math.sin(angle)+vec.z*math.cos(angle))
end

function ut.rotateY(vec, angle)
	return Vector3.new(vec.x*math.cos(angle)+vec.z*math.sin(angle), vec.y, -vec.x*math.sin(angle)+vec.z*math.cos(angle))
end

function ut.rotateZ(vec, angle)
	return Vector3.new(vec.x*math.cos(angle)-vec.y*math.sin(angle), vec.x*math.sin(angle)+vec.y*math.cos(angle), vec.z)
end

function ut.polarToCartesian(origin, degrees, length)
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

function ut.printTable(table, indent)

  indent = indent or 0;
  local keys = {};


  print(string.rep('  ', indent)..'{');
  indent = indent + 1;
  for k, v in pairs(table) do

    local key = k;
    if (type(key) == 'string') then
      if not (string.match(key, '^[A-Za-z_][0-9A-Za-z_]*$')) then
        key = "['"..key.."']";
      end
    elseif (type(key) == 'number') then
      key = "["..key.."]";
    end

    if (type(v) == 'table') then
      if (next(v)) then
        print(string.format("%s%s =", string.rep('  ', indent), tostring(key)));
        ut.printTable(v, indent);
      else
        print(string.format("%s%s = {},", string.rep('  ', indent), tostring(key)));
      end
    elseif (type(v) == 'string') then
      print(string.format("%s%s = %s,", string.rep('  ', indent), tostring(key), "'"..v.."'"));
    else
      print(string.format("%s%s = %s,", string.rep('  ', indent), tostring(key), tostring(v)));
    end
  end
  indent = indent - 1;
  print(string.rep('  ', indent)..'}');
end

return ut
		object.CFrame=options["rotation"]
		object.Size = options["size"]
		game.Workspace.Terrain:FillBlock(object.CFrame, object.Size, options["material"])
		object:Destroy()
	end
end

return tu
