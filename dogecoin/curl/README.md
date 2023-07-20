# Dogecoin JSON-RPC Examples

To get help on json-rpc you can generate them from `dogecoin-cli help sendtoaddress` as example.

## Commands

- `getblockchaininfo`

```bash
curl -u "user:pass" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:44555/ 
```

- `getinfo`

```bash
curl -u "user:pass" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getinfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:44555/ 
```

- `getnewaddress`

```bash
curl -u "user:pass" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getnewaddress", "params": ["main"]}' -H 'content-type: text/plain;' http://127.0.0.1:44555/ 
```

- `getaccountaddress`

```bash
curl -u "user:pass" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getaccountaddress", "params": ["main"]}' -H 'content-type: text/plain;' http://127.0.0.1:44555/ 
```

- `getaddressesbyaccount`

```bash
curl -u "user:pass" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getaddressesbyaccount", "params": ["main"]}' -H 'content-type: text/plain;' http://127.0.0.1:44555/ 
```

- `listaccounts`

```bash
curl -u "user:pass" -d '{"jsonrpc": "1.0", "id": "curl", "method": "listaccounts", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:44555/
```

- `getbalance`

```bash
curl -s -u "user:pass" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getbalance", "params": ["*", 6]}' -H 'content-type: text/plain;' http://127.0.0.1:44555/
```

