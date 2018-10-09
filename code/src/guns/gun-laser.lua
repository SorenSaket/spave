function gun_laser()
    return {
        name = "laser of doom",
        price = 75,
        firerate = 1,
        shoot = function(this)
            sfx(1)
            p.firetimer = p.firerate
            local pjt = projectile_laser()
            
            if p.flipped then
                pjt.boffset.x = -26
                pjt.init(pjt,p.x,p.y+4,p.x-p.range*8,p.y+4) 
            else
                pjt.boffset.x = 0
                pjt.init(pjt,p.x+8,p.y+4,p.x+8+p.range*8,p.y+4)
            end
            add(entities, pjt)
        end
    }
end