function enemy_snake ()
    return {
        tag= "enemy",
        -- stats --
        hkb=3,
        vkb=2,
        
        -- collision --
           box				 = {x=8,y=8},
           boffset = {x=0,y=0},
        
        -- physics --
        hasgravity=true,
        xacc = 0.3, -- acceleration
        xmax = 0.3,
        right=true,
        
        -- visuals
        sprs    ={x=1,y=1},
        cs      =16,
        jspr    ={16,17},
        wspr    ={16,17},
        animspd = 0.12,
        
        init = function(this)
            addstatics(this)
        end,
        update = function(this)
            if iscolliding(p,this) then 
                local dif = p.x - this.x
                
                -- if stoming
                if p.yv > 0 then
                       p.yv=-2
                       this.hit(this)
                else
                    p.hit(p,1,(dif/abs(dif))*this.hkb,-this.vkb)
                end
               end
            
            -- movement
            if this.grounded then
             if this.right then
                 this.xv += this.xacc
                 if issolid(this.x+9, this.y+4) or not issolid(this.x+9, this.y+12)  then
                     this.right = false
                 end
             else
                 this.xv -= this.xacc
                 if issolid(this.x-1, this.y+4) or not issolid(this.x-1, this.y+12)  then
                     this.right = true
                 end
             end
            end
            updateentity(this)
        end,
        draw = function(this)
            drawentity(this)
        end,
        hit = function(this)
            sfx(2)
            data.ek+=1
            local xdir = p.x-this.x
            blooda(this.x+4,this.y+4,32,xdir/abs(xdir),1,2,2)
            del(entities,this)
        end
    }
end