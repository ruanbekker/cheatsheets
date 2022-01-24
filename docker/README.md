# Docker Cheatsheet

If you can't find what you are looking for try my other sources:

* [wiki.ruanbekker.com:docker](https://wiki.ruanbekker.com/index.php/Category:Docker)
* [blog.ruanbekker.com:docker](https://blog.ruanbekker.com/blog/categories/docker/)
* [sysadmins.co.za:docker](https://sysadmins.co.za/tag/docker/)

Index:

- [docker](#docker)
  - [Manipulating Output](#manipulating-output)
  - [Template Variables](#template-variables)
  - [Permissions](#permissions)
  - [Update](#update)
- [docker-compose](#docker-compose)
  - [build](#docker-compose-build)
  - [healthchecks](#docker-compose-healthchecks)
  - [logging](#docker-compose-logging)
  - [depends-on](#docker-compose-depends-on)

## Docker

### Manipulating Output

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

### Template Variables

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


### Permissions

Copy as User:

```
FROM python:2.7
RUN pip install Flask==0.11.1 
RUN useradd -ms /bin/bash admin
COPY --chown=admin:admin app /app
WORKDIR /app
USER admin
CMD ["python", "app.py"] 
```

### Update

#### Service Update

Add a constraint to move to a worker node:

```
$ docker service update --constraint-add 'node.role==worker' my-service-name
```

## Docker Compose

### Docker Compose Build

In our Dockerfile we can specify:

```dockerfile
ARG APP_VERSION=1
ENV APP_VERSION=$APP_VERSION
```

Then we can set or overwrite the value by using build arguments:

```
services:
  my-app:
    build:
      context: .
      dockerfile: test/Dockerfile
      args:
        APP_VERSION: 1.1
```

### Docker Compose Healthchecks

To see how to use health checks for dependencies / conditions, look at the gist below:

```
services:
  php:
    build:
      context: .
      dockerfile: tests/Docker/Dockerfile-PHP
      args:
        version: cli
    depends_on:
      couchbase:
        condition: service_healthy
```

Credit to:
- [@phuysmans gist](https://gist.github.com/phuysmans/4f67a7fa1b0c6809a86f014694ac6c3a)

HTTP Healthcheck:

```
version: '2.1'
services:
    depends_on:
      couchbase:
        condition: service_healthy
  http-service:
    image: nginx
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80/"]
      interval: 1s
      timeout: 3s
      retries: 60
```

MySQL Healthcheck:

```
  mysql:
    image: mysql
    environment:
      - MYSQL_ALLOW_EMPTY_PASSWORD=yes
      - MYSQL_ROOT_PASSWORD=
      - MYSQL_DATABASE=test
    healthcheck:
      test: ["CMD", "mysql" ,"-h", "mysql", "-P", "3306", "-u", "root", "-e", "SELECT 1", "test"]
      interval: 1s
      timeout: 3s
      retries: 30
```

Postgres Healthcheck:

```
  postgresql:
    image: postgres
    environment:
      - POSTGRES_PASSWORD=
      - POSTGRES_DB=test
    healthcheck:
      test: ["CMD", "pg_isready"]
      interval: 1s
      timeout: 3s
      retries: 30
```

Redis Healthcheck:

```
  redis:
    image: redis
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 1s
      timeout: 3s
      retries: 30
```

Docker in Docker Healthcheck:

```
  docker:
    image: docker:19.03.12-dind
    container_name: docker
    privileged: true
    environment:
      DOCKER_HOST: tcp://docker:2375/
      DOCKER_DRIVER: overlay2
      DOCKER_TLS_CERTDIR: ""
    networks:
      - docker
    healthcheck:
      test: ["CMD", "docker" ,"ps"]
      interval: 5s
      timeout: 3s
      retries: 30
```

### Docker Compose Logging

JSON File Logging:

```yaml
service:
  myservice:
    logging:
      driver: "json-file"
      options:
        max-size: "1m"
```

Loki Logging:

```yaml
service:
  myservice:
    logging:
      driver: loki
      options:
        loki-url: http://192.168.0.2:3100/loki/api/v1/push
        loki-external-labels: job=dockerlogs
```

### Docker Compose Depends On

Depends-On Defaults, which will be wait for the database to start, before starting the web container:

```
version: "3.8"
services:
  web:
    build: .
    depends_on:
      - db
  db:
    image: postgres
```

Depends-On Types, where you can specify if it should wait for the service to start or to be healthy before starting the web container:

```
version: "3.8"
services:
  web:
    build: .
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
  redis:
    image: redis
  db:
    image: postgres
    healthcheck:
      test: "exit 0"
```

Different types of depends on:

```
condition: service_started
condition: service_healthy
condition: service_completed_successfully
```
