function projectile_fbb_shot ()
   return{
    tag = "projectile",
    x = 0,
    y = 0,
    rot = 0,
    
    -- stats --
    damage   = 1,
    spd      = 1,
    
    -- collision --
    box      = {x=3,y=3},
    boffset  = {x=-1,y=-1},
    init = function(this,x,y,r)
        this.x = x
        this.y = y
        this.rot = r
    end,
    update = function(this)
        this.x += cos(this.rot)*this.spd
        this.y += sin(this.rot)*this.spd

        if issolid(this.x,this.y) then
            del(entities, this)
        end
        if (iscolliding(this,p))then
            p.hit(p,this.damage,0,0)
        end
    end,
    draw = function(this)
        sspr(this.x,this.y,120,80,5,3,false,false,0,1,this.rot,1,1)
    end
   }
end