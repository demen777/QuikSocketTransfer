CreateDataSourceOrig = CreateDataSource
local DS_ID_NOT_FOUND = -1

-- Создаем data source, в случае успеха возвращаем id data source
function CreateDataSource(client_table, class_code, sec_code, interval, param)
    local ds, error

    if (param) then
        ds, error = CreateDataSourceOrig(class_code, sec_code, getInterval(interval), param)
    else
        ds, error = CreateDataSourceOrig(class_code, sec_code, getInterval(interval))
    end

    if (error) then
        return error
    end

    table.insert(client_table.ds_table, ds)

    return #client_table.ds_table
end

-- Open
function O(client_table, id, index)
    if (client_table.ds_table[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return client_table.ds_table[id]:O(index)
end

-- High
function H(client_table, id, index)
    if (client_table.ds_table[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return client_table.ds_table[id]:H(index)
end

-- Low
function L(client_table, id, index)
    if (client_table.ds_table[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return client_table.ds_table[id]:L(index)
end

-- Close
function C(client_table, id, index)
    if (client_table.ds_table[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return client_table.ds_table[id]:C(index)
end

-- Volume
function V(client_table, id, index)
    if (client_table.ds_table[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return client_table.ds_table[id]:V(index)
end

-- Time
function T(client_table, id, index)
    if (client_table.ds_table[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return client_table.ds_table[id]:T(index)
end

-- Size
function Size(client_table, id)
    if (client_table.ds_table[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return client_table.ds_table[id]:Size()
end

-- Close
function Close(client_table, id)
    if (client_table.ds_table[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    local result = client_table.ds_table[id]:Close()

    if (result) then
        table.remove(client_table.ds_table, id)
    end

    return result
end

-- SetUpdateCallback
function SetUpdateCallback(client_table, id)
    if (client_table.ds_table[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return client_table.ds_table[id]:SetUpdateCallback(function (index)
        client_table.c:send(config.send_delimitter .. json.encode({
            id = "callback",
            callback_name = "UpdateCallback",
            ds_id = id,
            result = index,
        }))
    end)
end

-- SetEmptyCallback
function SetEmptyCallback(client_table, id)
    if (client_table.ds_table[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return client_table.ds_table[id]:SetEmptyCallback()
end

-- Возвращает значение интервала по строке
function getInterval(interval_string)
    if (interval_string == "INTERVAL_TICK") then return INTERVAL_TICK
    elseif (interval_string == "INTERVAL_M1") then return INTERVAL_M1
    elseif (interval_string == "INTERVAL_M2") then return INTERVAL_M2
    elseif (interval_string == "INTERVAL_M3") then return INTERVAL_M3
    elseif (interval_string == "INTERVAL_M4") then return INTERVAL_M4
    elseif (interval_string == "INTERVAL_M5") then return INTERVAL_M5
    elseif (interval_string == "INTERVAL_M6") then return INTERVAL_M6
    elseif (interval_string == "INTERVAL_M10") then return INTERVAL_M10
    elseif (interval_string == "INTERVAL_M15") then return INTERVAL_M15
    elseif (interval_string == "INTERVAL_M20") then return INTERVAL_M20
    elseif (interval_string == "INTERVAL_M30") then return INTERVAL_M30
    elseif (interval_string == "INTERVAL_H1") then return INTERVAL_H1
    elseif (interval_string == "INTERVAL_H2") then return INTERVAL_H2
    elseif (interval_string == "INTERVAL_H4") then return INTERVAL_H4
    elseif (interval_string == "INTERVAL_D1") then return INTERVAL_D1
    elseif (interval_string == "INTERVAL_W1") then return INTERVAL_W1
    elseif (interval_string == "INTERVAL_MN1") then return INTERVAL_MN1
    end
end