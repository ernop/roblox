ut=require(workspace.Utils)

local tt = {}

function tt.TransmogrifyPlayers()
	local players = ut.getPlayers()
	for _,player in pairs(players) do
		if player ~= nil and player.Character ~= nil and player.Character.PrimaryPart ~= nil then
			local loc = player.Character:GetPrimaryPartCFrame()
			tt.TransmogrifyBelow(loc)
		end
	end
end

function tt.TransmogrifyBelow(cf, material)
	--transmogrify terrain at/below pos

	if material==nil then
		material=Enum.Material.Grass
	end
	--print("transmog", cf, material)


	if cf==nil then
		print("nil")
		return
	end

	local vec=Vector3.new(cf.X, cf.Y, cf.Z)
	--print("would=", cf, "vec=",vec)
	local region = Region3.new(vec + Vector3.new(-2,-8,-2), vec + Vector3.new(2,0,2))
	region = region:ExpandToGrid(4)
	if region==nil then
		print("nil region")
		return
	end
	local oldMaterial, oldOccupancy = game.Workspace.Terrain:ReadVoxels(region, 4)
	local size = oldMaterial.Size
	if 0 then
		--print("got region",region)
		--print("got size",size)
		--print("got material", material)
		--ut.printTable(material)
		--print("got occupancy", occupancy)
		--ut.printTable(occupancy)
	end


	local newMaterial, newOccupancy = nil, nil
	if material ~= Enum.Material.Air then
		--painting
		newMaterial = ut.create3dTable(size)
		newOccupancy = oldOccupancy
		for xx = 1, size.X do
			for yy= 1, size.Y do
				for zz=1, size.Z do
					--print("xx",xx,"yy",yy,"zz",zz)
					--print("mat xx yy", ut.printTable(material[xx][yy]))
					newMaterial[xx][yy][zz]=material
				end
			end
		end
	end
	if material == Enum.Material.Air then
		--clearing
		newOccupancy = ut.create3dTable(size)
		newMaterial = oldMaterial
		for xx = 1, size.X do
			for yy= 1, size.Y do
				for zz=1, size.Z do
					--print("xx",xx,"yy",yy,"zz",zz)
					newOccupancy[xx][yy][zz]=math.max(0, oldOccupancy[xx][yy][zz]-0.05)
					--print("occ xx yy", ut.printTable(newOccupancy[xx][yy]))
				end
			end
		end
	end

	--print("OCC", ut.printTable(newOccupancy))
	--print("Material", ut.printTable(newMaterial))
	game.Workspace.Terrain:WriteVoxels(region, 4, newMaterial, newOccupancy)












end

return tt
