function ui_pstats(x,y)
   local width=32

   ui_pstats_weapon(x,y)
   ui_pstats_healthbar(x+12,y,width)
   ui_pstats_firebar(x+12,y+9,width)
end

function ui_pstats_weapon(x,y)
   color(0)
   rectfill(x,y,x+11,y+11)
   spr(194,x+2,y+2)
end

function ui_pstats_healthbar(x,y,w)
   -- box
   rectfill(x,y,x+w,y+8,0)
   -- bar
   local ph = p.health / p.maxhealth
   rectfill(x+1,y+1,x+max(0,((w-1)*ph)),y+7,8)
   -- text
   local htxt = p.health .. "/" .. p.maxhealth
   print(htxt, x + w/2 - (#htxt*2) + 1,y+2,7)
end

function ui_pstats_firebar(x,y,w)
   -- box
   rectfill(x,y,x+w,y+2,0)
   -- bar
   local ph = 1-p.firetimer
   rectfill(x+1,y+1,x+max(0,((w-1)*ph)),y+1,12)
end