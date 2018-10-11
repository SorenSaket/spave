function acos(x)
    return atan2(x,-sqrt(1-x*x))
end

function asin(y)
    return atan2(sqrt(1-y*y),-y)
end