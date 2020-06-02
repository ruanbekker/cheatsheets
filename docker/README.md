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
