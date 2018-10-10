function projectile_boomerang ()
   return{
      tag = "projectile",
      x = 0,
      y = 0,
      xv=0,
      yv=0,

      damage = 1,
       
      -- collision --
      box     = {x=5,y=5},
      boffset = {x=0,y=0},

      rot = 0,

      init = function(this)

         
      end,
      update = function(this)
         for e in all(tagget("enemy")) do
            if (iscolliding(this,e))then
               e.hit(e)
               del(entities, this)
            end
         end
         if issolid(this.x,this.y) then
            del(entities, this)
         end

         rot+= time()/5
      end,
      draw = function(this)
         sspr(this.x,this.y,120,83,6,5,false,false,3,2.5,this.rot,1,1)
      end
   }
end
