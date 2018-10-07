function enemy_slime ()
   return {
      tag= "enemy",
      -- stats --
      hkb=3,
      vkb=2,
      
      -- collision --
      box      = {x=8,y=8},
      boffset  = {x=0,y=0},
      
      -- physics --
      hasgravity=true,
      xacc = 0.3, -- acceleration
      xmax = 0.3,
      right=true,
      
      -- visuals
      sprs     ={x=1,y=1},
      cs       =16,
      jspr     ={16,17},
      wspr     ={16,17},
      animspd  =0.12,
      
      init = function(this)
         addstatics(this)
      end,
      update = function(this)
         updateentity(this)
      end,
      draw = function(this)
         drawentity(this)
      end,
      hit = function(this)
         sfx(2)
         data.ek+=1
         blood(this.x+this.boffset.x,this.y+this.boffset.y)
         del(entities,this)
      end
   }
end