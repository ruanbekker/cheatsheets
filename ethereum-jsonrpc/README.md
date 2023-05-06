# ethereum json rpc

## JSON RPC

- `eth_syncing`:

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":51}' http://127.0.0.1:8545
```

- `eth_blockNumber`:

```bash
curl -s -H "Content-type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":["latest", false],"id":1}' localhost:8545  | jq -r ".result" | tr -d '\n' |  xargs -0 printf "%d"
```

- `eth_getBlockByNumber`:

```bash
curl -s -H "Content-type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["7881483", false],"id":1}' localhost:8545 | jq -r '.result.timestamp' | tr -d '\n' |  xargs -0 printf "%d"
```
