CreateDataSourceOrig = CreateDataSource

-- Создаем data source, в случае успеха возвращаем id data source
function CreateDataSource(class_code, sec_code, interval, param)
    local ds, error

    if (param) then
        ds, error = CreateDataSourceOrig(class_code, sec_code, getInterval(interval), param)
    else
        ds, error = CreateDataSourceOrig(class_code, sec_code, getInterval(interval))
    end

    if (error) then
        return packError(1, error)
    end

    table.insert(ds_tables, ds)

    return packOK({#ds_tables}, 0, "OK")
end

function checkDataSourceId(id)
    if (ds_tables[id] == nil) then
        return packError(1, "DataSource with id = " .. id .. " doesn't exist")
    end
    return nil
end

-- Open
function O(id, index)
    if (ds_tables[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return ds_tables[id]:O(index)
end

-- High
function H(id, index)
    if (ds_tables[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return ds_tables[id]:H(index)
end

-- Low
function L(id, index)
    if (ds_tables[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return ds_tables[id]:L(index)
end

-- Close
function C(id, index)
    if (ds_tables[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return ds_tables[id]:C(index)
end

-- Volume
function V(id, index)
    if (ds_tables[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return ds_tables[id]:V(index)
end

-- Time
function T(id, index)
    if (ds_tables[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return ds_tables[id]:T(index)
end

-- OHLCVT
function OHLCVT(id, index)
    error_table = checkDataSourceId(id)
    if (error_table ~= nil) then return error_table end
    return packOK({ds_tables[id]:O(index), ds_tables[id]:H(index), ds_tables[id]:L(index), ds_tables[id]:C(index),
        ds_tables[id]:V(index), ds_tables[id]:T(index)})
end

-- Size
function Size(id)
    error_table = checkDataSourceId(id)
    if (error_table ~= nil) then return error_table end
    return packOK({ds_tables[id]:Size()})
end

-- Close
function Close(id)
    error_table = checkDataSourceId(id)
    if (error_table ~= nil) then
        return error_table
    end

    local result = ds_tables[id]:Close()

    if (result) then
        table.remove(ds_tables, id)
    end

    return result
end

-- SetUpdateCallback
function SetUpdateCallback(id)
    if (ds_tables[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return ds_tables[id]:SetUpdateCallback(function (index)
        if c == nil then return end

        c:send(config.send_delimitter .. json_encode({
            id = "callback",
            callback_name = "UpdateCallback",
            ds_id = id,
            result = index,
        }))

        PrintDbgStr("UpdateCallback")
    end)
end

-- SetEmptyCallback
function SetEmptyCallback(id)
    if (ds_tables[id] == nil) then
        return DS_ID_NOT_FOUND
    end

    return ds_tables[id]:SetEmptyCallback()
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