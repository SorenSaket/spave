-- a super version of the normal spr()
-- x:    x coordinate   : num in pixels
-- y:    y spritesheet  : num in pixels
-- ssx:  spritesheet x  : num in pixels
-- ssy:  spritesheet y  : num in pixels
-- w:    width          : num in pixels
-- h:    height         : num in pixels
-- px:   pivot x        : num in pixels
-- py:   pivot y        : num in pixels
-- fx:   flipped x      : bool
-- fy:   flipped y      : bool
-- r:    rotation       : 0-1 num
-- sx:   scale x        : num
-- sy:   scale y        : num
-- s:    scale          : num
function sspr(x,y,ssx,ssy,w,h,fx,fy,px,py,r,sx,sy)
   for a=0,(w*sx)-1 do
      for b=0,(h*sy)-1 do
         local col = sget(ssx+flr(a/sx),ssy+flr(b/sy))
         
         if col != 0 then
            local s = sin(r)
            local c = cos(r)
         
            local mx = x+a
            local my = y+b

            local ox = x+(px)
            local oy = y+(py)

            pset( c * (mx-ox) - s * (my-oy) + ox,
                  s * (mx-ox) + c * (my-oy) + oy,
                  col)
         end
      end
   end
end