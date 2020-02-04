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
