-- todo
-- X 0. Global game data management
-- X Leaderboards
-- 1. laser enemy
-- 2. time + points displayed
-- 3. boss
--			a) 
-- 4. upgrade
--   	a) jetpack
--   	b) weapons
--			i) laser
--			ii) shotgun
--   	c) shield
--		d) health
--			i) max health so you can't overheal
--			ii) dynamic ui to support max health > 3
-- 6. super attack
--			a) granade
-- 7. paralaxing background

-- shows helpful information
debug = false


-------- system functions --------
function _init()
	-- Set cart data once in first init
	cartdata("ss_spave")
	--music(0)
	setgamestate(1)
end

function _update60()
	states[gamestate].update() -- update the current gamestate
end

function _draw()
	cls()								-- clear screen
	states[gamestate].draw()	-- draw the current gamestate
	if debug then					-- debug draw
		color(11)	-- green
		print(stat(0),2,16)		-- memory usage
		print(stat(1),2,24)		-- cpu usage. should not go over 1
		print(stat(2),2,32)		-- system cpu usage
	end
end
