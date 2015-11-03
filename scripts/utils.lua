--Brouhahaha's Utils Verison 0.00001

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



function ut.create3dTable(size)
	local ret = {}
	for x = 1, size.X do
		ret[x] = {}
		for y = 1, size.Y do
			ret[x][y] = {}
		end
	end
	return ret
end


function ut.getPlayers()
  local players = {}
  local servicePlayers = game:GetService("Players")
  for _, player in pairs(servicePlayers:GetPlayers()) do
    table.insert(players, player)
  end
  return players
end











--==========================END

return ut
