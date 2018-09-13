import json
import re
import sys
import socket
from io import BytesIO
from typing import List, Any
import logging


logger = logging.getLogger(__name__)


class ResponseError(Exception):

    def __init__(self, code: int, message: str):
        self.code = code
        self.message = message

    def __str__(self):
        return "Error_code={} Error_message={}".format(self.code, self.message)


class QuikSocketClient:
    SOCKET_TIMEOUT = 600.0

    def __init__(self, host: str, port: int, password: str):
        self.host = host
        self.port = port
        self.password = password
        self.message_id = 0
        socket.setdefaulttimeout(self.SOCKET_TIMEOUT)
        self.socket = None

    def connect(self):
        logger.debug("Start connect")
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        logger.debug("connect before connect")
        self.socket.connect((self.host, self.port))
        logger.debug("connect before checkSecurity")
        self._send_request('checkSecurity', [self.password])
        logger.debug("End connect")

    def close(self):
        if self.socket:
            self.socket.close()

    def send_request(self, command_name: str, args: List[Any]) -> List[Any]:
        if self.socket is None:
            self.connect()
        res = self._send_request(command_name, args)
        logger.debug("End send_request")
        return res

    def _send_request(self,command_name, args):
        self.message_id += 1
        request_json = {"id": self.message_id, "method": command_name, "args": args}
        message_text = json.dumps(request_json)
        logger.debug("_send_request before sendall")
        retries = 1
        while True:
            try:
                self.socket.sendall(message_text.encode('cp1251'))
                break
            except OSError as error:
                retries -= 1
                logger.error(error)
                self.close()
                self.connect()
                if retries < 0:
                    raise OSError(error)
        logger.debug("_send_request after sendall")
        with BytesIO() as response_bytes:
            while True:
                logger.debug("_send_request before recv")
                fragment = self.socket.recv(8192)
                logger.debug("_send_request after recv")
                response_bytes.write(fragment)
                if fragment[-1] == 10:
                    break
            response_bytes.flush()
            response_text = response_bytes.getvalue().decode('cp1251')
            response_bytes.close()
        m = re.match("message:\s*({.+})", response_text)
        response_text = m.group(1)
        response_json = json.loads(response_text)
        if response_json['error_code'] != 0:
            raise ResponseError(response_json['error_code'], response_json['error_message'])
        res = response_json['result']
        return res
