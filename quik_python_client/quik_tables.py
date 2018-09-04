from typing import List

from dataclasses import dataclass
from quik_python_client.quik_socket_client import QuikSocketClient


@dataclass(frozen=True)
class SecurityInfo:
    """ Таблица инструментов
    {'sec_code': 'Si73250BJ6', 'face_unit': 'SUR', 'class_code': 'SPBOPT', 'code': 'Si73250BJ6', 'scale': 0,
    'face_value': 0, 'short_name': 'Si073250BJ6', 'lot_size': 1, 'name': 'Si-12.16M201016CA 73250',
    'min_price_step': 1, 'isin_code': '', 'class_name': 'РТС: Опционы FORTS', 'mat_date': 20161020}
    """
    sec_code: str  # Код инструмента
    face_unit: str  # Валюта номинала
    class_code: str  # Код класса инструментов
    code: str  # Код инструмента
    scale: int  # Точность (количество значащих цифр после запятой)
    face_value: float  # Номинал
    short_name: str  # Короткое наименование инструмента
    lot_size: int  # Размер лота
    name: str  # Наименование инструмента
    min_price_step: float  # Минимальный шаг цены
    isin_code: str  # ISIN
    class_name: str  # Наименование класса инструментов
    mat_date: int  # Дата погашения


class QuikTables:

    def __init__(self, client: QuikSocketClient):
        self._client = client

    def get_securities(self) -> List[SecurityInfo]:
        securities = self._client.send_request("get_table", args=["securities"])
        res = []
        for security_dict in securities:
            security_info = SecurityInfo(**security_dict)
            res.append(security_info)
        return res
