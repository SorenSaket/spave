savedata = {}

function submitscore(name,score)

   -- if name is already on list
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
      dset(sindex,   getnum(sub(savedata[i].name,1,1)))
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