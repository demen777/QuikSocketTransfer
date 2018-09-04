import json
import re
import sys
import socket
from io import BytesIO
from typing import List, Any


class ResponseError(Exception):

    def __init__(self, code: int, message: str):
        self.code = code
        self.message = message

    def __str__(self):
        return "Error_code={} Error_message={}".format(self.code, self.message)


class QuikSocketClient:

    def __init__(self, host: str, port: int, password: str):
        self.host = host
        self.port = port
        self.password = password
        self.message_id = 0
        self.socket = None

    def __enter__(self):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.connect((self.host, self.port))
        self.send_request('checkSecurity', [self.password])
        return self

    def __exit__(self, exception_type, exception_value, traceback):
        if self.socket:
            self.socket.close()

    def send_request(self, command_name: str, args: List[Any]) -> List[Any]:
        self.message_id += 1
        request_json = {"id": self.message_id, "method": command_name, "args": args}
        message_text = json.dumps(request_json)
        self.socket.sendall(message_text.encode('cp1251'))
        with BytesIO() as response_bytes:
            while True:
                fragment = self.socket.recv(8192)
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
