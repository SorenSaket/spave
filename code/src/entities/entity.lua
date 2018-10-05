function addstatics(e)
	e.x									=0	--x position
	e.y									=0	--y position
	e.xv								=0	--x velociy
	e.yv								=0	--y velociy
	e.grounded		=false	--is grounded
	e.flipped			=false	--is flipped
	e.flippedy		=false
	e.animtimer	= 0
	return e
end

function updateentity(e)
	-- ungrounded
	e.grounded = false
	
	-- starting postions
	--local lastx = e.x
	--local lasty = e.y
	
	-- gravity
	if e.hasgravity then
		e.yv += physics.g
	end
	
	-- apply drag
	if e.xv > 0.01 then
		e.xv -= physics.d
	elseif e.xv < -0.01 then
		e.xv += physics.d
	else
		e.xv = 0
	end
	
	-- max speed
	if e.xv > e.xmax then
		e.xv = e.xmax
	elseif e.xv < -e.xmax then
		e.xv = -e.xmax
	end
	
	-- apply movement
	e.x += e.xv
	e.y += e.yv
	
	-- collisions
	
	-- if walking right
	if(e.xv > 0)then
		-- if tile is to the right
 	if issolid(e.x+8,e.y+4) then
 		e.xv = 0
 		e.x 	= flr((e.x)/8)*8
 	end
 	e.flipped = false
 
 -- else if walking left
	elseif(e.xv < 0)then
		if issolid(e.x,e.y+4) then
 		
 		e.xv = 0
 		e.x = flr((e.x+8)/8)*8
 	end
 	e.flipped = true
	end
		
	-- down
	if (e.yv >=0) then
 	if issolid(e.x+1,e.y+8) or issolid(e.x+7 ,e.y+8) then
 		e.yv = 0
 		e.y = flr((e.y)/8)*8
 		e.grounded = true
		end
 end
 -- up
	if(e.yv <= 0)then
 	if issolid(e.x+4,e.y) then
 		e.yv = 0
 		e.y = flr((e.y+8)/8)*8
 	end
	end
end


function drawentity(e)
	local cspr = e.cs
	
	local frame = flr(e.animtimer)
	
	if e.hasgravity then
		if not e.grounded then
 		if e.jspr != nil then
 			cspr = e.jspr[(frame % #e.jspr) +1]
 		end
 	elseif e.xv != 0 then
 		if e.wspr != nil then
 			cspr = e.wspr[(frame % #e.wspr) +1]
 		end
 	end
	else
		if e.wspr != nil then
 			cspr = e.wspr[(frame % #e.wspr) +1]
 	end
	end
	
	spr(cspr,e.x,e.y,1,1,e.flipped,e.flippedy)
	
	-- prevent reaching maximum int value
	if e.animtimer > 32766 then
		e.animtimer = 0
	end
	
	e.animtimer+=e.animspd
end

