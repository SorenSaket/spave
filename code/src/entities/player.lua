p = {
	tag = "player",
	hitjump	=false,
	
	-- stats --
	health=3,
	firerate=1,
	damage=1,
	range=3,
	firetimer=1,
	
	invtime=1.6,
	invtimer=0,
	
	-- physics --
	hasgravity=true,
	xacc = 0.2, -- acceleration
	xmax = 1.3, -- max speed
	jvmin= 0.1, -- min jump velocity
	jv			= 0.4, -- jump velocity
	jvmax= 6,			-- max jump height
	
	-- collision --
	box				 = {x=8,y=8},
	boffset = {x=0,y=0},
	
	-- visuals
	cs=1,
	jspr={4},   -- jumpsprite
	wspr={2,3},-- walk sprites
	animspd = 0.12,
	animtimer=0,  -- walk sprite timer
	    
    init = function(this)
        this = addstatics(this)
        add(entities,p)
    end,
    update = function(this)
            controlplayer()
            if this.invtimer > 0 then
                this.invtimer-= 1/stat(7)
            end
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
        end
    end
}

function controlplayer()
	
	-- shooting
	if p.firetimer > 0 then
		p.firetimer-= 1/stat(7)
	elseif btn(4) then
		sfx(1)
		p.firetimer = p.firerate
		local pjt = projectile_lazer()
		
		if p.flipped then
			pjt.init(pjt,p.x,p.y+4,p.x-p.range*8,p.y+4) 
			pjt.boffset.x = -pjt.box.x
		else
			pjt.init(pjt,p.x+8,p.y+4,p.x+8+p.range*8,p.y+4) 		
			pjt.boffset.x = 0
		end
		add(entities, pjt)
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