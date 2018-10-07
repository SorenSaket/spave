function blood(x,y)
	for i=0,32 do
		local part = particle_blood ()
		part.init(part,x,y,rnd(3)*-1,rnd(4)-2)
		add(entities,part)
	end
end

function blooda(x,y,n,xv,yv,rxv,ryv)
	for i=0,n do
		local part = particle_blood ()
		part.init(part,x,y,xv*(rnd(rxv)-rxv),yv*(rnd(ryv)-ryv))
		add(entities,part)
	end
end

function particle_blood ()
 return{
 	tag = "particle",
	
	-- physics --
 	hasgravity 	= true,
	xmax 			= 2,
	xdrag 		= 0,
	 
 	-- collision --
	box		= {x=1,y=1},
	boffset 	= {x=0,y=0},
 	
 	init = function(this,x,y,xv,yv)
		addstatics(this)
		this.x = x
		this.y = y
		this.xv = xv
		this.yv = yv
 	end,
 	update = function(this)
		if not this.grounded then
			updateentity(this)
		end
 	end,
 	draw = function(this)
 		color(8)
  		pset(this.x,this.y,8)
 	end
 }
end