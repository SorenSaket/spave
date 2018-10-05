function enemy_spike ()
    return {
        tag= "enemy",
        -- stats --
        health=3,
        hkb=4,
        vkb=3,
        
        -- collision --
           box				 = {x=7,y=5},
           boffset = {x=1,y=3},
        
        -- visuals
        wspr=36,
        
        init = function(this)
            addstatics(this)
        end,
        update = function(this)
            
               if iscolliding(p,this) and p.yv > 0 then 
                this.wspr=20
                local dif = p.x - this.x
                p.hit(p,1,(dif/abs(dif))*this.hkb,-this.vkb)
            end
        end,
        draw = function(this)
            spr(this.wspr,this.x,this.y)
        end,
        hit = function(this)
            sfx(2)
               del(entities,this)
        end
    }
end