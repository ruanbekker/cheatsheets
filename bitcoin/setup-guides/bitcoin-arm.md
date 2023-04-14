# Bitcoin Core

This document demonstrates the installation of bitcoin core v0.21.1 running on the testnet for ARM linux, running on a RaspberryPi 3

## Notes

This is a testnet, therefore a weak username and password was chosen, please increase security when running mainnets.

## Preperation

Create the user:

```bash
sudo useradd -s /bin/bash -m crypto
```

Create the directories:

```bash
sudo mkdir -p /blockchain/bitcoin/{data,scripts}
sudo mkdir -p /usr/local/bitcoin/0.21.1/bin
sudo mkdir -p /home/crypto/.bitcoin
```

Change the permissions:

```bash
sudo chown -R crypto:crypto /blockchain/bitcoin
sudo chown -R crypto:crypto /home/crypto/.bitcoin
```

## Installation

From [bitcoin core's](https://bitcoin.org/en/download) download page, I fetched version 0.21.1:

```bash
cd /tmp
wget https://bitcoin.org/bin/bitcoin-core-0.21.1/bitcoin-0.21.1-arm-linux-gnueabihf.tar.gz
```

Extract the tarball:

```bash
tar -xvf bitcoin-0.21.1-arm-linux-gnueabihf.tar.gz
```

Move the binaries to our created directories:

```bash
sudo mv bitcoin-0.21.1/bin/bitcoin* /usr/local/bitcoin/0.21.1/bin/
```

Then create a symlink to `current` as that will be referenced from systemd:

```bash
sudo ln -s /usr/local/bitcoin/0.21.1 /usr/local/bitcoin/current
```

## Configuration

Create the configuration for bitcoin in `/home/crypto/.bitcoin/bitcoin.conf` with the following content:

```
datadir=/blockchain/bitcoin/data
printtoconsole=1
onlynet=ipv4
rpcallowip=127.0.0.1
rpcuser=user
rpcpassword=pass
rpcclienttimeout=300
testnet=1
prune=2000
walletnotify=/blockchain/bitcoin/scripts/walletnotify.sh %s %w
blocknotify=/blockchain/bitcoin/scripts/blocknotify.sh %s
[test]
rpcbind=127.0.0.1
rpcport=18332
zmqpubrawblock=tcp://127.0.0.1:28332
zmqpubrawtx=tcp://127.0.0.1:28333
zmqpubhashblock=tcp://127.0.0.1:28332
zmqpubhashtx=tcp://127.0.0.1:28333
# uncomment after the wallet has been created
# wallet=main
```

Create the wallet notify script in `/blockchain/bitcoin/scripts/walletnotify.sh` with the content of:

```bash
#!/usr/bin/env bash
echo "[$(date +%FT%T)] type:walletnotify $1 $2" >> /var/log/wallet-notify.log
```

Create the block notify script in `/blockchain/bitcoin/scripts/blocknotify.sh` with the content of:

```bash
#!/usr/bin/env bash
echo "[$(date +%FT%T)] type:blocknotify $1" >> /var/log/wallet-notify.log
```

Create the file where the wallet and block notify data will be written to:

```bash
sudo touch /var/log/wallet-notify.log
```

Change the permissions of the file so that the crypto user can write to it:

```bash
sudo chown crypto:crypto /var/log/wallet-notify.log
```

Make the scripts executable:

```bash
sudo chmod +x /blockchain/bitcoin/scripts/*notify.sh
```

Create the systemd unit file in `/etc/systemd/system/bitcoind.service`:

```bash
[Unit]
Description=Bitcoin Core Testnet
After=network.target

[Service]
User=crypto
Group=crypto
WorkingDirectory=/blockchain/bitcoin/data
Type=simple
ExecStart=/usr/local/bitcoin/current/bin/bitcoind -conf=/home/crypto/.bitcoin/bitcoin.conf

[Install]
WantedBy=multi-user.target
```

Update the `PATH` variable to include bitcoin binaries in `/etc/profile.d/bitcoind.sh` with the following content:

```bash
export PATH=$PATH:/usr/local/bitcoin/current/bin
```

You can update your current session by running:

```bash
export PATH=$PATH:/usr/local/bitcoin/current/bin
```

Ensure permissions are set:

```bash
sudo chown -R crypto:crypto /blockchain/bitcoin
sudo chown -R crypto:crypto /home/crypto
```

Reload systemd:

```bash
sudo systemctl daemon-reload
```

## Start the IBD

Start bitcoin so that the initial block download can happen:

```bash
sudo systemctl restart bitcoind
```

This might take some time, but you can follow the progress by doing:

```bash
sudo journalctl -fu bitcoind
```

A fully sync node should look like this:

```bash
# sudo journalctl -fu bitcoind
Oct 04 13:39:58 rpi-01 bitcoind[532]: 2021-10-04T11:39:58Z UpdateTip: new best=000000000000003b06a186bbd79909e1a338196b5cffcee1979d6c4fc90f67a9 height=2097621 version=0x20a00000 log2_work=74.510314 tx=61253790 date='2021-10-04T11:39:54Z' progress=1.000000 cache=0.4MiB(1477txo)
```

You can use the json-rpc as well:

```bash
curl -s -u "user:pass" -d '{"jsonrpc": "1.0", "id": "curl", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/  | python3 -m json.tool
```
