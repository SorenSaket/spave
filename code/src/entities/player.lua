p = {
	tag 			="player",
	hitjump		=false,
	
	-- stats --
	maxhealth 	=3,	--
	health		=3,	-- current health TODO add max health
	range			=1,	--
	firetimer	=0.1,	--
	currentgun  =nil,	--
	
	invtime		=1.4,	-- invincibility time
	invtimer		=0,	-- timer
	
	-- physics --
	hasgravity	=true,-- does use gravity
	xacc 			=0.2, -- acceleration
	xmax 			=1.3, -- max speed
	jvmin			=0.1, -- min jump velocity
	jv				=0.4, -- jump velocity
	jvmax			=6,	-- max jump height
	
	-- collision --
	box		= {x=8,y=8},--
	boffset	= {x=0,y=0},--

	-- visuals
	sprs    		={x=1,y=1},
	cs				=1,		-- current sprite (idle sprite)
	jspr			={4},		-- jumpsprite
	wspr			={2,3},	-- walk sprites
	animspd 		=0.12,	-- animation speed
	animtimer	=0,  		-- walk sprite timer
	    
	init = function(this)
		this = addstatics(this)
		this.gun = gun_laser()
		add(entities,p)
	end,
	update = function(this)
		if this.invtimer > 0 then
			this.invtimer-= 1/stat(7)
		end
		
		controlplayer()
		updateentity(this)
	end,
	draw = function(this)
		drawentity(this)
	end,
	hit = function(this, dmg,hkb,vkb)
		if this.invtimer <= 0 then
			this.invtimer = this.invtime
			sfx(2)
			this.health-= dmg
			this.xv += hkb
			this.yv += vkb

			if this.health <= 0 then
				setgamestate(3)
			end
		end
	end
}

function controlplayer()
	
	-- shooting
	if p.firetimer > 0 then
		p.firetimer-= 1/stat(7)
	elseif btn(4) then
		p.firetimer = p.gun.firerate
		p.gun.fire(p.gun)
	end
	
	-- vertical movement
	if(btnp(2)) and p.grounded then
		p.yv -= p.jvmin
		p.lasty = p.y
		sfx(0)
	end
	
	-- if going up and pressed button
	if btn(2) and p.yv < 0  then
		if abs(p.lasty - p.y) < p.jvmax then
			p.yv -= p.jv
		end
	end
	
	-- horizontal movement
	if(btn(1)) then
		p.xv += p.xacc
	end
	if(btn(0)) then
		p.xv -= p.xacc
	end
	
	if p.x > 128 or p.y > 128 then
		p.x = 1
		p.y = 64
 		newroom(true)
	elseif p.x < 0 then
		p.x = 127
		p.y = 64
 		newroom(false)
	end
end