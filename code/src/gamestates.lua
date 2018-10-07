-- the gamestate
-- 1 - title
-- 2 - game
-- 3 - scoreboard
gamestate = 1

function setgamestate(s)
	-- clear the screen
	cls()
	-- seset the palette
	pal()
	-- set the gamestate
	gamestate = s
	-- initialize the gamestate
	states[gamestate].init()
end

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
			color(11)
			print("press z", 45,82)
			local r = 0.5
			print(cos(r),8,8)
			print(sin(r),8,16)

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
		tr = createroom(0)
		--tr = fillcube(tr,7,7,9,6,0)
		--tr = fillcube(tr,9,14,3,6,0)
		
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
	end,
	update = function()
		-- update all entities
		for e in all(entities) do
			e.update(e)
		end
		if data.score == 50 then
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
				rect(	e.x+e.boffset.x,
						e.y+e.boffset.y,
						e.x+e.box.x-1+e.boffset.x,
						e.y+e.box.y-1+e.boffset.y)
				pset(e.x,e.y,12)
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
	end
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