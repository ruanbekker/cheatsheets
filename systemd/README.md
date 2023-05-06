# systemd cheatsheet

## systemctl

To view a status of the service:

```bash
sudo systemctl status nginx
```

To restart a service:

```bash
sudo systemctl restart nginx
```

## journalctl

To tail the logs of a unit:

```bash
sudo journalctl -fu nginx
```

To tail and view the last 100 logs:

```bash
sudo journalctl -fu nginx -n 100 --no-pager
```
