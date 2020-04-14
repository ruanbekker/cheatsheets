Define variables:

```
$ cat variables.tf
variable "environment" {
  default = "prod"
}

variable "name" {
  default = "web"
}
```

Call a variable:

```
$ terraform console

> "${var.name}"
web

> "${var.environment}"
prod
```

Join strings:
- https://www.terraform.io/docs/configuration/functions/format.html

```
> format("%s-%s-server", var.name, var.environment)
web-prod-server
```
