socket = require("socket")
dofile(getScriptPath() .. "\\config.lua")
dofile(getScriptPath() .. "\\helpers.lua")
json = dofile(getScriptPath() .. "\\json.lua")
dofile(getScriptPath() .. "\\callbacks.lua")
dofile(getScriptPath() .. "\\data_source.lua")

local accepting = true
clients = {}

function NewMessage(client_table, mes)
    PrintDbgStr("New message: " .. mes)

    local json_mes = json.decode(mes)
    if (not json_mes.id or not json_mes.method or not json_mes.args) then return end

    if (client_table.auth == false and json_mes.method ~= "checkSecurity") then
        return sendError(client_table.c, json_mes.id, "Not auth")
    end

    -- Создаем контекст для выполняемого метода
    local context = tableMerge({
        client_table = client_table,
        json_mes = json_mes,
    }, _G)

    -- Создаем строку аргументов
    local args_string = ""

    for key, value in pairs(json_mes.args) do
        args_string = args_string .. "json_mes.args[" .. key .. "]"

        if (#json_mes.args ~= key) then
            args_string = args_string .. ", "
        end
    end

    -- Выполняем метод, отлавливаем ошибки
    -- Если метод авторизации, то подставляем в аргументы client_table
    local code
    -- Методы которым нужен client_table
    if (json_mes.method == "checkSecurity" or
        json_mes.method == "CreateDataSource" or
        json_mes.method == "O" or
        json_mes.method == "H" or
        json_mes.method == "L" or
        json_mes.method == "C" or
        json_mes.method == "V" or
        json_mes.method == "T" or
        json_mes.method == "Size" or
        json_mes.method == "Close" or
        json_mes.method == "SetUpdateCallback" or
        json_mes.method == "SetEmptyCallback"
    ) then
        args_string = "client_table, " .. args_string
        code = "return {" .. json_mes.method .. "(" .. args_string .. ")}"
    else
        code = "return {" .. json_mes.method .. "(" .. args_string .. ")}"
    end
    local f, error = loadstring(code)
    local ok, result

    if (f) then
        setfenv(f, context)
        ok, result = pcall(f)

        if (not ok) then
            return sendError(client_table.c, json_mes.id, result)
        end
    else
        return sendError(client_table.c, json_mes.id, error)
    end

    result = json.encode({
        id = json_mes.id,
        result = result,
    })

    PrintDbgStr("Message result: " .. result)
    client_table.c:send(config.send_delimitter .. result)
end

function main()
    s = assert(socket.bind(config.address, config.port))

    while accepting do
        local c = s:accept()
        c:settimeout(0.01)
        local client_table = {
            c = c,
            auth = false,
            ds_table = {},
        }
        table.insert(clients, client_table)

        PrintDbgStr("New connect")

        local t = coroutine.create(function(c)
            local closed = false

            while accepting and not closed do
                local mes, i, s, error = "", 0, "", ""

                while true do
                    s, error = c:receive(i, s)

                    if s ~= nil then
                        i = i + 1
                        mes = s
                    elseif error == "closed" then
                        closed = true

                        local result, key = table_search(clients, client_table)
                        if (result) then
                            table.remove(clients, key)
                        end

                        PrintDbgStr("Closed connect")

                        break
                    else break
                    end
                end

                if mes ~= "" then
                    local split_mes = split(mes, config.send_delimitter)

                    for key, value in pairs(split_mes) do
                        NewMessage(client_table, value)
                    end
                end
            end

            c:close()
        end)
        coroutine.resume(t, c)
    end
end

function OnStop()
    accepting = false
    return 1
end