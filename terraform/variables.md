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

## Validation

Regex for choices:

```terraform
variable "instance_type" {
  description = "Instance type for EC2."
  type        = string
  default     = "t2.medium"

  validation {
    condition     = can(regex("^[Tt][2-3].(nano|micro|small)", var.instance_type))
    error_message = "Instance type options are limited to t2.nano, t2.micro, t2.small"
  }
}
```
