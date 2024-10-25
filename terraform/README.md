# Terraform Cheatsheets

## Cheatsheets

### Terraform CLI Usage

Terraform Format:

```bash
terraform fmt
```

Validate terraform syntax:

```bash
terraform validate
```

Validate terraform syntax and skip backend validation:

```bash
terraform validate -backend=false
```

Initialize and download providers:

```bash
terraform init
```

Terraform plan to review what will be changed:

```bash
terraform plan
```

Terraform Apply to create/delete resources:

```bash
terraform apply
```

To do a targeted plan:

```bash
terraform plan -target=module.platform -out=platform.tfplan
```

Then we can do a targeted destroy from the computed plan:

```bash
terraform apply "platform.tfplan"
```

### Merge function

In this scenario, you can have default tags, but if you want to replace `Environment`, you can define the `var.environment` and include it in the merge function.

```terraform
variable "default_tags" {
  default = {
    ManagedBy   = "terraform"
    Environment = "local"
  }
}

variable "name" {
  default = "testing"
}

variable "environment" {
  default = "dev"
}

output "merge_tags" {
  value = "${merge(var.default_tags, tomap({"Name" = "prefix-${var.name}", "Environment" = "${var.environment}"}))}"
}
```

### Validations

Length:

```terraform
variable "service_name" {
  type = string

  validation {
    condition     = length(var.service_name) < 40
    error_message = "The service_name value cant be more than 40 characters."
  }
}
```

Regex match:

```terraform
variable "env_name" {
  type = string
  default = null
  validation {
    condition  = can(regex("^(dev|staging|production|ephemeral-.*)+$", var.env_name))
    error_message = "For the env_name value only dev, staging, production and ephemeral-* are allowed."
  }
}
```

### Booleans to control

We want to use a boolean variable to set the number:
- true = 1
- false = 0

```terraform
warm_pool = {
  pool_state                  = "Running"
  min_size                    = var.warm_pool_enabled ? 1 : 0
  max_group_prepared_capacity = var.warm_pool_enabled ? 1 : 0
}
```

## Resources

Terraform Tutorials:

- [@codeaprendiz terraform-kitchen](https://github.com/codeaprendiz/terraform-kitchen)

Terraform Examples:

- [rtfm.co.ua - AWS Examples](https://rtfm.co.ua/en/terraform-main-commands-state-files-backend-storages-and-modules-in-examples-on-aws/)
- [Jeff Geerling - Terraform and Vagrant Example](https://github.com/geerlingguy/ansible-for-devops/tree/master/gluster)
- [Jeff Geerling - Mac Playbook Examples](https://github.com/geerlingguy/mac-dev-playbook)
- [Kulasangar - AWS with IAM Policies Example](https://github.com/Kulasangar/terraform-demo)
- [AWS with IAM Policy Exampe #2](https://gist.github.com/ruanbekker/63ec1871ec3c6051a0d0cb75156e93bd)
- [phillipsj.net Terraform Blogposts](https://www.phillipsj.net/tags/terraform/)
- [Deploy EKS with Terraform](https://medium.com/4th-coffee/the-real-eks-anywhere-in-terraform-51fdf4a2ab59)
- [ECS with Terraform](https://github.com/alex/ecs-terraform)
- [Cross Account VPC Peering](https://chandarachea.medium.com/vpc-peering-connetion-with-terraform-c4522a24bf3e)
- [VPC Peering with AWS](https://medium.com/tensult/vpc-peering-using-terraform-105d554ed04d)
- [Multiple AWS Examples](https://github.com/tensult/terraform/tree/master/aws)
- [AWS API Gateway](https://github.com/comtravo/terraform-aws-api-gateway)
- [API GW: Moving from Serverless Framework](https://sysgears.com/articles/moving-lambda-function-from-serverless-to-terraform/)
- [Nodejs API GW with Lambda](https://github.com/TailorDev/hello-lambda)
- [Minimal Viable CICD with Terraform and AWS CodePipeline](https://alite-international.com/minimal-viable-ci-cd-with-terraform-aws-codepipeline/)

Learn Guides:

- [Hashicorp Terraform Modules](https://learn.hashicorp.com/collections/terraform/modules)
- [Terraform Study Guide](https://github.com/ari-hacks/terraform-study-guide/)

Terraform Cheatsheets
- [acloudguru cheatsheet](https://acloudguru.com/blog/engineering/the-ultimate-terraform-cheatsheet)

Terraform AWS Workshops:
- [Terraform EKS AWS Workshop](https://tf-eks-workshop.workshop.aws/000_workshop_introduction.html)
- [Terraform Guru](https://terraformguru.com/terraform-certification-using-azure-cloud/01-Infrastructure-as-Code-IaC-Basics/)

Terraform with Ansible Examples:

- [Terraform with Ansible Example #1](https://github.com/ramitsurana/terraform-ansible-setup)
- [Terraform with Ansible Example #2](https://github.com/insight-infrastructure/terraform-ansible-playbook)
- [Using a JumpHost in Ansible with Terraform](https://leftasexercise.com/2019/12/23/using-ansible-with-a-jump-host/) | [Lambda Auto Package](https://github.com/nozaq/terraform-aws-lambda-auto-package)

Terraform States:

- [gruntwork.io - Manage Terraform State](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa)

Terraform Providers:

- [Terraform Ansible Provider #1](https://nicholasbering.ca/tools/2018/01/08/introducing-terraform-provider-ansible/)
