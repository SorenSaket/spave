-- todo
-- 1. laser enemy
-- 2. time + points displayed
-- 3. boss
--			a) 
-- 4. upgrade
--   a) jetpack
--   b) weapons
--					 i) laser
--						ii) shotgun
--   c) sheild
--   d) health
--			e)
--	5. paralaxing background
-- 6. super attack
--			a) granade

-- shows helpful information
debug = false
-- global entity table
entities = {}
-- the gamestate
-- 1 - title
-- 2 - game
-- 3 - scoreboard
gamestate = 1


states = {
	-------- title --------
	{
		init = function()
			t = 0 
		end,
		update = function()
			t+=0.01
			if btnp(4)then
				setgamestate(2)
			end
		end,
		draw = function()

			local start = 235
			local xoffset = 32
			local yoffset = 32
			local spacing = 4
			
			
			for i = 0, 4 do
				pal( 6, i+sin(t)*5)
				local x = i*(8+(spacing+spacing*sin(t)))+xoffset-spacing*sin(t)
				local y = sin(0.1*i+t)*10+yoffset
				spr(start+i,x,y,1,2)
				pal( 6, i+sin(t)*5+1)
				spr(start+i,x-1,y+1,1,2)
			end
			print("press z", 45,82)
		end,
	},
	-------- game loop --------
	{
		init = function()
			-- add player
  	p.init(p)
  	p.x = 40
  	p.y = 80
  	-- create room
   tr = createroom(1)
   tr = fillcube(tr,7,7,9,6,0)
   tr = fillcube(tr,9,14,3,6,0)
   
   setroom(tr)
		end,
		update = function()
			-- update all entities
  	for e in all(entities) do
   		e.update(e)
   end
  	
  	if score == 50 then
  		roomtype=4
  	end
		end,
		draw = function()
 		-- draw map
  	map(0,0,0,0,16,16)
  	map(16,0,0,0,16,16)
  	-- draw entities
  	for e in all(entities) do
  		
  		if debug then
  			if e.grounded == nil or not e.grounded and e.hasgravity then
  				color(10)
  			else
  				color(11)
  			end
  			-- draw hitbox
  			rect(e.x										+e.boffset.x,
  								e.y										+e.boffset.y,
  								e.x+e.box.x-1+e.boffset.x,
  								e.y+e.box.y-1+e.boffset.y)
  		end
  		e.draw(e)
  	end
    
  	color(0)
  	rectfill(2,2,17,12)
  	color(12)
  	line(3,11,3+13*(1-p.firetimer),11)
 	 if p.health == 3 then
  		spr(240,2,2,2,1)
  	elseif p.health == 2 then
  		spr(242,2,2,2,1)
  	else
  		spr(244,2,2,2,1)
  	end
		end,
	},
	{
		init = function()
		end,
		update = function()
		end,
		draw = function()
		end,
	}
}

score = 0

-- 
function setgamestate(s)
	cls()
	pal()
	gamestate = s
	states[gamestate].init()
end

function tagget(tag)
	local items = {}
	for i in all(entities) do
		if i.tag != nil and i.tag == tag then
			add(items, i)
		end
	end
	return items
end


-------- system functions --------
function _init()
	cartdata("ss_spave")
	--music(0)
	setgamestate(1)
end

function _update60()
	states[gamestate].update()
end

function _draw()
	-- clear screen
	cls()
	states[gamestate].draw()

	--print("rip... score:"..score,8,8)
	
	if debug then
		color(11)
		
		print(stat(0),2,16)
		print(stat(1),2,24)
		print(stat(2),2,32)
		
		--print(p.grounded,2,16)
 	--print(p.xv.." + "..p.xv,2,24)
	end
end
