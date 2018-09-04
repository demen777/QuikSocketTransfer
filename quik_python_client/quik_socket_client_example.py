from quik_python_client.quik_data_source import QuikDataSource
from quik_python_client.quik_socket_client import QuikSocketClient

client = QuikSocketClient("localhost", 1111, "1")
data_source = QuikDataSource(client, "TQBR", "SNGSP", "INTERVAL_D1")
candles_size = data_source.get_size()
print(candles_size)
print(data_source.get_ohlcvt(candles_size))
