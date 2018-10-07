-- global entity table
entities = {}

function tagget(tag)
	local items = {}
	for i in all(entities) do
		if i.tag != nil and i.tag == tag then
			add(items, i)
		end
	end
	return items
end

function addstatics(e)
	e.x			=0			--x position
	e.y			=0			--y position
	e.xv			=0			--x velociy
	e.yv			=0			--y velociy
	e.grounded	=false	--is grounded
	e.flipped	=false	--is flipped
	e.flippedy	=false	--is flipped y dir
	e.animtimer	=0			--anim timer
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
		if e.xdrag == nil then
			e.xv -= physics.d
		else
			e.xv -= e.xdrag
		end
	elseif e.xv < -0.01 then
		if e.xdrag == nil then
			e.xv += physics.d
		else
			e.xv += e.xdrag
		end
	else
		e.xv = 0
	end
	
	-- max speed
	if e.xmax != nil then
		if e.xv > e.xmax then
			e.xv = e.xmax
		elseif e.xv < -e.xmax then
			e.xv = -e.xmax
		end
	end
	
	-- apply movement
	e.x += e.xv
	e.y += e.yv
	

	

	local pbox = {
		x=e.boffset.x+e.box.x,
		y=e.boffset.y+e.box.y
	}
	local pmin = {
		x=e.x+e.boffset.x,
		y=e.y+e.boffset.y}
	local pmax = {
		x=e.x+pbox.x,
		y=e.y+pbox.y}
	
	-- collisions
	-- if walking right
	if(e.xv > 0)then
		-- if tile is to the right
		if issolid(pmax.x,pmin.y+e.box.y/2) then
			e.xv 	= 0
			e.x 	= flr((e.x)/e.box.x)*e.box.x
		end
		e.flipped = false
 	-- else if walking left
	elseif(e.xv < 0)then
		if issolid(pmin.x,pmin.y+e.box.y/2) then
			e.xv 	= 0
			e.x 	= flr((e.x+e.box.x)/e.box.x)*e.box.x
 		end
 		e.flipped = true
	end
		
	-- down
	if (e.yv >=0) then
		if issolidc(pmin.x+1,pmax.y,{1,2}) or issolidc(pmax.x-1,pmax.y,{1,2}) then
			e.yv = 0
			e.y = flr((e.y)/e.box.y)*e.box.y
			e.grounded = true
		end
	end
 	-- up
	if(e.yv <= 0)then
		if issolid(pmin.x+e.box.x/2,pmin.y) then
			e.yv	= 0
			e.y	= flr((e.y+e.box.y)/e.box.y)*e.box.y
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

	spr(cspr,e.x,e.y,e.sprs.x,e.sprs.y,e.flipped,e.flippedy)
	
	-- prevent reaching maximum int value
	if e.animtimer > 32766 then
		e.animtimer = 0
	end
	-- process the animations
	e.animtimer+=e.animspd
end

