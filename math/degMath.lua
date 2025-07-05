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

function degMath.changeAngle(angle)
    --changes the angle to 45 in all quadrants... not needed I thought I ould make side-ways walkig (but that's incorect aproach)

    angle = degMath.fixDeg(angle)

    if angle <= 90 then
        angle = 45
    elseif angle <= 180 then
        angle = 135
    elseif angle <= 270 then
        angle = 225
    else
        angle = 315
    end

    return angle
end

return degMath