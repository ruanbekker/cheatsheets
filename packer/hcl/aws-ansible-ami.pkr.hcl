variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "node" {
  type    = string
  default = "test"
}

variable "project" {
  type    = string
  default = "test-project"
}

variable "builder_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "commit_sha" {
  type    = string
  default = "latest"
}

variable "aws_role_arn" {
  type        = string
  default     = "arn:aws:iam::000000000000:role/my-role"
  description = "The iam role that allows the project to assume from."
}

locals { 
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") 
}

source "amazon-ebs" "amznlinux" {
  ami_name      = "${var.project}-${var.node}-${local.timestamp}"
  instance_type = var.builder_instance_type
  region        = var.region
  ssh_username  = "ec2-user"

  tags = {
    Name        = "${var.project}-${var.node}-${local.timestamp}"
    Node        = var.node
    Timestamp   = local.timestamp
  }

  assume_role {
    role_arn     = var.aws_role_arn
    session_name = "packer"
  }

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
      architecture        = "x86_64"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  temporary_iam_instance_profile_policy_document {
    Statement {
      Action   = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetAuthorizationToken",
        "ecr:CreateRepository",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage"
      ]
      Effect   = "Allow"
      Resource = ["*"]
    }
    Version = "2012-10-17"
  }

}

build {
  sources = ["source.amazon-ebs.amznlinux"]

  provisioner "shell" {
    inline = [
      "echo installing ansible",
      "sudo yum update -y",
      "sudo amazon-linux-extras install ansible2 -y",
    ]
  }

  provisioner "ansible-local" {
    playbook_file   = "../ansible/playbook.yml"
    playbook_dir    = "../ansible"
    extra_arguments = [
      "--inventory inventory/${var.node}.yml",
      "--limit ${var.node}",
      "--extra-vars", 
      "\"NODE=${var.node} CODE_COMMIT=${var.commit_sha}\""
    ]
  }

}
