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
			clet = 1
			letterobjs = {}
			username = ""

			local xoffset = 8
			local yoffset = 8
			local xspacing = 8
			local yspacing = 8
			rows = 2
			
			local letx = xoffset
			local lety = yoffset
			
			for i=1,#letters do
				local col
				if i == 1 or i == 5 or i == 9 or i == 15 or i == 21 then
					col = 8
				else
					col = 12
				end

				add(letterobjs, {letter=sub(letters,i,i),x=letx,y=lety,color=col})

				letx+=xspacing
				
				if i % flr(#letters/rows) == 0 then
					color(11)
					lety+=yspacing
					letx=xoffset
				end
			end
		end,
		update = function()
			if btnp(0) then
				clet-=1
			end
			if btnp(1) then
				clet+=1
			end
			if btnp(2) then
				clet-=flr(#letterobjs/rows)
			end
			if btnp(3) then
				clet+=flr(#letterobjs/rows)
			end

			if clet > #letterobjs then
				clet = clet % #letterobjs + (#letterobjs%rows)
			elseif clet < 1 then
				clet = clet + #letterobjs - (#letterobjs%rows)
			end

			if btnp(4) then
				username = username .. letterobjs[clet].letter
			end
		end,
		draw = function()
			rectfill(letterobjs[clet].x-1,
						letterobjs[clet].y-1,
						letterobjs[clet].x+3,
						letterobjs[clet].y+5,10)

			for i in all(letterobjs) do
				color(i.color)
				pset(i.x,i.y,i.color)
				print(i.letter,i.x,i.y)
			end
			color(11)
			print(clet,64,64)
			print(username,64,72)
			print(tonumbers("ab"),2,82)
			print(letterindex("z"),2,100)
		end,
	}
}