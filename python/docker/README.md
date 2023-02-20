# python-docker

## Install pymsql in Alpine

To install `pymysql` in alpine:

```docker
FROM --platform=amd64 python:3.8-alpine

RUN apk add --no-cache mariadb-connector-c-dev && \
    apk add --no-cache --virtual .build-deps \
        build-base \
        mariadb-dev && \
    pip install mysqlclient && \
    apk del .build-deps
    
# import pymysq
# pymysql.install_as_MySQLdb()
```
