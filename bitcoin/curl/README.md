# JSON RPC Usage

This will show you how to use the json-rpc to interact with your bitcoin node on the testnet chain.

## Pre-Checks

If you installed the node with this [script]() your config would be in `/etc/litecoin/bitcoin.conf` and your username and password can be retrieved using:

```
cat /etc/litecoin/litecoin.conf | grep -E '(rpcuser|rpcpassword)'
# rpcuser=rpcuser
# rpcpassword=9a4e9cfac082721e870575a7c66178c0421512032a6d62af
```

then you can set some temporary env vars for this guide:

```bash
export rpcuser=rpcuser
export rpcpass=9a4e9cfac082721e870575a7c66178c0421512032a6d62af
```

For other guides see:
- x

## Uptime

To see the uptime in seconds:

```
$ curl -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "uptime", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/
{"result":60501,"error":null,"id":"curl"}
```

## RPC Info

The [rpcinfo](https://chainquery.com/bitcoin-cli/getrpcinfo) RPC returns runtime details of the RPC server. At the moment, it returns an array of the currently active commands and how long they’ve been running.

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getrpcinfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ | python -m json.tool
{
    "error": null,
    "id": "curl",
    "result": {
        "active_commands": [
            {
                "duration": 133,
                "method": "getrpcinfo"
            }
        ],
        "logpath": "/home/bitcoin/.bitcoin/testnet3/debug.log"
    }
}
```

## Blockchain Info

The [getblockchaininfo](https://chainquery.com/bitcoin-cli/getblockchaininfo) RPC provides information about the current state of the block chain.

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ | python -m json.tool
{
    "error": null,
    "id": "curl",
    "result": {
        "automatic_pruning": true,
        "bestblockhash": "000000000000003b5744e67b7f2a30634b98077055a58ff6b2eb1c160eb44a9e",
        "blocks": 1383644,
        "chain": "test",
        "chainwork": "000000000000000000000000000000000000000000000096db9d07fd29e70db2",
        "difficulty": 48174374.44122773,
        "headers": 2006191,
        "initialblockdownload": true,
        "mediantime": 1534268709,
        "prune_target_size": 1048576000,
        "pruned": true,
        "pruneheight": 1382612,
        "size_on_disk": 911147899,
        "softforks": {
            "bip34": {
                "active": true,
                "height": 21111,
                "type": "buried"
            },
            "bip65": {
                "active": true,
                "height": 581885,
                "type": "buried"
            },
            "bip66": {
                "active": true,
                "height": 330776,
                "type": "buried"
            },
            "csv": {
                "active": true,
                "height": 770112,
                "type": "buried"
            },
            "segwit": {
                "active": true,
                "height": 834624,
                "type": "buried"
            },
            "taproot": {
                "active": false,
                "bip9": {
                    "min_activation_height": 0,
                    "since": 0,
                    "start_time": 1619222400,
                    "status": "defined",
                    "timeout": 1628640000
                },
                "type": "bip9"
            }
        },
        "verificationprogress": 0.508263107545056,
        "warnings": ""
    }
}
```

## Wallets

Create a wallet named `main`:

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "createwallet", "params": ["main"]}' -H 'content-type: text/plain;' http://127.0.0.1:18332/
{"result":{"name":"main","warning":""},"error":null,"id":"curl"}
```

When we list our data directory we can see the files it created for the wallet:

```
sudo find /home/bitcoin/.bitcoin/ | grep main
/home/bitcoin/.bitcoin/testnet3/wallets/main
/home/bitcoin/.bitcoin/testnet3/wallets/main/wallet.dat
/home/bitcoin/.bitcoin/testnet3/wallets/main/db.log
/home/bitcoin/.bitcoin/testnet3/wallets/main/database
/home/bitcoin/.bitcoin/testnet3/wallets/main/database/log.0000000004
/home/bitcoin/.bitcoin/testnet3/wallets/main/database/log.0000000003
/home/bitcoin/.bitcoin/testnet3/wallets/main/.walletlock
```

List our loaded wallets:

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "listwallets", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/
{"result":["rpi01-main"],"error":null,"id":"curl"}
```

Get a new address for our main wallet:

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getnewaddress", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/main
{"result":"tb1qzxmefmcpq98z42v67a80gvug2fe979r5h768yv","error":null,"id":"curl"}
```

List the wallet addresses for our wallet:

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getaddressesbylabel", "params": [""]}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/rpi01-main
{"result":{"tb1qzxmefmcpq98z42v67a80gvug2fe979r5h768yv":{"purpose":"receive"}},"error":null,"id":"curl"}
```

Get the address info for our wallet:

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getaddressinfo", "params": ["tb1qzxmefmcpq98z42v67a80gvug2fe979r5h768yv"]}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/rpi01-main | python -m json.tool
{
    "error": null,
    "id": "curl",
    "result": {
        "address": "tb1qzxmefmcpq98z42v67a80gvug2fe979r5h768yv",
        "desc": "wpkh([x/0'/0'/0']x)#k3fgqsxn",
        "hdkeypath": "m/0'/0'/0'",
        "hdmasterfingerprint": "x",
        "hdseedid": "x",
        "ischange": false,
        "ismine": true,
        "isscript": false,
        "iswatchonly": false,
        "iswitness": true,
        "labels": [
            ""
        ],
        "pubkey": "03a4xx",
        "scriptPubKey": "0014xx",
        "solvable": true,
        "timestamp": 1624551798,
        "witness_program": "11b7xx4",
        "witness_version": 0
    }
}
```

## Transactions

If we list transactions for our wallet it should be empty:

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "listtransactions", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/rpi01-main
{"result":[],"error":null,"id":"curl"}
```

Go to https://coinfaucet.eu/en/btc-testnet/ and send testnet btc to `tb1qzxmefmcpq98z42v67a80gvug2fe979r5h768yv`, once the transaction is submitted run the `listtransactions` method again.

Other faucets that you can try:
- https://testnet-faucet.mempool.co/
- https://coinfaucet.eu/en/btc-testnet/
- https://bitcoinfaucet.uo1.net/
- https://onchain.io/bitcoin-testnet-faucet
- https://testnet.qc.to/
- https://tbtc.mocacinno.com/claim.php

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "listtransactions", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/rpi01-main
{"result":[],"error":null,"id":"curl"}
```

As you can see theres still nothing, but to add at this moment in time, the IBD process is not completed yet:

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ | python -m json.tool | grep verificationprogress
        "verificationprogress": 0.57450649965558,
```

After some time we can look at the logs as one method to see how far the verification progress is:

```
journalctl -fu bitcoind
Jun 25 10:53:31 rpi-01 bitcoind[16198]: 2021-06-25T08:53:31Z UpdateTip: new best=00000000afb049b341ddf19d8080af6524a05f618abbf0ec51806dcef7bd5b9d height=2006268 version=0x20000000 log2_work=74.331879 tx=60315046 date='2021-06-25T08:55:11Z' progress=1.000000 cache=46.3MiB(298787txo)
```

And we can see its synced `progress=1.000000`, we can then also validate with:

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ | python -m json.tool | grep verificationprogress
        "verificationprogress": 0.9999985282659621,
```

Now we should be able to see our funds and we can run the `listtransactions` method:

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "listtransactions", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/rpi01-main | python -m json.tool
{
    "error": null,
    "id": "curl",
    "result": [
        {
            "address": "tb1qzxmefmcpq98z42v67a80gvug2fe979r5h768yv",
            "amount": 0.01828492,
            "bip125-replaceable": "no",
            "blockhash": "0000000086003a9060e5743bfe0c7d81805a1948d6d5e326c5e3bb2f9ea83db7",
            "blockheight": 2006194,
            "blockindex": 8,
            "blocktime": 1624552612,
            "category": "receive",
            "confirmations": 75,
            "label": "",
            "time": 1624552612,
            "timereceived": 1624608999,
            "txid": "1635a05862e46a02306cfb9b5fd2f1f15a214a7227d29502550b40abdfe113d3",
            "vout": 1,
            "walletconflicts": []
        }
    ]
}
```

We can see the transaction, and because we are running a testnet chain, we need at least 1 confirmation, which we have 75 at the moment, so we should see the funds in our wallet:

```
curl -s -u "${rpcuser}:${rpcpass}" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getbalance", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/wallet/rpi01-main
{"result":0.01828492,"error":null,"id":"curl"}
```

We can also do a lookup on the `txid`, on a testnet blockchain explorer, like below:
- https://www.blockchain.com/btc-testnet/tx/1635a05862e46a02306cfb9b5fd2f1f15a214a7227d29502550b40abdfe113d3

[WIP]

