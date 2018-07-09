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

Запрос

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