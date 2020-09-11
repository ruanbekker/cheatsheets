# nginx cheatsheet

## External

- https://rtfm.co.ua/en/http-redirects-post-and-get-requests-and-lost-data/

## Configs

Bare bones website:

```
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

}
```

Redirect non existing webpage to home:

```
    # define the error page
    error_page 404 = @notfound;

    # 301 redirect to / for defined error page
    location @notfound {
        return 301 /;
    }
```

Redirect a old request url to a new path on disk:

```
    # redirect old urls
    location /content/images/2019/10/logo.png {
        rewrite ^/content/images/2019/10/logo.png /assets/img/logo.png ;
    }
```
