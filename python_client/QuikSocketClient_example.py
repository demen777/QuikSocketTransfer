from python_client.QuikDataSource import QuikDataSource
from python_client.QuikSocketClient import QuikSocketClient

client = QuikSocketClient("localhost", 1111, "1")
data_source = QuikDataSource(client,"SPBXM", "T_XM", "INTERVAL_D1")
print(data_source.get_size())
print(data_source.get_ohlcvt(1))
