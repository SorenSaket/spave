function enemy_fb ()
    return {
        tag= "enemy",
        -- stats --
        chaserange=7,
        
        -- collision --
        box	    = {x=8,y=8},
        boffset = {x=0,y=0},
        
        -- physics --
        hasgravity=false,
        spd=0.12,
        hkb=5,
        vkb=1,
        
        -- visuals
        sprs    ={x=1,y=1},
        wspr    ={32,33,34,33,32},
        animspd =0.12,
        
        init = function(this)
            addstatics(this)
        end,
        update = function(this)
            local dist = dist({x=this.x,y=this.y},{x=p.x,y=p.y})
            if dist < this.chaserange*8then 
                movetowards(this,p)
            end
            if iscolliding(p,this) then
                local dif = p.x - this.x
                p.xv = (dif/abs(dif))*this.hkb
                p.hit(p,1,0,-this.vkb)
            end
        end,
        draw = function(this)
            drawentity(this)
        end,
        hit = function(this)
            local xdir = p.x-this.x
            blooda(this.x+4,this.y+4,32,xdir/abs(xdir),1,2,2)
            sfx(2)
            data.ek+=1
            
            del(entities,this)
        end
    }
end