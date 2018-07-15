# QuikSocketTransfer
Lua сервер для терминала Quik. Нужен для того чтобы передавать данные из Quik через сокеты.

Данные передаются в формате json.

**Установка**

Файлы из архива ToQuikFolder.zip закинуть в папку с Quik

Папку QuikSocketTransfer закинуть в папку с Quik

Запустить файл main.lua

**Настройки**

config.lua

```lua
config = {
    address = "localhost", -- Адрес сервера
    port = 1111, -- Порт сервера
    security = "1", -- Секретный ключ, для установки соединения.
    send_delimitter = "message:", -- разделитель сообщений
}
```

**Пример запроса и ответа**

Запрос

```
message:{"id": 1, "method": "checkSecurity", "args": ["1"]}
```

Ответ

```
message:{"id": 1, "result": [true]}
```

Может возникнуть такая ситуация, когда в ответе будут два сообщения. Поэтому строку ответа нужно разбивать на массив через разделитель "message:"

**Установка соединения**

Проверка security ключа

Запрос

```json
{
  "id": 1,
  "method": "checkSecurity",
  "args": ["1"]
}
```

Ответ

```json
{
  "id": 1,
  "result": [true]
}
```

**Вызов методов Quik**

Запрос isConnected

```json
{
  "id": 2,
  "method": "isConnected",
  "args": [] // Список аргументов метода
}
```

Ответ

```json
{
  "id": 2,
  "result": [1]
}
```

Запрос getInfoParam

```json
{
  "id": 3,
  "method": "getInfoParam",
  "args": ["VERSION"] // Список аргументов метода
}
```

Ответ

```json
{
  "id": 3,
  "result": ["7.18.1.20"]
}
```

**Функции обратного вызова**

После проверки security ключа сервер отправляет вам данные переданные в функции обратного вызова.

Ответ OnQuote

```json
{
  "id": "callback",
  "result": {
    "class_code": "SPBFUT",
    "sec_code": "SiU8"
  },
   "callback_name": "OnQuote"
}
```

Ответ OnFuturesLimitChange

```json
{
  "id": "callback", 
  "result": {
    "cbplused": 5684, 
    "cbp_prev_limit": 300000, 
    "varmargin": 0, 
    "options_premium": 0, 
    "limit_type": 0, 
    "firmid": "SPBFUT000000", 
    "currcode": "SUR", 
    "cbplused_for_orders": 0, 
    "liquidity_coef": 1, 
    "real_varmargin": 0, 
    "cbplused_for_positions": 5684, 
    "accruedint": -0.5, 
    "kgo": 1, 
    "ts_comission": -0.5, 
    "cbplplanned": 294315.5, 
    "trdaccid": "SPBFUT000bb", 
    "cbplimit": 300000
  },
  "callback_name": "OnFuturesLimitChange"
}
```

**Работа с графиками**

Создаем data source

Запрос CreateDataSource

```json
{
  "id": 4,
  "method": "CreateDataSource",
  "args": ["SPBFUT", "SiU8", "INTERVAL_TICK"]
}
```

Ответ

Успешный ответ

```json
{
  "id": 4,
  "result": [1] // В случае успеха возвращается id data source, 
}
```

Ответ с ошибкой

```json
{
  "id": 4,
  "result": ["SPBFUT1 - unknown class code."]
}
```

Запрос SetUpdateCallback

```json
{
  "id": 5,
  "method": "SetUpdateCallback",
  "args": [1] // Передаем id data source
}
```

Ответ

Успешный ответ

```json
{
  "id": 5,
  "result": [true]
}
```

Ответ с ошибкой

```json
{
  "id": 5,
  "result": [-1] // -1 Возвращается если не удалось найти id data source
}
```

После того как установлен UpdateCallback сервер будет отправлять вам данные переданные в этот колбэк

Ответ UpdateCallback

```json
{
  "id": "callback",
  "callback_name": "UpdateCallback",
  "result": 8388,
  "ds_id": 1
}
```

**Ответы при ошибке выполнения**

**Пример ответа при ошибке, если неправильно переданы аргументы метода**

Запрос

```json
{
  "id": 6,
  "method": "O",
  "args": []
}
```

Ответ

```json
{
  "id": 6,
  "error": "[string \"return {O(client_table, )}\"]:1: unexpected symbol near ')'"
}
```