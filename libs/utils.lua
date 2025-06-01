local utils = {}

function utils:TableToString(tbl, indent)
    indent = indent or 0
    if type(tbl) ~= "table" then
        return "gay"
    end

    local str = ""
    local indentStr = string.rep("  ", indent)

    for k, v in pairs(tbl) do
        str = str .. indentStr .. tostring(k) .. ": "
        if type(v) == "table" then
            str = str .. "\n" .. UTILS.TableToString(v, indent + 1)
        else
            str = str .. tostring(v) .. "\n"
        end
    end

    return str
end


return utils