-- Поиск значения в таблице
function table_search(search_table, search_value)
    local found, search_key = false, nil

    table.foreach(search_table, function(key, value)
        if value == search_value then
            found = true
            search_key = key
        end
    end)

    return found, search_key
end

-- Объединить таблицы
function tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

-- Отправляет сообщение об ошибке
function sendError(id, error)
    if c == nil then return end

    PrintDbgStr("Message error: " .. error)

    c:send(config.send_delimitter .. json_encode({
        id = id,
        error = error,
    }))
end

-- Проверка security
function checkSecurity(security)
    if (config.security == security) then
        auth = true
        return true
    end

    return false
end

-- Разделить строку
function split(str, pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t,cap)
        end
        last_end = e+1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

function sendCallback(callback_name, result)
    if c == nil then return end

    c:send(config.send_delimitter .. json_encode({
        id = "callback",
        callback_name = callback_name,
        result = result,
    }))
end

-- ХУЙНЯ ЧТОБЫ ОТЛОВИТЬ ОШИБКУ В ЕБАНОМ LUA

function json_encode(encode)
    local status, result = pcall(function() return json.encode(encode) end)

    if status then
        return result
    else
        return false
    end
end

function json_decode(decode)
    local status, result = pcall(function() return json.decode(decode) end)

    if status then
        return result
    else
        return false
    end
end