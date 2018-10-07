function projectile_laser ()
    return{
        tag = "projectile",
        x = 0,
        y = 0,
        x2 = 0,
        y2 = 0,
        
        lifetime = 0.1,
        damage = 1,
        tolerance = 4,
        
        -- collision --
        box     = {x=25,y= 5},
        boffset = {x=-1,y=-2},
        
        st= 1,
        
        init = function(this,_x1,_y1,_x2,_y2)
            this.st = this.lifetime
            this.x 	= _x1
            this.y 	= _y1
            this.x2 = _x2
            this.y2 = _y2
            
            for e in all(tagget("enemy")) do
                if (iscolliding(this,e))then
                    e.hit(e)
                end
            end
        end,
        update = function(this)
            this.lifetime -= 1/stat(7)
            if this.lifetime <= 0 then
                del(entities, this)
            end
        end,
        draw = function(this)
            drawlaser(this.x,this.y,this.x2,this.y2, this.lifetime/this.st)
        end
    }
end

function drawlaser(x1,y1,x2,y2,i)
    if i > .5 then
        line(x1, y1, x2, y2, 7)
        line(x1, y1+1, x2, y2+1, 10)
        line(x1, y1-1, x2, y2-1, 10)
        line(x1, y1+2, x2, y2+1, 8)
        line(x1, y1-2, x2, y2-1, 8)
    elseif i > .2 then
        line(x1, y1, x2, y2, 8)
        line(x1, y1+1, x2, y2+1, 10)
        line(x1, y1-1, x2, y2-1, 10)
        line(x1, y1+2, x2, y2+1, 2)
        line(x1, y1-2, x2, y2-1, 2)
    else
        line(x1, y1, 	x2, y2, 10)
        line(x1, y1+1, x2, y2, 2)
        line(x1, y1-1, x2, y2, 2)
    end
end