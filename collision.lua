function PointInRectangle(px,py,rx,ry,rw,rh)
    return not PointNotInRectangle(px,py,rx,ry,rw,rh)
end

function PointInCenteredRectangle(px,py,rx,ry,rw,rh)
    return not PointNotInRectangle(px,py,rx-rw/2,ry-rh/2,rw,rh)
end

function PointNotInRectangle(px,py,rx,ry,rw,rh)
    return (px<rx or px > rx+rw or py<ry or py > ry + rh)
end