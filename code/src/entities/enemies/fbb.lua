function enemy_fbb ()
   return {
      tag= "enemy",
      
      -- stats --
      health   =16,
      state    =0,
      spd      =0.4,
      shootspd =3,
      rotspd   =7,
      targetspd=10,
      -- collision --
      box      = {x=24,y=24},
      boffset  = {x=4,y=4},

      hitbox = {x=18,y=18,ox=7,oy=7},

      
      -- physics --
      hasgravity=false,
      
      hkb=5,
      vkb=1,
      
      -- visuals
      animspd  =1,

      -- specific
      targetp     ={x=0,y=0}, -- target position
      rot         =0,         -- target rotation
      eyesprpos   ={x=112,y=80},
      
      init = function(this)
         addstatics(this)
         this.x = 64-16
         this.y = 32
         this.targetp.x = this.x 
         this.targetp.y = this.y
      end,
      update = function(this)
         this.rot = time()/this.rotspd

         if time() % 14 == 0 then
            this.targetp = {x=mid(8,p.x,87),y=mid(8,p.y,87)}
         end
         if time() % this.shootspd == 0 then
            fbb_attack(this, {0+this.rot, 
                              0.25+this.rot, 
                              0.5+this.rot,  
                              0.75+this.rot})
         end
         --if time() % 6 == 3 then
         --   fbb_attack(this, {0.125, 0.375,0.625,0.875})
         --end

         if dist({x=this.x,y=this.y},this.targetp) > 1 then
            local dir = movetowardsdir({x=this.x,y=this.y},this.targetp)
            this.xv = dir.x*this.spd
            this.yv = dir.y*this.spd

            this.x += this.xv
            this.y += this.yv
         end
      end,
      draw = function(this)
         if flr(time()/2) %2 == 0 then
            sspr(this.x,this.y,96,64,16,16,false,false,15.5,15.5,this.rot,2,2)
         elseif flr(time()/2) % 2 == 1 then
            sspr(this.x,this.y,112,64,16,16,false,false,15.5,15.5,this.rot,2,2)
         end

      
         
         local erot = atan2( p.x - (this.x+16),p.y - (this.y+16));
         sspr(this.x+12,this.y+12,this.eyesprpos.x,this.eyesprpos.y,4,4,false,false,4,4,erot,2,2)

      end,
      hit = function(this)
        local xdir = p.x-this.x
        blooda(this.x+16,this.y+16,32,xdir/abs(xdir),1,2,2)
        sfx(2)
        this.health-=1

        if(this.health < 10) then
            this.eyesprpos.x = 116
            this.shootspd = 2
            this.rotspd = 6
            this.targetspd=9
        end
        if(this.health < 5) then
            this.eyesprpos.x = 112
            this.eyesprpos.y = 84
            this.shootspd = 1.5
            this.rotspd = 5
            this.targetspd=8
        end

        if this.health < 0 then
            data.ek+=1
            blood(this.x+this.boffset.x,this.y+this.boffset.y)
            blood(this.x+this.boffset.x,this.y+this.boffset.y)
            del(entities,this)
        end
      end
   }
end

-- dir: 0:left 1:right 2:up 3:down
-- rdir: 0:left 1:right 2:up 3:down
function fbb_attack(e, points)
   for i in all(points) do
      local xp = (cos(i) * 16)+e.x+e.boffset.x+(e.box.x/2)
      local yp = (sin(i) * 16)+e.y+e.boffset.y+(e.box.y/2)

      local s = projectile_fbb_shot()
      s.init(s,xp,yp,i)
      add(entities, s)
   end
end

function GetRandomTarget()
   return {x=rnd(79)+8,y=rnd(79)+8}
end

