socket = require("socket")
dofile(getScriptPath() .. "\\config.lua")
dofile(getScriptPath() .. "\\helpers.lua")
json = dofile(getScriptPath() .. "\\json.lua")
dofile(getScriptPath() .. "\\callbacks.lua")
dofile(getScriptPath() .. "\\data_source.lua")

accepting = true
clients = {}
client_id = 0

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
    -- С таким таймаутом более менее адекватно работает. Нет долгого затишья сообщений а потом сваливания сообщений в кучу
    s:settimeout(1)

    while accepting do
        local c = s:accept()

        if (c == nil) then
            resumeThread()
        else
            -- С таким таймаутом более менее адекватно работает. Нет долгого затишья сообщений а потом сваливания сообщений в кучу
            c:settimeout(1)
            local client_table = {
                c = c,
                t = makeThread(),
                auth = false,
                ds_table = {},
            }
            table.insert(clients, client_table)
            client_id = #clients

            PrintDbgStr("New connect")

            coroutine.resume(client_table.t, client_table.c, client_table)
        end
    end
end

function OnStop()
    accepting = false
    return 1
end