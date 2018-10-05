--map
currentroom = {}

currentmap = {}

function createroom(fill)
 room = {}
 for i = 0, 15 do
  room[i] = {}
  for j = 0, 15 do
  	room[i][j] = fill -- fill the values here
  end
 end
 return room
end

--	use to set the current map with mset
function setroom(r)
	for x = 0, 15 do
  for y = 0, 15 do
  	cts = r[x][y]
  	if(cts > 0)then
 			cspr = tilesets[cts].tiles[gettileid(r,x,y,cts)]
  		mset(x,y,cspr.sprid)
  	end
  end
 end
end

function renderroom(r)
	for x = 0, 15 do
  for y = 0, 15 do
  	cts = r[x][y]
  	if(cts > 0)then
 			cspr = tilesets[cts].tiles[gettileid(r,x,y,cts)]
  		spr(cspr.sprid,x*8,y*8,1,1,cspr.flipx,cspr.flipy)
  	end
  end
 end
end

function gettileid(r,x,y,t)
	up = 0
	down = 0
	left = 0
	right = 0
	
	if(x+1 < 16 and r[x+1][y] == t) or x+1 >= 16 then
 	right = 1
	end
	if(x-1 > -1 and r[x-1][y] == t) or x-1 <= -1 then
		left = 1
	end
	if(y-1 > -1 and r[x][y-1] == t) or y-1 <= -1 then
		up = 1
	end
	if(y+1 < 16 and r[x][y+1] == t) or y+1 >= 16  then
		down = 1
	end
	
	return (1*up)+(2*left)+(4*right)+(8*down)+1
end


function fillrow(r,col,num)
	for x = 0, 15 do
   r[x][col] = num
 end
	return r
end

function fillcol(r,row,num)
	for y = 0, 15 do
   r[row][y] = num
 end
	return r
end

function fillcube(r,x,y,w,h,num)
	for cy = 0, h do
		for cx = 0, w do
			local ccx = x-flr(w/2) + cx
			local ccy = y-flr(h/2) + cy
			if ccx < 16 and ccx > -1 and ccy < 16 and ccy > -1 then
				r[ccx][ccy] = num
			end
  		end
 	end
	return r
end

function clearroom()
	for x = 0, 15 do
  for y = 0, 15 do
  	mset(x,y,0)
  end
 end
end