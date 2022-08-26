# jsonnet cheatsheet

A data templating language for app and tool developers. [website](https://jsonnet.org/)

## Installation

Install via brew:

```bash
brew install jsonnet
```

## Basic Example

In `basic.jsonnet`:

```
local host = '10.0.0.120'; // Standard local variable ends with semicolon(;).
local http_port = 8080;

{
    local db_port = 3128, // A local variable next to JSON fields ends with comma(,).
    app_protocol:: 'http', // A special hidden variable next to fields use (::) instead of (=) or (:).
    environment_config: {
        app: {
            name: 'Sample app',
            url: $.app_protocol + '://' + host + ':' + http_port + 'app/'
        },
        database: {
            name: "mysql database",
            username: "user",
            password: "password",
            host: host,
            port: db_port,
        },
        rest_api: $.app_protocol + '://' + host + ':' + http_port + '/v2/api/'
    }
}
```

Parse it with:

```bash
jsonnet basic.jsonnet
{
   "environment_config": {
      "app": {
         "name": "Sample app",
         "url": "http://10.0.0.120:8080app/"
      },
      "database": {
         "host": "10.0.0.120",
         "name": "mysql database",
         "password": "password",
         "port": 3128,
         "username": "user"
      },
      "rest_api": "http://10.0.0.120:8080/v2/api/"
   }
}
```
