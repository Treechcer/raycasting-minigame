--this is for all the math corelated with degrees and radians and variabels that needs to be stored that corespond to degree math

degMath = {
    oneDegree = math.rad(1) -- 1 degree in radians
}

function degMath.fixDeg(angle)
    local res = angle % 360

    if res < 0 then
        res = 360 + res
    end

    return res
end

return degMath