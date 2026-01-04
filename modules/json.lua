local function escape_str(s)
    s = s:gsub("\\", "\\\\")
    s = s:gsub("\"", "\\\"")
    s = s:gsub("\b", "\\b")
    s = s:gsub("\f", "\\f")
    s = s:gsub("\n", "\\n")
    s = s:gsub("\r", "\\r")
    s = s:gsub("\t", "\\t")
    return s
end

local function encode_value(v)
    local t = type(v)

    if t == "nil" then
        return "null"

    -- elseif t == "UIReclaimDataCombined"
    --     return "{" .. "mass" .. ":" .. tostring(v.mass) .. ""}"

    elseif t == "number" or t == "boolean" then
        return tostring(v)

    elseif t == "string" then
        return "\"" .. escape_str(v) .. "\""

    elseif t == "table" then
        -- Determine if this is an array
        local isArray = true
        local maxIndex = 0
        for k, _ in pairs(v) do
            if type(k) ~= "number" then
                isArray = false
                break
            end
            if k > maxIndex then maxIndex = k end
        end

        if isArray then
            -- Encode array
            local items = {}
            for i = 1, maxIndex do
                table.insert(items, encode_value(v[i]))
            end
            return "[" .. table.concat(items, ",") .. "]"
        else
            -- Encode object
            local items = {}
            for k, val in pairs(v) do
                -- LOG("[FA_METRICS] key " .. k)
                table.insert(items, "\"" .. escape_str(k) .. "\":" .. encode_value(val))
            end
            return "{" .. table.concat(items, ",") .. "}"
        end
    end

    -- ignore it its w/e
    -- LOG("[FA_METRICS] json.encode: unsupported type " .. t)
    return "N/A"
    -- error("json.encode: unsupported type " .. t .. tostring(v))
end

function encode(v)
    return encode_value(v)
end