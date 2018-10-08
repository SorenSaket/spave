-- this page is reserved for
-- a framework that is going to
-- be buildt to help further
-- development of other games

-- common functions
--

function movetowardsdir(p, t)
	edir={	x = t.x - p.x,
			y = t.y - p.y}
	return v_normalize(edir)
end

function movetowards(enemy, player)
	
	if dist({x=enemy.x,y=enemy.y},{x=player.x,y=player.y}) > 4 then
 	edir = { x = enemy.x - player.x,
 										y = enemy.y - player.y}
 	edir = v_normalize(edir)
 	
 	if edir.x < 0 then
 		enemy.flipped = true
 	else
 		enemy.flipped = false
 	end
 	if edir.y > 0 then
 		enemy.flippedy = true
 	else
 		enemy.flippedy = false
 	end
 	enemy.x -= edir.x*0.3
 	enemy.y -= edir.y*0.3
	end
end

function tostring(any)
    if type(any)=="function" then 
        return "function" 
    end
    if any==nil then 
        return "nil" 
    end
    if type(any)=="string" then
        return any
    end
    if type(any)=="boolean" then
        if any then return "true" end
        return "false"
    end
    if type(any)=="table" then
        local str = "{ "
        for k,v in pairs(any) do
            str=str..tostring(k)..":"..tostring(v).." "
        end
        return str.."}"
    end
    if type(any)=="number" then
        return ""..any
    end
    return "unkown" -- should never show
end