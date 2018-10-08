-- todo
-- 0. Global game data management
-- Leaderboards
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
--	
-- 6. super attack
--			a) granade
-- 7. paralaxing background

-- shows helpful information
debug = false


-------- system functions --------
function _init()
	cartdata("ss_spave")
	--music(0)
	setgamestate(3)
end

function _update60()
	states[gamestate].update() -- update the current gamestate
end

function _draw()
	cls()								-- clear screen
	states[gamestate].draw()	-- draw the current gamestate
	
	if debug then
		color(11)	-- green
		
		print(stat(0),2,16)
		print(stat(1),2,24)
		print(stat(2),2,32)
	end
end
