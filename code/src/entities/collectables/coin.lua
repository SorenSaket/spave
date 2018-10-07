function coin ()
	return {
        tag = "collectable",
        -- collision --
        box     = {x=8,y=8},
        boffset = {x=0,y=0},
        -- physics --
        hasgravity=false,
        -- visuals
        sprs    ={x=1,y=1},
        wspr    ={150,151,152,151,150,150},
        animspd = 0.12,
        
        init = function(this)
            addstatics(this)
        end,
        update = function(this)
            if iscolliding(p,this) then
                data.coins+=1
                sfx(3)
                del(entities,this)
            end
        end,
        draw = function(this)
            drawentity(this)
        end
	}
end