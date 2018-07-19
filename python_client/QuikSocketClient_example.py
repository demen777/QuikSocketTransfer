from QuikSocketClient import QuikSocketClient

client = QuikSocketClient("localhost", 1111, "1")
response = client.send_request("CreateDataSource", ["SPBXM", "T_XM", "INTERVAL_D1"])
data_source_id = response[0]
print(response)
response = client.send_request("OHLCVT", [data_source_id, 1])
print(response)
