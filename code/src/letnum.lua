letters = "abcdefghijklmnopqrstuvwxyz"


function toletters(numbers)
    
end

function tonumbers(string)
    local nums = ""
    for i = 0,#string do
        nums = nums .. letterindex(sub(string,i,i))
        nums = nums .. "0"
    end

    local dn = "0." .. nums
    return tonum(dn)
end

function letterindex(let)
    for i = 0,#letters do
        if sub(letters,i,i) == let then
            return i
        end
    end
end