# ethereum json rpc

## JSON RPC

- `eth_syncing`:

```bash
curl -XPOST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' http://127.0.0.1:8545
```

- `eth_chainId`

```bash
curl -s -XPOST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' localhost:8545 | jq -r '.result' | tr -d '\n' |  xargs -0 printf "%d"
```

- `eth_blockNumber`:

```bash
curl -s -XPOST -H "Content-type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' localhost:8545  | jq -r ".result" | tr -d '\n' |  xargs -0 printf "%d"
```

- `eth_getBlockByNumber` - by blocknumber:

```bash
curl -s -H "Content-type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["0x3a5d74", false],"id":1}' localhost:8545 | jq -r '.result.number' | tr -d '\n' |  xargs -0 printf "%d"
```

- `eth_getBlockByNumber` - latest :

```bash
curl -s -H "Content-type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", false],"id":1}' localhost:8545 | jq -r '.result.number' | tr -d '\n' |  xargs -0 printf "%d"
```

- `eth_blockNumber` - timestamp of latest received block

```bash
curl -s -H "Content-type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", false],"id":1}' localhost:8545 | jq -r '.result.timestamp' | tr -d '\n' |  xargs -0 printf "%d"
```

- `personal_newAccount`

```bash
# this is not recommended - rather create a account offline with a private key
curl -s -XPOST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"personal_newAccount","params":["securepassword"],"id":1}' localhost:8545
```

- `eth_getBalance`

```bash
curl -XPOST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0x9a070e582ef891ead3e9b92478df38dd17b4489e", "latest"],"id":1}' localhost:8545
```

- `eth_getBalance` - convert from wei to ether units

```bash
# testnet
printf %.2f $(echo $(curl -s -XPOST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0x746C9474d98C8A99280fC0E9DA7d706B647163DE", "latest"],"id":1}' http://localhost:8545 | jq -r '.result' | tr -d '\n' |  xargs -0 printf "%d") / 1000000000000000000 | bc -l)
```
