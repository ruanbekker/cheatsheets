# Docker Cheatsheet

If you can't find what you are looking for try my other sources:

* [wiki.ruanbekker.com:docker](https://wiki.ruanbekker.com/index.php/Category:Docker)
* [blog.ruanbekker.com:docker](https://blog.ruanbekker.com/blog/categories/docker/)
* [sysadmins.co.za:docker](https://sysadmins.co.za/tag/docker/)

## Manipulating Output:

Filter and specify the name that you are interested in:

```
$ docker ps -f name=my-hostname-service
CONTAINER ID        IMAGE                        COMMAND  CREATED              STATUS              PORTS                     NAMES
edb30579c208        ruanbekker/hostname:latest   "/app"   About a minute ago   Up About a minute   0.0.0.0:42177->8080/tcp   my-hostname-service-1234
```

Only output the ID:

```
$ docker ps -f name=my-hostname-service --format '{{.ID}}'
edb30579c208

or:

$ docker ps -f name=my-hostname-service -q
edb30579c208
```

If you have more than one container with the same prefix, but you are only interested in the most recent one:

```
$ docker ps -f name=my-hostname-service -ql
edb30579c208
```

ID, string characters and Name:

```
$ docker ps  -f name=my-hostname-service --format '{{.ID}} -> {{.Names}}'
edb30579c208 -> my-hostname-service-1234
```

Chaining them to exec into the container:

```
$ docker exec -it $(docker ps -f name=my-hostname-service -ql) sh
```

More examples:

- https://docs.docker.com/engine/reference/commandline/ps/

## Permissions

### Copy as User

```
FROM python:2.7
RUN pip install Flask==0.11.1 
RUN useradd -ms /bin/bash admin
COPY --chown=admin:admin app /app
WORKDIR /app
USER admin
CMD ["python", "app.py"] 
```

## Template Variables

For Docker:

```
$ docker run -it --log-driver json-file --log-opt tag="{{.ImageName}}|{{.Name}}|{{.ImageFullID}}|{{.FullID}}|{{.ID}}" alpine echo hi
hi
```

Get the logfile:

```
$ docker inspect $(docker ps -l) | jq '.[].LogPath'
/var/lib/docker/containers/b8e6523c8741d33f778a4f899dc04dab912472cedfba5ab71119a8c9ab1555a8/b8e6523c8741d33f778a4f899dc04dab912472cedfba5ab71119a8c9ab1555a8-json.log
```

View the content:

```
$ cat /var/lib/docker/containers/b8e6523c8741d33f778a4f899dc04dab912472cedfba5ab71119a8c9ab1555a8/b8e6523c8741d33f778a4f899dc04dab912472cedfba5ab71119a8c9ab1555a8-json.log
{"log":"hi\r\n","stream":"stdout","attrs":{"tag":"alpine|festive_bell|sha256:e7d92cdc71feacf90708cb59182d0df1b911f8ae022d29e8e95d75ca6a99776a|b8e6523c8741d33f778a4f899dc04dab912472cedfba5ab71119a8c9ab1555a8|b8e6523c8741"},"time":"2020-07-07T12:35:12.3938298Z"}
```

- https://docs.docker.com/config/formatting/

For Swarm:
- https://forums.docker.com/t/example-usage-of-docker-swarm-template-placeholders/73859

Get a container to report the host's hostname:

```
version: '3.7'
services:
  telegraf:
    ..
    hostname: "{{.Node.Hostname}}"
```

## Update

### Service Update

Add a constraint to move to a worker node:

```
$ docker service update --constraint-add 'node.role==worker' my-service-name
```
