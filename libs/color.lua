Color = {}

function Color(r, g, b, a)
    a = a and a or 1
    return {r/255, g/255, b/255, a}
end

return Color