socket = require("socket")
dofile(getScriptPath() .. "\\config.lua")
json = dofile(getScriptPath() .. "\\json.lua")
dofile(getScriptPath() .. "\\helpers.lua")
-- dofile(getScriptPath() .. "\\callbacks.lua")
dofile(getScriptPath() .. "\\data_source.lua")

accepting = true
ds_tables = {}
auth = false
c = nil

function NewMessage(mes)
    PrintDbgStr("New message: " .. mes)

    local json_mes = json_decode(mes)

    if json_mes == false then return end

    if (not json_mes.id or not json_mes.method or not json_mes.args) then return end

    if (auth == false and json_mes.method ~= "checkSecurity") then
        return sendError(json_mes.id, "Not auth")
    end

    -- Создаем контекст для выполняемого метода
    local context = tableMerge({
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

    local code = "return " .. json_mes.method .. "(" .. args_string .. ")"
    local f, error = loadstring(code)
    local ok, return_table

    if (f) then
        setfenv(f, context)
        ok, return_table = pcall(f)

        if (not ok) then
            return_table = packError(-2, "Fail pcall on expression = " .. code)
        end
    else
        return_table = packError(-1, "Is not valid lua expression = " .. code)
    end

    if c == nil then return end

    return_table["id"] = json_mes.id

    local result
    result = json_encode(return_table)

    PrintDbgStr("Message result: " .. result)

    c:send(config.send_delimitter .. result .. "\n")
end

function main()
    s = assert(socket.bind(config.address, config.port))
    s:settimeout(1)

    while accepting do
        c = s:accept()

        if (c) then
            c:settimeout(1)

            PrintDbgStr("New connect")

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
                        auth = false
                        ds_tables = {}
                        c:close()
                        c = nil

                        PrintDbgStr("Closed connect")

                        break
                    else break
                    end
                end

                if mes ~= "" then
                    local split_mes = split(mes, config.send_delimitter)

                    for key, value in pairs(split_mes) do
                        NewMessage(value)
                    end
                end
            end
        end
    end
end

function OnStop()
    accepting = false
    return 1
end