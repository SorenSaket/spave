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
			if btnp(4) then
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
		end,
	},
	-------- game loop --------
	{
	init = function()
		uipos = {x=2,y=2}
		
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
		
		ui_pstats(uipos.x,uipos.y)
		ui_money(2,118,data.coins)
	end
	},
	-------- score screen --------
	{
		init = function()

		end,
		update = function()

		end,
		draw = function()
			color(7)
			print("You had " .. data.coins .. " coins",8,8)
			print("You killed " .. data.ek .. " enemies",8,16)
			print("Your score was: " .. (data.ek + data.coins),8,24)
		end,
	}
}