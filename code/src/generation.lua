-- generation
roomtype = 2

function newbossroom()
	-- delete all entities but the player
	for i in all(entities)  do 
		if i.tag != "player" then
			del(entities, i)
		end
	end

	clearroom()
	local tr = createroom(0)
			
	tr = fillrow(tr,0,1)
	tr = fillrow(tr,15,1)
	tr = fillcol(tr,0,1)
	tr = fillcol(tr,15,1)
	
	
	tr[2][12] = 2
	tr[3][12] = 2
	tr[4][12] = 2

	tr[11][12] = 2
	tr[12][12] = 2
	tr[13][12] = 2

	tr[6][9] = 2
	tr[7][9] = 2
	tr[8][9] = 2
	tr[9][9] = 2

	tr[2][6] = 2
	tr[3][6] = 2
	tr[4][6] = 2

	tr[11][6] = 2
	tr[12][6] = 2
	tr[13][6] = 2

	tr[8][15] = 0
	tr[7][15] = 0


	local b = enemy_fbb()
	b.init(b)
	add(entities,b)

	setroom(tr)
end


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

	local fspawnpoints	=getspawnpointsa(temproom,0,4,0,0,0,1)
	local spawnpoints	=getspawnpoints(temproom,0,6,2)
	
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


function getspawnpoints(r,check,xm,ym)
	local points = {}
	
	for i = 0+xm, 15-xm do
		for j = 0+ym, 15-ym do
			if r[i][j] == check then
				add(points,{x=i,y=j})
			end
		end
	end

	return points
end

function getspawnpointsa(r,check,xm,ym,exclude,xo,yo)
	local points = {}
	
	for i = 0+xm, 15-xm do
		for j = 0+ym, 15-ym do
			if r[i][j] == check then
				if r[i+xo][j+yo] != exclude then
					add(points,{x=i,y=j})
				end
			end
		end
	end

	return points
end