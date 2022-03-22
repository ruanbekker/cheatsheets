# Bitcoin Python

## Get Balance

```python
import os
import requests
import json
from dotenv import load_dotenv

load_dotenv('.env')

RPC_USERNAME = os.getenv('RPC_USERNAME')
RPC_PASSWORD = os.getenv('RPC_PASSWORD')

def get_btc_balance():
    headers = 'content-type: text/plain'
    request_payload = {"jsonrpc": "1.0", "id":"requests", "method": "getbalance", "params": ["*", 6]}
    response = requests.post('http://127.0.0.1:8332/', json=request_payload, auth=(RPC_USERNAME, RPC_PASSWORD))
    return response.json()

current_balance = get_btc_balance()['result']

print('[DEBUG] current balance is: {}'.format(current_balance))
```
