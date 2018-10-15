-- Compiled at: 2018-10-15 22:20:26.503292
data = {
 username = "",
 score = 3,
 time = 0,
 coins = 0,
 ek = 0, 
 } 
 
 
 
 gamestate = 1
 
 function setgamestate(s)
 
 cls()
 
 pal()
 
 gamestate = s
 
 states[gamestate].init()
 end
 
 states = {
 
 {
 init = function()
 wait = 4
 fill = 0
 yp = 0
 
 end,
 update = function()
 wait-=0.01
 
 if wait <= 0 then
 if yp < 1 then
 yp+=0.01
 elseif yp >= 1 then
 if fill < 1 then
 fill+=0.01
 end
 end
 end
 end,
 draw = function()
 sspr(6,8*yp+6,48,118,26*fill+6,10,false,false,0,0,0,1,1)
 sspr(2,2,48,108,26*fill+6,10,false,false,0,0,0,1,1)
 
 end,
 },
 
 {
 init = function()
 
 t = 0 
 end,
 update = function()
 t+=0.01
 if btnp(4) then
 setgamestate(2)
 end
 end,
 draw = function()
 
 local start = 235
 local xoffset = 32
 local yoffset = 32
 local spacing = 4
 
 for i = 0, 4 do
 pal( 6, i+sin(t)*5)
 local x = i*(8+(spacing+spacing*sin(t)))+xoffset-spacing*sin(t)
 local y = sin(0.1*i+t)*10+yoffset
 spr(start+i,x,y,1,2)
 pal( 6, i+sin(t)*5+1)
 spr(start+i,x-1,y+1,1,2)
 end
 color(11)
 print("press z", 45,82)
 end,
 },
 
 {
 init = function()
 uipos = {x=2,y=2}
 
 
 p.init(p)
 p.x = 40
 p.y = 80
 
 tr = createroom(1)
 tr = fillcube(tr,7,7,9,6,0)
 tr = fillcube(tr,9,14,3,6,0)
 
 setroom(tr)
 end,
 update = function()
 
 
 for e in all(entities) do
 e.update(e)
 end
 
 if data.score == 50 then
 roomtype=4
 end
 end,
 draw = function()
 
 
 map(0,0,0,0,16,16)
 map(16,0,0,0,16,16)
 
 
 for e in all(entities) do
 
 if debug then
 if e.grounded == nil or not e.grounded and e.hasgravity then
 color(10)
 else
 color(11)
 end
 
 rect(e.x+e.boffset.x,
 e.y+e.boffset.y,
 e.x+e.box.x-1+e.boffset.x,
 e.y+e.box.y-1+e.boffset.y)
 pset(e.x,e.y,12)
 end
 e.draw(e)
 end
 
 ui_pstats(uipos.x,uipos.y)
 ui_money(2,118,data.coins)
 end
 },
 
 {
 init = function()
 savedata = loadsaves()
 
 
 if savedata[#savedata].score > data.ek+data.coins then
 setgamestate(4)
 end
 
 clet = 1
 letterobjs = {}
 username = ""
 
 local xoffset = 15
 local yoffset = 64
 local xspacing = 8
 local yspacing = 8
 rows = 2
 
 local letx = xoffset
 local lety = yoffset
 
 for i=1,#letters do
 local col
 if i == 1 or i == 5 or i == 9 or i == 15 or i == 21 then
 col = 8
 else
 col = 12
 end
 
 add(letterobjs, {letter=sub(letters,i,i),x=letx,y=lety,color=col})
 
 letx+=xspacing
 
 if i % flr(#letters/rows) == 0 then
 color(11)
 lety+=yspacing
 letx=xoffset
 end
 end
 end,
 update = function()
 if btnp(0) then
 clet-=1
 end
 if btnp(1) then
 clet+=1
 end
 if btnp(2) then
 clet-=flr(#letterobjs/rows)
 end
 if btnp(3) then
 clet+=flr(#letterobjs/rows)
 end
 
 if clet > #letterobjs then
 clet = clet % #letterobjs + (#letterobjs%rows)
 elseif clet < 1 then
 clet = clet + #letterobjs - (#letterobjs%rows)
 end
 
 if btnp(4) then
 if #username < 3 then
 username = username .. letterobjs[clet].letter
 end
 end
 
 if btnp(5) then
 if #username > 0 then
 username = sub(username,0,#username-1)
 end
 end
 
 if #username == 3 then
 data.username = username
 setgamestate(4)
 end
 end,
 draw = function()
 cls(1)
 
 rectfill(letterobjs[clet].x-1,
 letterobjs[clet].y-1,
 letterobjs[clet].x+3,
 letterobjs[clet].y+5,10)
 
 for i in all(letterobjs) do
 color(i.color)
 pset(i.x,i.y,i.color)
 print(i.letter,i.x,i.y)
 end
 
 local pu = username
 
 for i=0,2-#pu do
 pu = pu .. "_"
 end
 
 color(7)
 print(pu,64 - (#pu*2),32)
 print("Press X to delete",3,120)
 end,
 },
 
 {
 init = function()
 submitscore(data.username,(data.ek+data.coins))
 save()
 end,
 update = function()
 end,
 draw = function()
 cls(1)
 color(12)
 color(7)
 print("Highscores",64 - (#"Highscores"*2),2)
 local yoffset = 5
 for i,v in pairs(savedata) do
 color(7)
 
 if i < 16 and v.name != "___" then
 
 if data.username == v.name then
 color(10)
 end
 
 print(i, 24, i*7+yoffset)
 
 print(v.name,42, i*7+yoffset)
 
 print(v.score, 96, i*7+yoffset)
 end
 end
 end,
 }
 } 
 roomtype = 2
 
 function newbossroom()
 
 for i in all(entities) do 
 if i.tag != "player" then
 del(entities, i)
 end
 end
 
 clearroom()
 local tr = createroom(0)
 
 tr = fillrow(tr,0,1)
 tr = fillrow(tr,15,1)
 tr = fillcol(tr,0,1)
 tr = fillcol(tr,15,1)
 
 
 tr[2][12] = 2
 tr[3][12] = 2
 tr[4][12] = 2
 
 tr[11][12] = 2
 tr[12][12] = 2
 tr[13][12] = 2
 
 tr[6][9] = 2
 tr[7][9] = 2
 tr[8][9] = 2
 tr[9][9] = 2
 
 tr[2][6] = 2
 tr[3][6] = 2
 tr[4][6] = 2
 
 tr[11][6] = 2
 tr[12][6] = 2
 tr[13][6] = 2
 
 tr[8][15] = 0
 tr[7][15] = 0
 
 
 local b = enemy_fbb()
 b.init(b)
 add(entities,b)
 
 setroom(tr)
 end
 
 
 function newroom(right)
 
 for i in all(entities) do 
 if i.tag != "player" then
 del(entities, i)
 end
 end
 
 clearroom()
 tr = generateroom(right)
 setroom(tr)
 end
 
 
 function generateroom(right)
 local temproom = createroom(roomtype)
 
 local chunksize = 2
 local cy = 8
 local mincy
 local maxcy
 
 
 
 
 
 for x = 0, 15 do
 chunksize = flr(rnd(4))+1
 mincy = chunksize + 1
 maxcy = 15 - (chunksize+1)
 
 local cx
 
 if right then
 cx = x
 else
 cx = 15-x
 end
 
 temproom = fillcube(temproom,cx,cy,chunksize,chunksize,0)
 
 if ((cx+1)%3)-2 == 0 then
 local c = coin ()
 c.init(c)
 c.x = cx*8
 c.y = cy*8
 add(entities,c)
 end
 
 
 if flr(rnd(2)) == 1 then
 cy+=1
 else
 cy-=1
 end
 
 if(cy < mincy)then
 cy = mincy
 end
 if(cy > maxcy)then
 cy = maxcy
 end
 end
 
 temproom = fillrow(temproom,0,roomtype)
 temproom = fillrow(temproom,15,roomtype)
 
 local fspawnpoints=getspawnpointsa(temproom,0,4,0,0,0,1)
 local spawnpoints=getspawnpoints(temproom,0,6,2)
 
 
 
 for n = 0, flr(rnd(2)) do
 if #spawnpoints > 0 then
 local index = flr(rnd(#spawnpoints-1)+1)
 local point = spawnpoints[index]
 spawnenemy(false, point.x,point.y)
 del(spawnpoints, point)
 end
 end
 
 for n = 0, flr(rnd(3)) do
 if #fspawnpoints > 0 then
 local index = flr(rnd(#fspawnpoints-1)+1)
 local point = fspawnpoints[index]
 spawnenemy(true, point.x,point.y)
 del(fspawnpoints, point)
 end
 end
 
 return temproom
 end
 
 
 function spawnenemy(g,tx,ty)
 
 local e
 
 if g then
 local index = rnd(1)
 if index >=0.5 then
 e = enemy_snake ()
 else
 e = enemy_spike ()
 end
 else
 e = enemy_fb ()
 end
 
 e.init(e)
 e.x = tx*8
 e.y = ty*8
 add(entities,e)
 end
 
 
 function getspawnpoints(r,check,xm,ym)
 local points = {}
 
 for i = 0+xm, 15-xm do
 for j = 0+ym, 15-ym do
 if r[i][j] == check then
 add(points,{x=i,y=j})
 end
 end
 end
 
 return points
 end
 
 function getspawnpointsa(r,check,xm,ym,exclude,xo,yo)
 local points = {}
 
 for i = 0+xm, 15-xm do
 for j = 0+ym, 15-ym do
 if r[i][j] == check then
 if r[i+xo][j+yo] != exclude then
 add(points,{x=i,y=j})
 end
 end
 end
 end
 
 return points
 end 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 debug = false
 
 
 
 function _init()
 
 cartdata("ss_spave")
 
 setgamestate(1)
 end
 
 function _update60()
 states[gamestate].update() 
 end
 
 function _draw()
 cls()
 states[gamestate].draw()
 if debug then
 color(11)
 print(stat(0),2,16)
 print(stat(1),2,24)
 print(stat(2),2,32)
 end
 end
 physics = {
 g=0.1,
 d=0.1,
 adm=0.5 
 }
 
 function iscolliding(a,b)
 
 local amin = {
 x=a.x+a.boffset.x,
 y=a.y+a.boffset.y}
 local amax = {
 x=a.x+a.boffset.x+a.box.x,
 y=a.y+a.boffset.y+a.box.y}
 local bmin = {
 x=b.x+b.boffset.x,
 y=b.y+b.boffset.y}
 local bmax = {
 x=b.x+b.boffset.x+b.box.x,
 y=b.y+b.boffset.y+b.box.y}
 
 if (amax.x < bmin.x) then return false end 
 if (amin.x > bmax.x) then return false end 
 if (amax.y < bmin.y) then return false end 
 if (amin.y > bmax.y) then return false end 
 return true;
 end
 
 function issolid(x,y)
 if(fget(mget(x/8,y/8)) == 1)then
 return true
 else
 return false
 end
 end
 
 function issolidc(x,y,f)
 for i in all(f) do
 if(fget(mget(x/8,y/8)) == i)then
 return true
 end
 end
 return false
 end 
 currentroom = {}
 
 currentmap = {}
 
 
 function createroom(fill)
 room = {}
 for i = 0, 15 do
 room[i] = {}
 for j = 0, 15 do
 room[i][j] = fill
 end
 end
 return room
 end
 
 
 function setroom(r)
 for x = 0, 15 do
 for y = 0, 15 do
 cts = r[x][y]
 if(cts > 0)then
 cspr = tilesets[cts].tiles[gettileid(r,x,y,cts)]
 mset(x,y,cspr.sprid)
 end
 end
 end
 end
 
 function gettileid(r,x,y,t)
 up = 0
 down = 0
 left = 0
 right = 0
 
 if(x+1 < 16 and r[x+1][y] == t) or x+1 >= 16 then
 right = 1
 end
 if(x-1 > -1 and r[x-1][y] == t) or x-1 <= -1 then
 left = 1
 end
 if(y-1 > -1 and r[x][y-1] == t) or y-1 <= -1 then
 up = 1
 end
 if(y+1 < 16 and r[x][y+1] == t) or y+1 >= 16 then
 down = 1
 end
 
 return (1*up)+(2*left)+(4*right)+(8*down)+1
 end
 
 
 function fillrow(r,col,num)
 for x = 0, 15 do
 r[x][col] = num
 end
 return r
 end
 
 function fillcol(r,row,num)
 for y = 0, 15 do
 r[row][y] = num
 end
 return r
 end
 
 function fillcube(r,x,y,w,h,num)
 for cy = 0, h do
 for cx = 0, w do
 local ccx = x-flr(w/2) + cx
 local ccy = y-flr(h/2) + cy
 if ccx < 16 and ccx > -1 and ccy < 16 and ccy > -1 then
 r[ccx][ccy] = num
 end
 end
 end
 return r
 end
 
 function clearroom()
 for x = 0, 15 do
 for y = 0, 15 do
 mset(x,y,0)
 end
 end
 end savedata = {}
 
 function submitscore(name,score)
 
 
 local exists = false
 for i,v in pairs(savedata) do
 if v.name == name then
 exists = true
 if score>v.score then
 v.score = score
 end
 end
 end
 
 if not exists then
 add(savedata, {name=name,score=score})
 end
 
 qsort(savedata, function(a,b) return a.score>b.score end)
 end
 
 function save()
 for i=1,16 do
 local sindex = (i-1)*4
 dset(sindex, getnum(sub(savedata[i].name,1,1)))
 dset(sindex+1, getnum(sub(savedata[i].name,2,2)))
 dset(sindex+2, getnum(sub(savedata[i].name,3,3)))
 dset(sindex+3, savedata[i].score)
 end
 end
 
 function loadsaves()
 local tdata = {}
 for i=0,15 do
 local sindex = i*4
 
 local name = getletter(dget(sindex)) .. getletter(dget(sindex+1)) .. getletter(dget(sindex+2))
 if name == "" then
 name = "___"
 end
 add(tdata,{name=name,score=dget(sindex+3)})
 end
 return tdata
 end
 
 function defaultsave()
 local tdata = {}
 for i=0,15 do
 add(tdata,{name="___",score=0})
 end
 return tdata
 end 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
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
 tilesets = {
 {
 autotile=true,
 solid=2,
 tiles={
 {
 id=0,
 sprid=81
 },
 {
 id=1,
 sprid=81
 },
 {
 id=2,
 sprid=81
 },
 {
 id=3,
 sprid=98,
 flipx=true,
 flipy=true
 },
 {
 id=4,
 sprid=81
 },
 {
 id=5,
 sprid=96,
 flipy=true
 },
 {
 id=6,
 sprid=65
 },
 {
 id=7,
 sprid=65
 },
 {
 id=8,
 sprid=81
 },
 {
 id=9,
 sprid=82
 },
 {
 id=10,
 sprid=66,
 flipx=true
 },
 {
 id=11,
 sprid=80
 },
 {
 id=12,
 sprid=64
 },
 {
 id=13,
 sprid=82
 },
 {
 id=14,
 sprid=97
 },
 {
 id=15,
 sprid=81
 }
 }
 },
 
 {
 autotile=true,
 solid=2,
 tiles={
 {
 id=0,
 sprid=119
 },
 {
 id=1,
 sprid=71
 },
 {
 id=2,
 sprid=118
 },
 {
 id=3,
 sprid=102
 },
 {
 id=4,
 sprid=116
 },
 {
 id=5,
 sprid=100
 },
 {
 id=6,
 sprid=117
 },
 {
 id=7,
 sprid=101
 },
 {
 id=8,
 sprid=87
 },
 {
 id=9,
 sprid=103
 },
 {
 id=10,
 sprid=70
 },
 {
 id=11,
 sprid=86
 },
 {
 id=12,
 sprid=68
 },
 {
 id=13,
 sprid=84
 },
 {
 id=14,
 sprid=69
 },
 {
 id=15,
 sprid=85
 }
 }
 },
 
 {
 autotile=true,
 solid=2,
 tiles={
 {
 id=0,
 sprid=123
 },
 {
 id=1,
 sprid=75
 },
 {
 id=2,
 sprid=122
 },
 {
 id=3,
 sprid=106
 },
 {
 id=4,
 sprid=120
 },
 {
 id=5,
 sprid=104
 },
 {
 id=6,
 sprid=121
 },
 {
 id=7,
 sprid=105
 },
 {
 id=8,
 sprid=91
 },
 {
 id=9,
 sprid=107
 },
 {
 id=10,
 sprid=74
 },
 {
 id=11,
 sprid=90
 },
 {
 id=12,
 sprid=72
 },
 {
 id=13,
 sprid=88
 },
 {
 id=14,
 sprid=73
 },
 {
 id=15,
 sprid=89
 }
 }
 },
 
 {
 autotile=true,
 solid=2,
 tiles={
 {
 id=0,
 sprid=127
 },
 {
 id=1,
 sprid=111
 },
 {
 id=2,
 sprid=112
 },
 {
 id=3,
 sprid=110
 },
 {
 id=4,
 sprid=124
 },
 {
 id=5,
 sprid=108
 },
 {
 id=6,
 sprid=125
 },
 {
 id=7,
 sprid=109
 },
 {
 id=8,
 sprid=79
 },
 {
 id=9,
 sprid=95
 },
 {
 id=10,
 sprid=78
 },
 {
 id=11,
 sprid=94
 },
 {
 id=12,
 sprid=76
 },
 {
 id=13,
 sprid=92
 },
 {
 id=14,
 sprid=77
 },
 {
 id=15,
 sprid=93
 }
 }
 }
 }
 
 entities = {}
 
 function tagget(tag)
 local items = {}
 for i in all(entities) do
 if i.tag != nil and i.tag == tag then
 add(items, i)
 end
 end
 return items
 end
 
 function addstatics(e)
 e.x=0
 e.y=0
 e.xv=0
 e.yv=0
 e.grounded=false
 e.flipped=false
 e.flippedy=false
 e.animtimer=0
 return e
 end
 
 function updateentity(e)
 
 e.grounded = false
 
 
 
 
 
 
 if e.hasgravity then
 e.yv += physics.g
 end
 
 
 if e.xv > 0.01 then
 if e.xdrag == nil then
 e.xv -= physics.d
 else
 e.xv -= e.xdrag
 end
 elseif e.xv < -0.01 then
 if e.xdrag == nil then
 e.xv += physics.d
 else
 e.xv += e.xdrag
 end
 else
 e.xv = 0
 end
 
 
 if e.xmax != nil then
 if e.xv > e.xmax then
 e.xv = e.xmax
 elseif e.xv < -e.xmax then
 e.xv = -e.xmax
 end
 end
 
 
 e.x += e.xv
 e.y += e.yv
 
 
 
 
 local pbox = {
 x=e.boffset.x+e.box.x,
 y=e.boffset.y+e.box.y
 }
 local pmin = {
 x=e.x+e.boffset.x,
 y=e.y+e.boffset.y}
 local pmax = {
 x=e.x+pbox.x,
 y=e.y+pbox.y}
 
 
 
 if(e.xv > 0)then
 
 if issolid(pmax.x,pmin.y+e.box.y/2) then
 e.xv = 0
 e.x = flr((e.x)/e.box.x)*e.box.x
 end
 e.flipped = false
 
 elseif(e.xv < 0)then
 if issolid(pmin.x,pmin.y+e.box.y/2) then
 e.xv = 0
 e.x = flr((e.x+e.box.x)/e.box.x)*e.box.x
 end
 e.flipped = true
 end
 
 
 if (e.yv >=0) then
 if issolidc(pmin.x+1,pmax.y,{1,2}) or issolidc(pmax.x-1,pmax.y,{1,2}) then
 e.yv = 0
 e.y = flr((e.y)/e.box.y)*e.box.y
 e.grounded = true
 end
 end
 
 if(e.yv <= 0)then
 if issolid(pmin.x+e.box.x/2,pmin.y) then
 e.yv= 0
 e.y= flr((e.y+e.box.y)/e.box.y)*e.box.y
 end
 end
 end
 
 
 function drawentity(e)
 local cspr = e.cs
 
 local frame = flr(e.animtimer)
 
 if e.hasgravity then
 if not e.grounded then
 if e.jspr != nil then
 cspr = e.jspr[(frame % #e.jspr) +1]
 end
 elseif e.xv != 0 then
 if e.wspr != nil then
 cspr = e.wspr[(frame % #e.wspr) +1]
 end
 end
 else
 if e.wspr != nil then
 cspr = e.wspr[(frame % #e.wspr) +1]
 end
 end
 
 spr(cspr,e.x,e.y,e.sprs.x,e.sprs.y,e.flipped,e.flippedy)
 
 
 if e.animtimer > 32766 then
 e.animtimer = 0
 end
 
 e.animtimer+=e.animspd
 end
 
 p = {
 tag ="player",
 hitjump=false,
 
 
 maxhealth =3,
 health=3,
 range=1,
 firetimer=0.1,
 currentgun =nil,
 
 invtime=1.4,
 invtimer=0,
 
 
 hasgravity=true,
 xacc =0.2, 
 xmax =1.3, 
 jvmin=0.1, 
 jv=0.4, 
 jvmax=6,
 
 
 box= {x=8,y=8},
 boffset= {x=0,y=0},
 
 
 sprs ={x=1,y=1},
 cs=1,
 jspr={4},
 wspr={2,3},
 animspd =0.12,
 animtimer=0, 
 
 init = function(this)
 this = addstatics(this)
 this.gun = gun_laser()
 add(entities,p)
 end,
 update = function(this)
 if this.invtimer > 0 then
 this.invtimer-= 1/stat(7)
 end
 
 controlplayer()
 updateentity(this)
 end,
 draw = function(this)
 drawentity(this)
 end,
 hit = function(this,dmg,hkb,vkb)
 if this.invtimer <= 0 then
 this.invtimer = this.invtime
 sfx(2)
 this.health-= dmg
 this.xv += hkb
 this.yv += vkb
 
 if this.health <= 0 then
 setgamestate(3)
 end
 end
 end
 }
 
 function controlplayer()
 
 
 if p.firetimer > 0 then
 p.firetimer-= 1/stat(7)
 elseif btn(4) then
 p.firetimer = p.gun.firerate
 p.gun.fire(p.gun)
 end
 
 
 if(btnp(2)) and p.grounded then
 p.yv -= p.jvmin
 p.lasty = p.y
 sfx(0)
 end
 
 
 if btn(2) and p.yv < 0 then
 if abs(p.lasty - p.y) < p.jvmax then
 p.yv -= p.jv
 end
 end
 
 
 if(btn(1)) then
 p.xv += p.xacc
 end
 if(btn(0)) then
 p.xv -= p.xacc
 end
 
 if p.x > 128 or p.y > 128 then
 p.x = 1
 p.y = 64
 newroom(true)
 elseif p.x < 0 then
 p.x = 127
 p.y = 64
 newroom(false)
 end
 end function coin ()
 return {
 tag = "collectable",
 
 box = {x=8,y=8},
 boffset = {x=0,y=0},
 
 hasgravity=false,
 
 sprs ={x=1,y=1},
 wspr ={144,145,146,145,144,144},
 animspd = 0.12,
 
 init = function(this)
 addstatics(this)
 end,
 update = function(this)
 if iscolliding(p,this) then
 data.coins+=1
 sfx(3)
 del(entities,this)
 end
 end,
 draw = function(this)
 drawentity(this)
 end
 }
 end function enemy_fb ()
 return {
 tag= "enemy",
 
 chaserange=7,
 
 
 box = {x=8,y=8},
 boffset = {x=0,y=0},
 
 
 hasgravity=false,
 spd=0.12,
 hkb=5,
 vkb=1,
 
 
 sprs ={x=1,y=1},
 wspr ={32,33,34,33,32},
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
 end function enemy_fbb ()
 return {
 tag= "enemy",
 
 
 health =16,
 state =0,
 spd =0.4,
 shootspd =3,
 rotspd =7,
 targetspd=10,
 
 box = {x=24,y=24},
 boffset = {x=4,y=4},
 
 hitbox = {x=18,y=18,ox=7,oy=7},
 
 
 
 hasgravity=false,
 
 hkb=5,
 vkb=1,
 
 
 animspd =1,
 
 
 targetp ={x=0,y=0}, 
 rot =0, 
 eyesprpos ={x=112,y=80},
 
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
 
 function enemy_slime ()
 return {
 tag= "enemy",
 
 hkb=3,
 vkb=2,
 
 
 box = {x=8,y=8},
 boffset = {x=0,y=0},
 
 
 hasgravity=true,
 xacc = 0.3, 
 xmax = 0.3,
 right=true,
 
 
 sprs ={x=1,y=1},
 cs =21,
 jspr ={22},
 wspr ={21,23,22,23,21},
 animspd =0.12,
 
 init = function(this)
 addstatics(this)
 end,
 update = function(this)
 if p.x > this.x then
 this.xv += this.xacc
 elseif p.x < this.x then
 this.xv -= this.xacc
 end
 
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
 end function enemy_snake ()
 return {
 tag= "enemy",
 
 hkb=3,
 vkb=2,
 
 
 box = {x=8,y=8},
 boffset = {x=0,y=0},
 
 
 hasgravity=true,
 xacc = 0.3, 
 xmax = 0.3,
 right=true,
 
 
 sprs ={x=1,y=1},
 cs =16,
 jspr ={16,17},
 wspr ={16,17},
 animspd = 0.12,
 
 init = function(this)
 addstatics(this)
 end,
 update = function(this)
 if iscolliding(p,this) then 
 local dif = p.x - this.x
 
 
 if p.yv > 0 then
 p.yv=-2
 this.hit(this)
 else
 p.hit(p,1,(dif/abs(dif))*this.hkb,-this.vkb)
 end
 end
 
 
 if this.grounded then
 if this.right then
 this.xv += this.xacc
 if issolid(this.x+9, this.y+4) or not issolid(this.x+9, this.y+12) then
 this.right = false
 end
 else
 this.xv -= this.xacc
 if issolid(this.x-1, this.y+4) or not issolid(this.x-1, this.y+12) then
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
 blooda(this.x+4,this.y+4,32,(xdir/abs(xdir)),2,1,2)
 del(entities,this)
 end
 }
 end function enemy_spike ()
 return {
 tag= "enemy",
 
 health=3,
 hkb=4,
 vkb=3,
 
 
 box ={x=7,y=5},
 boffset ={x=1,y=3},
 
 
 sprs ={x=1,y=1},
 wspr =36,
 
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
 end function blood(x,y)
 for i=0,32 do
 local part = particle_blood ()
 part.init(part,x,y,rnd(3)*-1,rnd(4)-2)
 add(entities,part)
 end
 end
 
 function blooda(x,y,n,xv,yv,rxv,ryv)
 for i=0,n do
 local part = particle_blood ()
 part.init(part,x,y,xv*(rnd(rxv)-rxv),yv*(rnd(ryv)-ryv))
 add(entities,part)
 end
 end
 
 function particle_blood ()
 return{
 tag = "particle",
 
 
 hasgravity = true,
 xmax = 2,
 xdrag = 0,
 
 
 box= {x=1,y=1},
 boffset = {x=0,y=0},
 
 init = function(this,x,y,xv,yv)
 addstatics(this)
 this.x = x
 this.y = y
 this.xv = xv
 this.yv = yv
 end,
 update = function(this)
 if not this.grounded then
 updateentity(this)
 end
 end,
 draw = function(this)
 color(8)
 pset(this.x,this.y,8)
 end
 }
 end function projectile_arrow ()
 return{
 tag = "projectile",
 x = 0,
 y = 0,
 xv=0,
 yv=0,
 
 damage = 1,
 
 
 box = {x=3,y=3},
 boffset = {x=1,y=0},
 
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
 end,
 draw = function(this)
 sspr(this.x,this.y,120,83,6,5,false,false,3,2.5,this.rot,1,1)
 end
 }
 end
 function projectile_boomerang ()
 return{
 tag = "projectile",
 x = 0,
 y = 0,
 xv=0,
 yv=0,
 
 damage = 1,
 
 
 box = {x=5,y=5},
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
 function projectile_fbb_shot ()
 return{
 tag = "projectile",
 x = 0,
 y = 0,
 rot = 0,
 
 
 damage = 1,
 spd = 1,
 
 
 box = {x=3,y=3},
 boffset = {x=-1,y=-1},
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
 end function projectile_laser ()
 return{
 tag = "projectile",
 x = 0,
 y = 0,
 x2 = 0,
 y2 = 0,
 
 lifetime = 0.1,
 damage = 1,
 tolerance = 4,
 
 
 box = {x=25,y= 5},
 boffset = {x=-1,y=-2},
 
 st= 1,
 
 init = function(this,_x1,_y1,_x2,_y2)
 this.st = this.lifetime
 this.x = _x1
 this.y = _y1
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
 line(x1, y1, x2, y2, 10)
 line(x1, y1+1, x2, y2, 2)
 line(x1, y1-1, x2, y2, 2)
 end
 end function gun_boomerang()
 return {
 name ="boomeragun",
 price =75,
 spr =192,
 firerate =0.5,
 fire = function(this)
 sfx(1)
 local pjt = projectile_laser()
 
 if p.flipped then
 pjt.boffset.x = -26
 pjt.init(pjt,p.x,p.y+4,p.x-p.range*24,p.y+4) 
 else
 pjt.boffset.x = 0
 pjt.init(pjt,p.x+8,p.y+4,p.x+8+p.range*24,p.y+4)
 end
 add(entities, pjt)
 end
 }
 end function gun_laser()
 return {
 name ="laser of doom",
 price =75,
 spr =193,
 firerate =1,
 fire = function(this)
 sfx(1)
 local pjt = projectile_laser()
 
 if p.flipped then
 pjt.boffset.x = -26
 pjt.init(pjt,p.x,p.y+4,p.x-p.range*24,p.y+4) 
 else
 pjt.boffset.x = 0
 pjt.init(pjt,p.x+8,p.y+4,p.x+8+p.range*24,p.y+4)
 end
 add(entities, pjt)
 end
 }
 end letters = "abcdefghijklmnopqrstuvwxyz"
 
 function getletter(num)
 return sub(letters,num,num)
 end
 
 function getnum(let)
 for i = 0,#letters do
 if sub(letters,i,i) == let then
 return i
 end
 end
 end function acos(x)
 return atan2(x,-sqrt(1-x*x))
 end
 
 function asin(y)
 return atan2(sqrt(1-y*y),-y)
 end 
 
 
 
 
 
 
 
 function movetowardsdir(p, t)
 edir={x = t.x - p.x,
 y = t.y - p.y}
 return v_normalize(edir)
 end
 
 function movetowards(enemy, player)
 
 if dist({x=enemy.x,y=enemy.y},{x=player.x,y=player.y}) > 4 then
 edir = { x = enemy.x - player.x,
 y = enemy.y - player.y}
 edir = v_normalize(edir)
 
 if edir.x < 0 then
 enemy.flipped = true
 else
 enemy.flipped = false
 end
 if edir.y > 0 then
 enemy.flippedy = true
 else
 enemy.flippedy = false
 end
 enemy.x -= edir.x*0.3
 enemy.y -= edir.y*0.3
 end
 end
 
 function tostring(any)
 if type(any)=="function" then 
 return "function" 
 end
 if any==nil then 
 return "nil" 
 end
 if type(any)=="string" then
 return any
 end
 if type(any)=="boolean" then
 if any then return "true" end
 return "false"
 end
 if type(any)=="table" then
 local str = "{ "
 for k,v in pairs(any) do
 str=str..tostring(k)..":"..tostring(v).."\n"
 end
 return str.."}"
 end
 if type(any)=="number" then
 return ""..any
 end
 return "unkown" 
 end
 
 
 function ascending(a,b) return a<b end
 function descending(a,b) return a>b end
 
 
 
 
 
 function qsort(a,c,l,r)
 c,l,r=c or ascending,l or 1,r or #a
 if l<r then
 if c(a[r],a[l]) then
 a[l],a[r]=a[r],a[l]
 end
 local lp,rp,k,p,q=l+1,r-1,l+1,a[l],a[r]
 while k<=rp do
 if c(a[k],p) then
 a[k],a[lp]=a[lp],a[k]
 lp+=1
 elseif not c(a[k],q) then
 while c(q,a[rp]) and k<rp do
 rp-=1
 end
 a[k],a[rp]=a[rp],a[k]
 rp-=1
 if c(a[k],p) then
 a[k],a[lp]=a[lp],a[k]
 lp+=1
 end
 end
 k+=1
 end
 lp-=1
 rp+=1
 a[l],a[lp]=a[lp],a[l]
 a[r],a[rp]=a[rp],a[r]
 qsort(a,c,l,lp-1 )
 qsort(a,c, lp+1,rp-1 )
 qsort(a,c, rp+1,r)
 end
 end 
 
 
 
 
 function dist(v1,v2)
 return sqrt((v2.x-v1.x)^2 + (v2.y-v1.y)^2)
 end
 
 
 function v_addv( v1, v2 )
 return { x = v1.x + v2.x, y = v1.y + v2.y }
 end
 
 
 function v_subv( v1, v2 )
 return { x = v1.x - v2.x, y = v1.y - v2.y }
 end
 
 
 function v_mults( v, n )
 return { x = v.x * n, y = v.y * n }
 end
 
 
 function v_divs( v, n )
 return { x = v.x / n, y = v.y / n }
 end
 
 
 function v_magsqr( v )
 return ( v.x * v.x ) + ( v.y * v.y )
 end
 
 
 function v_mag( v )
 return sqrt( ( v.x * v.x ) + ( v.y * v.y ) )
 end
 
 
 function v_normalize( v )
 local len = v_mag( v )
 return { x = v.x / len, y = v.y / len }
 end
 
 
 function v_dot( v1, v2 )
 return ( v1.x * v2.x ) + ( v1.y * v2.y )
 end
 
 
 
 function v_reflect( v, n )
 local dot = v_dot( v, n )
 local wdnv = v_mults( v_mults( n, dot ), 2.0 )
 local refv = v_subv( v, wdnv )
 return refv
 end function ui_money(x,y,n)
 spr(144,x,y)
 color(10)
 print(n,x+10,y+1)
 end function ui_pstats(x,y)
 local width=32
 
 ui_pstats_weapon(x,y)
 ui_pstats_healthbar(x+12,y,width)
 ui_pstats_firebar(x+12,y+9,width)
 end
 
 function ui_pstats_weapon(x,y)
 color(0)
 rectfill(x,y,x+11,y+11)
 spr(p.gun.spr,x+2,y+2)
 end
 
 function ui_pstats_healthbar(x,y,w)
 
 rectfill(x,y,x+w,y+8,0)
 
 local ph = p.health / p.maxhealth
 rectfill(x+1,y+1,x+max(0,((w-1)*ph)),y+7,8)
 
 local htxt = p.health .. "/" .. p.maxhealth
 print(htxt, x + w/2 - (#htxt*2) + 1,y+2,7)
 end
 
 function ui_pstats_firebar(x,y,w)
 
 rectfill(x,y,x+w,y+2,0)
 
 local ph = 1-p.firetimer
 rectfill(x+1,y+1,x+max(0,((w-1)*ph)),y+1,12)
 end 