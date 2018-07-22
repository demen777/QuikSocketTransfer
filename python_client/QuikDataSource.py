from datetime import datetime
from typing import List, Any

from python_client.QuikSocketClient import QuikSocketClient


class QuikDataSource:

    def __init__(self, client: QuikSocketClient, security_class: str, security_code: str, interval: str):
        self.security_class = security_class
        self.security_code = security_code
        self.interval = interval
        self.client = client
        self.data_source_id = self._create_data_source()

    def _create_data_source(self) -> int:
        response = self.client.send_request("CreateDataSource",
            [self.security_class, self.security_code, self.interval])
        data_source_id = response[0]
        return data_source_id

    def get_size(self) -> int:
        response = self.client.send_request("Size", [self.data_source_id])
        size = response[0]
        return size

    def get_ohlcvt(self, index) -> List[Any]:
        response = self.client.send_request("OHLCVT", [self.data_source_id, index])
        response[5] = datetime(year=response[5]['year'], month=response[5]['month'], day=response[5]['day'],
            hour=response[5]['hour'], minute=response[5]['min'], second=response[5]['sec'])
        return response
