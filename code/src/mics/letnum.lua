letters = "abcdefghijklmnopqrstuvwxyz"

function getletter(num)
    return sub(letters,num,num)
end

function getnum(let)
    for i = 0,#letters do
        if sub(letters,i,i) == let then
            return i
        end
    end
end