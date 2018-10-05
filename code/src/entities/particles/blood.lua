function blood(x,y)
	for i=0,32 do
		local part = particle_blood ()
		part.init(part)
		part.x = x
		part.y = y
		add(entities,part)
	end
end

function particle_blood ()
 return{
 	tag = "particle",
 	
 	lifetime = 0.1,

 	hasgravity = true,
 	xmax 	= 2,
 	-- collision --
		box		= {x=1,y=1},
		boffset = {x=0,y=0},
 	
 	init = function(this)
			addstatics(this)
 		this.yv = rnd(3)*-1
 		this.xv = rnd(4)-2
 	end,
 	update = function(this)
  	-- ungrounded
			this.grounded = false
	
  	-- starting postions
  	local lastx = this.x
  	local lasty = this.y
  	
  	this.yv += physics.g
  	-- apply movement
  	this.x += this.xv
  	this.y += this.yv
  	
  	-- if walking right
  	if(this.xv > 0)then
  		-- if tile is to the right
   	if issolid(this.x,this.y) then
   		this.xv = 0
   		this.x 	= lastx
   	end
   -- else if walking left
  	elseif(this.xv < 0)then
  		if issolid(this.x,this.y) then
   		this.xv = 0
   		this.x = lastx
   	end
  	end
  	-- down
  	if (this.yv >=0) then
   	if issolid(this.x,this.y) then
   		this.yv = 0
   		this.y 	= lasty
   		this.grounded = true
  		end
   end
   -- up
  	if(this.yv <= 0)then
   	if issolid(this.x,this.y) then
   		this.yv = 0
   		this.y = lasty
   	end
  	end
 	end,
 	draw = function(this)
 		color(8)
  	pset(this.x,this.y,8)
 	end
 }
end