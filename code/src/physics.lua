physics = {
	g=0.1,		-- gravity
	d=0.1,		-- drag
	adm=0.5 	-- air drag multiplier
}

function iscolliding(a,b)
	-- postion, box, boffset
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
	
	if (amax.x < bmin.x) then return false end -- a is left of b
	if (amin.x > bmax.x) then return false end -- a is right of b
	if (amax.y < bmin.y) then return false end -- a is above b
	if (amin.y > bmax.y) then return false end -- a is below b
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