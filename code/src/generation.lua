-- generation
roomtype = 2

function newroom(right)
	-- delete all entities but the player
	for i in all(entities)  do 
		if i.tag != "player" then
			del(entities, i)
		end
	end

	clearroom()
	tr = generateroom(right)
	setroom(tr)
end


function generateroom(right)
	local temproom = createroom(roomtype)
	
	local chunksize = 2
	local cy = 8
	local mincy
	local maxcy
	
	
	--temproom = fillcube(temproom,flr(rnd(15)),flr(rnd(15)),flr(rnd(2))+1,flr(rnd(2))+1,1)
	
	
	for x = 0, 15 do
		chunksize = flr(rnd(4))+1
		mincy = chunksize + 1
		maxcy = 15 - (chunksize+1)
		
		local cx
		
		if right then
			cx = x
		else
			cx = 15-x
		end
		
		temproom = fillcube(temproom,cx,cy,chunksize,chunksize,0)
		
		if ((cx+1)%3)-2 == 0 then
			local c = coin ()
			c.init(c)
			c.x = cx*8
			c.y = cy*8
			add(entities,c)
		end
		
		
		if flr(rnd(2)) == 1 then
		 cy+=1
		else
			cy-=1
		end
		
		if(cy < mincy)then
			cy = mincy
		end
		if(cy > maxcy)then
			cy = maxcy
		end
	end
	
	temproom = fillrow(temproom,0,roomtype)
	temproom = fillrow(temproom,15,roomtype)


	local spawnpoints = {}
	local fspawnpoints = {}

 for i = 4, 11 do
  for j = 1, 14 do
  	if temproom[i][j] == 0 then
  		if temproom[i][j+1] > 0 then
  			add(fspawnpoints,{x=i,y=j})
  		else
  			add(spawnpoints,{x=i,y=j})
  		end
  	end
  end
 end
	
	
	
	-- spawn enemies
	
	for n = 0, flr(rnd(2)) do
		if #spawnpoints > 0 then
  	local index = flr(rnd(#spawnpoints-1)+1)
  	local point = spawnpoints[index]
  	spawnenemy(false, point.x,point.y)
  	del(spawnpoints, point)
		end
	end

	for n = 0, flr(rnd(3)) do
		if #fspawnpoints > 0 then
  	local index = flr(rnd(#fspawnpoints-1)+1)
  	local point = fspawnpoints[index]
  	spawnenemy(true, point.x,point.y)
  	del(fspawnpoints, point)
		end
	end

	return temproom
end


function spawnenemy(g,tx,ty)
	
	local e
	
	if g then
 	local index = rnd(1)
 	if index >=0.5 then
 		 e = enemy_snake ()
 	else
 		 e = enemy_spike ()
 	end
	else
		e = enemy_fb ()
	end

	e.init(e)
	e.x = tx*8
	e.y = ty*8
	add(entities,e)
end