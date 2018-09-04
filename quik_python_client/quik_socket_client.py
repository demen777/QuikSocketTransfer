import json
import re
import telnetlib
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
        self.telnet = None
        self.connect_and_auth()

    def connect_and_auth(self) -> None:
        self.telnet = telnetlib.Telnet(self.host, self.port)
        self.send_request('checkSecurity', [self.password])

    def send_request(self, command_name: str, args: List[Any]) -> List[Any]:
        self.message_id += 1
        request_json = {"id": self.message_id, "method": command_name, "args": args}
        message_text = json.dumps(request_json)
        self.telnet.write(message_text.encode('ascii'))
        response_text = self.telnet.read_until('\n'.encode('ascii')).decode('ascii').strip()
        m = re.match("message:\s*({.+})", response_text)
        response_text = m.group(1)
        response_json = json.loads(response_text)
        if response_json['error_code'] != 0:
            raise ResponseError(response_json['error_code'], response_json['error_message'])
        res = response_json['result']
        return res
