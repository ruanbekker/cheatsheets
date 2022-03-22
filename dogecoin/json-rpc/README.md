# Dogecoin JSON-RPC Examples

To get help on json-rpc you can generate them from `dogecoin-cli help sendtoaddress` as example.

## Get Addresses by Account

```bash
curl -s -u "user:pass" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getaddressesbyaccount", "params": [""]}' -H 'content-type: text/plain;' http://127.0.0.1:22555/
{"result":["xxxxxxxx","yyyyyyyyy"],"error":null,"id":"curl"}
```

## Get Balance

```bash
curl -s -u "user:pass" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getbalance", "params": ["*", 6]}' -H 'content-type: text/plain;' http://127.0.0.1:22555/
{"result":xx.xxxxxxxx,"error":null,"id":"curl"}
```

