locals {
  users = {
    "james.dean" = "administrators"
  }
}

module "some-module" {
  source = "../../modules/some-module"
  
  username = local.key
  group    = local.value

  for_each = local.users
}
